import { useEffect, useState } from "react";
import {
  Container,
  Grid,
  Paper,
  Box,
  TextField,
  MenuItem,
  InputAdornment,
  Chip,
  Snackbar,
  Alert,
} from "@mui/material";
import SearchRoundedIcon from "@mui/icons-material/SearchRounded";
import PlayersTable from "./PlayersTable.jsx";
import EditPlayerDialog from "./EditPlayerDialog.jsx";
import ChatPanel from "./ChatPanel.jsx";
import CountryFlag from "./CountryFlag.jsx";
import { fetchPlayers, fetchCountries } from "../api.js";

const POSITIONS = [
  { value: "", label: "All positions" },
  { value: "GK", label: "Goalkeepers" },
  { value: "DF", label: "Defenders" },
  { value: "MF", label: "Midfielders" },
  { value: "FW", label: "Forwards" },
];

export default function SquadExplorer() {
  const [players, setPlayers] = useState([]);
  const [total, setTotal] = useState(0);
  const [countries, setCountries] = useState([]);
  const [loading, setLoading] = useState(true);

  const [search, setSearch] = useState("");
  const [country, setCountry] = useState("");
  const [position, setPosition] = useState("");

  const [editing, setEditing] = useState(null);
  const [toast, setToast] = useState("");

  useEffect(() => {
    fetchCountries().then(setCountries).catch(() => {});
  }, []);

  // Debounced load whenever filters change.
  useEffect(() => {
    setLoading(true);
    const t = setTimeout(() => {
      fetchPlayers({ search, country, position, limit: 300 })
        .then((data) => {
          setPlayers(data.players);
          setTotal(data.total);
        })
        .catch(() => setToast("Could not reach the API. Is the server running on :4000?"))
        .finally(() => setLoading(false));
    }, 250);
    return () => clearTimeout(t);
  }, [search, country, position]);

  function handleSaved(updated) {
    setPlayers((list) => list.map((p) => (p.id === updated.id ? { ...p, ...updated } : p)));
    setEditing(null);
    setToast(`Saved ${updated.full_name}.`);
  }

  return (
    <Container maxWidth="xl" sx={{ mt: 3 }}>
      <Grid container spacing={3}>
        {/* Left: players + filters */}
        <Grid item xs={12} md={8}>
          <Paper sx={{ p: 2, mb: 2 }}>
            <Grid container spacing={2} alignItems="center">
              <Grid item xs={12} sm={5}>
                <TextField
                  fullWidth
                  size="small"
                  placeholder="Search name or club…"
                  value={search}
                  onChange={(e) => setSearch(e.target.value)}
                  InputProps={{
                    startAdornment: (
                      <InputAdornment position="start">
                        <SearchRoundedIcon fontSize="small" />
                      </InputAdornment>
                    ),
                  }}
                />
              </Grid>
              <Grid item xs={7} sm={4}>
                <TextField
                  select
                  fullWidth
                  size="small"
                  label="Country"
                  value={country}
                  onChange={(e) => setCountry(e.target.value)}
                >
                  <MenuItem value="">All countries</MenuItem>
                  {countries.map((c) => (
                    <MenuItem key={c.id} value={c.name}>
                      <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
                        <CountryFlag code={c.code} emoji={c.flag_emoji} size={16} />
                        {c.name}
                        {c.fifa_ranking != null && (
                          <Box component="span" sx={{ color: "text.secondary", fontSize: 12 }}>
                            · FIFA #{c.fifa_ranking}
                          </Box>
                        )}
                      </Box>
                    </MenuItem>
                  ))}
                </TextField>
              </Grid>
              <Grid item xs={5} sm={3}>
                <TextField
                  select
                  fullWidth
                  size="small"
                  label="Position"
                  value={position}
                  onChange={(e) => setPosition(e.target.value)}
                >
                  {POSITIONS.map((p) => (
                    <MenuItem key={p.value} value={p.value}>
                      {p.label}
                    </MenuItem>
                  ))}
                </TextField>
              </Grid>
            </Grid>
            {(search || country || position) && (
              <Box sx={{ mt: 1.5 }}>
                <Chip
                  label="Clear filters"
                  size="small"
                  onClick={() => {
                    setSearch("");
                    setCountry("");
                    setPosition("");
                  }}
                  onDelete={() => {
                    setSearch("");
                    setCountry("");
                    setPosition("");
                  }}
                />
              </Box>
            )}
          </Paper>

          <Paper sx={{ overflow: "hidden" }}>
            <PlayersTable players={players} loading={loading} onEdit={setEditing} />
          </Paper>
        </Grid>

        {/* Right: chat */}
        <Grid item xs={12} md={4}>
          <Box sx={{ height: { md: "calc(100vh - 190px)" }, minHeight: 480, position: "sticky", top: 138 }}>
            <ChatPanel />
          </Box>
        </Grid>
      </Grid>

      <EditPlayerDialog
        player={editing}
        open={Boolean(editing)}
        onClose={() => setEditing(null)}
        onSaved={handleSaved}
      />

      <Snackbar
        open={Boolean(toast)}
        autoHideDuration={3000}
        onClose={() => setToast("")}
        anchorOrigin={{ vertical: "bottom", horizontal: "center" }}
      >
        <Alert severity="success" variant="filled" onClose={() => setToast("")}>
          {toast}
        </Alert>
      </Snackbar>
    </Container>
  );
}
