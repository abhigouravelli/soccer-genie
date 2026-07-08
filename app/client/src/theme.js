import { createTheme } from "@mui/material/styles";

// A modern, slightly "sporty" dark theme with a teal/green accent.
const theme = createTheme({
  palette: {
    mode: "dark",
    primary: { main: "#10b981" }, // emerald
    secondary: { main: "#38bdf8" }, // sky
    background: {
      default: "#0b1120",
      paper: "#111a2e",
    },
    success: { main: "#22c55e" },
    text: {
      primary: "#e7ecf3",
      secondary: "#9aa7bd",
    },
  },
  typography: {
    fontFamily: "Inter, system-ui, Roboto, Helvetica, Arial, sans-serif",
    h4: { fontWeight: 800, letterSpacing: -0.5 },
    h6: { fontWeight: 700 },
    button: { textTransform: "none", fontWeight: 600 },
  },
  shape: { borderRadius: 14 },
  components: {
    MuiPaper: {
      styleOverrides: {
        root: {
          backgroundImage: "none",
          border: "1px solid rgba(255,255,255,0.06)",
        },
      },
    },
    MuiButton: {
      styleOverrides: {
        root: { borderRadius: 12 },
      },
    },
  },
});

export default theme;
