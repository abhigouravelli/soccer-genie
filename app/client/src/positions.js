// Shared colour + label mapping for player positions.
export const POSITION_META = {
  GK: { label: "GK", color: "#f59e0b", full: "Goalkeeper" },
  DF: { label: "DF", color: "#38bdf8", full: "Defender" },
  MF: { label: "MF", color: "#a78bfa", full: "Midfielder" },
  FW: { label: "FW", color: "#fb7185", full: "Forward" },
};

export function positionColor(code) {
  return POSITION_META[code]?.color || "#94a3b8";
}
