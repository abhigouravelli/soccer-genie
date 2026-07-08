import { Box, Paper, Typography, Chip } from "@mui/material";
import PlaceOutlinedIcon from "@mui/icons-material/PlaceOutlined";
import ArrowLeftIcon from "@mui/icons-material/ArrowLeft";
import CountryFlag from "./CountryFlag.jsx";

// A single fixture: two teams, score or kickoff time, status and scorers.
export default function MatchCard({ match }) {
  const { home, away, status, kickoff, minute, stadium, city, stage_label } = match;
  const live = status === "In_Progress";
  const done = status === "Completed";
  const hasScore = home.score != null && away.score != null;
  // Mark the leader on any card that has a score — completed (winner) or live
  // (currently ahead). Penalties break a level score.
  const homeWin =
    hasScore &&
    (home.score > away.score ||
      (home.score === away.score && (home.pens ?? 0) > (away.pens ?? 0)));
  const awayWin =
    hasScore &&
    (away.score > home.score ||
      (home.score === away.score && (away.pens ?? 0) > (home.pens ?? 0)));

  const kickoffTime = kickoff
    ? new Date(kickoff).toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" })
    : null;

  return (
    <Paper sx={{ p: 1.75, height: "100%" }}>
      <Box sx={{ display: "flex", alignItems: "center", justifyContent: "space-between", mb: 1 }}>
        <Chip label={stage_label} size="small" variant="outlined" sx={{ height: 22, fontSize: 11 }} />
        <StatusChip live={live} done={done} minute={minute} kickoffTime={kickoffTime} />
      </Box>

      <TeamRow team={home} score={hasScore ? home.score : null} winner={homeWin} />
      <TeamRow team={away} score={hasScore ? away.score : null} winner={awayWin} />

      {(home.pens != null || away.pens != null) && (
        <Typography variant="caption" color="text.secondary" sx={{ display: "block", mt: 0.5 }}>
          Penalties: {home.pens ?? 0}–{away.pens ?? 0}
        </Typography>
      )}

      {(home.scorers?.length > 0 || away.scorers?.length > 0) && (
        <Box sx={{ mt: 1, pt: 1, borderTop: "1px solid rgba(255,255,255,0.06)", display: "flex", gap: 2 }}>
          <ScorerList scorers={home.scorers} align="left" />
          <ScorerList scorers={away.scorers} align="right" />
        </Box>
      )}

      {stadium && (
        <Box sx={{ display: "flex", alignItems: "center", gap: 0.5, mt: 1, color: "text.secondary" }}>
          <PlaceOutlinedIcon sx={{ fontSize: 14 }} />
          <Typography variant="caption" noWrap>
            {stadium}
            {city ? `, ${city}` : ""}
          </Typography>
        </Box>
      )}
    </Paper>
  );
}

function StatusChip({ live, done, minute, kickoffTime }) {
  if (live) {
    return (
      <Chip
        size="small"
        label={minute ? `LIVE ${minute}'` : "LIVE"}
        sx={{
          height: 22,
          fontSize: 11,
          fontWeight: 700,
          bgcolor: "#ef4444",
          color: "#fff",
          animation: "pulse 1.6s ease-in-out infinite",
          "@keyframes pulse": { "50%": { opacity: 0.55 } },
        }}
      />
    );
  }
  if (done) {
    return <Chip size="small" label="FT" sx={{ height: 22, fontSize: 11, fontWeight: 700 }} color="success" />;
  }
  return (
    <Typography variant="caption" color="text.secondary" sx={{ fontWeight: 600 }}>
      {kickoffTime || "TBD"}
    </Typography>
  );
}

function TeamRow({ team, score, winner }) {
  return (
    <Box sx={{ display: "flex", alignItems: "center", gap: 1, py: 0.5 }}>
      <CountryFlag code={team.code} emoji={team.flag_emoji} size={20} />
      <Typography
        variant="body2"
        sx={{ flex: 1, fontWeight: winner ? 800 : 500, color: winner ? "text.primary" : "text.secondary" }}
        noWrap
      >
        {team.name}
      </Typography>
      <Typography variant="h6" sx={{ minWidth: 20, textAlign: "right", fontWeight: winner ? 800 : 500 }}>
        {score != null ? score : "–"}
      </Typography>
      {/* Fixed-width slot keeps both rows aligned; arrow marks the winner. */}
      <Box sx={{ width: 18, display: "flex", justifyContent: "center" }}>
        {winner && (
          <ArrowLeftIcon aria-label="Winner" sx={{ fontSize: 24, color: "primary.main", ml: -0.5 }} />
        )}
      </Box>
    </Box>
  );
}

function ScorerList({ scorers, align }) {
  if (!scorers?.length) return <Box sx={{ flex: 1 }} />;
  return (
    <Box sx={{ flex: 1, textAlign: align }}>
      {scorers.map((s, i) => (
        <Typography key={i} variant="caption" color="text.secondary" sx={{ display: "block", lineHeight: 1.5 }}>
          {align === "right" ? "" : "⚽ "}
          {s.name}
          {s.minute ? ` ${s.minute}'` : ""}
          {s.is_penalty ? " (P)" : ""}
          {s.is_own_goal ? " (OG)" : ""}
          {align === "right" ? " ⚽" : ""}
        </Typography>
      ))}
    </Box>
  );
}
