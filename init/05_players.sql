--
-- PostgreSQL database dump
--

\restrict NZwZ0NZwTRRD0xDNgz0uceYbFUgyJ76oBFmtpmOvbbTAqbOdgLe9JjvKrOncSBQ

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
-- Name: players; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.players (
    id integer NOT NULL,
    team_id integer NOT NULL,
    full_name character varying(120) NOT NULL,
    shirt_name character varying(60),
    "position" public.position_type NOT NULL,
    jersey_number smallint,
    date_of_birth date,
    age smallint,
    club character varying(100),
    caps smallint DEFAULT 0,
    goals smallint DEFAULT 0
);


--
-- Name: players_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.players_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.players_id_seq OWNED BY public.players.id;


--
-- Name: players id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.players ALTER COLUMN id SET DEFAULT nextval('public.players_id_seq'::regclass);


--
-- Data for Name: players; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.players VALUES (389, 27, 'Luis Díaz', 'L. DÍAZ', 'FW', 7, '1997-01-13', 29, 'Bayern Munich', 72, 28);
INSERT INTO public.players VALUES (81, 8, 'Borna Sosa', 'SOSA', 'DF', 3, '1998-01-21', 28, 'Ajax', 28, 0);
INSERT INTO public.players VALUES (244, 20, 'William Saliba', 'SALIBA', 'DF', 17, '2001-03-24', 25, 'Arsenal', 28, 2);
INSERT INTO public.players VALUES (1, 2, 'Guillermo Ochoa', 'OCHOA', 'GK', 1, '1985-07-13', 40, 'CF Pachuca', 152, 0);
INSERT INTO public.players VALUES (2, 2, 'Luis Malagón', 'MALAGÓN', 'GK', 12, '1997-02-06', 29, 'Club América', 12, 0);
INSERT INTO public.players VALUES (3, 2, 'Jorge Sánchez', 'J. SÁNCHEZ', 'DF', 19, '1997-12-10', 28, 'Cruz Azul', 48, 1);
INSERT INTO public.players VALUES (4, 2, 'César Montes', 'C. MONTES', 'DF', 3, '1997-03-27', 29, 'Espanyol', 54, 2);
INSERT INTO public.players VALUES (5, 2, 'Johan Vásquez', 'VÁSQUEZ', 'DF', 2, '1998-10-22', 27, 'Genoa', 34, 2);
INSERT INTO public.players VALUES (6, 2, 'Jesús Gallardo', 'GALLARDO', 'DF', 23, '1994-08-15', 31, 'Toluca', 78, 3);
INSERT INTO public.players VALUES (7, 2, 'Edson Álvarez', 'E. ÁLVAREZ', 'MF', 4, '1997-10-24', 28, 'West Ham United', 77, 5);
INSERT INTO public.players VALUES (8, 2, 'Luis Romo', 'ROMO', 'MF', 6, '1995-06-05', 31, 'Rayados Monterrey', 45, 4);
INSERT INTO public.players VALUES (9, 2, 'Orbelín Pineda', 'PINEDA', 'MF', 10, '1996-03-24', 30, 'AEK Athens', 55, 8);
INSERT INTO public.players VALUES (10, 2, 'Carlos Rodríguez', 'C. RODRÍGUEZ', 'MF', 8, '1997-01-03', 29, 'Cruz Azul', 38, 2);
INSERT INTO public.players VALUES (11, 2, 'Hirving Lozano', 'LOZANO', 'FW', 7, '1995-07-30', 30, 'PSV Eindhoven', 87, 30);
INSERT INTO public.players VALUES (12, 2, 'Santiago Giménez', 'S. GIMÉNEZ', 'FW', 9, '2001-04-18', 25, 'AC Milan', 32, 16);
INSERT INTO public.players VALUES (13, 2, 'Alexis Vega', 'A. VEGA', 'FW', 11, '1997-10-21', 28, 'Toluca', 45, 9);
INSERT INTO public.players VALUES (14, 2, 'Raúl Jiménez', 'R. JIMÉNEZ', 'FW', 18, '1991-05-05', 35, 'Fulham', 99, 40);
INSERT INTO public.players VALUES (15, 2, 'Roberto Alvarado', 'ALVARADO', 'FW', 21, '1998-09-07', 27, 'Chivas Guadalajara', 42, 7);
INSERT INTO public.players VALUES (46, 1, 'Luis Mejía', 'L. MEJÍA', 'GK', 1, '1994-11-20', 31, 'Universitario', 45, 0);
INSERT INTO public.players VALUES (47, 1, 'Orlando Mosquera', 'MOSQUERA', 'GK', 22, '1994-04-15', 32, 'Al-Wehda', 22, 0);
INSERT INTO public.players VALUES (48, 1, 'Éric Davis', 'E. DAVIS', 'DF', 15, '1991-03-31', 35, 'Botoșani', 62, 2);
INSERT INTO public.players VALUES (49, 1, 'Fidel Escobar', 'ESCOBAR', 'DF', 5, '1995-02-09', 31, 'Real Salt Lake', 58, 4);
INSERT INTO public.players VALUES (50, 1, 'Andrés Andrade', 'A. ANDRADE', 'DF', 13, '1993-10-31', 32, 'Club América', 48, 2);
INSERT INTO public.players VALUES (51, 1, 'Michael Murillo', 'MURILLO', 'DF', 2, '1996-02-11', 30, 'Marseille', 55, 4);
INSERT INTO public.players VALUES (52, 1, 'César Blackman', 'BLACKMAN', 'DF', 17, '1998-04-11', 28, 'Cracovia', 32, 1);
INSERT INTO public.players VALUES (53, 1, 'Adalberto Carrasquilla', 'CARRASQUILLA', 'MF', 6, '1998-06-02', 28, 'Houston Dynamo', 58, 8);
INSERT INTO public.players VALUES (54, 1, 'Aníbal Godoy', 'GODOY', 'MF', 20, '1990-02-10', 36, 'San Jose Earthquakes', 95, 5);
INSERT INTO public.players VALUES (55, 1, 'Cristian Martínez', 'C. MARTÍNEZ', 'MF', 18, '1991-09-21', 34, 'CD Universitario', 52, 6);
INSERT INTO public.players VALUES (56, 1, 'Édgar Bárcenas', 'BÁRCENAS', 'MF', 21, '1993-09-23', 32, 'Mazatlán', 58, 8);
INSERT INTO public.players VALUES (57, 1, 'Ismael Díaz', 'I. DÍAZ', 'FW', 9, '1997-05-12', 29, 'León', 42, 12);
INSERT INTO public.players VALUES (58, 1, 'Cecilio Waterman', 'WATERMAN', 'FW', 11, '1991-05-30', 35, 'Coquimbo Unido', 56, 16);
INSERT INTO public.players VALUES (59, 1, 'José Fajardo', 'FAJARDO', 'FW', 19, '1995-08-26', 30, 'Independiente', 38, 9);
INSERT INTO public.players VALUES (60, 1, 'Tomás Rodríguez', 'T. RODRÍGUEZ', 'FW', 7, '2001-03-15', 25, 'Sporting San Miguelito', 24, 4);
INSERT INTO public.players VALUES (61, 6, 'Matt Turner', 'M. TURNER', 'GK', 1, '1994-06-24', 31, 'Crystal Palace', 46, 0);
INSERT INTO public.players VALUES (62, 6, 'Patrick Schulte', 'SCHULTE', 'GK', 12, '2001-01-20', 25, 'Columbus Crew', 6, 0);
INSERT INTO public.players VALUES (63, 6, 'Sergiño Dest', 'DEST', 'DF', 2, '2000-11-03', 25, 'PSV Eindhoven', 38, 2);
INSERT INTO public.players VALUES (64, 6, 'Chris Richards', 'RICHARDS', 'DF', 3, '2000-03-28', 26, 'Crystal Palace', 28, 3);
INSERT INTO public.players VALUES (65, 6, 'Tim Ream', 'REAM', 'DF', 13, '1987-10-05', 38, 'Charlotte FC', 62, 1);
INSERT INTO public.players VALUES (66, 6, 'Antonee Robinson', 'ROBINSON', 'DF', 5, '1997-08-08', 28, 'Fulham', 48, 3);
INSERT INTO public.players VALUES (67, 6, 'Joe Scally', 'SCALLY', 'DF', 19, '2002-12-31', 23, 'Borussia M.gladbach', 18, 0);
INSERT INTO public.players VALUES (68, 6, 'Tyler Adams', 'T. ADAMS', 'MF', 4, '1999-02-14', 27, 'Bournemouth', 70, 3);
INSERT INTO public.players VALUES (69, 6, 'Weston McKennie', 'MCKENNIE', 'MF', 8, '1998-08-28', 27, 'Juventus', 72, 15);
INSERT INTO public.players VALUES (70, 6, 'Yunus Musah', 'MUSAH', 'MF', 6, '2002-11-29', 23, 'AC Milan', 42, 1);
INSERT INTO public.players VALUES (71, 6, 'Gio Reyna', 'G. REYNA', 'MF', 11, '2002-11-13', 23, 'Borussia Dortmund', 42, 10);
INSERT INTO public.players VALUES (72, 6, 'Christian Pulisic', 'PULISIC', 'FW', 10, '1998-09-18', 27, 'AC Milan', 88, 32);
INSERT INTO public.players VALUES (73, 6, 'Timothy Weah', 'WEAH', 'FW', 21, '2000-02-22', 26, 'Juventus', 44, 7);
INSERT INTO public.players VALUES (74, 6, 'Ricardo Pepi', 'R. PEPI', 'FW', 9, '2003-01-09', 23, 'PSV Eindhoven', 38, 14);
INSERT INTO public.players VALUES (75, 6, 'Folarin Balogun', 'BALOGUN', 'FW', 20, '2001-07-03', 24, 'AS Monaco', 18, 5);
INSERT INTO public.players VALUES (76, 8, 'Dominik Livaković', 'LIVAKOVIĆ', 'GK', 1, '1995-01-09', 31, 'Fenerbahçe', 68, 0);
INSERT INTO public.players VALUES (77, 8, 'Ivica Ivušić', 'IVUŠIĆ', 'GK', 12, '1995-02-01', 31, 'Pafos', 10, 0);
INSERT INTO public.players VALUES (78, 8, 'Josip Šutalo', 'ŠUTALO', 'DF', 5, '2000-02-28', 26, 'Ajax', 36, 1);
INSERT INTO public.players VALUES (79, 8, 'Joško Gvardiol', 'GVARDIOL', 'DF', 20, '2002-01-23', 24, 'Manchester City', 38, 4);
INSERT INTO public.players VALUES (80, 8, 'Josip Stanišić', 'STANIŠIĆ', 'DF', 2, '2000-04-02', 26, 'Bayern Munich', 24, 1);
INSERT INTO public.players VALUES (82, 8, 'Marcelo Brozović', 'BROZOVIĆ', 'MF', 11, '1992-11-16', 33, 'Al-Nassr', 95, 8);
INSERT INTO public.players VALUES (83, 8, 'Mateo Kovačić', 'KOVAČIĆ', 'MF', 8, '1994-05-06', 32, 'Manchester City', 105, 12);
INSERT INTO public.players VALUES (84, 8, 'Luka Modrić', 'MODRIĆ', 'MF', 10, '1985-09-09', 40, 'AC Milan', 180, 25);
INSERT INTO public.players VALUES (85, 8, 'Mario Pašalić', 'PAŠALIĆ', 'MF', 15, '1995-02-09', 31, 'Atalanta', 58, 9);
INSERT INTO public.players VALUES (86, 8, 'Lovro Majer', 'MAJER', 'MF', 7, '1998-01-17', 28, 'VfL Wolfsburg', 38, 6);
INSERT INTO public.players VALUES (87, 8, 'Ivan Perišić', 'PERIŠIĆ', 'FW', 4, '1989-02-02', 37, 'Hajduk Split', 138, 34);
INSERT INTO public.players VALUES (88, 8, 'Andrej Kramarić', 'KRAMARIĆ', 'FW', 9, '1991-06-19', 34, 'Hoffenheim', 98, 28);
INSERT INTO public.players VALUES (89, 8, 'Bruno Petković', 'B. PETKOVIĆ', 'FW', 16, '1994-09-16', 31, 'Dinamo Zagreb', 54, 15);
INSERT INTO public.players VALUES (90, 8, 'Marco Pašalić', 'M. PAŠALIĆ', 'FW', 18, '2000-09-05', 25, 'Orlando City', 12, 3);
INSERT INTO public.players VALUES (121, 11, 'Maxime Crépeau', 'CRÉPEAU', 'GK', 1, '1994-05-11', 32, 'Portland Timbers', 38, 0);
INSERT INTO public.players VALUES (122, 11, 'Dayne St. Clair', 'ST. CLAIR', 'GK', 18, '1997-04-09', 29, 'Minnesota United', 18, 0);
INSERT INTO public.players VALUES (123, 11, 'Alphonso Davies', 'A. DAVIES', 'DF', 19, '2000-11-02', 25, 'Bayern Munich', 75, 12);
INSERT INTO public.players VALUES (124, 11, 'Moïse Bombito', 'BOMBITO', 'DF', 4, '1999-12-19', 26, 'OGC Nice', 18, 1);
INSERT INTO public.players VALUES (125, 11, 'Derek Cornelius', 'CORNELIUS', 'DF', 2, '1997-11-25', 28, 'Marseille', 38, 2);
INSERT INTO public.players VALUES (126, 11, 'Alistair Johnston', 'JOHNSTON', 'DF', 22, '1998-10-08', 27, 'Celtic', 48, 2);
INSERT INTO public.players VALUES (127, 11, 'Sam Adekugbe', 'ADEKUGBE', 'DF', 3, '1995-01-16', 31, 'Hatayspor', 42, 1);
INSERT INTO public.players VALUES (128, 11, 'Stephen Eustáquio', 'EUSTÁQUIO', 'MF', 7, '1996-12-21', 29, 'FC Porto', 62, 8);
INSERT INTO public.players VALUES (129, 11, 'Ismaël Koné', 'KONÉ', 'MF', 8, '2002-06-16', 23, 'Marseille', 32, 3);
INSERT INTO public.players VALUES (130, 11, 'Jonathan Osorio', 'OSORIO', 'MF', 21, '1992-06-12', 33, 'Toronto FC', 72, 10);
INSERT INTO public.players VALUES (131, 11, 'Tajon Buchanan', 'BUCHANAN', 'MF', 11, '1999-02-08', 27, 'Villarreal', 48, 10);
INSERT INTO public.players VALUES (132, 11, 'Jonathan David', 'J. DAVID', 'FW', 20, '2000-01-14', 26, 'Juventus', 70, 35);
INSERT INTO public.players VALUES (133, 11, 'Cyle Larin', 'LARIN', 'FW', 9, '1995-04-17', 31, 'Mallorca', 74, 31);
INSERT INTO public.players VALUES (134, 11, 'Jacob Shaffelburg', 'SHAFFELBURG', 'FW', 14, '1999-12-08', 26, 'Nashville SC', 28, 6);
INSERT INTO public.players VALUES (135, 11, 'Promise David', 'P. DAVID', 'FW', 17, '2001-03-08', 25, 'Union SG', 12, 4);
INSERT INTO public.players VALUES (136, 12, 'Uğurcan Çakır', 'U. ÇAKIR', 'GK', 1, '1996-04-08', 30, 'Galatasaray', 55, 0);
INSERT INTO public.players VALUES (137, 12, 'Altay Bayındır', 'BAYINDIR', 'GK', 12, '1998-04-14', 28, 'Manchester United', 12, 0);
INSERT INTO public.players VALUES (138, 12, 'Merih Demiral', 'DEMIRAL', 'DF', 3, '1998-03-05', 28, 'Al-Ahli', 54, 6);
INSERT INTO public.players VALUES (139, 12, 'Abdülkerim Bardakcı', 'BARDAKCI', 'DF', 4, '1994-09-07', 31, 'Galatasaray', 24, 1);
INSERT INTO public.players VALUES (140, 12, 'Samet Akaydın', 'AKAYDIN', 'DF', 14, '1994-03-13', 32, 'Panathinaikos', 22, 2);
INSERT INTO public.players VALUES (141, 12, 'Ferdi Kadıoğlu', 'KADIOĞLU', 'DF', 20, '1999-10-07', 26, 'Brighton', 32, 1);
INSERT INTO public.players VALUES (142, 12, 'Mert Müldür', 'MÜLDÜR', 'DF', 2, '1999-04-03', 27, 'Fenerbahçe', 38, 1);
INSERT INTO public.players VALUES (143, 12, 'Hakan Çalhanoğlu', 'ÇALHANOĞLU', 'MF', 10, '1994-02-08', 32, 'Inter Milan', 95, 28);
INSERT INTO public.players VALUES (144, 12, 'Orkun Kökçü', 'KÖKÇÜ', 'MF', 8, '2000-12-29', 25, 'Benfica', 32, 4);
INSERT INTO public.players VALUES (145, 12, 'İsmail Yüksek', 'YÜKSEK', 'MF', 18, '1999-01-05', 27, 'Fenerbahçe', 18, 0);
INSERT INTO public.players VALUES (146, 12, 'Arda Güler', 'A. GÜLER', 'MF', 17, '2005-02-25', 21, 'Real Madrid', 30, 10);
INSERT INTO public.players VALUES (147, 12, 'Kerem Aktürkoğlu', 'AKTÜRKOĞLU', 'FW', 21, '1998-10-22', 27, 'Fenerbahçe', 45, 15);
INSERT INTO public.players VALUES (148, 12, 'Kenan Yıldız', 'YILDIZ', 'FW', 15, '2005-05-04', 21, 'Juventus', 18, 6);
INSERT INTO public.players VALUES (149, 12, 'Barış Alper Yılmaz', 'B.A. YILMAZ', 'FW', 7, '2000-05-23', 26, 'Galatasaray', 32, 8);
INSERT INTO public.players VALUES (150, 12, 'Yusuf Yazıcı', 'YAZICI', 'FW', 11, '1997-01-29', 29, 'Hull City', 42, 9);
INSERT INTO public.players VALUES (151, 9, 'Yahia Fofana', 'Y. FOFANA', 'GK', 1, '2000-08-21', 25, 'Angers', 22, 0);
INSERT INTO public.players VALUES (152, 9, 'Badra Ali Sangaré', 'SANGARÉ', 'GK', 16, '1992-11-30', 33, 'Apejes de Mfou', 28, 0);
INSERT INTO public.players VALUES (153, 9, 'Serge Aurier', 'AURIER', 'DF', 24, '1992-12-24', 33, 'FC Astana', 82, 7);
INSERT INTO public.players VALUES (154, 9, 'Odilon Kossounou', 'KOSSOUNOU', 'DF', 4, '2001-01-04', 25, 'Atalanta', 34, 1);
INSERT INTO public.players VALUES (155, 9, 'Evan Ndicka', 'NDICKA', 'DF', 22, '1999-08-20', 26, 'AS Roma', 32, 1);
INSERT INTO public.players VALUES (156, 9, 'Ghislain Konan', 'KONAN', 'DF', 3, '1995-12-27', 30, 'Al-Arabi', 38, 2);
INSERT INTO public.players VALUES (157, 9, 'Wilfried Singo', 'SINGO', 'DF', 17, '2000-12-25', 25, 'AS Monaco', 28, 1);
INSERT INTO public.players VALUES (158, 9, 'Franck Kessié', 'KESSIÉ', 'MF', 19, '1996-12-19', 29, 'Al-Ahli', 85, 22);
INSERT INTO public.players VALUES (159, 9, 'Ibrahim Sangaré', 'I. SANGARÉ', 'MF', 6, '1997-12-02', 28, 'Nottingham Forest', 52, 4);
INSERT INTO public.players VALUES (160, 9, 'Seko Fofana', 'S. FOFANA', 'MF', 8, '1995-05-07', 31, 'Rennes', 38, 5);
INSERT INTO public.players VALUES (161, 9, 'Simon Adingra', 'ADINGRA', 'FW', 11, '2002-01-01', 24, 'Brighton', 32, 12);
INSERT INTO public.players VALUES (162, 9, 'Sébastien Haller', 'HALLER', 'FW', 9, '1994-06-22', 31, 'Borussia Dortmund', 55, 23);
INSERT INTO public.players VALUES (163, 9, 'Nicolas Pépé', 'PÉPÉ', 'FW', 10, '1995-05-29', 31, 'Villarreal', 48, 18);
INSERT INTO public.players VALUES (164, 9, 'Jean-Philippe Krasso', 'KRASSO', 'FW', 14, '1997-12-21', 28, 'Panathinaikos', 18, 6);
INSERT INTO public.players VALUES (165, 9, 'Jérémie Boga', 'BOGA', 'FW', 23, '1997-01-03', 29, 'OGC Nice', 28, 4);
INSERT INTO public.players VALUES (181, 15, 'Alisson Becker', 'ALISSON', 'GK', 1, '1992-10-02', 33, 'Liverpool', 100, 0);
INSERT INTO public.players VALUES (182, 15, 'Bento', 'BENTO', 'GK', 12, '1999-06-10', 27, 'Al-Nassr', 12, 0);
INSERT INTO public.players VALUES (183, 15, 'Danilo', 'DANILO', 'DF', 2, '1991-07-15', 34, 'Flamengo', 58, 1);
INSERT INTO public.players VALUES (184, 15, 'Marquinhos', 'MARQUINHOS', 'DF', 4, '1994-05-14', 32, 'PSG', 106, 9);
INSERT INTO public.players VALUES (185, 15, 'Gabriel Magalhães', 'GABRIEL', 'DF', 3, '1997-12-19', 28, 'Arsenal', 24, 2);
INSERT INTO public.players VALUES (186, 15, 'Wendell', 'WENDELL', 'DF', 6, '1993-07-20', 32, 'FC Porto', 14, 0);
INSERT INTO public.players VALUES (187, 15, 'Vanderson', 'VANDERSON', 'DF', 14, '2001-06-21', 24, 'AS Monaco', 12, 0);
INSERT INTO public.players VALUES (188, 15, 'Bruno Guimarães', 'B. GUIMARÃES', 'MF', 5, '1997-11-16', 28, 'Newcastle United', 42, 4);
INSERT INTO public.players VALUES (189, 15, 'Casemiro', 'CASEMIRO', 'MF', 15, '1992-02-23', 34, 'Manchester United', 108, 19);
INSERT INTO public.players VALUES (190, 15, 'Lucas Paquetá', 'PAQUETÁ', 'MF', 10, '1997-08-27', 28, 'West Ham United', 52, 11);
INSERT INTO public.players VALUES (191, 15, 'Vinícius Jr', 'VINÍCIUS JR', 'FW', 7, '2000-07-12', 25, 'Real Madrid', 85, 30);
INSERT INTO public.players VALUES (192, 15, 'Rodrygo', 'RODRYGO', 'FW', 11, '2001-01-09', 25, 'Real Madrid', 62, 22);
INSERT INTO public.players VALUES (193, 15, 'Raphinha', 'RAPHINHA', 'FW', 19, '1996-12-14', 29, 'FC Barcelona', 45, 15);
INSERT INTO public.players VALUES (194, 15, 'Endrick', 'ENDRICK', 'FW', 9, '2006-07-21', 19, 'Real Madrid', 28, 10);
INSERT INTO public.players VALUES (195, 15, 'Savinho', 'SAVINHO', 'FW', 18, '2004-04-10', 22, 'Manchester City', 18, 3);
INSERT INTO public.players VALUES (196, 16, 'Yann Sommer', 'SOMMER', 'GK', 1, '1988-12-17', 37, 'Inter Milan', 108, 0);
INSERT INTO public.players VALUES (197, 16, 'Gregor Kobel', 'KOBEL', 'GK', 12, '1997-12-06', 28, 'Borussia Dortmund', 18, 0);
INSERT INTO public.players VALUES (198, 16, 'Manuel Akanji', 'AKANJI', 'DF', 5, '1995-07-19', 30, 'Manchester City', 72, 3);
INSERT INTO public.players VALUES (199, 16, 'Nico Elvedi', 'ELVEDI', 'DF', 4, '1996-09-30', 29, 'Borussia M.gladbach', 58, 1);
INSERT INTO public.players VALUES (200, 16, 'Ricardo Rodríguez', 'R. RODRÍGUEZ', 'DF', 13, '1992-08-25', 33, 'Real Betis', 120, 9);
INSERT INTO public.players VALUES (201, 16, 'Fabian Schär', 'SCHÄR', 'DF', 22, '1991-12-20', 34, 'Newcastle United', 78, 9);
INSERT INTO public.players VALUES (202, 16, 'Silvan Widmer', 'WIDMER', 'DF', 2, '1993-03-05', 33, 'Mainz 05', 38, 2);
INSERT INTO public.players VALUES (203, 16, 'Granit Xhaka', 'XHAKA', 'MF', 10, '1992-09-27', 33, 'Bayer Leverkusen', 125, 18);
INSERT INTO public.players VALUES (204, 16, 'Remo Freuler', 'FREULER', 'MF', 8, '1992-04-15', 34, 'Bologna', 62, 4);
INSERT INTO public.players VALUES (205, 16, 'Michel Aebischer', 'AEBISCHER', 'MF', 20, '1997-01-06', 29, 'Bologna', 32, 2);
INSERT INTO public.players VALUES (206, 16, 'Ruben Vargas', 'VARGAS', 'FW', 17, '1998-08-05', 27, 'Sevilla', 52, 9);
INSERT INTO public.players VALUES (207, 16, 'Breel Embolo', 'EMBOLO', 'FW', 7, '1997-02-14', 29, 'AS Monaco', 68, 18);
INSERT INTO public.players VALUES (208, 16, 'Dan Ndoye', 'NDOYE', 'FW', 11, '2000-10-25', 25, 'Bologna', 32, 10);
INSERT INTO public.players VALUES (209, 16, 'Zeki Amdouni', 'AMDOUNI', 'FW', 9, '2000-12-04', 25, 'Benfica', 24, 7);
INSERT INTO public.players VALUES (210, 16, 'Noah Okafor', 'OKAFOR', 'FW', 16, '2000-05-24', 26, 'AC Milan', 32, 6);
INSERT INTO public.players VALUES (211, 14, 'Hernán Galíndez', 'GALÍNDEZ', 'GK', 1, '1987-03-30', 39, 'Huachipato', 60, 0);
INSERT INTO public.players VALUES (212, 14, 'Alexander Domínguez', 'DOMÍNGUEZ', 'GK', 22, '1987-06-05', 39, 'LDU Quito', 58, 0);
INSERT INTO public.players VALUES (213, 14, 'Pervis Estupiñán', 'ESTUPIÑÁN', 'DF', 7, '1998-01-21', 28, 'Brighton', 42, 2);
INSERT INTO public.players VALUES (214, 14, 'Piero Hincapié', 'HINCAPIÉ', 'DF', 3, '2002-01-09', 24, 'Bayer Leverkusen', 48, 3);
INSERT INTO public.players VALUES (215, 14, 'Félix Torres', 'F. TORRES', 'DF', 4, '1997-01-11', 29, 'Corinthians', 38, 4);
INSERT INTO public.players VALUES (216, 14, 'Ángelo Preciado', 'PRECIADO', 'DF', 17, '1998-02-18', 28, 'Sparta Prague', 42, 1);
INSERT INTO public.players VALUES (217, 14, 'William Pacho', 'PACHO', 'DF', 2, '2001-10-16', 24, 'PSG', 24, 1);
INSERT INTO public.players VALUES (218, 14, 'Moisés Caicedo', 'M. CAICEDO', 'MF', 23, '2001-11-02', 24, 'Chelsea', 58, 12);
INSERT INTO public.players VALUES (219, 14, 'Alan Franco', 'A. FRANCO', 'MF', 5, '1998-08-21', 27, 'Charlotte FC', 38, 1);
INSERT INTO public.players VALUES (220, 14, 'Carlos Gruezo', 'GRUEZO', 'MF', 20, '1995-04-19', 31, 'San Jose Earthquakes', 62, 1);
INSERT INTO public.players VALUES (221, 14, 'Kendry Páez', 'PÁEZ', 'MF', 10, '2007-05-04', 19, 'Chelsea', 18, 3);
INSERT INTO public.players VALUES (222, 14, 'Enner Valencia', 'E. VALENCIA', 'FW', 13, '1989-11-04', 36, 'Internacional', 104, 40);
INSERT INTO public.players VALUES (223, 14, 'Gonzalo Plata', 'PLATA', 'FW', 19, '2000-11-01', 25, 'Flamengo', 42, 14);
INSERT INTO public.players VALUES (224, 14, 'Kevin Rodríguez', 'K. RODRÍGUEZ', 'FW', 9, '2000-03-04', 26, 'Union SG', 18, 5);
INSERT INTO public.players VALUES (225, 14, 'Jeremy Sarmiento', 'SARMIENTO', 'FW', 11, '2002-06-16', 23, 'Brighton', 18, 2);
INSERT INTO public.players VALUES (226, 13, 'Mohamed El-Shenawy', 'EL-SHENAWY', 'GK', 1, '1988-08-17', 37, 'Al Ahly', 86, 0);
INSERT INTO public.players VALUES (227, 13, 'Mohamed Abou Gabal', 'GABASKI', 'GK', 23, '1988-12-01', 37, 'Al Ittihad', 32, 0);
INSERT INTO public.players VALUES (228, 13, 'Ahmed Hegazy', 'HEGAZY', 'DF', 6, '1991-01-25', 35, 'Al-Ittihad', 96, 9);
INSERT INTO public.players VALUES (229, 13, 'Mohamed Abdelmonem', 'ABDELMONEM', 'DF', 3, '1998-09-12', 27, 'Nice', 32, 3);
INSERT INTO public.players VALUES (230, 13, 'Ahmed Fattouh', 'FATTOUH', 'DF', 13, '1998-05-10', 28, 'Zamalek', 28, 0);
INSERT INTO public.players VALUES (231, 13, 'Omar Kamal', 'O. KAMAL', 'DF', 2, '1996-04-14', 30, 'Al Ahly', 24, 1);
INSERT INTO public.players VALUES (232, 13, 'Mohamed Hany', 'HANY', 'DF', 17, '1995-10-02', 30, 'Al Ahly', 32, 1);
INSERT INTO public.players VALUES (233, 13, 'Mohamed Elneny', 'ELNENY', 'MF', 8, '1992-07-11', 33, 'Al-Jazira', 100, 6);
INSERT INTO public.players VALUES (234, 13, 'Emam Ashour', 'ASHOUR', 'MF', 14, '1998-01-05', 28, 'Al Ahly', 38, 6);
INSERT INTO public.players VALUES (235, 13, 'Mahmoud Trezeguet', 'TREZEGUET', 'MF', 7, '1994-10-01', 31, 'Trabzonspor', 78, 18);
INSERT INTO public.players VALUES (236, 13, 'Mohamed Salah', 'M. SALAH', 'FW', 10, '1992-06-15', 33, 'Liverpool', 115, 62);
INSERT INTO public.players VALUES (237, 13, 'Omar Marmoush', 'MARMOUSH', 'FW', 11, '1999-01-07', 27, 'Manchester City', 42, 22);
INSERT INTO public.players VALUES (238, 13, 'Mostafa Mohamed', 'M. MOHAMED', 'FW', 9, '1997-11-28', 28, 'Nantes', 42, 14);
INSERT INTO public.players VALUES (239, 13, 'Mohamed Sherif', 'SHERIF', 'FW', 19, '1997-01-22', 29, 'Al Ahly', 18, 6);
INSERT INTO public.players VALUES (240, 13, 'Ibrahim Adel', 'I. ADEL', 'FW', 21, '2001-02-22', 25, 'Pyramids', 18, 4);
INSERT INTO public.players VALUES (241, 20, 'Mike Maignan', 'MAIGNAN', 'GK', 1, '1995-07-03', 30, 'AC Milan', 48, 0);
INSERT INTO public.players VALUES (242, 20, 'Brice Samba', 'SAMBA', 'GK', 16, '1994-04-25', 32, 'Rennes', 10, 0);
INSERT INTO public.players VALUES (243, 20, 'Jules Koundé', 'KOUNDÉ', 'DF', 5, '1998-11-12', 27, 'FC Barcelona', 52, 1);
INSERT INTO public.players VALUES (245, 20, 'Dayot Upamecano', 'UPAMECANO', 'DF', 4, '1998-10-27', 27, 'Bayern Munich', 42, 1);
INSERT INTO public.players VALUES (246, 20, 'Theo Hernández', 'T. HERNÁNDEZ', 'DF', 22, '1997-10-06', 28, 'AC Milan', 42, 4);
INSERT INTO public.players VALUES (247, 20, 'Ibrahima Konaté', 'KONATÉ', 'DF', 3, '1999-05-25', 27, 'Liverpool', 24, 1);
INSERT INTO public.players VALUES (248, 20, 'Aurélien Tchouaméni', 'TCHOUAMÉNI', 'MF', 8, '2000-01-27', 26, 'Real Madrid', 52, 5);
INSERT INTO public.players VALUES (249, 20, 'Eduardo Camavinga', 'CAMAVINGA', 'MF', 12, '2002-11-10', 23, 'Real Madrid', 38, 1);
INSERT INTO public.players VALUES (250, 20, 'Adrien Rabiot', 'RABIOT', 'MF', 14, '1995-04-03', 31, 'Marseille', 52, 6);
INSERT INTO public.players VALUES (251, 20, 'Kylian Mbappé', 'MBAPPÉ', 'FW', 10, '1998-12-20', 27, 'Real Madrid', 110, 52);
INSERT INTO public.players VALUES (252, 20, 'Ousmane Dembélé', 'DEMBÉLÉ', 'FW', 11, '1997-05-15', 29, 'PSG', 58, 8);
INSERT INTO public.players VALUES (253, 20, 'Marcus Thuram', 'THURAM', 'FW', 9, '1997-08-06', 28, 'Inter Milan', 32, 7);
INSERT INTO public.players VALUES (254, 20, 'Bradley Barcola', 'BARCOLA', 'FW', 20, '2002-09-02', 23, 'PSG', 18, 4);
INSERT INTO public.players VALUES (255, 20, 'Randal Kolo Muani', 'KOLO MUANI', 'FW', 18, '1998-12-05', 27, 'Juventus', 32, 9);
INSERT INTO public.players VALUES (256, 20, 'Antoine Griezmann', 'GRIEZMANN', 'FW', 13, '1991-03-21', 35, 'Atletico Madrid', 140, 50);
INSERT INTO public.players VALUES (257, 19, 'Yassine Bounou', 'BONO', 'GK', 1, '1991-04-05', 35, 'Al-Hilal', 68, 0);
INSERT INTO public.players VALUES (258, 19, 'Munir Mohamedi', 'MUNIR', 'GK', 12, '1989-05-10', 37, 'Al-Wehda', 42, 0);
INSERT INTO public.players VALUES (259, 19, 'Achraf Hakimi', 'HAKIMI', 'DF', 2, '1998-11-04', 27, 'PSG', 82, 12);
INSERT INTO public.players VALUES (260, 19, 'Noussair Mazraoui', 'MAZRAOUI', 'DF', 3, '1997-11-14', 28, 'Manchester United', 38, 2);
INSERT INTO public.players VALUES (261, 19, 'Nayef Aguerd', 'AGUERD', 'DF', 5, '1996-03-30', 30, 'West Ham United', 48, 3);
INSERT INTO public.players VALUES (262, 19, 'Romain Saïss', 'SAÏSS', 'DF', 6, '1990-03-26', 36, 'Al-Shabab', 78, 4);
INSERT INTO public.players VALUES (263, 19, 'Achraf Dari', 'DARI', 'DF', 18, '1999-05-06', 27, 'Brest', 28, 2);
INSERT INTO public.players VALUES (264, 19, 'Sofyan Amrabat', 'AMRABAT', 'MF', 4, '1996-08-21', 29, 'Fenerbahçe', 60, 4);
INSERT INTO public.players VALUES (265, 19, 'Azzedine Ounahi', 'OUNAHI', 'MF', 8, '2000-04-19', 26, 'Panathinaikos', 35, 5);
INSERT INTO public.players VALUES (266, 19, 'Bilal El Khannouss', 'EL KHANNOUSS', 'MF', 15, '2004-05-10', 22, 'Leicester City', 24, 4);
INSERT INTO public.players VALUES (267, 19, 'Hakim Ziyech', 'ZIYECH', 'MF', 7, '1993-03-19', 33, 'Al-Duhail', 72, 22);
INSERT INTO public.players VALUES (268, 19, 'Brahim Díaz', 'B. DÍAZ', 'FW', 19, '1999-08-03', 26, 'Real Madrid', 18, 4);
INSERT INTO public.players VALUES (269, 19, 'Youssef En-Nesyri', 'EN-NESYRI', 'FW', 9, '1997-06-01', 29, 'Fenerbahçe', 60, 18);
INSERT INTO public.players VALUES (270, 19, 'Sofiane Boufal', 'BOUFAL', 'FW', 17, '1993-09-17', 32, 'Al-Rayyan', 48, 8);
INSERT INTO public.players VALUES (271, 19, 'Ayoub El Kaabi', 'EL KAABI', 'FW', 11, '1993-06-25', 32, 'Olympiacos', 32, 12);
INSERT INTO public.players VALUES (287, 17, 'Alex Paulsen', 'PAULSEN', 'GK', 1, '2002-04-14', 24, 'Bournemouth', 12, 0);
INSERT INTO public.players VALUES (288, 17, 'Max Crocombe', 'CROCOMBE', 'GK', 12, '1993-08-15', 32, 'Burton Albion', 18, 0);
INSERT INTO public.players VALUES (289, 17, 'Tyler Bindon', 'BINDON', 'DF', 5, '2005-01-26', 21, 'Nottingham Forest', 12, 1);
INSERT INTO public.players VALUES (290, 17, 'Michael Boxall', 'BOXALL', 'DF', 6, '1988-08-18', 37, 'Minnesota United', 62, 2);
INSERT INTO public.players VALUES (291, 17, 'Nando Pijnaker', 'PIJNAKER', 'DF', 3, '1999-09-11', 26, 'Rapid Bucharest', 22, 1);
INSERT INTO public.players VALUES (292, 17, 'Liberato Cacace', 'CACACE', 'DF', 2, '2000-09-27', 25, 'Empoli', 42, 3);
INSERT INTO public.players VALUES (293, 17, 'Tim Payne', 'PAYNE', 'DF', 22, '1994-04-10', 32, 'Auckland FC', 48, 1);
INSERT INTO public.players VALUES (294, 17, 'Joe Bell', 'BELL', 'MF', 8, '1999-06-14', 26, 'Viking FK', 38, 2);
INSERT INTO public.players VALUES (295, 17, 'Marko Stamenić', 'STAMENIĆ', 'MF', 14, '2002-01-19', 24, 'Olympiacos', 24, 3);
INSERT INTO public.players VALUES (296, 17, 'Matthew Garbett', 'GARBETT', 'MF', 10, '2002-02-13', 24, 'Auckland FC', 28, 4);
INSERT INTO public.players VALUES (297, 17, 'Clayton Lewis', 'LEWIS', 'MF', 17, '1997-04-13', 29, 'Auckland FC', 32, 3);
INSERT INTO public.players VALUES (298, 17, 'Chris Wood', 'C. WOOD', 'FW', 9, '1991-12-07', 34, 'Nottingham Forest', 110, 34);
INSERT INTO public.players VALUES (299, 17, 'Kosta Barbarouses', 'BARBAROUSES', 'FW', 7, '1990-02-26', 36, 'Auckland FC', 82, 22);
INSERT INTO public.players VALUES (300, 17, 'Ben Waine', 'WAINE', 'FW', 11, '2001-05-08', 25, 'Plymouth Argyle', 24, 6);
INSERT INTO public.players VALUES (301, 17, 'Eli Just', 'JUST', 'FW', 19, '2000-03-31', 26, 'Odense BK', 18, 3);
INSERT INTO public.players VALUES (302, 24, 'Manuel Neuer', 'NEUER', 'GK', 1, '1986-03-27', 40, 'Bayern Munich', 124, 0);
INSERT INTO public.players VALUES (303, 24, 'Marc-André ter Stegen', 'TER STEGEN', 'GK', 22, '1992-04-30', 34, 'FC Barcelona', 42, 0);
INSERT INTO public.players VALUES (304, 24, 'Joshua Kimmich', 'KIMMICH', 'DF', 6, '1995-02-08', 31, 'Bayern Munich', 92, 14);
INSERT INTO public.players VALUES (305, 24, 'Antonio Rüdiger', 'RÜDIGER', 'DF', 2, '1993-03-03', 33, 'Real Madrid', 78, 4);
INSERT INTO public.players VALUES (306, 24, 'Jonathan Tah', 'TAH', 'DF', 4, '1996-02-11', 30, 'Bayern Munich', 38, 2);
INSERT INTO public.players VALUES (307, 24, 'Nico Schlotterbeck', 'SCHLOTTERBECK', 'DF', 23, '1999-12-01', 26, 'Borussia Dortmund', 24, 1);
INSERT INTO public.players VALUES (308, 24, 'David Raum', 'RAUM', 'DF', 15, '1998-04-22', 28, 'RB Leipzig', 38, 3);
INSERT INTO public.players VALUES (309, 24, 'Robert Andrich', 'ANDRICH', 'MF', 5, '1994-09-22', 31, 'Bayer Leverkusen', 28, 2);
INSERT INTO public.players VALUES (310, 24, 'Pascal Groß', 'GROSS', 'MF', 13, '1991-06-15', 34, 'Borussia Dortmund', 18, 2);
INSERT INTO public.players VALUES (311, 24, 'Florian Wirtz', 'WIRTZ', 'MF', 10, '2003-05-03', 23, 'Liverpool', 42, 16);
INSERT INTO public.players VALUES (312, 24, 'Jamal Musiala', 'MUSIALA', 'MF', 14, '2003-02-26', 23, 'Bayern Munich', 55, 18);
INSERT INTO public.players VALUES (313, 24, 'Leroy Sané', 'SANÉ', 'FW', 19, '1996-01-11', 30, 'Galatasaray', 82, 28);
INSERT INTO public.players VALUES (314, 24, 'Kai Havertz', 'HAVERTZ', 'FW', 7, '1999-06-11', 27, 'Arsenal', 66, 23);
INSERT INTO public.players VALUES (315, 24, 'Niclas Füllkrug', 'FÜLLKRUG', 'FW', 9, '1993-02-09', 33, 'West Ham United', 32, 14);
INSERT INTO public.players VALUES (317, 24, 'Deniz Undav', 'UNDAV', 'FW', 17, '1996-07-19', 29, 'VfB Stuttgart', 12, 4);
INSERT INTO public.players VALUES (318, 22, 'Zion Suzuki', 'Z. SUZUKI', 'GK', 1, '2002-08-21', 23, 'Parma', 18, 0);
INSERT INTO public.players VALUES (319, 22, 'Daniel Schmidt', 'SCHMIDT', 'GK', 12, '1992-02-03', 34, 'Sint-Truiden', 32, 0);
INSERT INTO public.players VALUES (320, 22, 'Hiroki Sakai', 'SAKAI', 'DF', 2, '1990-04-12', 36, 'Urawa Red Diamonds', 78, 3);
INSERT INTO public.players VALUES (321, 22, 'Takehiro Tomiyasu', 'TOMIYASU', 'DF', 16, '1998-11-05', 27, 'Arsenal', 42, 2);
INSERT INTO public.players VALUES (322, 22, 'Ko Itakura', 'ITAKURA', 'DF', 3, '1997-01-27', 29, 'Ajax', 38, 4);
INSERT INTO public.players VALUES (323, 22, 'Hiroki Ito', 'ITO', 'DF', 22, '1999-05-12', 27, 'Bayern Munich', 28, 1);
INSERT INTO public.players VALUES (324, 22, 'Yukinari Sugawara', 'SUGAWARA', 'DF', 5, '2000-06-28', 25, 'Southampton', 24, 1);
INSERT INTO public.players VALUES (325, 22, 'Wataru Endo', 'ENDO', 'MF', 6, '1993-02-09', 33, 'Liverpool', 75, 4);
INSERT INTO public.players VALUES (326, 22, 'Hidemasa Morita', 'MORITA', 'MF', 13, '1995-05-10', 31, 'Sporting CP', 42, 2);
INSERT INTO public.players VALUES (327, 22, 'Takefusa Kubo', 'KUBO', 'MF', 20, '2001-06-04', 25, 'Real Sociedad', 42, 6);
INSERT INTO public.players VALUES (328, 22, 'Junya Ito', 'J. ITO', 'FW', 14, '1993-03-09', 33, 'Stade de Reims', 58, 14);
INSERT INTO public.players VALUES (329, 22, 'Kaoru Mitoma', 'MITOMA', 'FW', 7, '1997-05-20', 29, 'Brighton', 52, 18);
INSERT INTO public.players VALUES (330, 22, 'Takumi Minamino', 'MINAMINO', 'FW', 10, '1995-01-16', 31, 'AS Monaco', 72, 24);
INSERT INTO public.players VALUES (331, 22, 'Ayase Ueda', 'UEDA', 'FW', 19, '1998-08-28', 27, 'Feyenoord', 32, 12);
INSERT INTO public.players VALUES (332, 22, 'Daizen Maeda', 'MAEDA', 'FW', 15, '1997-10-20', 28, 'Celtic', 38, 10);
INSERT INTO public.players VALUES (333, 23, 'Anthony Mandrea', 'MANDREA', 'GK', 1, '1997-03-09', 29, 'Angers', 12, 0);
INSERT INTO public.players VALUES (334, 23, 'Alexandre Oukidja', 'OUKIDJA', 'GK', 23, '1988-07-19', 37, 'FC Metz', 32, 0);
INSERT INTO public.players VALUES (335, 23, 'Aïssa Mandi', 'MANDI', 'DF', 2, '1991-10-22', 34, 'Lille', 78, 4);
INSERT INTO public.players VALUES (336, 23, 'Ramy Bensebaini', 'BENSEBAINI', 'DF', 3, '1995-04-16', 31, 'Borussia Dortmund', 52, 6);
INSERT INTO public.players VALUES (337, 23, 'Mohamed Amoura', 'AMOURA', 'FW', 14, '2000-04-09', 26, 'VfL Wolfsburg', 28, 10);
INSERT INTO public.players VALUES (338, 23, 'Youcef Atal', 'ATAL', 'DF', 20, '1996-05-17', 30, 'Al-Sadd', 42, 3);
INSERT INTO public.players VALUES (339, 23, 'Jaouen Hadjam', 'HADJAM', 'DF', 21, '2003-03-26', 23, 'Young Boys', 14, 1);
INSERT INTO public.players VALUES (340, 23, 'Ismaël Bennacer', 'BENNACER', 'MF', 4, '1997-12-01', 28, 'AC Milan', 62, 5);
INSERT INTO public.players VALUES (341, 23, 'Nabil Bentaleb', 'BENTALEB', 'MF', 8, '1994-11-24', 31, 'Lille', 42, 3);
INSERT INTO public.players VALUES (342, 23, 'Ramiz Zerrouki', 'ZERROUKI', 'MF', 13, '1998-07-29', 27, 'Feyenoord', 24, 1);
INSERT INTO public.players VALUES (343, 23, 'Houssem Aouar', 'AOUAR', 'MF', 7, '1998-06-30', 27, 'AS Roma', 18, 3);
INSERT INTO public.players VALUES (344, 23, 'Riyad Mahrez', 'MAHREZ', 'FW', 6, '1991-02-21', 35, 'Al-Ahli', 105, 36);
INSERT INTO public.players VALUES (345, 23, 'Baghdad Bounedjah', 'BOUNEDJAH', 'FW', 9, '1991-11-24', 34, 'Al-Sadd', 68, 28);
INSERT INTO public.players VALUES (346, 23, 'Islam Slimani', 'SLIMANI', 'FW', 13, '1988-06-18', 37, 'Mechelen', 98, 45);
INSERT INTO public.players VALUES (347, 23, 'Saïd Benrahma', 'BENRAHMA', 'FW', 11, '1995-08-10', 30, 'Neom SC', 28, 6);
INSERT INTO public.players VALUES (348, 21, 'Yazeed Abulaila', 'ABULAILA', 'GK', 1, '1994-02-12', 32, 'Al-Faisaly', 55, 0);
INSERT INTO public.players VALUES (349, 21, 'Abdullah Al-Fakhouri', 'AL-FAKHOURI', 'GK', 16, '1996-08-09', 29, 'Al-Hussein', 18, 0);
INSERT INTO public.players VALUES (350, 21, 'Mohammad Abu Hashish', 'ABU HASHISH', 'DF', 4, '1997-08-09', 28, 'Al-Wehdat', 42, 2);
INSERT INTO public.players VALUES (351, 21, 'Yazan Al-Arab', 'AL-ARAB', 'DF', 5, '1996-03-01', 30, 'Al-Ramtha', 38, 1);
INSERT INTO public.players VALUES (352, 21, 'Salem Al-Ajalin', 'AL-AJALIN', 'DF', 13, '1998-06-15', 27, 'Al-Hussein', 24, 0);
INSERT INTO public.players VALUES (353, 21, 'Ihsan Haddad', 'HADDAD', 'DF', 2, '1997-11-20', 28, 'Al-Faisaly', 32, 1);
INSERT INTO public.players VALUES (354, 21, 'Noor Al-Rawabdeh', 'AL-RAWABDEH', 'DF', 3, '2000-04-18', 26, 'Al-Wehdat', 22, 0);
INSERT INTO public.players VALUES (355, 21, 'Nour Al-Rawashdeh', 'N.AL-RAWASHDEH', 'MF', 8, '1998-09-22', 27, 'Al-Hussein', 28, 2);
INSERT INTO public.players VALUES (356, 21, 'Ihsan Haddad II', 'HADDAD II', 'MF', 18, '1995-12-12', 30, 'Al-Faisaly', 24, 1);
INSERT INTO public.players VALUES (357, 21, 'Mahmoud Al-Mardi', 'AL-MARDI', 'MF', 14, '1998-02-04', 28, 'Al-Wehdat', 32, 3);
INSERT INTO public.players VALUES (358, 21, 'Musa Al-Taamari', 'AL-TAAMARI', 'FW', 10, '1997-06-10', 29, 'Montpellier', 42, 15);
INSERT INTO public.players VALUES (359, 21, 'Yazan Al-Naimat', 'AL-NAIMAT', 'FW', 9, '1998-03-22', 28, 'Al-Ahli', 38, 12);
INSERT INTO public.players VALUES (360, 21, 'Ali Olwan', 'OLWAN', 'FW', 11, '1998-01-31', 28, 'Zakho', 32, 10);
INSERT INTO public.players VALUES (361, 21, 'Mousa Al-Tamari II', 'TAMARI II', 'FW', 17, '2001-05-14', 25, 'Al-Wehdat', 18, 4);
INSERT INTO public.players VALUES (362, 21, 'Hamza Al-Dardour', 'AL-DARDOUR', 'FW', 19, '1991-06-09', 35, 'Al-Wehdat', 58, 20);
INSERT INTO public.players VALUES (363, 28, 'Emiliano Martínez', 'E. MARTÍNEZ', 'GK', 1, '1992-09-02', 33, 'Aston Villa', 70, 0);
INSERT INTO public.players VALUES (364, 28, 'Gerónimo Rulli', 'RULLI', 'GK', 12, '1992-05-20', 34, 'Marseille', 12, 0);
INSERT INTO public.players VALUES (365, 28, 'Nahuel Molina', 'MOLINA', 'DF', 3, '1998-04-06', 28, 'Atletico Madrid', 48, 4);
INSERT INTO public.players VALUES (366, 28, 'Cristian Romero', 'C. ROMERO', 'DF', 13, '1998-04-27', 28, 'Tottenham Hotspur', 60, 5);
INSERT INTO public.players VALUES (367, 28, 'Nicolás Otamendi', 'OTAMENDI', 'DF', 19, '1988-02-12', 38, 'Benfica', 120, 5);
INSERT INTO public.players VALUES (368, 28, 'Nicolás Tagliafico', 'TAGLIAFICO', 'DF', 3, '1992-08-31', 33, 'Lyon', 58, 2);
INSERT INTO public.players VALUES (369, 28, 'Lisandro Martínez', 'L. MARTÍNEZ', 'DF', 25, '1998-01-18', 28, 'Manchester United', 28, 1);
INSERT INTO public.players VALUES (370, 28, 'Rodrigo De Paul', 'DE PAUL', 'MF', 7, '1994-05-24', 32, 'Atletico Madrid', 84, 18);
INSERT INTO public.players VALUES (371, 28, 'Enzo Fernández', 'ENZO', 'MF', 24, '2001-01-17', 25, 'Chelsea', 38, 4);
INSERT INTO public.players VALUES (372, 28, 'Alexis Mac Allister', 'MAC ALLISTER', 'MF', 20, '1998-12-24', 27, 'Liverpool', 42, 6);
INSERT INTO public.players VALUES (373, 28, 'Lionel Messi', 'MESSI', 'FW', 10, '1987-06-24', 38, 'Inter Miami CF', 191, 109);
INSERT INTO public.players VALUES (374, 28, 'Lautaro Martínez', 'LAUTARO', 'FW', 22, '1997-08-22', 28, 'Inter Milan', 85, 42);
INSERT INTO public.players VALUES (375, 28, 'Julián Álvarez', 'J. ÁLVAREZ', 'FW', 9, '2000-01-31', 26, 'Atletico Madrid', 65, 26);
INSERT INTO public.players VALUES (376, 28, 'Ángel Di María', 'DI MARÍA', 'FW', 11, '1988-02-14', 38, 'Benfica', 145, 31);
INSERT INTO public.players VALUES (377, 28, 'Giovani Lo Celso', 'LO CELSO', 'MF', 18, '1996-04-09', 30, 'Real Betis', 58, 6);
INSERT INTO public.players VALUES (378, 27, 'Camilo Vargas', 'C. VARGAS', 'GK', 1, '1989-03-09', 37, 'Atlas', 62, 0);
INSERT INTO public.players VALUES (379, 27, 'David Ospina', 'OSPINA', 'GK', 12, '1988-08-31', 37, 'Atlético Nacional', 128, 0);
INSERT INTO public.players VALUES (380, 27, 'Daniel Muñoz', 'D. MUÑOZ', 'DF', 4, '1996-05-26', 30, 'Crystal Palace', 48, 5);
INSERT INTO public.players VALUES (381, 27, 'Yerry Mina', 'MINA', 'DF', 13, '1994-09-23', 31, 'Cagliari', 48, 8);
INSERT INTO public.players VALUES (382, 27, 'Dávinson Sánchez', 'D. SÁNCHEZ', 'DF', 3, '1996-06-12', 29, 'Galatasaray', 72, 5);
INSERT INTO public.players VALUES (383, 27, 'Johan Mojica', 'MOJICA', 'DF', 17, '1992-08-21', 33, 'Mallorca', 42, 1);
INSERT INTO public.players VALUES (384, 27, 'Santiago Arias', 'ARIAS', 'DF', 14, '1992-01-13', 34, 'Bahia', 58, 1);
INSERT INTO public.players VALUES (385, 27, 'James Rodríguez', 'JAMES', 'MF', 10, '1991-07-12', 34, 'Rayo Vallecano', 111, 29);
INSERT INTO public.players VALUES (386, 27, 'Jefferson Lerma', 'LERMA', 'MF', 5, '1994-10-25', 31, 'Crystal Palace', 62, 3);
INSERT INTO public.players VALUES (387, 27, 'Richard Ríos', 'RÍOS', 'MF', 8, '2000-05-16', 26, 'Benfica', 38, 5);
INSERT INTO public.players VALUES (388, 27, 'Juan Fernando Quintero', 'QUINTERO', 'MF', 20, '1993-01-18', 33, 'River Plate', 48, 6);
INSERT INTO public.players VALUES (390, 27, 'Jhon Córdoba', 'CÓRDOBA', 'FW', 9, '1993-05-11', 33, 'Krasnodar', 24, 8);
INSERT INTO public.players VALUES (391, 27, 'Jhon Durán', 'DURÁN', 'FW', 19, '2003-12-13', 22, 'Al-Nassr', 32, 15);
INSERT INTO public.players VALUES (392, 27, 'Luis Sinisterra', 'SINISTERRA', 'FW', 11, '1999-06-17', 26, 'Bournemouth', 28, 5);
INSERT INTO public.players VALUES (393, 25, 'Mathew Ryan', 'M. RYAN', 'GK', 1, '1992-04-08', 34, 'Roma', 94, 0);
INSERT INTO public.players VALUES (394, 25, 'Joe Gauci', 'GAUCI', 'GK', 18, '2000-07-04', 25, 'Aston Villa', 12, 0);
INSERT INTO public.players VALUES (395, 25, 'Harry Souttar', 'SOUTTAR', 'DF', 19, '1998-10-22', 27, 'Sheffield United', 36, 5);
INSERT INTO public.players VALUES (396, 25, 'Kye Rowles', 'ROWLES', 'DF', 4, '1998-06-24', 27, 'Hearts', 32, 1);
INSERT INTO public.players VALUES (397, 25, 'Cameron Burgess', 'BURGESS', 'DF', 16, '1995-10-21', 30, 'Ipswich Town', 18, 1);
INSERT INTO public.players VALUES (398, 25, 'Aziz Behich', 'BEHICH', 'DF', 3, '1990-12-16', 35, 'Melbourne City', 78, 1);
INSERT INTO public.players VALUES (399, 25, 'Nathaniel Atkinson', 'ATKINSON', 'DF', 2, '1999-06-13', 26, 'Hearts', 28, 0);
INSERT INTO public.players VALUES (400, 25, 'Aaron Mooy', 'MOOY', 'MF', 13, '1990-09-15', 35, 'Macarthur FC', 80, 9);
INSERT INTO public.players VALUES (401, 25, 'Jackson Irvine', 'IRVINE', 'MF', 22, '1993-03-07', 33, 'St. Pauli', 62, 9);
INSERT INTO public.players VALUES (402, 25, 'Connor Metcalfe', 'METCALFE', 'MF', 8, '1999-11-05', 26, 'St. Pauli', 24, 2);
INSERT INTO public.players VALUES (403, 25, 'Riley McGree', 'MCGREE', 'MF', 14, '1998-11-02', 27, 'Middlesbrough', 32, 3);
INSERT INTO public.players VALUES (404, 25, 'Mitchell Duke', 'DUKE', 'FW', 9, '1991-01-18', 35, 'Machida Zelvia', 62, 16);
INSERT INTO public.players VALUES (405, 25, 'Martin Boyle', 'BOYLE', 'FW', 7, '1993-04-25', 33, 'Hibernian', 52, 14);
INSERT INTO public.players VALUES (406, 25, 'Kusini Yengi', 'YENGI', 'FW', 11, '1999-01-19', 27, 'Portsmouth', 18, 5);
INSERT INTO public.players VALUES (407, 25, 'Brandon Borrello', 'BORRELLO', 'FW', 17, '1995-07-25', 30, 'Western Sydney', 24, 3);
INSERT INTO public.players VALUES (423, 32, 'Unai Simón', 'U. SIMÓN', 'GK', 1, '1997-06-11', 29, 'Athletic Bilbao', 55, 0);
INSERT INTO public.players VALUES (424, 32, 'David Raya', 'RAYA', 'GK', 23, '1995-09-15', 30, 'Arsenal', 18, 0);
INSERT INTO public.players VALUES (425, 32, 'Dani Carvajal', 'CARVAJAL', 'DF', 2, '1992-01-11', 34, 'Real Madrid', 52, 4);
INSERT INTO public.players VALUES (426, 32, 'Robin Le Normand', 'LE NORMAND', 'DF', 3, '1996-11-11', 29, 'Atletico Madrid', 32, 2);
INSERT INTO public.players VALUES (427, 32, 'Aymeric Laporte', 'LAPORTE', 'DF', 14, '1994-05-27', 32, 'Al-Nassr', 42, 2);
INSERT INTO public.players VALUES (428, 32, 'Marc Cucurella', 'CUCURELLA', 'DF', 24, '1998-07-22', 27, 'Chelsea', 28, 1);
INSERT INTO public.players VALUES (429, 32, 'Pau Cubarsí', 'CUBARSÍ', 'DF', 5, '2007-01-22', 19, 'FC Barcelona', 14, 0);
INSERT INTO public.players VALUES (430, 32, 'Rodri', 'RODRI', 'MF', 16, '1996-06-22', 29, 'Manchester City', 58, 4);
INSERT INTO public.players VALUES (431, 32, 'Pedri', 'PEDRI', 'MF', 9, '2002-11-25', 23, 'FC Barcelona', 38, 12);
INSERT INTO public.players VALUES (432, 32, 'Fabián Ruiz', 'FABIÁN', 'MF', 8, '1996-04-03', 30, 'PSG', 42, 9);
INSERT INTO public.players VALUES (433, 32, 'Mikel Merino', 'MERINO', 'MF', 20, '1996-06-22', 29, 'Arsenal', 28, 4);
INSERT INTO public.players VALUES (434, 32, 'Lamine Yamal', 'YAMAL', 'FW', 19, '2007-07-13', 18, 'FC Barcelona', 32, 14);
INSERT INTO public.players VALUES (435, 32, 'Nico Williams', 'N. WILLIAMS', 'FW', 17, '2002-07-12', 23, 'Athletic Bilbao', 28, 8);
INSERT INTO public.players VALUES (436, 32, 'Álvaro Morata', 'MORATA', 'FW', 7, '1992-10-23', 33, 'Como', 80, 36);
INSERT INTO public.players VALUES (437, 32, 'Mikel Oyarzabal', 'OYARZABAL', 'FW', 21, '1997-04-21', 29, 'Real Sociedad', 42, 14);
INSERT INTO public.players VALUES (438, 30, 'Édouard Mendy', 'MENDY', 'GK', 1, '1992-03-01', 34, 'Al-Ahli', 68, 0);
INSERT INTO public.players VALUES (439, 30, 'Seny Dieng', 'DIENG', 'GK', 23, '1994-11-23', 31, 'Middlesbrough', 18, 0);
INSERT INTO public.players VALUES (440, 30, 'Kalidou Koulibaly', 'KOULIBALY', 'DF', 3, '1991-06-20', 34, 'Al-Hilal', 105, 7);
INSERT INTO public.players VALUES (441, 30, 'Abdou Diallo', 'A. DIALLO', 'DF', 22, '1996-05-04', 30, 'Al-Arabi', 42, 1);
INSERT INTO public.players VALUES (442, 30, 'Moussa Niakhaté', 'NIAKHATÉ', 'DF', 12, '1996-03-08', 30, 'Lyon', 28, 1);
INSERT INTO public.players VALUES (443, 30, 'Ismail Jakobs', 'JAKOBS', 'DF', 14, '1999-08-17', 26, 'Galatasaray', 24, 1);
INSERT INTO public.players VALUES (444, 30, 'Krépin Diatta', 'DIATTA', 'DF', 18, '1999-02-25', 27, 'AS Monaco', 42, 5);
INSERT INTO public.players VALUES (445, 30, 'Idrissa Gueye', 'I. GUEYE', 'MF', 5, '1989-09-26', 36, 'Everton', 112, 10);
INSERT INTO public.players VALUES (446, 30, 'Pape Matar Sarr', 'P.M. SARR', 'MF', 17, '2002-09-14', 23, 'Tottenham Hotspur', 28, 3);
INSERT INTO public.players VALUES (447, 30, 'Pape Gueye', 'P. GUEYE', 'MF', 15, '1999-01-24', 27, 'Villarreal', 28, 1);
INSERT INTO public.players VALUES (448, 30, 'Lamine Camara', 'CAMARA', 'MF', 6, '2004-01-01', 22, 'AS Monaco', 18, 4);
INSERT INTO public.players VALUES (449, 30, 'Sadio Mané', 'MANÉ', 'FW', 10, '1992-04-10', 34, 'Al-Nassr', 110, 44);
INSERT INTO public.players VALUES (450, 30, 'Ismaïla Sarr', 'I. SARR', 'FW', 7, '1998-02-25', 28, 'Crystal Palace', 65, 18);
INSERT INTO public.players VALUES (451, 30, 'Nicolas Jackson', 'JACKSON', 'FW', 9, '2001-06-20', 24, 'Chelsea', 24, 8);
INSERT INTO public.players VALUES (452, 30, 'Habib Diallo', 'H. DIALLO', 'FW', 19, '1995-06-18', 30, 'Al-Shabab', 42, 11);
INSERT INTO public.players VALUES (468, 29, 'Ronwen Williams', 'R. WILLIAMS', 'GK', 1, '1992-01-21', 34, 'Mamelodi Sundowns', 55, 0);
INSERT INTO public.players VALUES (469, 29, 'Ricardo Goss', 'GOSS', 'GK', 16, '1995-04-04', 31, 'Sekhukhune United', 12, 0);
INSERT INTO public.players VALUES (470, 29, 'Nyiko Mobbie', 'MOBBIE', 'DF', 2, '2000-03-06', 26, 'Mamelodi Sundowns', 18, 0);
INSERT INTO public.players VALUES (471, 29, 'Siyanda Xulu', 'XULU', 'DF', 5, '1991-12-30', 34, 'Sekhukhune United', 68, 2);
INSERT INTO public.players VALUES (472, 29, 'Mothobi Mvala', 'MVALA', 'DF', 6, '1994-06-21', 31, 'Mamelodi Sundowns', 42, 3);
INSERT INTO public.players VALUES (473, 29, 'Khuliso Mudau', 'MUDAU', 'DF', 22, '1995-05-21', 31, 'Mamelodi Sundowns', 32, 1);
INSERT INTO public.players VALUES (474, 29, 'Aubrey Modiba', 'MODIBA', 'DF', 3, '1995-07-22', 30, 'Mamelodi Sundowns', 38, 2);
INSERT INTO public.players VALUES (475, 29, 'Teboho Mokoena', 'MOKOENA', 'MF', 8, '1997-01-24', 29, 'Mamelodi Sundowns', 48, 6);
INSERT INTO public.players VALUES (476, 29, 'Sphephelo Sithole', 'SITHOLE', 'MF', 15, '1999-02-07', 27, 'Tondela', 24, 2);
INSERT INTO public.players VALUES (477, 29, 'Themba Zwane', 'ZWANE', 'MF', 10, '1989-08-03', 36, 'Mamelodi Sundowns', 42, 15);
INSERT INTO public.players VALUES (478, 29, 'Thalente Mbatha', 'MBATHA', 'MF', 14, '1998-04-16', 28, 'Orlando Pirates', 18, 1);
INSERT INTO public.players VALUES (479, 29, 'Percy Tau', 'TAU', 'FW', 9, '1994-05-13', 32, 'Qatar SC', 58, 24);
INSERT INTO public.players VALUES (480, 29, 'Lyle Foster', 'FOSTER', 'FW', 11, '2000-09-03', 25, 'Burnley', 32, 12);
INSERT INTO public.players VALUES (481, 29, 'Evidence Makgopa', 'MAKGOPA', 'FW', 19, '2000-03-23', 26, 'Orlando Pirates', 28, 7);
INSERT INTO public.players VALUES (482, 29, 'Mihlali Mayambela', 'MAYAMBELA', 'FW', 17, '1996-08-03', 29, 'Aris Limassol', 18, 4);
INSERT INTO public.players VALUES (483, 36, 'Jordan Pickford', 'PICKFORD', 'GK', 1, '1994-03-07', 32, 'Everton', 78, 0);
INSERT INTO public.players VALUES (484, 36, 'Dean Henderson', 'HENDERSON', 'GK', 13, '1997-03-12', 29, 'Crystal Palace', 12, 0);
INSERT INTO public.players VALUES (485, 36, 'Kyle Walker', 'K. WALKER', 'DF', 2, '1990-05-28', 36, 'Burnley', 90, 1);
INSERT INTO public.players VALUES (486, 36, 'John Stones', 'STONES', 'DF', 5, '1994-05-28', 32, 'Manchester City', 82, 3);
INSERT INTO public.players VALUES (487, 36, 'Marc Guéhi', 'GUÉHI', 'DF', 6, '2000-07-13', 25, 'Crystal Palace', 28, 2);
INSERT INTO public.players VALUES (488, 36, 'Ezri Konsa', 'KONSA', 'DF', 4, '1997-10-23', 28, 'Aston Villa', 18, 0);
INSERT INTO public.players VALUES (489, 36, 'Trent Alexander-Arnold', 'ALEXANDER-A.', 'DF', 12, '1998-10-07', 27, 'Real Madrid', 38, 3);
INSERT INTO public.players VALUES (490, 36, 'Declan Rice', 'D. RICE', 'MF', 16, '1999-01-14', 27, 'Arsenal', 72, 7);
INSERT INTO public.players VALUES (491, 36, 'Jude Bellingham', 'BELLINGHAM', 'MF', 10, '2003-06-29', 22, 'Real Madrid', 65, 24);
INSERT INTO public.players VALUES (492, 36, 'Cole Palmer', 'PALMER', 'MF', 24, '2002-05-06', 24, 'Chelsea', 18, 6);
INSERT INTO public.players VALUES (493, 36, 'Phil Foden', 'FODEN', 'MF', 7, '2000-05-28', 26, 'Manchester City', 68, 20);
INSERT INTO public.players VALUES (494, 36, 'Harry Kane', 'H. KANE', 'FW', 9, '1993-07-28', 32, 'Bayern Munich', 108, 68);
INSERT INTO public.players VALUES (495, 36, 'Bukayo Saka', 'SAKA', 'FW', 17, '2001-09-05', 24, 'Arsenal', 48, 12);
INSERT INTO public.players VALUES (496, 36, 'Anthony Gordon', 'GORDON', 'FW', 11, '2001-02-24', 25, 'Newcastle United', 18, 3);
INSERT INTO public.players VALUES (497, 36, 'Ollie Watkins', 'WATKINS', 'FW', 18, '1995-12-30', 30, 'Aston Villa', 24, 6);
INSERT INTO public.players VALUES (498, 35, 'Thibaut Courtois', 'COURTOIS', 'GK', 1, '1992-05-11', 34, 'Real Madrid', 108, 0);
INSERT INTO public.players VALUES (499, 35, 'Koen Casteels', 'CASTEELS', 'GK', 12, '1992-06-25', 33, 'Al-Qadsiah', 32, 0);
INSERT INTO public.players VALUES (500, 35, 'Timothy Castagne', 'CASTAGNE', 'DF', 21, '1995-12-05', 30, 'Fulham', 58, 3);
INSERT INTO public.players VALUES (501, 35, 'Wout Faes', 'FAES', 'DF', 4, '1998-04-03', 28, 'Leicester City', 38, 2);
INSERT INTO public.players VALUES (502, 35, 'Zeno Debast', 'DEBAST', 'DF', 3, '2003-10-24', 22, 'Sporting CP', 24, 1);
INSERT INTO public.players VALUES (503, 35, 'Arthur Theate', 'THEATE', 'DF', 24, '2000-05-25', 26, 'Eintracht Frankfurt', 32, 2);
INSERT INTO public.players VALUES (504, 35, 'Maxim De Cuyper', 'DE CUYPER', 'DF', 15, '2000-12-22', 25, 'Brighton', 18, 1);
INSERT INTO public.players VALUES (505, 35, 'Youri Tielemans', 'TIELEMANS', 'MF', 8, '1997-05-07', 29, 'Aston Villa', 72, 9);
INSERT INTO public.players VALUES (506, 35, 'Amadou Onana', 'ONANA', 'MF', 17, '2001-08-16', 24, 'Aston Villa', 28, 2);
INSERT INTO public.players VALUES (507, 35, 'Kevin De Bruyne', 'DE BRUYNE', 'MF', 7, '1991-06-28', 34, 'Napoli', 112, 30);
INSERT INTO public.players VALUES (508, 35, 'Charles De Ketelaere', 'DE KETELAERE', 'MF', 11, '2001-03-10', 25, 'Atalanta', 32, 5);
INSERT INTO public.players VALUES (509, 35, 'Romelu Lukaku', 'LUKAKU', 'FW', 9, '1993-05-13', 33, 'Napoli', 108, 74);
INSERT INTO public.players VALUES (510, 35, 'Jérémy Doku', 'DOKU', 'FW', 22, '2002-05-27', 24, 'Manchester City', 32, 4);
INSERT INTO public.players VALUES (511, 35, 'Leandro Trossard', 'TROSSARD', 'FW', 10, '1994-12-04', 31, 'Arsenal', 42, 9);
INSERT INTO public.players VALUES (512, 35, 'Loïs Openda', 'OPENDA', 'FW', 18, '2000-02-16', 26, 'RB Leipzig', 38, 16);
INSERT INTO public.players VALUES (513, 33, 'Mohammed Al-Owais', 'AL-OWAIS', 'GK', 1, '1991-10-10', 34, 'Al-Hilal', 72, 0);
INSERT INTO public.players VALUES (514, 33, 'Nawaf Al-Aqidi', 'AL-AQIDI', 'GK', 21, '2000-05-10', 26, 'Al-Nassr', 12, 0);
INSERT INTO public.players VALUES (515, 33, 'Sultan Al-Ghannam', 'AL-GHANNAM', 'DF', 2, '1994-05-06', 32, 'Al-Nassr', 55, 2);
INSERT INTO public.players VALUES (516, 33, 'Ali Al-Bulaihi', 'AL-BULAIHI', 'DF', 4, '1989-11-21', 36, 'Al-Hilal', 58, 1);
INSERT INTO public.players VALUES (517, 33, 'Hassan Al-Tambakti', 'AL-TAMBAKTI', 'DF', 5, '1999-02-09', 27, 'Al-Hilal', 38, 2);
INSERT INTO public.players VALUES (518, 33, 'Yasser Al-Shahrani', 'AL-SHAHRANI', 'DF', 13, '1992-05-25', 34, 'Al-Hilal', 72, 1);
INSERT INTO public.players VALUES (519, 33, 'Saud Abdulhamid', 'ABDULHAMID', 'DF', 14, '1999-07-18', 26, 'AS Roma', 32, 1);
INSERT INTO public.players VALUES (520, 33, 'Salman Al-Faraj', 'AL-FARAJ', 'MF', 7, '1989-08-01', 36, 'Al-Hilal', 78, 6);
INSERT INTO public.players VALUES (521, 33, 'Mohamed Kanno', 'KANNO', 'MF', 17, '1994-09-22', 31, 'Al-Hilal', 58, 4);
INSERT INTO public.players VALUES (522, 33, 'Nasser Al-Dawsari', 'N.AL-DAWSARI', 'MF', 23, '1998-12-19', 27, 'Al-Hilal', 32, 3);
INSERT INTO public.players VALUES (523, 33, 'Salem Al-Dawsari', 'AL-DAWSARI', 'FW', 10, '1991-08-19', 34, 'Al-Hilal', 95, 32);
INSERT INTO public.players VALUES (524, 33, 'Firas Al-Buraikan', 'AL-BURAIKAN', 'FW', 9, '2000-05-14', 26, 'Al-Ahli', 48, 18);
INSERT INTO public.players VALUES (525, 33, 'Saleh Al-Shehri', 'AL-SHEHRI', 'FW', 11, '1993-11-01', 32, 'Al-Hilal', 42, 14);
INSERT INTO public.players VALUES (526, 33, 'Abdullah Al-Hamdan', 'AL-HAMDAN', 'FW', 20, '1999-09-12', 26, 'Al-Hilal', 28, 6);
INSERT INTO public.players VALUES (527, 33, 'Feras Al-Brikan II', 'AL-BRIKAN II', 'FW', 19, '2002-03-15', 24, 'Al-Fateh', 14, 3);
INSERT INTO public.players VALUES (543, 40, 'Diogo Costa', 'D. COSTA', 'GK', 1, '1999-09-19', 26, 'FC Porto', 42, 0);
INSERT INTO public.players VALUES (544, 40, 'Rui Patrício', 'PATRÍCIO', 'GK', 12, '1988-02-15', 38, 'Al-Ahli Doha', 108, 0);
INSERT INTO public.players VALUES (545, 40, 'Rúben Dias', 'R. DIAS', 'DF', 3, '1997-05-14', 29, 'Manchester City', 72, 5);
INSERT INTO public.players VALUES (546, 40, 'Pepe', 'PEPE', 'DF', 2, '1983-02-26', 43, 'Free agent', 141, 8);
INSERT INTO public.players VALUES (547, 40, 'Nuno Mendes', 'N. MENDES', 'DF', 19, '2002-06-19', 23, 'PSG', 38, 2);
INSERT INTO public.players VALUES (548, 40, 'João Cancelo', 'CANCELO', 'DF', 20, '1994-05-27', 32, 'Al-Hilal', 58, 10);
INSERT INTO public.players VALUES (549, 40, 'Diogo Dalot', 'DALOT', 'DF', 13, '1999-03-18', 27, 'Manchester United', 38, 3);
INSERT INTO public.players VALUES (550, 40, 'Bruno Fernandes', 'B. FERNANDES', 'MF', 8, '1994-09-08', 31, 'Manchester United', 90, 28);
INSERT INTO public.players VALUES (551, 40, 'Vitinha', 'VITINHA', 'MF', 16, '2000-02-13', 26, 'PSG', 38, 3);
INSERT INTO public.players VALUES (552, 40, 'Bernardo Silva', 'B. SILVA', 'MF', 10, '1994-08-10', 31, 'Manchester City', 95, 24);
INSERT INTO public.players VALUES (553, 40, 'João Neves', 'J. NEVES', 'MF', 18, '2004-09-27', 21, 'PSG', 18, 2);
INSERT INTO public.players VALUES (554, 40, 'Cristiano Ronaldo', 'RONALDO', 'FW', 7, '1985-02-05', 41, 'Al-Nassr', 218, 130);
INSERT INTO public.players VALUES (555, 40, 'Rafael Leão', 'LEÃO', 'FW', 15, '1999-06-10', 27, 'AC Milan', 58, 18);
INSERT INTO public.players VALUES (556, 40, 'Gonçalo Ramos', 'G. RAMOS', 'FW', 26, '2001-06-20', 24, 'PSG', 24, 11);
INSERT INTO public.players VALUES (557, 40, 'Pedro Neto', 'P. NETO', 'FW', 17, '2000-03-09', 26, 'Chelsea', 28, 6);
INSERT INTO public.players VALUES (573, 37, 'Alireza Beiranvand', 'BEIRANVAND', 'GK', 1, '1992-09-21', 33, 'Persepolis', 75, 0);
INSERT INTO public.players VALUES (574, 37, 'Payam Niazmand', 'NIAZMAND', 'GK', 12, '1995-04-06', 31, 'Sepahan', 24, 0);
INSERT INTO public.players VALUES (575, 37, 'Sadegh Moharrami', 'MOHARRAMI', 'DF', 2, '1996-03-01', 30, 'Dinamo Zagreb', 42, 1);
INSERT INTO public.players VALUES (576, 37, 'Shojae Khalilzadeh', 'KHALILZADEH', 'DF', 4, '1989-05-14', 37, 'Tractor', 48, 3);
INSERT INTO public.players VALUES (577, 37, 'Hossein Kanaanizadegan', 'KANAANI', 'DF', 8, '1994-03-23', 32, 'Al-Ahli', 58, 4);
INSERT INTO public.players VALUES (578, 37, 'Milad Mohammadi', 'M. MOHAMMADI', 'DF', 3, '1993-09-29', 32, 'Persepolis', 62, 1);
INSERT INTO public.players VALUES (579, 37, 'Ehsan Hajsafi', 'HAJSAFI', 'DF', 5, '1990-02-25', 36, 'AEK Athens', 120, 8);
INSERT INTO public.players VALUES (580, 37, 'Saeid Ezatolahi', 'EZATOLAHI', 'MF', 6, '1996-10-01', 29, 'Esteghlal', 58, 2);
INSERT INTO public.players VALUES (581, 37, 'Ahmad Nourollahi', 'NOUROLLAHI', 'MF', 16, '1993-02-01', 33, 'Shabab Al-Ahli', 42, 4);
INSERT INTO public.players VALUES (582, 37, 'Mehdi Ghayedi', 'GHAYEDI', 'MF', 18, '1998-12-05', 27, 'Ittihad Kalba', 32, 6);
INSERT INTO public.players VALUES (583, 37, 'Alireza Jahanbakhsh', 'JAHANBAKHSH', 'FW', 7, '1993-08-11', 32, 'Heerenveen', 72, 14);
INSERT INTO public.players VALUES (584, 37, 'Mehdi Taremi', 'TAREMI', 'FW', 9, '1992-07-18', 33, 'Inter Milan', 92, 50);
INSERT INTO public.players VALUES (585, 37, 'Sardar Azmoun', 'AZMOUN', 'FW', 10, '1995-01-01', 31, 'Shabab Al-Ahli', 65, 42);
INSERT INTO public.players VALUES (586, 37, 'Karim Ansarifard', 'ANSARIFARD', 'FW', 11, '1990-04-03', 36, 'Esteghlal', 98, 30);
INSERT INTO public.players VALUES (587, 37, 'Mohammad Mohebbi', 'MOHEBBI', 'FW', 19, '1999-04-01', 27, 'Rostov', 28, 5);
INSERT INTO public.players VALUES (588, 38, 'Lionel Mpasi', 'MPASI', 'GK', 1, '1995-04-21', 31, 'Rodez', 18, 0);
INSERT INTO public.players VALUES (589, 38, 'Timothy Fayulu', 'FAYULU', 'GK', 16, '1996-09-13', 29, 'Sion', 12, 0);
INSERT INTO public.players VALUES (590, 38, 'Chancel Mbemba', 'MBEMBA', 'DF', 5, '1994-08-08', 31, 'Lille', 72, 4);
INSERT INTO public.players VALUES (591, 38, 'Gédéon Kalulu', 'KALULU', 'DF', 2, '1997-08-29', 28, 'Lorient', 24, 1);
INSERT INTO public.players VALUES (592, 38, 'Arthur Masuaku', 'MASUAKU', 'DF', 3, '1993-11-07', 32, 'Sunderland', 38, 2);
INSERT INTO public.players VALUES (593, 38, 'Dylan Batubinsika', 'BATUBINSIKA', 'DF', 4, '1996-02-15', 30, 'Saint-Étienne', 28, 1);
INSERT INTO public.players VALUES (594, 38, 'Rocky Bushiri', 'BUSHIRI', 'DF', 15, '1999-10-30', 26, 'Hibernian', 24, 1);
INSERT INTO public.players VALUES (595, 38, 'Samuel Moutoussamy', 'MOUTOUSSAMY', 'MF', 8, '1996-08-12', 29, 'Nantes', 28, 2);
INSERT INTO public.players VALUES (596, 38, 'Charles Pickel', 'PICKEL', 'MF', 6, '1997-05-15', 29, 'Cremonese', 24, 1);
INSERT INTO public.players VALUES (597, 38, 'Edo Kayembe', 'KAYEMBE', 'MF', 13, '1998-03-10', 28, 'Watford', 32, 2);
INSERT INTO public.players VALUES (598, 38, 'Théo Bongonda', 'BONGONDA', 'FW', 11, '1995-11-20', 30, 'Spartak Moscow', 42, 12);
INSERT INTO public.players VALUES (599, 38, 'Cédric Bakambu', 'BAKAMBU', 'FW', 9, '1991-04-11', 35, 'Real Betis', 68, 28);
INSERT INTO public.players VALUES (600, 38, 'Yoane Wissa', 'WISSA', 'FW', 10, '1996-09-03', 29, 'Brentford', 28, 9);
INSERT INTO public.players VALUES (601, 38, 'Silas Katompa', 'SILAS', 'FW', 7, '1998-10-06', 27, 'VfB Stuttgart', 24, 6);
INSERT INTO public.players VALUES (602, 38, 'Meschack Elia', 'ELIA', 'FW', 17, '1997-08-06', 28, 'Young Boys', 38, 8);
INSERT INTO public.players VALUES (603, 44, 'Bart Verbruggen', 'VERBRUGGEN', 'GK', 1, '2002-08-18', 23, 'Brighton', 32, 0);
INSERT INTO public.players VALUES (604, 44, 'Mark Flekken', 'FLEKKEN', 'GK', 13, '1993-06-13', 32, 'Bayer Leverkusen', 18, 0);
INSERT INTO public.players VALUES (605, 44, 'Denzel Dumfries', 'DUMFRIES', 'DF', 22, '1996-04-18', 30, 'Inter Milan', 58, 10);
INSERT INTO public.players VALUES (606, 44, 'Virgil van Dijk', 'VAN DIJK', 'DF', 4, '1991-07-08', 34, 'Liverpool', 88, 10);
INSERT INTO public.players VALUES (607, 44, 'Stefan de Vrij', 'DE VRIJ', 'DF', 3, '1992-02-05', 34, 'Inter Milan', 72, 3);
INSERT INTO public.players VALUES (608, 44, 'Nathan Aké', 'AKÉ', 'DF', 5, '1995-02-18', 31, 'Manchester City', 42, 2);
INSERT INTO public.players VALUES (609, 44, 'Lutsharel Geertruida', 'GEERTRUIDA', 'DF', 2, '2000-07-18', 25, 'RB Leipzig', 18, 1);
INSERT INTO public.players VALUES (610, 44, 'Frenkie de Jong', 'DE JONG', 'MF', 21, '1997-05-12', 29, 'FC Barcelona', 72, 8);
INSERT INTO public.players VALUES (611, 44, 'Tijjani Reijnders', 'REIJNDERS', 'MF', 14, '1998-07-29', 27, 'Manchester City', 28, 3);
INSERT INTO public.players VALUES (612, 44, 'Ryan Gravenberch', 'GRAVENBERCH', 'MF', 8, '2002-05-16', 24, 'Liverpool', 24, 2);
INSERT INTO public.players VALUES (613, 44, 'Xavi Simons', 'X. SIMONS', 'MF', 7, '2003-04-21', 23, 'RB Leipzig', 42, 12);
INSERT INTO public.players VALUES (614, 44, 'Cody Gakpo', 'GAKPO', 'FW', 11, '1999-05-07', 27, 'Liverpool', 52, 24);
INSERT INTO public.players VALUES (615, 44, 'Memphis Depay', 'DEPAY', 'FW', 10, '1994-02-13', 32, 'Corinthians', 90, 44);
INSERT INTO public.players VALUES (616, 44, 'Donyell Malen', 'MALEN', 'FW', 6, '1999-01-19', 27, 'Aston Villa', 42, 11);
INSERT INTO public.players VALUES (617, 44, 'Wout Weghorst', 'WEGHORST', 'FW', 19, '1992-08-07', 33, 'Ajax', 42, 14);
INSERT INTO public.players VALUES (618, 42, 'Sergio Rochet', 'ROCHET', 'GK', 1, '1993-03-23', 33, 'Internacional', 55, 0);
INSERT INTO public.players VALUES (619, 42, 'Franco Israel', 'ISRAEL', 'GK', 12, '2000-04-22', 26, 'Sporting CP', 12, 0);
INSERT INTO public.players VALUES (620, 42, 'Nahitan Nández', 'NÁNDEZ', 'DF', 17, '1995-12-28', 30, 'Al-Qadsiah', 78, 2);
INSERT INTO public.players VALUES (621, 42, 'José María Giménez', 'J.M. GIMÉNEZ', 'DF', 2, '1995-01-20', 31, 'Atletico Madrid', 78, 5);
INSERT INTO public.players VALUES (622, 42, 'Ronald Araújo', 'ARAÚJO', 'DF', 4, '1999-03-07', 27, 'FC Barcelona', 42, 2);
INSERT INTO public.players VALUES (623, 42, 'Sebastián Cáceres', 'CÁCERES', 'DF', 22, '1999-08-18', 26, 'Club América', 28, 1);
INSERT INTO public.players VALUES (624, 42, 'Mathías Olivera', 'OLIVERA', 'DF', 3, '1997-10-31', 28, 'Napoli', 38, 1);
INSERT INTO public.players VALUES (625, 42, 'Federico Valverde', 'VALVERDE', 'MF', 15, '1998-07-22', 27, 'Real Madrid', 72, 14);
INSERT INTO public.players VALUES (626, 42, 'Manuel Ugarte', 'UGARTE', 'MF', 5, '2001-04-11', 25, 'Manchester United', 32, 1);
INSERT INTO public.players VALUES (627, 42, 'Rodrigo Bentancur', 'BENTANCUR', 'MF', 6, '1997-06-25', 28, 'Tottenham Hotspur', 68, 8);
INSERT INTO public.players VALUES (628, 42, 'Nicolás De La Cruz', 'DE LA CRUZ', 'MF', 10, '1997-06-01', 29, 'Flamengo', 42, 5);
INSERT INTO public.players VALUES (629, 42, 'Darwin Núñez', 'D. NÚÑEZ', 'FW', 9, '1999-06-24', 26, 'Liverpool', 58, 24);
INSERT INTO public.players VALUES (630, 42, 'Federico Viñas', 'VIÑAS', 'FW', 19, '1998-11-30', 27, 'León', 18, 5);
INSERT INTO public.players VALUES (631, 42, 'Maximiliano Araújo', 'M. ARAÚJO', 'FW', 11, '2000-05-09', 26, 'Toluca', 24, 4);
INSERT INTO public.players VALUES (632, 42, 'Facundo Pellistri', 'PELLISTRI', 'FW', 7, '2001-12-20', 24, 'Panathinaikos', 28, 3);
INSERT INTO public.players VALUES (633, 43, 'Patrick Pentz', 'PENTZ', 'GK', 1, '1997-01-02', 29, 'Brøndby', 32, 0);
INSERT INTO public.players VALUES (634, 43, 'Niklas Hedl', 'HEDL', 'GK', 12, '2001-03-23', 25, 'Rapid Wien', 12, 0);
INSERT INTO public.players VALUES (635, 43, 'Stefan Posch', 'POSCH', 'DF', 4, '1997-05-14', 29, 'Bologna', 42, 4);
INSERT INTO public.players VALUES (636, 43, 'Kevin Danso', 'DANSO', 'DF', 3, '1998-09-19', 27, 'Tottenham Hotspur', 38, 2);
INSERT INTO public.players VALUES (637, 43, 'Maximilian Wöber', 'WÖBER', 'DF', 5, '1998-02-04', 28, 'Borussia M.gladbach', 32, 1);
INSERT INTO public.players VALUES (638, 43, 'Philipp Mwene', 'MWENE', 'DF', 13, '1994-01-29', 32, 'Mainz 05', 28, 1);
INSERT INTO public.players VALUES (639, 43, 'Phillipp Lienhart', 'LIENHART', 'DF', 15, '1996-07-11', 29, 'SC Freiburg', 32, 2);
INSERT INTO public.players VALUES (640, 43, 'Konrad Laimer', 'LAIMER', 'MF', 6, '1997-05-27', 29, 'Bayern Munich', 52, 8);
INSERT INTO public.players VALUES (641, 43, 'Nicolas Seiwald', 'SEIWALD', 'MF', 14, '2001-05-04', 25, 'RB Leipzig', 28, 1);
INSERT INTO public.players VALUES (642, 43, 'Marcel Sabitzer', 'SABITZER', 'MF', 9, '1994-03-17', 32, 'Borussia Dortmund', 78, 22);
INSERT INTO public.players VALUES (643, 43, 'Christoph Baumgartner', 'BAUMGARTNER', 'MF', 19, '1999-08-01', 26, 'RB Leipzig', 42, 12);
INSERT INTO public.players VALUES (644, 43, 'Marko Arnautović', 'ARNAUTOVIĆ', 'FW', 7, '1989-04-19', 37, 'Inter Milan', 110, 34);
INSERT INTO public.players VALUES (645, 43, 'Michael Gregoritsch', 'GREGORITSCH', 'FW', 11, '1994-04-18', 32, 'SC Freiburg', 48, 13);
INSERT INTO public.players VALUES (646, 43, 'Patrick Wimmer', 'WIMMER', 'FW', 16, '2001-05-30', 25, 'VfL Wolfsburg', 24, 4);
INSERT INTO public.players VALUES (648, 43, 'Romano Schmid', 'SCHMID', 'MF', 20, '2000-01-27', 26, 'Werder Bremen', 24, 3);
INSERT INTO public.players VALUES (649, 41, 'Jalal Hassan', 'J. HASSAN', 'GK', 1, '1993-08-10', 32, 'Al-Shorta', 52, 0);
INSERT INTO public.players VALUES (650, 41, 'Ahmad Basil', 'A. BASIL', 'GK', 22, '1998-04-12', 28, 'Al-Quwa Al-Jawiya', 18, 0);
INSERT INTO public.players VALUES (651, 41, 'Merchas Doski', 'DOSKI', 'DF', 2, '2000-01-09', 26, 'Al-Talaba', 24, 1);
INSERT INTO public.players VALUES (652, 41, 'Rebin Sulaka', 'SULAKA', 'DF', 5, '1996-09-22', 29, 'PAS Giannina', 38, 2);
INSERT INTO public.players VALUES (653, 41, 'Akam Hashim', 'HASHIM', 'DF', 3, '1999-04-15', 27, 'Al-Shorta', 28, 1);
INSERT INTO public.players VALUES (654, 41, 'Hussein Ali', 'H. ALI', 'DF', 13, '2001-06-20', 24, 'Al-Zawraa', 24, 0);
INSERT INTO public.players VALUES (655, 41, 'Ali Adnan', 'ALI ADNAN', 'DF', 17, '1993-12-19', 32, 'Al-Shorta', 80, 6);
INSERT INTO public.players VALUES (656, 41, 'Amir Al-Ammari', 'AL-AMMARI', 'MF', 6, '1997-09-27', 28, 'Halmstad', 32, 4);
INSERT INTO public.players VALUES (657, 41, 'Ibrahim Bayesh', 'BAYESH', 'MF', 8, '1996-04-08', 30, 'Al-Quwa Al-Jawiya', 38, 5);
INSERT INTO public.players VALUES (658, 41, 'Bashar Resan', 'RESAN', 'MF', 10, '1996-12-22', 29, 'Al-Gharafa', 48, 6);
INSERT INTO public.players VALUES (659, 41, 'Zidane Iqbal', 'IQBAL', 'MF', 14, '2003-04-27', 23, 'Utrecht', 18, 1);
INSERT INTO public.players VALUES (660, 41, 'Aymen Hussein', 'A. HUSSEIN', 'FW', 9, '1996-05-22', 30, 'Al-Quwa Al-Jawiya', 62, 22);
INSERT INTO public.players VALUES (661, 41, 'Mohanad Ali', 'M. ALI', 'FW', 11, '2000-06-20', 25, 'Al-Shorta', 38, 12);
INSERT INTO public.players VALUES (662, 41, 'Ali Al-Hamadi', 'AL-HAMADI', 'FW', 19, '2002-03-01', 24, 'Ipswich Town', 18, 5);
INSERT INTO public.players VALUES (663, 41, 'Alaa Abbas', 'ABBAS', 'FW', 20, '1998-08-14', 27, 'Al-Karkh', 24, 6);
INSERT INTO public.players VALUES (679, 46, 'Kim Seung-gyu', 'KIM S.G.', 'GK', 1, '1990-09-30', 35, 'Al-Shabab', 72, 0);
INSERT INTO public.players VALUES (680, 46, 'Jo Hyeon-woo', 'JO H.W.', 'GK', 21, '1991-09-25', 34, 'Ulsan HD', 42, 0);
INSERT INTO public.players VALUES (681, 46, 'Kim Min-jae', 'KIM M.J.', 'DF', 4, '1996-11-15', 29, 'Bayern Munich', 72, 5);
INSERT INTO public.players VALUES (682, 46, 'Kim Young-gwon', 'KIM Y.G.', 'DF', 19, '1990-02-27', 36, 'Ulsan HD', 98, 6);
INSERT INTO public.players VALUES (683, 46, 'Kim Ji-soo', 'KIM J.S.', 'DF', 20, '2004-12-24', 21, 'Newcastle United', 14, 0);
INSERT INTO public.players VALUES (684, 46, 'Kim Tae-hwan', 'KIM T.H.', 'DF', 2, '1989-07-24', 36, 'Ulsan HD', 38, 1);
INSERT INTO public.players VALUES (685, 46, 'Lee Ki-je', 'LEE K.J.', 'DF', 12, '1991-07-09', 34, 'Suwon FC', 32, 1);
INSERT INTO public.players VALUES (686, 46, 'Hwang In-beom', 'HWANG I.B.', 'MF', 6, '1996-09-20', 29, 'Feyenoord', 68, 8);
INSERT INTO public.players VALUES (687, 46, 'Lee Jae-sung', 'LEE J.S.', 'MF', 10, '1992-08-10', 33, 'Mainz 05', 82, 12);
INSERT INTO public.players VALUES (688, 46, 'Park Yong-woo', 'PARK Y.W.', 'MF', 16, '1993-09-10', 32, 'Al-Ain', 38, 1);
INSERT INTO public.players VALUES (689, 46, 'Lee Kang-in', 'LEE K.I.', 'MF', 18, '2001-02-19', 25, 'PSG', 42, 8);
INSERT INTO public.players VALUES (690, 46, 'Son Heung-min', 'SON', 'FW', 7, '1992-07-08', 33, 'LAFC', 126, 50);
INSERT INTO public.players VALUES (691, 46, 'Hwang Hee-chan', 'HWANG H.C.', 'FW', 11, '1996-01-26', 30, 'Wolverhampton', 68, 22);
INSERT INTO public.players VALUES (692, 46, 'Cho Gue-sung', 'CHO G.S.', 'FW', 9, '1998-01-25', 28, 'FC Midtjylland', 38, 14);
INSERT INTO public.players VALUES (693, 46, 'Oh Hyeon-gyu', 'OH H.G.', 'FW', 22, '2001-04-12', 25, 'Genk', 24, 6);
INSERT INTO public.players VALUES (694, 47, 'Angus Gunn', 'GUNN', 'GK', 1, '1996-01-22', 30, 'Nottingham Forest', 32, 0);
INSERT INTO public.players VALUES (695, 47, 'Craig Gordon', 'GORDON', 'GK', 12, '1982-12-31', 43, 'Hearts', 78, 0);
INSERT INTO public.players VALUES (696, 47, 'Andrew Robertson', 'ROBERTSON', 'DF', 3, '1994-03-11', 32, 'Liverpool', 80, 4);
INSERT INTO public.players VALUES (697, 47, 'Kieran Tierney', 'TIERNEY', 'DF', 6, '1997-06-05', 29, 'Celtic', 48, 1);
INSERT INTO public.players VALUES (698, 47, 'Jack Hendry', 'HENDRY', 'DF', 5, '1995-05-07', 31, 'Al-Ettifaq', 38, 2);
INSERT INTO public.players VALUES (699, 47, 'Grant Hanley', 'HANLEY', 'DF', 4, '1991-11-20', 34, 'Birmingham City', 58, 1);
INSERT INTO public.players VALUES (700, 47, 'Anthony Ralston', 'RALSTON', 'DF', 2, '1998-11-16', 27, 'Celtic', 24, 1);
INSERT INTO public.players VALUES (701, 47, 'John McGinn', 'MCGINN', 'MF', 7, '1994-10-18', 31, 'Aston Villa', 82, 22);
INSERT INTO public.players VALUES (702, 47, 'Billy Gilmour', 'GILMOUR', 'MF', 8, '2001-06-11', 25, 'Napoli', 38, 1);
INSERT INTO public.players VALUES (703, 47, 'Scott McTominay', 'MCTOMINAY', 'MF', 9, '1996-12-08', 29, 'Napoli', 65, 16);
INSERT INTO public.players VALUES (704, 47, 'Ryan Christie', 'CHRISTIE', 'MF', 14, '1995-02-22', 31, 'Bournemouth', 48, 5);
INSERT INTO public.players VALUES (705, 47, 'Che Adams', 'ADAMS', 'FW', 10, '1996-07-13', 29, 'Torino', 32, 7);
INSERT INTO public.players VALUES (706, 47, 'Lyndon Dykes', 'DYKES', 'FW', 18, '1995-10-07', 30, 'Birmingham City', 42, 11);
INSERT INTO public.players VALUES (707, 47, 'Lawrence Shankland', 'SHANKLAND', 'FW', 9, '1995-08-10', 30, 'Hearts', 28, 6);
INSERT INTO public.players VALUES (708, 47, 'Ben Doak', 'DOAK', 'FW', 11, '2005-11-11', 20, 'Liverpool', 14, 2);
INSERT INTO public.players VALUES (709, 45, 'Utkir Yusupov', 'YUSUPOV', 'GK', 1, '1995-03-13', 31, 'Pakhtakor', 32, 0);
INSERT INTO public.players VALUES (710, 45, 'Abduvohid Nematov', 'NEMATOV', 'GK', 12, '1998-07-21', 27, 'Navbahor', 12, 0);
INSERT INTO public.players VALUES (711, 45, 'Abdukodir Khusanov', 'KHUSANOV', 'DF', 4, '2004-02-29', 22, 'Manchester City', 18, 1);
INSERT INTO public.players VALUES (712, 45, 'Rustamjon Ashurmatov', 'ASHURMATOV', 'DF', 5, '1996-07-07', 29, 'Buriram United', 48, 2);
INSERT INTO public.players VALUES (713, 45, 'Farrukh Sayfiev', 'SAYFIEV', 'DF', 2, '1997-02-15', 29, 'Pakhtakor', 38, 1);
INSERT INTO public.players VALUES (714, 45, 'Sherzod Nasrullaev', 'NASRULLAEV', 'DF', 3, '1999-11-08', 26, 'Nasaf', 28, 0);
INSERT INTO public.players VALUES (715, 45, 'Abbosbek Fayzullaev', 'FAYZULLAEV', 'MF', 10, '2003-09-23', 22, 'CSKA Moscow', 28, 5);
INSERT INTO public.players VALUES (716, 45, 'Jaloliddin Masharipov', 'MASHARIPOV', 'MF', 7, '1993-04-20', 33, 'Pakhtakor', 85, 20);
INSERT INTO public.players VALUES (717, 45, 'Otabek Shukurov', 'SHUKUROV', 'MF', 6, '1996-07-22', 29, 'Al-Wakrah', 58, 4);
INSERT INTO public.players VALUES (718, 45, 'Jasurbek Jaloliddinov', 'JALOLIDDINOV', 'MF', 8, '2002-01-16', 24, 'Lokomotiv Tashkent', 24, 3);
INSERT INTO public.players VALUES (719, 45, 'Oston Urunov', 'URUNOV', 'MF', 14, '2000-12-19', 25, 'Pakhtakor', 32, 6);
INSERT INTO public.players VALUES (720, 45, 'Eldor Shomurodov', 'SHOMURODOV', 'FW', 9, '1995-06-29', 30, 'AS Roma', 72, 30);
INSERT INTO public.players VALUES (721, 45, 'Igor Sergeev', 'SERGEEV', 'FW', 11, '1993-04-23', 33, 'Pakhtakor', 62, 18);
INSERT INTO public.players VALUES (722, 45, 'Khojimat Erkinov', 'ERKINOV', 'FW', 17, '1998-03-25', 28, 'Pakhtakor', 38, 9);
INSERT INTO public.players VALUES (723, 45, 'Jasurbek Yakhshiboev', 'YAKHSHIBOEV', 'FW', 19, '1997-12-16', 28, 'Sheriff Tiraspol', 28, 7);


--
-- Name: players_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.players_id_seq', 723, true);


--
-- Name: players players_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_pkey PRIMARY KEY (id);


--
-- Name: idx_players_team; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_players_team ON public.players USING btree (team_id);


--
-- Name: players players_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- PostgreSQL database dump complete
--

\unrestrict NZwZ0NZwTRRD0xDNgz0uceYbFUgyJ76oBFmtpmOvbbTAqbOdgLe9JjvKrOncSBQ

