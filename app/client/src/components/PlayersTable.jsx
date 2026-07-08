import {
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Chip,
  IconButton,
  Avatar,
  Box,
  Typography,
  Tooltip,
} from "@mui/material";
import EditOutlinedIcon from "@mui/icons-material/EditOutlined";
import { POSITION_META, positionColor } from "../positions.js";
import { playerAvatarUrl } from "../media.js";
import CountryFlag from "./CountryFlag.jsx";
import SoccerBallLoader from "./SoccerBallLoader.jsx";

function PositionChip({ code }) {
  const meta = POSITION_META[code];
  return (
    <Chip
      label={meta?.label || code}
      size="small"
      sx={{
        bgcolor: `${positionColor(code)}22`,
        color: positionColor(code),
        fontWeight: 700,
        border: `1px solid ${positionColor(code)}55`,
      }}
    />
  );
}

export default function PlayersTable({ players, loading, onEdit }) {
  if (loading) {
    return (
      <Box sx={{ display: "flex", justifyContent: "center", py: 8 }}>
        <SoccerBallLoader size={56} />
      </Box>
    );
  }

  if (!players.length) {
    return (
      <Box sx={{ p: 6, textAlign: "center" }}>
        <Typography color="text.secondary">No players match your filters.</Typography>
      </Box>
    );
  }

  return (
    <TableContainer sx={{ maxHeight: "62vh" }}>
      <Table stickyHeader size="small">
        <TableHead>
          <TableRow>
            <TableCell>Player</TableCell>
            <TableCell>Country</TableCell>
            <TableCell align="center">Pos</TableCell>
            <TableCell align="center">#</TableCell>
            <TableCell>Club</TableCell>
            <TableCell align="center">Caps</TableCell>
            <TableCell align="center">Goals</TableCell>
            <TableCell align="right">Edit</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {players.map((p) => (
            <TableRow key={p.id} hover>
              <TableCell>
                <Box sx={{ display: "flex", alignItems: "center", gap: 1.5 }}>
                  <Avatar
                    src={playerAvatarUrl(p.id ?? p.full_name)}
                    sx={{
                      width: 34,
                      height: 34,
                      bgcolor: `${positionColor(p.position)}22`,
                      color: positionColor(p.position),
                      fontSize: 13,
                      fontWeight: 700,
                    }}
                  >
                    {(p.shirt_name || p.full_name || "?").slice(0, 2).toUpperCase()}
                  </Avatar>
                  <Box>
                    <Typography variant="body2" fontWeight={600}>
                      {p.full_name}
                    </Typography>
                    {p.shirt_name && p.shirt_name !== p.full_name && (
                      <Typography variant="caption" color="text.secondary">
                        {p.shirt_name}
                      </Typography>
                    )}
                  </Box>
                </Box>
              </TableCell>
              <TableCell>
                <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
                  <CountryFlag code={p.country_code} emoji={p.flag_emoji} size={18} />
                  <Box>
                    <Typography variant="body2">{p.country}</Typography>
                    {p.fifa_ranking != null && (
                      <Typography variant="caption" color="text.secondary">
                        FIFA #{p.fifa_ranking}
                      </Typography>
                    )}
                  </Box>
                </Box>
              </TableCell>
              <TableCell align="center">
                <PositionChip code={p.position} />
              </TableCell>
              <TableCell align="center">{p.jersey_number ?? "—"}</TableCell>
              <TableCell>
                <Typography variant="body2" color="text.secondary">
                  {p.club || "—"}
                </Typography>
              </TableCell>
              <TableCell align="center">{p.caps ?? 0}</TableCell>
              <TableCell align="center">
                <Typography fontWeight={p.goals ? 700 : 400} color={p.goals ? "primary" : "text.primary"}>
                  {p.goals ?? 0}
                </Typography>
              </TableCell>
              <TableCell align="right">
                <Tooltip title="Edit player">
                  <IconButton size="small" onClick={() => onEdit(p)}>
                    <EditOutlinedIcon fontSize="small" />
                  </IconButton>
                </Tooltip>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </TableContainer>
  );
}
