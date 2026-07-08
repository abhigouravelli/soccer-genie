// Real national-team flags (flagcdn.com) and generated player avatars
// (DiceBear). No new DB columns are needed for either: flags are derived
// from the team's FIFA code, avatars are derived from the player's id so
// they stay stable across edits.

// FIFA squad code -> ISO 3166-1 alpha-2 (flagcdn.com uses alpha-2; England
// and Scotland use flagcdn's UK-subdivision codes since they aren't
// sovereign ISO countries).
const FIFA_TO_ISO2 = {
  GER: "de", FRA: "fr", ITA: "it", ESP: "es", ENG: "gb-eng", POR: "pt",
  NED: "nl", BEL: "be", CRO: "hr", POL: "pl", SUI: "ch", AUT: "at",
  SCO: "gb-sct", TUR: "tr", DEN: "dk", SRB: "rs", UKR: "ua",
  SWE: "se", NOR: "no",
  BRA: "br", ARG: "ar", URU: "uy", COL: "co", ECU: "ec", CHI: "cl",
  USA: "us", MEX: "mx", CAN: "ca", HON: "hn", JAM: "jm", PAN: "pa",
  MAR: "ma", SEN: "sn", CMR: "cm", CIV: "ci", NGA: "ng", EGY: "eg",
  ALG: "dz", RSA: "za", COD: "cd", MLI: "ml",
  JPN: "jp", KOR: "kr", AUS: "au", IRN: "ir", KSA: "sa", IRQ: "iq",
  JOR: "jo", UZB: "uz", NZL: "nz",
};

// Returns a real flag image URL for a FIFA/country code, or null if the
// code isn't recognised (caller should fall back to the flag emoji).
export function flagUrl(code, width = 40) {
  const iso2 = FIFA_TO_ISO2[String(code || "").toUpperCase()];
  return iso2 ? `https://flagcdn.com/w${width}/${iso2}.png` : null;
}

// Generated "player picture" — consistent per player (seeded by id/name),
// no real photo required.
export function playerAvatarUrl(seed) {
  return `https://api.dicebear.com/9.x/avataaars/svg?seed=${encodeURIComponent(
    String(seed)
  )}&radius=50&backgroundType=gradientLinear`;
}
