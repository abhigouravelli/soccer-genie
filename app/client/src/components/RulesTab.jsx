import { useEffect, useRef, useState } from "react";
import {
  Box,
  Container,
  Paper,
  Typography,
  TextField,
  IconButton,
  Chip,
  Stack,
  Avatar,
  Divider,
} from "@mui/material";
import SendRoundedIcon from "@mui/icons-material/SendRounded";
import MenuBookOutlinedIcon from "@mui/icons-material/MenuBookOutlined";
import SoccerBallLoader from "./SoccerBallLoader.jsx";
import { askDocs } from "../api.js";

const SUGGESTIONS = [
  "What is the offside rule?",
  "How does the knockout stage work?",
  "How many players are in a squad?",
  "What happens if a match is tied?",
  "When is a direct free kick awarded?",
];

function Message({ msg }) {
  const isUser = msg.role === "user";
  return (
    <Box sx={{ display: "flex", justifyContent: isUser ? "flex-end" : "flex-start", gap: 1 }}>
      {!isUser && (
        <Avatar sx={{ width: 30, height: 30, bgcolor: "secondary.main", color: "#04140d" }}>
          <MenuBookOutlinedIcon fontSize="small" />
        </Avatar>
      )}
      <Paper
        elevation={0}
        sx={{
          px: 1.75,
          py: 1.25,
          maxWidth: "85%",
          bgcolor: isUser ? "primary.main" : "background.default",
          color: isUser ? "#04140d" : "text.primary",
          border: isUser ? "none" : "1px solid rgba(255,255,255,0.06)",
          borderRadius: 2,
        }}
      >
        <Typography variant="body2" sx={{ fontWeight: isUser ? 600 : 500, whiteSpace: "pre-wrap" }}>
          {msg.text}
        </Typography>
      </Paper>
    </Box>
  );
}

export default function RulesTab() {
  const [messages, setMessages] = useState([
    {
      role: "bot",
      text:
        "Ask me about the FIFA World Cup 2026 regulations or the Laws of the Game. " +
        "Answers are drawn straight from the documents, with sources.",
    },
  ]);
  const [input, setInput] = useState("");
  const [loading, setLoading] = useState(false);
  const scrollRef = useRef(null);

  useEffect(() => {
    scrollRef.current?.scrollTo({ top: scrollRef.current.scrollHeight, behavior: "smooth" });
  }, [messages, loading]);

  async function submit(text) {
    const q = (text ?? input).trim();
    if (!q || loading) return;
    setInput("");
    setMessages((m) => [...m, { role: "user", text: q }]);
    setLoading(true);
    try {
      const res = await askDocs(q);
      setMessages((m) => [...m, { role: "bot", text: res.answer }]);
    } catch (e) {
      setMessages((m) => [...m, { role: "bot", text: `⚠️ ${e.message}` }]);
    } finally {
      setLoading(false);
    }
  }

  return (
    <Container maxWidth="md" sx={{ mt: 3 }}>
      <Box sx={{ mb: 2 }}>
        <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
          <MenuBookOutlinedIcon color="secondary" />
          <Typography variant="h4">Rules & Regulations</Typography>
        </Box>
        <Typography variant="body2" color="text.secondary" sx={{ mt: 0.5 }}>
          Retrieval-augmented answers from the Laws of the Game and the FIFA World Cup 2026 regulations.
        </Typography>
      </Box>

      <Paper sx={{ display: "flex", flexDirection: "column", height: "calc(100vh - 240px)", minHeight: 460, overflow: "hidden" }}>
        <Box ref={scrollRef} sx={{ flex: 1, overflowY: "auto", p: 2, display: "flex", flexDirection: "column", gap: 1.5 }}>
          {messages.map((m, i) => (
            <Message key={i} msg={m} />
          ))}
          {loading && (
            <Box sx={{ display: "flex", alignItems: "center", gap: 1, color: "text.secondary" }}>
              <SoccerBallLoader size={18} />
              <Typography variant="caption">Searching the documents…</Typography>
            </Box>
          )}
        </Box>

        <Divider />
        <Box sx={{ px: 2, pt: 1.5 }}>
          <Stack direction="row" spacing={1} sx={{ flexWrap: "wrap", gap: 1, mb: 1 }}>
            {SUGGESTIONS.map((s) => (
              <Chip key={s} label={s} size="small" variant="outlined" onClick={() => submit(s)} sx={{ cursor: "pointer" }} />
            ))}
          </Stack>
        </Box>
        <Box
          component="form"
          onSubmit={(e) => {
            e.preventDefault();
            submit();
          }}
          sx={{ display: "flex", gap: 1, p: 2, pt: 0 }}
        >
          <TextField
            fullWidth
            size="small"
            placeholder="Ask about the rules…"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            autoComplete="off"
          />
          <IconButton type="submit" color="secondary" disabled={loading || !input.trim()}>
            <SendRoundedIcon />
          </IconButton>
        </Box>
      </Paper>
    </Container>
  );
}
