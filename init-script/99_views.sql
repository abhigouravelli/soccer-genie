--
-- PostgreSQL database dump
--

\restrict OzE38EMNhdiO2RGbRoFxitkLWXGdn8CIySiLlc8lmKoc5OqW8jCBReBXSg9sQAs

-- Dumped from database version 17.10 (Debian 17.10-1.pgdg13+1)
-- Dumped by pg_dump version 17.10 (Debian 17.10-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: v_group_standings; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_group_standings AS
 SELECT g.name AS grp,
    c.name AS team,
    c.code,
    gs.played,
    gs.won,
    gs.drawn,
    gs.lost,
    gs.goals_for,
    gs.goals_against,
    gs.goal_diff,
    gs.points,
    rank() OVER (PARTITION BY gs.group_id ORDER BY gs.points DESC, gs.goal_diff DESC, gs.goals_for DESC) AS "position"
   FROM (((public.group_standings gs
     JOIN public.groups g ON ((g.id = gs.group_id)))
     JOIN public.teams t ON ((t.id = gs.team_id)))
     JOIN public.countries c ON ((c.id = t.country_id)))
  ORDER BY g.name, (rank() OVER (PARTITION BY gs.group_id ORDER BY gs.points DESC, gs.goal_diff DESC, gs.goals_for DESC));


--
-- PostgreSQL database dump complete
--

\unrestrict OzE38EMNhdiO2RGbRoFxitkLWXGdn8CIySiLlc8lmKoc5OqW8jCBReBXSg9sQAs

--
-- PostgreSQL database dump
--

\restrict E3l0U6wl5og6c2qLSaH5QuPmfMUEXzSRUjqsf4dsuKtDdkCabfktqahCb37taTK

-- Dumped from database version 17.10 (Debian 17.10-1.pgdg13+1)
-- Dumped by pg_dump version 17.10 (Debian 17.10-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: v_match_schedule; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_match_schedule AS
 SELECT m.match_number,
    m.stage,
    g.name AS grp,
    hc.name AS home_team,
    ac.name AS away_team,
    m.home_score,
    m.away_score,
    s.name AS stadium,
    s.city,
    s.host_country,
    m.match_date,
    m.status
   FROM ((((((public.matches m
     JOIN public.stadiums s ON ((s.id = m.stadium_id)))
     LEFT JOIN public.groups g ON ((g.id = m.group_id)))
     LEFT JOIN public.teams ht ON ((ht.id = m.home_team_id)))
     LEFT JOIN public.teams at ON ((at.id = m.away_team_id)))
     LEFT JOIN public.countries hc ON ((hc.id = ht.country_id)))
     LEFT JOIN public.countries ac ON ((ac.id = at.country_id)))
  ORDER BY m.match_date;


--
-- PostgreSQL database dump complete
--

\unrestrict E3l0U6wl5og6c2qLSaH5QuPmfMUEXzSRUjqsf4dsuKtDdkCabfktqahCb37taTK

