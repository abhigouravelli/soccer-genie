import { flagUrl } from "../media.js";

// Real flag image when we can map the code, otherwise falls back to the
// flag emoji already stored on the country/player row.
export default function CountryFlag({ code, emoji, size = 20, style }) {
  const src = flagUrl(code, Math.max(size * 2, 40));
  if (!src) {
    return <span style={{ fontSize: size, lineHeight: 1, ...style }}>{emoji}</span>;
  }
  return (
    <img
      src={src}
      alt=""
      width={size}
      height={Math.round(size * 0.75)}
      style={{
        borderRadius: 3,
        objectFit: "cover",
        boxShadow: "0 0 0 1px rgba(255,255,255,0.18)",
        display: "block",
        flexShrink: 0,
        ...style,
      }}
      onError={(e) => {
        e.currentTarget.outerHTML = `<span style="font-size:${size}px;line-height:1">${emoji || ""}</span>`;
      }}
    />
  );
}
