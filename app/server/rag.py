"""Local RAG over the PDFs in the docs/ folder.

Answers questions about the FIFA World Cup 2026 regulations and the Laws of the
Game by retrieving relevant passages and letting the local Ollama model compose
an answer grounded in them. Everything runs locally:

- Retrieval: vector embeddings via Ollama (OLLAMA_EMBED_MODEL, default
  "nomic-embed-text"). Falls back to a self-contained TF-IDF index if the
  embedding model is unavailable, or set OLLAMA_EMBED_MODEL="" to force it.
- Generation: the same local Ollama chat model used elsewhere (OLLAMA_MODEL).

The index is built lazily on first use and cached to disk; it rebuilds
automatically when the PDFs change.
"""

import asyncio
import math
import os
import pickle
import re

import httpx
from pypdf import PdfReader

OLLAMA_URL = os.getenv("OLLAMA_URL", "http://localhost:11434")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "qwen2.5-coder:7b")
OLLAMA_EMBED_MODEL = os.getenv("OLLAMA_EMBED_MODEL", "nomic-embed-text:latest")  # optional; enables vector retrieval
TIMEOUT_S = float(os.getenv("OLLAMA_TIMEOUT_MS", "30000")) / 1000

_HERE = os.path.dirname(os.path.abspath(__file__))
DOCS_DIR = os.path.normpath(os.getenv("RAG_DOCS_DIR", os.path.join(_HERE, "..", "..", "docs")))
INDEX_PATH = os.path.join(_HERE, ".rag_index.pkl")

CHUNK_SIZE = 900
CHUNK_OVERLAP = 150
TOP_K = 5

_index: dict | None = None
_lock = asyncio.Lock()

SYSTEM_PROMPT = (
    "You are a helpful assistant answering questions about soccer and the FIFA World Cup 2026, "
    "using ONLY the reference excerpts provided. Answer in at most 2 short sentences. "
    "Do NOT mention, cite, quote, or refer to the source documents, page numbers, or excerpts — "
    "just state the answer directly. If the answer is not contained in the excerpts, say you "
    "couldn't find it in the documents. "
    "Be precise with numbers, and distinguish quantities that the rules define separately. "
    "In particular, the number of substitutes (players) a team may use is NOT the same as the "
    "number of substitution opportunities (windows) it has; when asked how many substitutions "
    "are allowed, report the number of substitutes a team may use."
)


# ── PDF loading & chunking ─────────────────────────────────────────────────

def _title(filename: str) -> str:
    base = os.path.splitext(filename)[0]
    return re.sub(r"\s+", " ", base.replace("_", " ")).strip()


def _clean(text: str) -> str:
    text = text.replace("�", "").replace("\x00", "")
    return re.sub(r"[ \t]+", " ", text).strip()


