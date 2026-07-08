--
-- PostgreSQL database dump
--

\restrict 8kIqseV4VZVaRESt9ENBceBp0JSqKcp7ypTXbbeowYfi0Zq37izfUU4p1gOfICp

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
-- Name: group_standings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_standings (
    id integer NOT NULL,
    group_id integer NOT NULL,
    team_id integer NOT NULL,
    played smallint DEFAULT 0,
    won smallint DEFAULT 0,
    drawn smallint DEFAULT 0,
    lost smallint DEFAULT 0,
    goals_for smallint DEFAULT 0,
    goals_against smallint DEFAULT 0,
    goal_diff smallint GENERATED ALWAYS AS ((goals_for - goals_against)) STORED,
    points smallint GENERATED ALWAYS AS (((won * 3) + drawn)) STORED
);


--
-- Name: group_standings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.group_standings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_standings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.group_standings_id_seq OWNED BY public.group_standings.id;


--
-- Name: group_standings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_standings ALTER COLUMN id SET DEFAULT nextval('public.group_standings_id_seq'::regclass);


--
-- Data for Name: group_standings; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.group_standings VALUES (97, 1, 2, 3, 3, 0, 0, 6, 0, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (98, 1, 29, 3, 1, 1, 1, 2, 3, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (99, 1, 46, 3, 1, 0, 2, 2, 3, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (100, 1, 78, 3, 0, 1, 2, 2, 6, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (101, 2, 11, 3, 1, 1, 1, 8, 3, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (102, 2, 49, 3, 1, 1, 1, 5, 6, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (103, 3, 6, 3, 2, 0, 1, 8, 4, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (104, 3, 81, 3, 1, 1, 1, 2, 4, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (105, 2, 82, 3, 0, 1, 2, 2, 10, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (106, 2, 16, 3, 2, 1, 0, 7, 3, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (107, 4, 15, 3, 2, 1, 0, 7, 1, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (108, 4, 19, 3, 2, 1, 0, 6, 3, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (109, 4, 80, 3, 0, 0, 3, 2, 8, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (110, 4, 47, 3, 1, 0, 2, 1, 4, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (111, 3, 25, 3, 1, 1, 1, 2, 2, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (112, 3, 12, 3, 1, 0, 2, 3, 5, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (113, 5, 24, 3, 2, 0, 1, 10, 4, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (114, 5, 77, 3, 0, 1, 2, 1, 9, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (115, 6, 44, 3, 2, 1, 0, 10, 4, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (116, 6, 22, 3, 1, 2, 0, 7, 3, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (117, 5, 9, 3, 2, 0, 1, 4, 2, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (118, 5, 14, 3, 1, 1, 1, 2, 2, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (119, 6, 51, 3, 1, 1, 1, 7, 7, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (120, 6, 83, 3, 0, 0, 3, 2, 12, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (121, 7, 32, 3, 2, 1, 0, 5, 0, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (122, 7, 76, 3, 0, 3, 0, 2, 2, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (123, 8, 35, 3, 1, 2, 0, 6, 2, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (124, 8, 13, 3, 1, 2, 0, 5, 3, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (125, 7, 33, 3, 0, 2, 1, 1, 5, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (126, 7, 42, 3, 0, 2, 1, 3, 4, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (127, 8, 37, 3, 0, 3, 0, 3, 3, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (128, 8, 17, 3, 0, 1, 2, 4, 10, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (129, 9, 20, 3, 3, 0, 0, 10, 2, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (130, 9, 30, 3, 1, 0, 2, 8, 6, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (131, 9, 41, 3, 0, 0, 3, 1, 12, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (132, 9, 50, 3, 2, 0, 1, 8, 7, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (133, 10, 28, 3, 3, 0, 0, 8, 1, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (134, 10, 23, 3, 1, 1, 1, 5, 7, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (135, 10, 43, 3, 1, 1, 1, 6, 6, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (136, 10, 21, 3, 0, 0, 3, 3, 8, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (137, 11, 40, 3, 1, 2, 0, 6, 1, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (138, 11, 38, 3, 1, 1, 1, 4, 3, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (139, 12, 36, 3, 2, 1, 0, 6, 2, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (140, 12, 8, 3, 2, 0, 1, 5, 5, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (141, 12, 79, 3, 1, 1, 1, 2, 2, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (142, 12, 1, 3, 0, 0, 3, 0, 4, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (143, 11, 45, 3, 0, 0, 3, 2, 11, DEFAULT, DEFAULT);
INSERT INTO public.group_standings VALUES (144, 11, 27, 3, 2, 1, 0, 4, 1, DEFAULT, DEFAULT);


--
-- Name: group_standings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.group_standings_id_seq', 144, true);


--
-- Name: group_standings group_standings_group_id_team_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_standings
    ADD CONSTRAINT group_standings_group_id_team_id_key UNIQUE (group_id, team_id);


--
-- Name: group_standings group_standings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_standings
    ADD CONSTRAINT group_standings_pkey PRIMARY KEY (id);


--
-- Name: idx_standings_group; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_standings_group ON public.group_standings USING btree (group_id);


--
-- Name: group_standings group_standings_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_standings
    ADD CONSTRAINT group_standings_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- Name: group_standings group_standings_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_standings
    ADD CONSTRAINT group_standings_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 8kIqseV4VZVaRESt9ENBceBp0JSqKcp7ypTXbbeowYfi0Zq37izfUU4p1gOfICp

