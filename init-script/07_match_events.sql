--
-- PostgreSQL database dump
--

\restrict oSsrn0SoHLuO3tkkb73tEAilhTQj1zQR9wUPNcCgO9Z9FDVNXkPJfp3q3uZOLkd

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
-- Name: match_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.match_events (
    id integer NOT NULL,
    match_id integer NOT NULL,
    player_id integer NOT NULL,
    event public.event_type NOT NULL,
    minute smallint NOT NULL,
    extra_time smallint DEFAULT 0,
    detail character varying(120)
);


--
-- Name: match_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.match_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: match_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.match_events_id_seq OWNED BY public.match_events.id;


--
-- Name: match_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match_events ALTER COLUMN id SET DEFAULT nextval('public.match_events_id_seq'::regclass);


--
-- Data for Name: match_events; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: match_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.match_events_id_seq', 36, true);


--
-- Name: match_events match_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match_events
    ADD CONSTRAINT match_events_pkey PRIMARY KEY (id);


--
-- Name: idx_match_events_match; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_match_events_match ON public.match_events USING btree (match_id);


--
-- Name: idx_match_events_player; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_match_events_player ON public.match_events USING btree (player_id);


--
-- Name: match_events match_events_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match_events
    ADD CONSTRAINT match_events_match_id_fkey FOREIGN KEY (match_id) REFERENCES public.matches(id);


--
-- Name: match_events match_events_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match_events
    ADD CONSTRAINT match_events_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(id);


--
-- PostgreSQL database dump complete
--

\unrestrict oSsrn0SoHLuO3tkkb73tEAilhTQj1zQR9wUPNcCgO9Z9FDVNXkPJfp3q3uZOLkd

