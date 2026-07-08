import { useEffect, useState } from "react";
import {
  Box,
  Container,
  Grid,
  Typography,
  Chip,
  Alert,
  Stack,
  TextField,
  IconButton,
  Button,
} from "@mui/material";
import CalendarMonthOutlinedIcon from "@mui/icons-material/CalendarMonthOutlined";
import FiberManualRecordIcon from "@mui/icons-material/FiberManualRecord";
import ChevronLeftIcon from "@mui/icons-material/ChevronLeft";
import ChevronRightIcon from "@mui/icons-material/ChevronRight";
import MatchCard from "./MatchCard.jsx";
import SoccerBallLoader from "./SoccerBallLoader.jsx";
import { fetchOverview } from "../api.js";

const REFRESH_MS = 10000; // poll for a "real-time" feel

// Local YYYY-MM-DD (avoids the UTC shift of toISOString()).
function toISO(date) {
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}-${String(
    date.getDate()
  ).padStart(2, "0")}`;
}
function addDays(iso, n) {
  const d = new Date(`${iso}T00:00:00`);
  d.setDate(d.getDate() + n);
  return toISO(d);
}

export default function OverviewTab() {
  const [day, setDay] = useState(() => toISO(new Date()));
  const [data, setData] = useState(null);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let active = true;
    setLoading(true);
    const load = () =>
      fetchOverview(day)
        .then((d) => {
          if (!active) return;
          setData(d);
          setError("");
        })
        .catch(() => active && setError("Could not reach the API. Is the server running on :4000?"))
        .finally(() => active && setLoading(false));

    load();
    const timer = setInterval(load, REFRESH_MS);
    return () => {
      active = false;
      clearInterval(timer);
    };
  }, [day]);

  const isToday = day === toISO(new Date());
  const dateLabel = new Date(`${day}T00:00:00`).toLocaleDateString(undefined, {
    weekday: "long",
    year: "numeric",
    month: "long",
    day: "numeric",
  });

  const todayByStage = groupByStage(data?.today || []);

  return (
    <Container maxWidth="xl" sx={{ mt: 3 }}>
      {/* Landing header — selected date */}
      <Box sx={{ mb: 3 }}>
        <Box sx={{ display: "flex", alignItems: "center", gap: 1, color: "primary.main" }}>
          <CalendarMonthOutlinedIcon />
          <Typography variant="overline" sx={{ letterSpacing: 1.5 }}>
            {dateLabel}
            {isToday ? " · Today" : ""}
          </Typography>
        </Box>
        <Typography variant="h4" sx={{ mt: 0.5 }}>
          FIFA World Cup 2026 — {isToday ? "Today" : "Fixtures"}
        </Typography>

        {/* Date navigation */}
        <Stack direction="row" spacing={1} sx={{ mt: 1.5 }} alignItems="center">
          <IconButton size="small" onClick={() => setDay((d) => addDays(d, -1))} aria-label="Previous day">
            <ChevronLeftIcon />
          </IconButton>
          <TextField
            type="date"
            size="small"
            value={day}
            onChange={(e) => e.target.value && setDay(e.target.value)}
            sx={{ width: 170 }}
          />
          <IconButton size="small" onClick={() => setDay((d) => addDays(d, 1))} aria-label="Next day">
            <ChevronRightIcon />
          </IconButton>
          <Button size="small" variant="text" disabled={isToday} onClick={() => setDay(toISO(new Date()))}>
            Today
          </Button>
        </Stack>

        <Stack direction="row" spacing={1} sx={{ mt: 1 }} alignItems="center">
          <Typography variant="body2" color="text.secondary">
            Live scores, fixtures and results.
          </Typography>
          {data?.source && (
            <Chip
              size="small"
              variant="outlined"
              label={`source: ${data.source}`}
              sx={{ height: 20, fontSize: 11 }}
            />
          )}
          {isToday && data?.live?.length > 0 && (
            <Chip
              size="small"
              icon={<FiberManualRecordIcon sx={{ fontSize: 12, color: "#ef4444 !important" }} />}
              label={`${data.live.length} live`}
              sx={{ height: 20, fontSize: 11, fontWeight: 700 }}
            />
          )}
        </Stack>
      </Box>

      {error && (
        <Alert severity="error" sx={{ mb: 2 }}>
          {error}
        </Alert>
      )}

      {loading && !data ? (
        <Box sx={{ display: "flex", justifyContent: "center", py: 8 }}>
          <SoccerBallLoader size={64} />
        </Box>
      ) : (
        <>
          {/* "Live now" and "Recent results" are tournament-wide dashboard
              sections — only meaningful on the Today view. On any other selected
              date we show just that date's fixtures (played / live / scheduled). */}
          {isToday && data?.live?.length > 0 && (
            <Section title="🔴 Live now">
              <MatchGrid matches={data.live} />
            </Section>
          )}

          {todayByStage.length > 0 ? (
            todayByStage.map(([label, matches]) => (
              <Section key={label} title={label}>
                <MatchGrid matches={matches} />
              </Section>
            ))
          ) : (
            <Alert severity="info" sx={{ mb: 3 }}>
              No matches {isToday ? "are being played today" : "were scheduled for this date"}.
              {isToday && data?.recent?.length > 0 ? " Recent results are shown below." : ""}
            </Alert>
          )}

          {isToday && data?.recent?.length > 0 && (
            <Section title="Recent results">
              <MatchGrid matches={data.recent} />
            </Section>
          )}
        </>
      )}
    </Container>
  );
}

function Section({ title, children }) {
  return (
    <Box sx={{ mb: 3 }}>
      <Typography variant="h6" sx={{ mb: 1.5 }}>
        {title}
      </Typography>
      {children}
    </Box>
  );
}

function MatchGrid({ matches }) {
  return (
    <Grid container spacing={2}>
      {matches.map((m) => (
        <Grid item xs={12} sm={6} md={4} lg={3} key={m.id}>
          <MatchCard match={m} />
        </Grid>
      ))}
    </Grid>
  );
}

// Group the day's fixtures by their stage label, preserving server order.
function groupByStage(matches) {
  const order = [];
  const map = new Map();
  for (const m of matches) {
    if (!map.has(m.stage_label)) {
      map.set(m.stage_label, []);
      order.push(m.stage_label);
    }
    map.get(m.stage_label).push(m);
  }
  return order.map((label) => [label, map.get(label)]);
}