def _split(text: str, size: int = CHUNK_SIZE, overlap: int = CHUNK_OVERLAP) -> list[str]:
    text = _clean(text)
    if len(text) <= size:
        return [text] if text else []
    chunks, start = [], 0
    while start < len(text):
        end = min(start + size, len(text))
        if end < len(text):
            sp = text.rfind(" ", start + size // 2, end)
            if sp > start:
                end = sp
        piece = text[start:end].strip()
        if piece:
            chunks.append(piece)
        if end >= len(text):
            break
        start = max(end - overlap, start + 1)
    return chunks


def _load_pdf_chunks() -> list[dict]:
    chunks: list[dict] = []
    if not os.path.isdir(DOCS_DIR):
        return chunks
    for filename in sorted(os.listdir(DOCS_DIR)):
        if not filename.lower().endswith(".pdf"):
            continue
        path = os.path.join(DOCS_DIR, filename)
        try:
            reader = PdfReader(path)
        except Exception as e:  # noqa: BLE001
            print(f"RAG: could not read {filename}: {e}")
            continue
        title = _title(filename)
        for page_no, page in enumerate(reader.pages, start=1):
            try:
                text = page.extract_text() or ""
            except Exception:  # noqa: BLE001
                text = ""
            for i, piece in enumerate(_split(text)):
                chunks.append(
                    {"id": f"{filename}#p{page_no}#{i}", "doc": title, "file": filename,
                     "page": page_no, "text": piece}
                )
    return chunks


# ── TF-IDF retrieval (default, no model needed) ────────────────────────────

def _tokenize(s: str) -> list[str]:
    return re.findall(r"[a-z0-9]{2,}", s.lower())


def _build_tfidf(chunks: list[dict]) -> dict:
    n = len(chunks)
    tokenized = [_tokenize(c["text"]) for c in chunks]
    df: dict[str, int] = {}
    for toks in tokenized:
        for t in set(toks):
            df[t] = df.get(t, 0) + 1
    idf = {t: math.log((n + 1) / (d + 1)) + 1 for t, d in df.items()}

    postings: dict[str, list[tuple[int, float]]] = {}
    for i, toks in enumerate(tokenized):
        tf: dict[str, int] = {}
        for t in toks:
            tf[t] = tf.get(t, 0) + 1
        vec = {t: (1 + math.log(f)) * idf[t] for t, f in tf.items()}
        norm = math.sqrt(sum(w * w for w in vec.values())) or 1.0
        for t, w in vec.items():
            postings.setdefault(t, []).append((i, w / norm))
    return {"idf": idf, "postings": postings}


def _tfidf_search(index: dict, query: str, k: int) -> list[tuple[dict, float]]:
    idf = index["tfidf"]["idf"]
    postings = index["tfidf"]["postings"]
    q_tf: dict[str, int] = {}
    for t in _tokenize(query):
        if t in idf:
            q_tf[t] = q_tf.get(t, 0) + 1
    q_vec = {t: (1 + math.log(f)) * idf[t] for t, f in q_tf.items()}
    norm = math.sqrt(sum(w * w for w in q_vec.values())) or 1.0
    q_vec = {t: w / norm for t, w in q_vec.items()}

    scores: dict[int, float] = {}
    for t, qw in q_vec.items():
        for i, w in postings.get(t, []):
            scores[i] = scores.get(i, 0.0) + qw * w
    ranked = sorted(scores.items(), key=lambda x: x[1], reverse=True)[:k]
    return [(index["chunks"][i], s) for i, s in ranked]


# ── Optional embedding retrieval ───────────────────────────────────────────

# nomic-embed-text expects task-instruction prefixes; harmless to omit for others.
_EMBED_PREFIX = {"document": "search_document: ", "query": "search_query: "}


def _prefix(kind: str) -> str:
    if "nomic" in (OLLAMA_EMBED_MODEL or "").lower():
        return _EMBED_PREFIX.get(kind, "")
    return ""


def _batched(items: list, size: int):
    for i in range(0, len(items), size):
        yield items[i:i + size]


async def _embed(texts: list[str], kind: str = "document") -> list[list[float]]:
    inputs = [_prefix(kind) + t for t in texts]
    out: list[list[float]] = []
    async with httpx.AsyncClient(timeout=120) as client:
        for batch in _batched(inputs, 64):
            try:
                r = await client.post(
                    f"{OLLAMA_URL}/api/embed", json={"model": OLLAMA_EMBED_MODEL, "input": batch}
                )
                r.raise_for_status()
                out.extend(r.json()["embeddings"])
            except Exception:  # noqa: BLE001 — fall back to the legacy per-text endpoint
                for text in batch:
                    r = await client.post(
                        f"{OLLAMA_URL}/api/embeddings",
                        json={"model": OLLAMA_EMBED_MODEL, "prompt": text},
                    )
                    r.raise_for_status()
                    out.append(r.json()["embedding"])
    return out


def _cosine(a: list[float], b: list[float]) -> float:
    dot = sum(x * y for x, y in zip(a, b))
    na = math.sqrt(sum(x * x for x in a)) or 1.0
    nb = math.sqrt(sum(y * y for y in b)) or 1.0
    return dot / (na * nb)


async def _embed_search(index: dict, query: str, k: int) -> list[tuple[dict, float]]:
    q = (await _embed([query], "query"))[0]
    scored = [(index["chunks"][i], _cosine(q, e)) for i, e in enumerate(index["embeddings"])]
    scored.sort(key=lambda x: x[1], reverse=True)
    return scored[:k]


# ── Index lifecycle ────────────────────────────────────────────────────────

def _signature() -> str:
    parts = [OLLAMA_EMBED_MODEL or "tfidf"]
    if os.path.isdir(DOCS_DIR):
        for f in sorted(os.listdir(DOCS_DIR)):
            if f.lower().endswith(".pdf"):
                st = os.stat(os.path.join(DOCS_DIR, f))
                parts.append(f"{f}:{st.st_size}:{int(st.st_mtime)}")
    return "|".join(parts)


async def _build_index() -> dict:
    chunks = _load_pdf_chunks()
    index = {"signature": _signature(), "chunks": chunks, "docs": sorted({c["doc"] for c in chunks})}
    if not chunks:
        index["backend"] = "empty"
        return index
    if OLLAMA_EMBED_MODEL:
        try:
            index["embeddings"] = await _embed([c["text"] for c in chunks], "document")
            index["backend"] = "embed"
            return index
        except Exception as e:  # noqa: BLE001
            print(f"RAG: embedding backend failed ({e}); using TF-IDF.")
    index["tfidf"] = _build_tfidf(chunks)
    index["backend"] = "tfidf"
    return index


async def get_index() -> dict:
    global _index
    sig = _signature()
    if _index and _index.get("signature") == sig:
        return _index
    async with _lock:
        if _index and _index.get("signature") == sig:
            return _index
        try:
            with open(INDEX_PATH, "rb") as fh:
                disk = pickle.load(fh)
            if disk.get("signature") == sig:
                _index = disk
                return _index
        except Exception:  # noqa: BLE001
            pass
        _index = await _build_index()
        try:
            with open(INDEX_PATH, "wb") as fh:
                pickle.dump(_index, fh)
        except Exception as e:  # noqa: BLE001
            print(f"RAG: could not cache index: {e}")
        return _index


def _search(index: dict, query: str, k: int):
    if index.get("backend") == "embed":
        return _embed_search(index, query, k)  # coroutine
    return _tfidf_search(index, query, k)


# ── Answering ──────────────────────────────────────────────────────────────

def _snippet(text: str, length: int = 220) -> str:
    s = re.sub(r"\s+", " ", text).strip()
    return s if len(s) <= length else s[:length].rsplit(" ", 1)[0] + "…"


async def _generate(question: str, context: str) -> str:
    async with httpx.AsyncClient(timeout=TIMEOUT_S) as client:
        r = await client.post(
            f"{OLLAMA_URL}/api/chat",
            json={
                "model": OLLAMA_MODEL,
                "stream": False,
                "options": {"temperature": 0},
                "messages": [
                    {"role": "system", "content": SYSTEM_PROMPT},
                    {"role": "user",
                     "content": f"Reference excerpts:\n\n{context}\n\nQuestion: {question}\n\nAnswer:"},
                ],
            },
        )
        r.raise_for_status()
        return r.json()["message"]["content"].strip()


async def answer(question: str, k: int = TOP_K) -> dict:
    q = (question or "").strip()
    if not q:
        return {"answer": "Ask me about the FIFA World Cup 2026 rules or the Laws of the Game.", "sources": []}

    index = await get_index()
    if index.get("backend") == "empty":
        return {"answer": "No documents are available to search. Add PDFs to the docs/ folder.", "sources": []}

    result = _search(index, q, k)
    hits = await result if asyncio.iscoroutine(result) else result
    hits = [(c, s) for c, s in hits if s > 0]
    if not hits:
        return {"answer": "I couldn't find anything relevant in the documents.", "sources": []}

    context = "\n\n".join(
        f"[{i + 1}] ({c['doc']}, p.{c['page']})\n{c['text']}" for i, (c, _s) in enumerate(hits)
    )
    try:
        text = await _generate(q, context)
    except Exception as e:  # noqa: BLE001
        print(f"RAG: generation failed ({e}); returning passages only.")
        text = "The local model (Ollama) is unavailable, but here are the most relevant passages:"

    sources = [
        {"n": i + 1, "doc": c["doc"], "file": c["file"], "page": c["page"],
         "score": round(s, 3), "snippet": _snippet(c["text"])}
        for i, (c, s) in enumerate(hits)
    ]
    return {"answer": text, "sources": sources, "backend": index.get("backend")}
