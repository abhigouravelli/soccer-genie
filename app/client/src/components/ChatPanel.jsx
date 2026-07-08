import { useEffect, useRef, useState } from "react";
import {
  Box,
  Paper,
  TextField,
  IconButton,
  Typography,
  Chip,
  Stack,
  Avatar,
} from "@mui/material";
import SendRoundedIcon from "@mui/icons-material/SendRounded";
import SmartToyOutlinedIcon from "@mui/icons-material/SmartToyOutlined";
import SoccerBallLoader from "./SoccerBallLoader.jsx";
import { sendChat } from "../api.js";
import { positionColor } from "../positions.js";
import { playerAvatarUrl } from "../media.js";
import CountryFlag from "./CountryFlag.jsx";

const SUGGESTIONS = [
  "Players from Argentina",
  "Goalkeepers from Mexico",
  "Who won Mexico vs Ecuador?",
  "Round of 32 results",
  "Top scorers",
  "Who is Messi?",
];

function PlayerLine({ p }) {
  return (
    <Box
      sx={{
        display: "flex",
        alignItems: "center",
        gap: 1,
        py: 0.5,
        borderTop: "1px solid rgba(255,255,255,0.06)",
      }}
    >
      <Avatar src={playerAvatarUrl(p.id ?? p.full_name)} sx={{ width: 22, height: 22, fontSize: 10 }}>
        {(p.full_name || "?").slice(0, 2).toUpperCase()}
      </Avatar>
      <Box
        sx={{
          width: 26,
          textAlign: "center",
          fontSize: 11,
          fontWeight: 700,
          color: positionColor(p.position),
        }}
      >
        {p.position}
      </Box>
      <Typography variant="body2" sx={{ flex: 1 }}>
        {p.full_name}
      </Typography>
      <CountryFlag code={p.country_code} emoji={p.flag_emoji} size={15} />
      <Typography variant="caption" color="text.secondary" sx={{ minWidth: 70, textAlign: "right" }}>
        {p.country}
      </Typography>
    </Box>
  );
}

function MatchLine({ m }) {
  const { home, away, winner, stage_label, date } = m;
  const hasScore = home.score != null && away.score != null;
  return (
    <Box sx={{ py: 0.5, borderTop: "1px solid rgba(255,255,255,0.06)" }}>
      <Box sx={{ display: "flex", alignItems: "center", gap: 0.75 }}>
        <CountryFlag code={home.code} emoji={home.flag_emoji} size={15} />
        <Typography variant="body2" sx={{ flex: 1, fontWeight: winner === "home" ? 800 : 500 }} noWrap>
          {home.name}
        </Typography>
        <Typography
          variant="body2"
          sx={{ fontWeight: 800, minWidth: 42, textAlign: "center", color: hasScore ? "text.primary" : "text.secondary" }}
        >
          {hasScore ? `${home.score}–${away.score}` : "vs"}
        </Typography>
        <Typography
          variant="body2"
          sx={{ flex: 1, fontWeight: winner === "away" ? 800 : 500, textAlign: "right" }}
          noWrap
        >
          {away.name}
        </Typography>
        <CountryFlag code={away.code} emoji={away.flag_emoji} size={15} />
      </Box>
      <Typography variant="caption" color="text.secondary" sx={{ display: "block", pl: "22px" }}>
        {stage_label}
        {date ? ` · ${date}` : ""}
      </Typography>
    </Box>
  );
}

function Message({ msg }) {
  const isUser = msg.role === "user";
  return (
    <Box sx={{ display: "flex", justifyContent: isUser ? "flex-end" : "flex-start", gap: 1 }}>
      {!isUser && (
        <Avatar sx={{ width: 30, height: 30, bgcolor: "primary.main", color: "#04140d" }}>
          <SmartToyOutlinedIcon fontSize="small" />
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
        <Typography variant="body2" sx={{ fontWeight: isUser ? 600 : 500 }}>
          {msg.text}
        </Typography>
        {msg.players?.length > 0 && (
          <Box sx={{ mt: 0.5 }}>
            {msg.players.slice(0, 12).map((p) => (
              <PlayerLine key={p.id} p={p} />
            ))}
            {msg.players.length > 12 && (
              <Typography variant="caption" color="text.secondary" sx={{ mt: 0.5, display: "block" }}>
                …and {msg.players.length - 12} more
              </Typography>
            )}
          </Box>
        )}
        {msg.matches?.length > 0 && (
          <Box sx={{ mt: 0.5 }}>
            {msg.matches.slice(0, 12).map((m) => (
              <MatchLine key={m.id} m={m} />
            ))}
            {msg.matches.length > 12 && (
              <Typography variant="caption" color="text.secondary" sx={{ mt: 0.5, display: "block" }}>
                …and {msg.matches.length - 12} more
              </Typography>
            )}
          </Box>
        )}
      </Paper>
    </Box>
  );
}

export default function ChatPanel() {
  const [messages, setMessages] = useState([
    {
      role: "bot",
      text:
        "Hi! Ask me about FIFA World Cup 2026 squads — try a country, a position, a count, or a player's name.",
      players: [],
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
      const res = await sendChat(q);
      setMessages((m) => [
        ...m,
        { role: "bot", text: res.answer, players: res.players, matches: res.matches },
      ]);
    } catch (e) {
      setMessages((m) => [...m, { role: "bot", text: `⚠️ ${e.message}`, players: [] }]);
    } finally {
      setLoading(false);
    }
  }

  return (
    <Paper sx={{ display: "flex", flexDirection: "column", height: "100%", overflow: "hidden" }}>
      <Box sx={{ px: 2, py: 1.5, borderBottom: "1px solid rgba(255,255,255,0.06)" }}>
        <Typography variant="h6" sx={{ display: "flex", alignItems: "center", gap: 1 }}>
          <SmartToyOutlinedIcon fontSize="small" color="primary" /> Squad Assistant
        </Typography>
        <Typography variant="caption" color="text.secondary">
          Ask questions — answers come straight from the database.
        </Typography>
      </Box>

      <Box ref={scrollRef} sx={{ flex: 1, overflowY: "auto", p: 2, display: "flex", flexDirection: "column", gap: 1.5 }}>
        {messages.map((m, i) => (
          <Message key={i} msg={m} />
        ))}
        {loading && (
          <Box sx={{ display: "flex", alignItems: "center", gap: 1, color: "text.secondary" }}>
            <SoccerBallLoader size={18} />
            <Typography variant="caption">Looking it up…</Typography>
          </Box>
        )}
      </Box>

      <Box sx={{ px: 2, pt: 1 }}>
        <Stack direction="row" spacing={1} sx={{ flexWrap: "wrap", gap: 1, mb: 1 }}>
          {SUGGESTIONS.map((s) => (
            <Chip
              key={s}
              label={s}
              size="small"
              variant="outlined"
              onClick={() => submit(s)}
              sx={{ cursor: "pointer" }}
            />
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
          placeholder="Ask about a player or country…"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          autoComplete="off"
        />
        <IconButton type="submit" color="primary" disabled={loading || !input.trim()}>
          <SendRoundedIcon />
        </IconButton>
      </Box>
    </Paper>
  );
}
