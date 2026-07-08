import { useState } from "react";
import { AppBar, Toolbar, Typography, Box, Tabs, Tab } from "@mui/material";
import SportsSoccerIcon from "@mui/icons-material/SportsSoccer";
import OverviewTab from "./components/OverviewTab.jsx";
import SquadExplorer from "./components/SquadExplorer.jsx";
import RulesTab from "./components/RulesTab.jsx";

export default function App() {
  const [tab, setTab] = useState(0);

  return (
    <Box sx={{ minHeight: "100vh", pb: 6 }}>
      <AppBar
        position="sticky"
        elevation={0}
        sx={{
          bgcolor: "rgba(17,26,46,0.85)",
          backdropFilter: "blur(8px)",
          borderBottom: "1px solid rgba(255,255,255,0.06)",
        }}
      >
        <Toolbar>
          <SportsSoccerIcon sx={{ mr: 1.5, color: "primary.main" }} />
          <Box sx={{ flex: 1 }}>
            <Typography variant="h6" sx={{ lineHeight: 1.1 }}>
              FIFA World Cup 2026
            </Typography>
            <Typography variant="caption" color="text.secondary">
              Live scores, fixtures and squad explorer
            </Typography>
          </Box>
        </Toolbar>
        <Tabs
          value={tab}
          onChange={(_e, v) => setTab(v)}
          sx={{ px: 2, borderTop: "1px solid rgba(255,255,255,0.06)", minHeight: 44 }}
        >
          <Tab label="Overview" sx={{ minHeight: 44 }} />
          <Tab label="Squad Explorer" sx={{ minHeight: 44 }} />
          <Tab label="Rules Q&A" sx={{ minHeight: 44 }} />
        </Tabs>
      </AppBar>

      {tab === 0 && <OverviewTab />}
      {tab === 1 && <SquadExplorer />}
      {tab === 2 && <RulesTab />}
    </Box>
  );
}
