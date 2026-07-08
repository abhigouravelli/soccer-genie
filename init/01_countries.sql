--
-- PostgreSQL database dump
--

\restrict lxoNs4z3GowRJA7cI08nBOE1urp5vcTQHN6wRWzPgjgcKVs4Ceczo264LLDLNco

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
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.countries (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    code character(3) NOT NULL,
    confederation public.confederation_type NOT NULL,
    region character varying(60),
    flag_emoji character varying(10)
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.countries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.countries VALUES (1, 'Germany', 'GER', 'UEFA', 'Europe', '🇩🇪');
INSERT INTO public.countries VALUES (2, 'France', 'FRA', 'UEFA', 'Europe', '🇫🇷');
INSERT INTO public.countries VALUES (4, 'Spain', 'ESP', 'UEFA', 'Europe', '🇪🇸');
INSERT INTO public.countries VALUES (5, 'England', 'ENG', 'UEFA', 'Europe', '🏴󠁧󠁢󠁥󠁮󠁧󠁿');
INSERT INTO public.countries VALUES (6, 'Portugal', 'POR', 'UEFA', 'Europe', '🇵🇹');
INSERT INTO public.countries VALUES (7, 'Netherlands', 'NED', 'UEFA', 'Europe', '🇳🇱');
INSERT INTO public.countries VALUES (8, 'Belgium', 'BEL', 'UEFA', 'Europe', '🇧🇪');
INSERT INTO public.countries VALUES (9, 'Croatia', 'CRO', 'UEFA', 'Europe', '🇭🇷');
INSERT INTO public.countries VALUES (11, 'Switzerland', 'SUI', 'UEFA', 'Europe', '🇨🇭');
INSERT INTO public.countries VALUES (12, 'Austria', 'AUT', 'UEFA', 'Europe', '🇦🇹');
INSERT INTO public.countries VALUES (13, 'Scotland', 'SCO', 'UEFA', 'Europe', '🏴󠁧󠁢󠁳󠁣󠁴󠁿');
INSERT INTO public.countries VALUES (14, 'Turkey', 'TUR', 'UEFA', 'Europe', '🇹🇷');
INSERT INTO public.countries VALUES (18, 'Brazil', 'BRA', 'CONMEBOL', 'South America', '🇧🇷');
INSERT INTO public.countries VALUES (19, 'Argentina', 'ARG', 'CONMEBOL', 'South America', '🇦🇷');
INSERT INTO public.countries VALUES (20, 'Uruguay', 'URU', 'CONMEBOL', 'South America', '🇺🇾');
INSERT INTO public.countries VALUES (21, 'Colombia', 'COL', 'CONMEBOL', 'South America', '🇨🇴');
INSERT INTO public.countries VALUES (22, 'Ecuador', 'ECU', 'CONMEBOL', 'South America', '🇪🇨');
INSERT INTO public.countries VALUES (24, 'United States', 'USA', 'CONCACAF', 'North America', '🇺🇸');
INSERT INTO public.countries VALUES (25, 'Mexico', 'MEX', 'CONCACAF', 'North America', '🇲🇽');
INSERT INTO public.countries VALUES (26, 'Canada', 'CAN', 'CONCACAF', 'North America', '🇨🇦');
INSERT INTO public.countries VALUES (29, 'Panama', 'PAN', 'CONCACAF', 'Central America', '🇵🇦');
INSERT INTO public.countries VALUES (30, 'Morocco', 'MAR', 'CAF', 'Africa', '🇲🇦');
INSERT INTO public.countries VALUES (31, 'Senegal', 'SEN', 'CAF', 'Africa', '🇸🇳');
INSERT INTO public.countries VALUES (33, 'Ivory Coast', 'CIV', 'CAF', 'Africa', '🇨🇮');
INSERT INTO public.countries VALUES (35, 'Egypt', 'EGY', 'CAF', 'Africa', '🇪🇬');
INSERT INTO public.countries VALUES (36, 'Algeria', 'ALG', 'CAF', 'Africa', '🇩🇿');
INSERT INTO public.countries VALUES (37, 'South Africa', 'RSA', 'CAF', 'Africa', '🇿🇦');
INSERT INTO public.countries VALUES (38, 'DR Congo', 'COD', 'CAF', 'Africa', '🇨🇩');
INSERT INTO public.countries VALUES (40, 'Japan', 'JPN', 'AFC', 'Asia', '🇯🇵');
INSERT INTO public.countries VALUES (41, 'South Korea', 'KOR', 'AFC', 'Asia', '🇰🇷');
INSERT INTO public.countries VALUES (42, 'Australia', 'AUS', 'AFC', 'Oceania/Asia', '🇦🇺');
INSERT INTO public.countries VALUES (43, 'Iran', 'IRN', 'AFC', 'Asia', '🇮🇷');
INSERT INTO public.countries VALUES (44, 'Saudi Arabia', 'KSA', 'AFC', 'Asia', '🇸🇦');
INSERT INTO public.countries VALUES (45, 'Iraq', 'IRQ', 'AFC', 'Asia', '🇮🇶');
INSERT INTO public.countries VALUES (46, 'Jordan', 'JOR', 'AFC', 'Asia', '🇯🇴');
INSERT INTO public.countries VALUES (47, 'Uzbekistan', 'UZB', 'AFC', 'Asia', '🇺🇿');
INSERT INTO public.countries VALUES (48, 'New Zealand', 'NZL', 'OFC', 'Oceania', '🇳🇿');
INSERT INTO public.countries VALUES (49, 'Bosnia and Herzegovina', 'BIH', 'UEFA', 'Europe', '🇧🇦');
INSERT INTO public.countries VALUES (50, 'Sweden', 'SWE', 'UEFA', 'Northern Europe', '🇸🇪');
INSERT INTO public.countries VALUES (51, 'Norway', 'NOR', 'UEFA', 'Northern Europe', '🇳🇴');
INSERT INTO public.countries VALUES (77, 'Cape Verde', 'CPV', 'CAF', NULL, '🇨🇻');
INSERT INTO public.countries VALUES (78, 'Curaçao', 'CUW', 'CONCACAF', NULL, '🇨🇼');
INSERT INTO public.countries VALUES (79, 'Czech Republic', 'CZE', 'UEFA', NULL, '🇨🇿');
INSERT INTO public.countries VALUES (80, 'Ghana', 'GHA', 'CAF', NULL, '🇬🇭');
INSERT INTO public.countries VALUES (81, 'Haiti', 'HAI', 'CONCACAF', NULL, '🇭🇹');
INSERT INTO public.countries VALUES (82, 'Paraguay', 'PAR', 'CONMEBOL', NULL, '🇵🇾');
INSERT INTO public.countries VALUES (83, 'Qatar', 'QAT', 'AFC', NULL, '🇶🇦');
INSERT INTO public.countries VALUES (84, 'Tunisia', 'TUN', 'CAF', NULL, '🇹🇳');


--
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.countries_id_seq', 84, true);


--
-- Name: countries countries_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_code_key UNIQUE (code);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict lxoNs4z3GowRJA7cI08nBOE1urp5vcTQHN6wRWzPgjgcKVs4Ceczo264LLDLNco

