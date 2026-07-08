// Thin fetch wrappers around the FastAPI backend.

async function handle(request) {
  // `request` is the Promise returned by fetch(); await it to get the Response.
  const res = await request;
  if (!res.ok) {
    const body = await res.json().catch(() => ({}));
    throw new Error(body.error || `Request failed (${res.status})`);
  }
  return res.json();
}

export function fetchPlayers(params = {}) {
  const qs = new URLSearchParams(
    Object.entries(params).filter(([, v]) => v !== "" && v != null)
  );
  return handle(fetch(`/api/players?${qs}`));
}

export function fetchCountries() {
  return handle(fetch("/api/countries"));
}

export function updatePlayer(id, data) {
  return handle(
    fetch(`/api/players/${id}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(data),
    })
  );
}

export function fetchOverview(day) {
  return handle(fetch(`/api/overview${day ? `?day=${day}` : ""}`));
}

export function sendChat(message) {
  return handle(
    fetch("/api/chat", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message }),
    })
  );
}

export function askDocs(question) {
  return handle(
    fetch("/api/rag", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ question }),
    })
  );
}
