--
-- PostgreSQL database dump
--

\restrict SVob200VBufuZvMgtIW116dnaarLzUV3DKRtunkxR5eg3sbs2FG5xMVE1OKVMAd

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
-- Name: stadiums; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stadiums (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    city character varying(100) NOT NULL,
    host_country character varying(50) NOT NULL,
    capacity integer NOT NULL,
    surface character varying(20) DEFAULT 'Grass'::character varying,
    opened_year integer,
    latitude numeric(9,6),
    longitude numeric(9,6)
);


--
-- Name: stadiums_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stadiums_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stadiums_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stadiums_id_seq OWNED BY public.stadiums.id;


--
-- Name: stadiums id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stadiums ALTER COLUMN id SET DEFAULT nextval('public.stadiums_id_seq'::regclass);


--
-- Data for Name: stadiums; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.stadiums VALUES (1, 'MetLife Stadium', 'East Rutherford, NJ', 'USA', 82500, 'Grass', 2010, 40.813528, -74.074311);
INSERT INTO public.stadiums VALUES (2, 'AT&T Stadium', 'Arlington, TX', 'USA', 80000, 'Grass', 2009, 32.747754, -97.092889);
INSERT INTO public.stadiums VALUES (3, 'SoFi Stadium', 'Inglewood, CA', 'USA', 70240, 'Grass', 2020, 33.953499, -118.339844);
INSERT INTO public.stadiums VALUES (4, 'Hard Rock Stadium', 'Miami Gardens, FL', 'USA', 65326, 'Grass', 1987, 25.957928, -80.238842);
INSERT INTO public.stadiums VALUES (5, 'Arrowhead Stadium', 'Kansas City, MO', 'USA', 76416, 'Grass', 1972, 39.048786, -94.483955);
INSERT INTO public.stadiums VALUES (6, 'Lincoln Financial Field', 'Philadelphia, PA', 'USA', 69176, 'Grass', 2003, 39.900775, -75.167453);
INSERT INTO public.stadiums VALUES (7, 'Lumen Field', 'Seattle, WA', 'USA', 72000, 'FieldTurf', 2002, 47.595153, -122.331625);
INSERT INTO public.stadiums VALUES (8, 'Gillette Stadium', 'Foxborough, MA', 'USA', 65878, 'Grass', 2002, 42.090944, -71.264344);
INSERT INTO public.stadiums VALUES (9, 'Rose Bowl', 'Pasadena, CA', 'USA', 87500, 'Grass', 1922, 34.161388, -118.167550);
INSERT INTO public.stadiums VALUES (10, 'NRG Stadium', 'Houston, TX', 'USA', 72220, 'Grass', 2002, 29.684961, -95.410606);
INSERT INTO public.stadiums VALUES (11, 'Allegiant Stadium', 'Las Vegas, NV', 'USA', 65000, 'Grass', 2020, 36.090794, -115.183891);
INSERT INTO public.stadiums VALUES (12, 'BC Place', 'Vancouver, BC', 'Canada', 54500, 'FieldTurf', 1983, 49.276739, -123.111668);
INSERT INTO public.stadiums VALUES (13, 'BMO Field', 'Toronto, ON', 'Canada', 45000, 'Grass', 2007, 43.633333, -79.418611);
INSERT INTO public.stadiums VALUES (14, 'Estadio Azteca', 'Mexico City', 'Mexico', 83714, 'Grass', 1966, 19.303028, -99.150667);
INSERT INTO public.stadiums VALUES (15, 'Estadio BBVA', 'Monterrey', 'Mexico', 53500, 'Grass', 2015, 25.669233, -100.245953);
INSERT INTO public.stadiums VALUES (16, 'Estadio Akron', 'Guadalajara', 'Mexico', 49850, 'Grass', 2010, 20.678697, -103.419397);
INSERT INTO public.stadiums VALUES (17, 'Levi Stadium', 'Santa Clara, CA', 'USA', 60000, 'Grass', NULL, NULL, NULL);
INSERT INTO public.stadiums VALUES (18, 'Mercedes Benz Stadium', 'Atalanta, GA', 'USA', 75000, 'Grass', NULL, NULL, NULL);
INSERT INTO public.stadiums VALUES (21, 'TBD', 'TBD', 'TBD', 0, 'Grass', NULL, NULL, NULL);


--
-- Name: stadiums_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.stadiums_id_seq', 21, true);


--
-- Name: stadiums stadiums_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stadiums
    ADD CONSTRAINT stadiums_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict SVob200VBufuZvMgtIW116dnaarLzUV3DKRtunkxR5eg3sbs2FG5xMVE1OKVMAd

