import { useEffect, useState } from "react";
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  TextField,
  MenuItem,
  Grid,
  Box,
  Typography,
  Alert,
  Avatar,
} from "@mui/material";
import { updatePlayer } from "../api.js";
import { playerAvatarUrl } from "../media.js";
import CountryFlag from "./CountryFlag.jsx";

const POSITIONS = [
  { value: "GK", label: "Goalkeeper" },
  { value: "DF", label: "Defender" },
  { value: "MF", label: "Midfielder" },
  { value: "FW", label: "Forward" },
];

export default function EditPlayerDialog({ player, open, onClose, onSaved }) {
  const [form, setForm] = useState({});
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    if (player) {
      setForm({
        full_name: player.full_name ?? "",
        shirt_name: player.shirt_name ?? "",
        position: player.position ?? "MF",
        jersey_number: player.jersey_number ?? "",
        club: player.club ?? "",
        caps: player.caps ?? "",
        goals: player.goals ?? "",
        age: player.age ?? "",
      });
      setError("");
    }
  }, [player]);

  const set = (key) => (e) => setForm((f) => ({ ...f, [key]: e.target.value }));

  async function handleSave() {
    setSaving(true);
    setError("");
    try {
      const payload = {
        ...form,
        jersey_number: form.jersey_number === "" ? null : Number(form.jersey_number),
        caps: form.caps === "" ? null : Number(form.caps),
        goals: form.goals === "" ? null : Number(form.goals),
        age: form.age === "" ? null : Number(form.age),
      };
      const updated = await updatePlayer(player.id, payload);
      onSaved(updated);
    } catch (e) {
      setError(e.message);
    } finally {
      setSaving(false);
    }
  }

  if (!player) return null;

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth>
      <DialogTitle sx={{ pb: 0.5 }}>
        <Box sx={{ display: "flex", alignItems: "center", gap: 1.5 }}>
          <Avatar src={playerAvatarUrl(player.id ?? player.full_name)} sx={{ width: 44, height: 44 }}>
            {(player.shirt_name || player.full_name || "?").slice(0, 2).toUpperCase()}
          </Avatar>
          <Box>
            <Typography variant="subtitle1" sx={{ fontWeight: 700, lineHeight: 1.2 }}>
              Edit player
            </Typography>
            <Box sx={{ display: "flex", alignItems: "center", gap: 0.75 }}>
              <CountryFlag code={player.country_code} emoji={player.flag_emoji} size={16} />
              <Typography variant="body2" color="text.secondary">
                {player.country}
                {player.fifa_ranking != null && ` · FIFA #${player.fifa_ranking}`}
              </Typography>
            </Box>
          </Box>
        </Box>
        <Typography variant="caption" color="text.secondary" sx={{ display: "block", mt: 0.75 }}>
          Country is set by the player's national team and isn't editable here.
        </Typography>
      </DialogTitle>
      <DialogContent>
        {error && (
          <Alert severity="error" sx={{ mb: 2, mt: 1 }}>
            {error}
          </Alert>
        )}
        <Box component="form" sx={{ mt: 1 }}>
          <Grid container spacing={2}>
            <Grid item xs={12} sm={8}>
              <TextField
                label="Full name"
                value={form.full_name}
                onChange={set("full_name")}
                fullWidth
                required
              />
            </Grid>
            <Grid item xs={12} sm={4}>
              <TextField
                label="Shirt name"
                value={form.shirt_name}
                onChange={set("shirt_name")}
                fullWidth
              />
            </Grid>
            <Grid item xs={6} sm={4}>
              <TextField
                label="Position"
                value={form.position}
                onChange={set("position")}
                select
                fullWidth
              >
                {POSITIONS.map((p) => (
                  <MenuItem key={p.value} value={p.value}>
                    {p.label}
                  </MenuItem>
                ))}
              </TextField>
            </Grid>
            <Grid item xs={6} sm={4}>
              <TextField
                label="Jersey #"
                type="number"
                value={form.jersey_number}
                onChange={set("jersey_number")}
                fullWidth
              />
            </Grid>
            <Grid item xs={6} sm={4}>
              <TextField
                label="Age"
                type="number"
                value={form.age}
                onChange={set("age")}
                fullWidth
              />
            </Grid>
            <Grid item xs={12} sm={6}>
              <TextField label="Club" value={form.club} onChange={set("club")} fullWidth />
            </Grid>
            <Grid item xs={6} sm={3}>
              <TextField
                label="Caps"
                type="number"
                value={form.caps}
                onChange={set("caps")}
                fullWidth
              />
            </Grid>
            <Grid item xs={6} sm={3}>
              <TextField
                label="Goals"
                type="number"
                value={form.goals}
                onChange={set("goals")}
                fullWidth
              />
            </Grid>
          </Grid>
        </Box>
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose} color="inherit">
          Cancel
        </Button>
        <Button onClick={handleSave} variant="contained" disabled={saving || !form.full_name}>
          {saving ? "Saving…" : "Save changes"}
        </Button>
      </DialogActions>
    </Dialog>
  );
}
