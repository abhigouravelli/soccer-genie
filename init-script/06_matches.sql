--
-- PostgreSQL database dump
--

\restrict 2OAh7RodqhAPbPGxW5FWRu0caIflDicztrfFfrD9dBfqf7ndIKbMe6H8ZdI2vjE

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: matches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.matches (
    id integer NOT NULL,
    match_number smallint NOT NULL,
    stage public.match_stage DEFAULT 'Group'::public.match_stage NOT NULL,
    group_id integer,
    home_team_id integer,
    away_team_id integer,
    stadium_id integer NOT NULL,
    match_date timestamp with time zone,
    home_score smallint,
    away_score smallint,
    home_pens smallint,
    away_pens smallint,
    status public.match_status DEFAULT 'Scheduled'::public.match_status NOT NULL,
    attendance integer,
    referee character varying(100),
    CONSTRAINT no_self_match CHECK ((home_team_id <> away_team_id))
);


--
-- Name: matches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.matches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: matches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.matches_id_seq OWNED BY public.matches.id;


--
-- Name: matches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matches ALTER COLUMN id SET DEFAULT nextval('public.matches_id_seq'::regclass);


--
-- Data for Name: matches; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.matches VALUES (336, 1, 'Group', 1, 2, 29, 14, '2026-06-11 19:00:00+00', 2, 0, NULL, NULL, 'Completed', 80824, NULL);
INSERT INTO public.matches VALUES (337, 2, 'Group', 1, 46, 78, 16, '2026-06-12 02:00:00+00', 2, 1, NULL, NULL, 'Completed', 44985, NULL);
INSERT INTO public.matches VALUES (338, 3, 'Group', 2, 11, 49, 13, '2026-06-12 19:00:00+00', 1, 1, NULL, NULL, 'Completed', 43002, NULL);
INSERT INTO public.matches VALUES (339, 4, 'Group', 3, 6, 81, 21, '2026-06-13 01:00:00+00', 4, 1, NULL, NULL, 'Completed', 70492, NULL);
INSERT INTO public.matches VALUES (340, 5, 'Group', 2, 82, 16, 21, '2026-06-13 19:00:00+00', 1, 1, NULL, NULL, 'Completed', -1, NULL);
INSERT INTO public.matches VALUES (341, 6, 'Group', 4, 15, 19, 21, '2026-06-13 22:00:00+00', 1, 1, NULL, NULL, 'Completed', 80663, NULL);
INSERT INTO public.matches VALUES (342, 7, 'Group', 4, 80, 47, 8, '2026-06-14 01:00:00+00', 0, 1, NULL, NULL, 'Completed', 64146, NULL);
INSERT INTO public.matches VALUES (343, 8, 'Group', 3, 25, 12, 12, '2026-06-14 04:00:00+00', 2, 0, NULL, NULL, 'Completed', 52497, NULL);
INSERT INTO public.matches VALUES (344, 9, 'Group', 5, 24, 77, 21, '2026-06-14 17:00:00+00', 7, 1, NULL, NULL, 'Completed', 68021, NULL);
INSERT INTO public.matches VALUES (345, 10, 'Group', 6, 44, 22, 21, '2026-06-14 20:00:00+00', 2, 2, NULL, NULL, 'Completed', 69285, NULL);
INSERT INTO public.matches VALUES (346, 11, 'Group', 5, 9, 14, 21, '2026-06-14 23:00:00+00', 1, 0, NULL, NULL, 'Completed', 68274, NULL);
INSERT INTO public.matches VALUES (347, 12, 'Group', 6, 51, 83, 15, '2026-06-15 02:00:00+00', 5, 1, NULL, NULL, 'Completed', 50987, NULL);
INSERT INTO public.matches VALUES (348, 13, 'Group', 7, 32, 76, 18, '2026-06-15 16:00:00+00', 0, 0, NULL, NULL, 'Completed', 67640, NULL);
INSERT INTO public.matches VALUES (349, 14, 'Group', 8, 35, 13, 7, '2026-06-15 19:00:00+00', 1, 1, NULL, NULL, 'Completed', 66775, NULL);
INSERT INTO public.matches VALUES (350, 15, 'Group', 7, 33, 42, 21, '2026-06-15 22:00:00+00', 1, 1, NULL, NULL, 'Completed', 62464, NULL);
INSERT INTO public.matches VALUES (351, 16, 'Group', 8, 37, 17, 21, '2026-06-16 01:00:00+00', 2, 2, NULL, NULL, 'Completed', 70108, NULL);
INSERT INTO public.matches VALUES (352, 17, 'Group', 9, 20, 30, 21, '2026-06-16 19:00:00+00', 3, 1, NULL, NULL, 'Completed', 80545, NULL);
INSERT INTO public.matches VALUES (353, 18, 'Group', 9, 41, 50, 8, '2026-06-16 22:00:00+00', 1, 4, NULL, NULL, 'Completed', 63106, NULL);
INSERT INTO public.matches VALUES (354, 19, 'Group', 10, 28, 23, 21, '2026-06-17 01:00:00+00', 3, 0, NULL, NULL, 'Completed', 69045, NULL);
INSERT INTO public.matches VALUES (355, 20, 'Group', 10, 43, 21, 21, '2026-06-17 04:00:00+00', 3, 1, NULL, NULL, 'Completed', 68527, NULL);
INSERT INTO public.matches VALUES (356, 21, 'Group', 11, 40, 38, 21, '2026-06-17 17:00:00+00', 1, 1, NULL, NULL, 'Completed', 68777, NULL);
INSERT INTO public.matches VALUES (357, 22, 'Group', 12, 36, 8, 21, '2026-06-17 20:00:00+00', 4, 2, NULL, NULL, 'Completed', 70389, NULL);
INSERT INTO public.matches VALUES (358, 23, 'Group', 12, 79, 1, 13, '2026-06-17 23:00:00+00', 1, 0, NULL, NULL, 'Completed', 42942, NULL);
INSERT INTO public.matches VALUES (359, 24, 'Group', 11, 45, 27, 14, '2026-06-18 02:00:00+00', 1, 3, NULL, NULL, 'Completed', 80824, NULL);
INSERT INTO public.matches VALUES (360, 25, 'Group', 1, 78, 29, 18, '2026-06-18 16:00:00+00', 1, 1, NULL, NULL, 'Completed', 67442, NULL);
INSERT INTO public.matches VALUES (361, 26, 'Group', 2, 16, 49, 21, '2026-06-18 19:00:00+00', 4, 1, NULL, NULL, 'Completed', 70026, NULL);
INSERT INTO public.matches VALUES (362, 27, 'Group', 2, 11, 82, 12, '2026-06-18 22:00:00+00', 6, 0, NULL, NULL, 'Completed', 52497, NULL);
INSERT INTO public.matches VALUES (363, 28, 'Group', 1, 2, 46, 16, '2026-06-19 01:00:00+00', 1, 0, NULL, NULL, 'Completed', 45522, NULL);
INSERT INTO public.matches VALUES (364, 29, 'Group', 3, 6, 25, 7, '2026-06-19 19:00:00+00', 2, 0, NULL, NULL, 'Completed', 66925, NULL);
INSERT INTO public.matches VALUES (365, 30, 'Group', 4, 47, 19, 8, '2026-06-19 22:00:00+00', 0, 1, NULL, NULL, 'Completed', 64146, NULL);
INSERT INTO public.matches VALUES (366, 31, 'Group', 4, 15, 80, 21, '2026-06-20 00:30:00+00', 3, 0, NULL, NULL, 'Completed', 68324, NULL);
INSERT INTO public.matches VALUES (367, 32, 'Group', 3, 12, 81, 21, '2026-06-20 03:00:00+00', 0, 1, NULL, NULL, 'Completed', 68827, NULL);
INSERT INTO public.matches VALUES (368, 33, 'Group', 6, 44, 51, 21, '2026-06-20 17:00:00+00', 5, 1, NULL, NULL, 'Completed', 68777, NULL);
INSERT INTO public.matches VALUES (369, 34, 'Group', 5, 24, 9, 13, '2026-06-20 20:00:00+00', 2, 1, NULL, NULL, 'Completed', 43036, NULL);
INSERT INTO public.matches VALUES (370, 35, 'Group', 5, 14, 77, 21, '2026-06-21 00:00:00+00', 0, 0, NULL, NULL, 'Completed', 68598, NULL);
INSERT INTO public.matches VALUES (371, 36, 'Group', 6, 83, 22, 15, '2026-06-21 04:00:00+00', 0, 4, NULL, NULL, 'Completed', 51243, NULL);
INSERT INTO public.matches VALUES (372, 37, 'Group', 7, 32, 33, 18, '2026-06-21 16:00:00+00', 4, 0, NULL, NULL, 'Completed', 68239, NULL);
INSERT INTO public.matches VALUES (373, 38, 'Group', 8, 35, 37, 21, '2026-06-21 19:00:00+00', 0, 0, NULL, NULL, 'Completed', 70317, NULL);
INSERT INTO public.matches VALUES (374, 39, 'Group', 7, 42, 76, 21, '2026-06-21 22:00:00+00', 2, 2, NULL, NULL, 'Completed', 64003, NULL);
INSERT INTO public.matches VALUES (375, 40, 'Group', 8, 17, 13, 12, '2026-06-22 01:00:00+00', 1, 3, NULL, NULL, 'Completed', 52497, NULL);
INSERT INTO public.matches VALUES (376, 41, 'Group', 10, 28, 43, 21, '2026-06-22 17:00:00+00', 2, 0, NULL, NULL, 'Completed', 70649, NULL);
INSERT INTO public.matches VALUES (377, 42, 'Group', 9, 20, 41, 21, '2026-06-22 21:00:00+00', 3, 0, NULL, NULL, 'Completed', 68324, NULL);
INSERT INTO public.matches VALUES (378, 43, 'Group', 9, 50, 30, 21, '2026-06-23 00:00:00+00', 3, 2, NULL, NULL, 'Completed', 80663, NULL);
INSERT INTO public.matches VALUES (379, 44, 'Group', 10, 21, 23, 21, '2026-06-23 03:00:00+00', 1, 2, NULL, NULL, 'Completed', 68371, NULL);
INSERT INTO public.matches VALUES (380, 45, 'Group', 11, 40, 45, 21, '2026-06-23 17:00:00+00', 5, 0, NULL, NULL, 'Completed', 68777, NULL);
INSERT INTO public.matches VALUES (381, 46, 'Group', 12, 36, 79, 8, '2026-06-23 20:00:00+00', 0, 0, NULL, NULL, 'Completed', 63983, NULL);
INSERT INTO public.matches VALUES (382, 47, 'Group', 12, 1, 8, 13, '2026-06-23 23:00:00+00', 0, 1, NULL, NULL, 'Completed', 43036, NULL);
INSERT INTO public.matches VALUES (383, 48, 'Group', 11, 27, 38, 16, '2026-06-24 02:00:00+00', 1, 0, NULL, NULL, 'Completed', 45358, NULL);
INSERT INTO public.matches VALUES (384, 49, 'Group', 2, 16, 11, 12, '2026-06-24 19:00:00+00', 2, 1, NULL, NULL, 'Completed', 52497, NULL);
INSERT INTO public.matches VALUES (385, 50, 'Group', 2, 49, 82, 7, '2026-06-24 19:00:00+00', 3, 1, NULL, NULL, 'Completed', 66925, NULL);
INSERT INTO public.matches VALUES (386, 51, 'Group', 4, 47, 15, 21, '2026-06-24 22:00:00+00', 0, 3, NULL, NULL, 'Completed', 64478, NULL);
INSERT INTO public.matches VALUES (387, 52, 'Group', 4, 19, 80, 18, '2026-06-24 22:00:00+00', 4, 2, NULL, NULL, 'Completed', 68239, NULL);
INSERT INTO public.matches VALUES (388, 53, 'Group', 1, 29, 46, 15, '2026-06-25 01:00:00+00', 1, 0, NULL, NULL, 'Completed', 51243, NULL);
INSERT INTO public.matches VALUES (389, 54, 'Group', 1, 78, 2, 14, '2026-06-25 01:00:00+00', 0, 3, NULL, NULL, 'Completed', 80824, NULL);
INSERT INTO public.matches VALUES (390, 55, 'Group', 5, 14, 24, 21, '2026-06-25 20:00:00+00', 2, 1, NULL, NULL, 'Completed', 80663, NULL);
INSERT INTO public.matches VALUES (391, 56, 'Group', 5, 77, 9, 21, '2026-06-25 20:00:00+00', 0, 2, NULL, NULL, 'Completed', 68324, NULL);
INSERT INTO public.matches VALUES (392, 57, 'Group', 6, 83, 44, 21, '2026-06-25 23:00:00+00', 1, 3, NULL, NULL, 'Completed', 70137, NULL);
INSERT INTO public.matches VALUES (393, 58, 'Group', 6, 22, 51, 21, '2026-06-25 23:00:00+00', 1, 1, NULL, NULL, 'Completed', 70137, NULL);
INSERT INTO public.matches VALUES (394, 59, 'Group', 3, 81, 25, 21, '2026-06-26 02:00:00+00', 0, 0, NULL, NULL, 'Completed', 68827, NULL);
INSERT INTO public.matches VALUES (395, 60, 'Group', 3, 12, 6, 21, '2026-06-26 02:00:00+00', 3, 2, NULL, NULL, 'Completed', 70492, NULL);
INSERT INTO public.matches VALUES (396, 61, 'Group', 9, 50, 20, 8, '2026-06-26 19:00:00+00', 1, 4, NULL, NULL, 'Completed', 64146, NULL);
INSERT INTO public.matches VALUES (397, 62, 'Group', 9, 30, 41, 13, '2026-06-26 19:00:00+00', 5, 0, NULL, NULL, 'Completed', 43036, NULL);
INSERT INTO public.matches VALUES (398, 63, 'Group', 7, 42, 32, 16, '2026-06-27 00:00:00+00', 0, 1, NULL, NULL, 'Completed', 45065, NULL);
INSERT INTO public.matches VALUES (399, 64, 'Group', 7, 76, 33, 21, '2026-06-27 00:00:00+00', 0, 0, NULL, NULL, 'Completed', 68278, NULL);
INSERT INTO public.matches VALUES (400, 65, 'Group', 8, 13, 37, 7, '2026-06-27 03:00:00+00', 1, 1, NULL, NULL, 'Completed', 66925, NULL);
INSERT INTO public.matches VALUES (401, 66, 'Group', 8, 17, 35, 12, '2026-06-27 03:00:00+00', 1, 5, NULL, NULL, 'Completed', 52497, NULL);
INSERT INTO public.matches VALUES (402, 67, 'Group', 12, 8, 79, 21, '2026-06-27 21:00:00+00', 2, 1, NULL, NULL, 'Completed', 68324, NULL);
INSERT INTO public.matches VALUES (403, 68, 'Group', 12, 1, 36, 21, '2026-06-27 21:00:00+00', 0, 2, NULL, NULL, 'Completed', 80663, NULL);
INSERT INTO public.matches VALUES (404, 69, 'Group', 11, 27, 40, 21, '2026-06-27 23:30:00+00', 0, 0, NULL, NULL, 'Completed', 64478, NULL);
INSERT INTO public.matches VALUES (405, 70, 'Group', 11, 38, 45, 18, '2026-06-27 23:30:00+00', 3, 1, NULL, NULL, 'Completed', 68239, NULL);
INSERT INTO public.matches VALUES (406, 71, 'Group', 10, 23, 43, 21, '2026-06-28 02:00:00+00', 3, 3, NULL, NULL, 'Completed', 69045, NULL);
INSERT INTO public.matches VALUES (407, 72, 'Group', 10, 21, 28, 21, '2026-06-28 02:00:00+00', 1, 3, NULL, NULL, 'Completed', 70649, NULL);
INSERT INTO public.matches VALUES (408, 73, 'R32', NULL, 29, 11, 21, '2026-06-28 19:00:00+00', 0, 1, NULL, NULL, 'Completed', 69237, NULL);
INSERT INTO public.matches VALUES (409, 74, 'R32', NULL, 15, 22, 21, '2026-06-29 17:00:00+00', 2, 1, NULL, NULL, 'Completed', 68777, NULL);
INSERT INTO public.matches VALUES (410, 75, 'R32', NULL, 24, 81, 8, '2026-06-29 20:30:00+00', 1, 1, NULL, NULL, 'Completed', 63945, NULL);
INSERT INTO public.matches VALUES (411, 76, 'R32', NULL, 44, 19, 15, '2026-06-30 01:00:00+00', 1, 1, NULL, NULL, 'Completed', 51243, NULL);
INSERT INTO public.matches VALUES (412, 77, 'R32', NULL, 9, 50, 21, '2026-06-30 17:00:00+00', 1, 2, NULL, NULL, 'Completed', 69661, NULL);
INSERT INTO public.matches VALUES (413, 78, 'R32', NULL, 20, 51, 21, '2026-06-30 21:00:00+00', 3, 0, NULL, NULL, 'Completed', 80663, NULL);
INSERT INTO public.matches VALUES (414, 79, 'R32', NULL, 2, 14, 14, '2026-07-01 02:00:00+00', 2, 0, NULL, NULL, 'Completed', 80824, NULL);
INSERT INTO public.matches VALUES (415, 80, 'R32', NULL, 36, 38, 18, '2026-07-01 16:00:00+00', 2, 1, NULL, NULL, 'Completed', 68239, NULL);
INSERT INTO public.matches VALUES (416, 81, 'R32', NULL, 35, 30, 7, '2026-07-01 20:00:00+00', 3, 2, NULL, NULL, 'Completed', 66925, NULL);
INSERT INTO public.matches VALUES (417, 82, 'R32', NULL, 6, 49, 21, '2026-07-02 00:00:00+00', 2, 0, NULL, NULL, 'Completed', 68827, NULL);
INSERT INTO public.matches VALUES (418, 83, 'R32', NULL, 32, 43, 21, '2026-07-02 19:00:00+00', 3, 0, NULL, NULL, 'Completed', 70492, NULL);
INSERT INTO public.matches VALUES (419, 84, 'R32', NULL, 40, 8, 13, '2026-07-02 23:00:00+00', 2, 1, NULL, NULL, 'Completed', 43036, NULL);
INSERT INTO public.matches VALUES (420, 85, 'R32', NULL, 16, 23, 12, '2026-07-03 03:00:00+00', 2, 0, NULL, NULL, 'Completed', 52497, NULL);
INSERT INTO public.matches VALUES (421, 86, 'R32', NULL, 25, 13, 21, '2026-07-03 18:00:00+00', 1, 1, NULL, NULL, 'Completed', 70244, NULL);
INSERT INTO public.matches VALUES (422, 87, 'R32', NULL, 28, 76, 21, '2026-07-03 22:00:00+00', 3, 2, NULL, NULL, 'Completed', 64478, NULL);
INSERT INTO public.matches VALUES (423, 88, 'R32', NULL, 27, 79, 21, '2026-07-04 01:30:00+00', 1, 0, NULL, NULL, 'Completed', 69045, NULL);
INSERT INTO public.matches VALUES (424, 89, 'R16', NULL, 11, 19, 21, '2026-07-04 17:00:00+00', 0, 3, NULL, NULL, 'Completed', 68777, NULL);
INSERT INTO public.matches VALUES (425, 90, 'R16', NULL, 81, 20, 21, '2026-07-04 21:00:00+00', 0, 1, NULL, NULL, 'Completed', 68324, NULL);
INSERT INTO public.matches VALUES (426, 91, 'R16', NULL, 15, 50, 21, '2026-07-05 20:00:00+00', 1, 2, NULL, NULL, 'Completed', 80663, NULL);
INSERT INTO public.matches VALUES (427, 92, 'R16', NULL, 2, 36, 7, '2026-07-06 01:00:00+00', 2, 3, NULL, NULL, 'Completed', 80824, NULL);
INSERT INTO public.matches VALUES (428, 93, 'R16', NULL, 40, 32, 21, '2026-07-06 19:00:00+00', 0, 1, NULL, NULL, 'Completed', 70649, NULL);
INSERT INTO public.matches VALUES (429, 94, 'R16', NULL, 6, 35, 7, '2026-07-07 00:00:00+00', 1, 4, NULL, NULL, 'Completed', 66925, NULL);
INSERT INTO public.matches VALUES (430, 95, 'R16', NULL, 28, 13, 18, '2026-07-07 16:00:00+00', 3, 2, NULL, NULL, 'Completed', 68239, NULL);
INSERT INTO public.matches VALUES (431, 96, 'R16', NULL, 16, 27, 12, '2026-07-07 20:00:00+00', NULL, NULL, NULL, NULL, 'Scheduled', NULL, NULL);
INSERT INTO public.matches VALUES (432, 97, 'QF', NULL, 20, 19, 8, '2026-07-09 20:00:00+00', NULL, NULL, NULL, NULL, 'Scheduled', NULL, NULL);
INSERT INTO public.matches VALUES (433, 98, 'QF', NULL, 32, 35, 21, '2026-07-10 19:00:00+00', NULL, NULL, NULL, NULL, 'Scheduled', NULL, NULL);
INSERT INTO public.matches VALUES (434, 99, 'QF', NULL, 50, 36, 21, '2026-07-11 21:00:00+00', NULL, NULL, NULL, NULL, 'Scheduled', NULL, NULL);


--
-- Name: matches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.matches_id_seq', 434, true);


--
-- Name: matches matches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (id);


--
-- Name: idx_matches_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_matches_date ON public.matches USING btree (match_date);


--
-- Name: idx_matches_stage; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_matches_stage ON public.matches USING btree (stage);


--
-- Name: matches matches_away_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_away_team_id_fkey FOREIGN KEY (away_team_id) REFERENCES public.teams(id);


--
-- Name: matches matches_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- Name: matches matches_home_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_home_team_id_fkey FOREIGN KEY (home_team_id) REFERENCES public.teams(id);


--
-- Name: matches matches_stadium_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_stadium_id_fkey FOREIGN KEY (stadium_id) REFERENCES public.stadiums(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 2OAh7RodqhAPbPGxW5FWRu0caIflDicztrfFfrD9dBfqf7ndIKbMe6H8ZdI2vjE

