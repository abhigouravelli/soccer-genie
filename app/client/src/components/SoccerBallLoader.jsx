import { useId } from "react";
import { Box } from "@mui/material";

// App-wide loading indicator: a spinning rendition of the adidas "Trionda",
// the official FIFA World Cup 2026 match ball — a white ball with the three
// host-nation colours (red, blue, green) in the signature three-wave pinwheel.
// Drawn as an SVG so it needs no image asset, stays crisp at any size, and
// works offline. (Stylised — not the licensed product photo.)

// One curved "wave" blade, rotated to 0°/120°/240° to form the tri-onda swirl.
const BLADE = "M50 50 C60 32 82 40 85 52 C78 58 64 56 50 50 Z";
const WAVES = [
  { deg: 0, fill: "#e4002b" },   // red
  { deg: 120, fill: "#0066cc" }, // blue
  { deg: 240, fill: "#00a650" }, // green
];

export default function SoccerBallLoader({ size = 48, sx }) {
  const clip = useId().replace(/:/g, "");

  return (
    <Box
      component="span"
      aria-label="Loading"
      role="status"
      sx={{
        display: "inline-flex",
        lineHeight: 0,
        "@keyframes trionda-spin": { to: { transform: "rotate(360deg)" } },
        animation: "trionda-spin 1.1s linear infinite",
        "@media (prefers-reduced-motion: reduce)": { animationDuration: "3s" },
        ...sx,
      }}
    >
      <svg width={size} height={size} viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <clipPath id={clip}>
            <circle cx="50" cy="50" r="46" />
          </clipPath>
        </defs>
        <circle cx="50" cy="50" r="46" fill="#ffffff" stroke="#cbd5e1" strokeWidth="2" />
        <g clipPath={`url(#${clip})`}>
          {WAVES.map(({ deg, fill }) => (
            <path key={deg} d={BLADE} fill={fill} transform={`rotate(${deg} 50 50)`} />
          ))}
          {/* white hub keeps the three waves from merging into a blob */}
          <circle cx="50" cy="50" r="9" fill="#ffffff" />
        </g>
        <circle cx="50" cy="50" r="46" fill="none" stroke="#cbd5e1" strokeWidth="2" />
      </svg>
    </Box>
  );
}
