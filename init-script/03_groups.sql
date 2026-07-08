--
-- PostgreSQL database dump
--

\restrict HyvLJzabGdMzxU5jSfb7jMp4v1f4oeuBnBzLV0QbvTcsV3gPPJf3r4aO28b9Uhv

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
-- Name: groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.groups (
    id integer NOT NULL,
    name character(1) NOT NULL
);


--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.groups VALUES (1, 'A');
INSERT INTO public.groups VALUES (2, 'B');
INSERT INTO public.groups VALUES (3, 'C');
INSERT INTO public.groups VALUES (4, 'D');
INSERT INTO public.groups VALUES (5, 'E');
INSERT INTO public.groups VALUES (6, 'F');
INSERT INTO public.groups VALUES (7, 'G');
INSERT INTO public.groups VALUES (8, 'H');
INSERT INTO public.groups VALUES (9, 'I');
INSERT INTO public.groups VALUES (10, 'J');
INSERT INTO public.groups VALUES (11, 'K');
INSERT INTO public.groups VALUES (12, 'L');


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.groups_id_seq', 12, true);


--
-- Name: groups groups_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_name_key UNIQUE (name);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict HyvLJzabGdMzxU5jSfb7jMp4v1f4oeuBnBzLV0QbvTcsV3gPPJf3r4aO28b9Uhv

