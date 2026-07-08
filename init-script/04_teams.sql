--
-- PostgreSQL database dump
--

\restrict poFHvDZqnnFrWhcu6ZLg8ldTyhate60r0Ci4NjyIpXV8mcjTaolo4iQcohFgkci

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
-- Name: teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teams (
    id integer NOT NULL,
    country_id integer NOT NULL,
    group_id integer NOT NULL,
    fifa_ranking integer,
    coach character varying(100),
    qualified_via character varying(60)
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.teams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.teams VALUES (23, 36, 10, 40, 'Vladimir Petković', 'CAF Qualifiers');
INSERT INTO public.teams VALUES (28, 19, 10, 1, 'Lionel Scaloni', 'CONMEBOL Qualifiers');
INSERT INTO public.teams VALUES (25, 42, 3, 23, 'Tony Popovic', 'AFC Qualifiers');
INSERT INTO public.teams VALUES (43, 12, 10, 27, 'Ralf Rangnick', 'UEFA Qualifiers');
INSERT INTO public.teams VALUES (35, 8, 8, 9, 'Domenico Tedesco', 'UEFA Qualifiers');
INSERT INTO public.teams VALUES (49, 49, 2, 62, 'Sergej Barbarez
', 'UEFA Qualifiers');
INSERT INTO public.teams VALUES (15, 18, 4, 3, 'Carlo Ancelotti', 'CONMEBOL Qualifiers');
INSERT INTO public.teams VALUES (11, 26, 2, 41, 'Jesse Marsch', 'Host');
INSERT INTO public.teams VALUES (76, 77, 7, NULL, NULL, NULL);
INSERT INTO public.teams VALUES (27, 21, 11, 11, 'Néstor Lorenzo', 'CONMEBOL Qualifiers');
INSERT INTO public.teams VALUES (8, 9, 12, 10, 'Zlatko Dalić', 'UEFA Qualifiers');
INSERT INTO public.teams VALUES (77, 78, 5, NULL, NULL, NULL);
INSERT INTO public.teams VALUES (78, 79, 1, NULL, NULL, NULL);
INSERT INTO public.teams VALUES (38, 38, 11, 67, 'Sébastien Desabre', 'CAF Qualifiers');
INSERT INTO public.teams VALUES (14, 22, 5, 44, 'Sebastián Beccacece', 'CONMEBOL Qualifiers');
INSERT INTO public.teams VALUES (13, 35, 8, 34, 'Hossam Hassan', 'CAF Qualifiers');
INSERT INTO public.teams VALUES (36, 5, 12, 4, 'Thomas Tuchel', 'UEFA Qualifiers');
INSERT INTO public.teams VALUES (20, 2, 9, 2, 'Didier Deschamps', 'UEFA Qualifiers');
INSERT INTO public.teams VALUES (24, 1, 5, 5, 'Julian Nagelsmann', 'UEFA Qualifiers');
INSERT INTO public.teams VALUES (79, 80, 12, NULL, NULL, NULL);
INSERT INTO public.teams VALUES (80, 81, 4, NULL, NULL, NULL);
INSERT INTO public.teams VALUES (37, 43, 8, 25, 'Amir Ghalenoei', 'AFC Qualifiers');
INSERT INTO public.teams VALUES (41, 45, 9, 58, 'Jesús Casas', 'AFC Qualifiers');
INSERT INTO public.teams VALUES (9, 33, 5, 53, 'Emerse Faé', 'CAF Qualifiers');
INSERT INTO public.teams VALUES (22, 40, 6, 15, 'Hajime Moriyasu', 'AFC Qualifiers');
INSERT INTO public.teams VALUES (21, 46, 10, 71, 'Hussain Ammouta', 'AFC Qualifiers');
INSERT INTO public.teams VALUES (2, 25, 1, 12, 'Javier Aguirre', 'Host');
INSERT INTO public.teams VALUES (19, 30, 4, 14, 'Walid Regragui', 'CAF Qualifiers');
INSERT INTO public.teams VALUES (44, 7, 6, 8, 'Ronald Koeman', 'UEFA Qualifiers');
INSERT INTO public.teams VALUES (17, 48, 8, 96, 'Darren Bazeley', 'OFC Qualifiers');
INSERT INTO public.teams VALUES (50, 51, 9, 38, NULL, 'UEFA Qualifiers');
INSERT INTO public.teams VALUES (1, 29, 12, 61, 'Thomas Christiansen', 'CONCACAF Qualifiers');
INSERT INTO public.teams VALUES (81, 82, 3, NULL, NULL, NULL);
INSERT INTO public.teams VALUES (40, 6, 11, 7, 'Roberto Martínez', 'UEFA Qualifiers');
INSERT INTO public.teams VALUES (82, 83, 2, NULL, NULL, NULL);
INSERT INTO public.teams VALUES (33, 44, 7, 56, 'Roberto Mancini', 'AFC Qualifiers');
INSERT INTO public.teams VALUES (47, 13, 4, 30, 'Steve Clarke', 'UEFA Qualifiers');
INSERT INTO public.teams VALUES (30, 31, 9, 20, 'Aliou Cissé', 'CAF Qualifiers');
INSERT INTO public.teams VALUES (29, 37, 1, 64, 'Hugo Broos', 'CAF Qualifiers');
INSERT INTO public.teams VALUES (46, 41, 1, 19, 'Hong Myung-bo', 'AFC Qualifiers');
INSERT INTO public.teams VALUES (32, 4, 7, 6, 'Luis de la Fuente', 'UEFA Qualifiers');
INSERT INTO public.teams VALUES (51, 50, 6, 24, NULL, 'UEFA Qualifiers');
INSERT INTO public.teams VALUES (16, 11, 2, 18, 'Murat Yakin', 'UEFA Qualifiers');
INSERT INTO public.teams VALUES (83, 84, 6, NULL, NULL, NULL);
INSERT INTO public.teams VALUES (12, 14, 3, 26, 'Vincenzo Montella', 'UEFA Qualifiers');
INSERT INTO public.teams VALUES (6, 24, 3, 13, 'Mauricio Pochettino', 'Host');
INSERT INTO public.teams VALUES (42, 20, 7, 16, 'Marcelo Bielsa', 'CONMEBOL Qualifiers');
INSERT INTO public.teams VALUES (45, 47, 11, 62, 'Srecko Katanec', 'AFC Qualifiers');


--
-- Name: teams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.teams_id_seq', 83, true);


--
-- Name: teams teams_country_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_country_id_key UNIQUE (country_id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: teams teams_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: teams teams_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- PostgreSQL database dump complete
--

\unrestrict poFHvDZqnnFrWhcu6ZLg8ldTyhate60r0Ci4NjyIpXV8mcjTaolo4iQcohFgkci

