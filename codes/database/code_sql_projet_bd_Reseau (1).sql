--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2024-11-22 18:15:52

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 16499)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 16585)
-- Name: admindiscipline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admindiscipline (
    idadmindisc character varying(11) NOT NULL,
    datedattributiondisc date NOT NULL,
    idcontratdisc character varying(20) NOT NULL
);


ALTER TABLE public.admindiscipline OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16609)
-- Name: adminevenement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adminevenement (
    idadmineve character varying(11) NOT NULL,
    datedattributioneve date NOT NULL,
    idcontrateve character varying(20) NOT NULL,
    CONSTRAINT datedattributioneve_check CHECK (((datedattributioneve >= '1975-01-01'::date) AND (datedattributioneve <= CURRENT_DATE))),
    CONSTRAINT idadmineve_check CHECK (((idadmineve)::text ~ '^[A-Za-z0-9]+$'::text))
);


ALTER TABLE public.adminevenement OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16566)
-- Name: administrateur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.administrateur (
    idadministrateur character varying(11) NOT NULL,
    nomadmin character varying(30) NOT NULL,
    prenomadmin character varying(30) NOT NULL,
    emailadmin character varying(260) NOT NULL,
    typeadmin character varying(60) NOT NULL,
    motdepasse text NOT NULL
);


ALTER TABLE public.administrateur OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16659)
-- Name: discipline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discipline (
    iddiscipline character varying(11) NOT NULL,
    nomdiscipline character varying(30) NOT NULL,
    lieudiscipline character varying(300) NOT NULL,
    CONSTRAINT discip2 CHECK (((nomdiscipline)::text ~ '^[a-zA-Z]+$'::text)),
    CONSTRAINT discip3 CHECK (((lieudiscipline)::text ~ '^[a-zA-Z0-9 ]+$'::text)),
    CONSTRAINT iddiscip CHECK (((iddiscipline)::text ~ '^[a-zA-Z0-9]+$'::text))
);


ALTER TABLE public.discipline OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16699)
-- Name: evenement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.evenement (
    idevenement character varying(11) NOT NULL,
    nomevenement character varying(200) NOT NULL,
    dateevenement date NOT NULL,
    heureevenement time without time zone NOT NULL,
    heurefinevenement time without time zone NOT NULL,
    capacitemax integer NOT NULL,
    iddiscipline character varying(11) NOT NULL,
    CONSTRAINT alphanum1_eve CHECK (((idevenement)::text ~ '^[a-zA-Z0-9]+$'::text)),
    CONSTRAINT aplhanum3_eve CHECK (((iddiscipline)::text ~ '^[a-zA-Z0-9]+$'::text)),
    CONSTRAINT capacitemax CHECK ((capacitemax > 0))
);


ALTER TABLE public.evenement OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16795)
-- Name: gere; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gere (
    idadmineve character varying(11) NOT NULL,
    idevenement character varying(11) NOT NULL,
    CONSTRAINT alphanum1_gere CHECK (((idadmineve)::text ~ '^[a-zA-Z0-9]+$'::text)),
    CONSTRAINT alphanum2_gere CHECK (((idevenement)::text ~ '^[a-zA-Z0-9]+$'::text))
);


ALTER TABLE public.gere OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16766)
-- Name: peutetrescanne; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.peutetrescanne (
    idticket character varying(11) NOT NULL,
    idscanner character varying(11) NOT NULL,
    CONSTRAINT check_idscanner CHECK (((idscanner)::text ~ '^[a-zA-Z0-9]+$'::text)),
    CONSTRAINT check_idticket CHECK (((idticket)::text ~ '^[a-zA-Z0-9]+$'::text))
);


ALTER TABLE public.peutetrescanne OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16716)
-- Name: place; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.place (
    idplace character varying(11) NOT NULL,
    numeroplace character varying(10) NOT NULL,
    idevenement character varying(11) NOT NULL,
    idzone character varying(11) NOT NULL,
    typeplace character varying(20) NOT NULL,
    CONSTRAINT idplace_check CHECK (((idplace)::text ~ '^[a-zA-Z0-9]+$'::text))
);


ALTER TABLE public.place OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16667)
-- Name: responsablede; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.responsablede (
    idadmindisc character varying(11) NOT NULL,
    iddiscipline character varying(11) NOT NULL,
    CONSTRAINT aplhanum_re2 CHECK (((iddiscipline)::text ~ '^[a-zA-Z0-9]+$'::text)),
    CONSTRAINT aplhanum_res1 CHECK (((idadmindisc)::text ~ '^[a-zA-Z0-9]+$'::text))
);


ALTER TABLE public.responsablede OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16642)
-- Name: scanner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scanner (
    idscanner character varying(11) NOT NULL,
    emplacement character varying(250) NOT NULL,
    modelescanner character varying(50) NOT NULL,
    CONSTRAINT emplacement_contrainte CHECK (((emplacement)::text ~ '^[a-zA-Z0-9 ]+$'::text)),
    CONSTRAINT scan1 CHECK (((idscanner)::text ~ '^[a-zA-Z0-9]+$'::text))
);


ALTER TABLE public.scanner OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16633)
-- Name: spectateur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.spectateur (
    idspectateur character varying(11) NOT NULL,
    nomspectateur character varying(30) NOT NULL,
    prenomspectateur character varying(30) NOT NULL,
    emailspectateur character varying(260) NOT NULL,
    CONSTRAINT alphab_prenomspec CHECK (((prenomspectateur)::text ~ '^[a-zA-Z]+$'::text)),
    CONSTRAINT alphanu_id CHECK (((idspectateur)::text ~ '^[a-zA-Z0-9]+$'::text)),
    CONSTRAINT aplhab_nomspec CHECK (((nomspectateur)::text ~ '^[a-zA-Z]+$'::text))
);


ALTER TABLE public.spectateur OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16742)
-- Name: ticket; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ticket (
    idticket character varying(11) NOT NULL,
    dateachat date NOT NULL,
    idevenement character varying(11),
    idspectateur character varying(11) NOT NULL,
    prixticket real NOT NULL,
    CONSTRAINT idevenement_check CHECK (((idevenement)::text ~ '^[a-zA-Z0-9]+$'::text)),
    CONSTRAINT idspectateur_check CHECK (((idspectateur)::text ~ '^[a-zA-Z0-9]+$'::text)),
    CONSTRAINT idticket_check CHECK (((idticket)::text ~ '^[a-zA-Z0-9]+$'::text))
);


ALTER TABLE public.ticket OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16783)
-- Name: ticketvalide; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ticketvalide (
    idlogscan character varying(11) NOT NULL,
    heurescan timestamp without time zone NOT NULL,
    id_ticket_valide character varying(11) NOT NULL,
    idscanner character varying(11) NOT NULL,
    CONSTRAINT idlogscan CHECK (((idlogscan)::text ~ '^[a-zA-Z0-9]+$'::text))
);


ALTER TABLE public.ticketvalide OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16649)
-- Name: zone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.zone (
    idzone character varying(11) NOT NULL,
    nomzone character varying(300) NOT NULL,
    capacitezone integer NOT NULL,
    CONSTRAINT idzone_check CHECK (((idzone)::text ~ '^[a-zA-Z0-9]+$'::text))
);


ALTER TABLE public.zone OWNER TO postgres;

--
-- TOC entry 5005 (class 0 OID 16585)
-- Dependencies: 217
-- Data for Name: admindiscipline; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admindiscipline (idadmindisc, datedattributiondisc, idcontratdisc) FROM stdin;
ADM001	2024-01-15	CT1-2024-02-01
ADM002	2024-01-20	CT2-2024-05-12
\.


--
-- TOC entry 5006 (class 0 OID 16609)
-- Dependencies: 218
-- Data for Name: adminevenement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adminevenement (idadmineve, datedattributioneve, idcontrateve) FROM stdin;
ADM003	2024-02-10	CT2-2024-10-11
ADM004	2024-02-12	CT9-2024-04-10
\.


--
-- TOC entry 5004 (class 0 OID 16566)
-- Dependencies: 216
-- Data for Name: administrateur; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.administrateur (idadministrateur, nomadmin, prenomadmin, emailadmin, typeadmin, motdepasse) FROM stdin;
ADM004	LAMARI	Azzeddine	Azzeddine.lamari@gmail.com	adminevenement	gAAAAABnHM2GtGm1WmY96j77eyDd3H9Y_effrNIo1eAjRdoG1J7AxJ9MpjKDhcFukqcVt2V3TaN-o1KrAMKcnj_Nu6zWmNzKxw==
ADM003	BOUKILI	Inas	inas.boukili@gmail.com	adminevenement	gAAAAABnHM1eno3EwqwhdjACO9xumJzQ17JM9sLhPNt_Yq9T0moMcSldBZaX5I9LnXg8hjGTvCV-7NtpW_PQKbYTQU8Jkl5evw==
ADM002	OFFIONG	Dara	dara.offiang@gmail.com	admindiscipline	gAAAAABnHMz4Tl3AkN8Mfcs3j17L0m-7_g-YsxL_YXDk0HdNaIFC9eodybrj_6wLkrGrfZ6UF5-og9Zm9QmfVCdtRNwjcs_NJQ==
ADM001	DUPONT	Jean	jean.dupont@gmail.com	admindiscipline	gAAAAABnHMx6VVq6PISzlsKvooBvrOgeoj6fudzFa1rT3Po9SjhDVqDMQ972OkEYF_0zAvCn1AuR9eWbcxRBKpGn-O3C96t2qQ==
\.


--
-- TOC entry 5010 (class 0 OID 16659)
-- Dependencies: 222
-- Data for Name: discipline; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discipline (iddiscipline, nomdiscipline, lieudiscipline) FROM stdin;
DISC001	Football	Stade de France
DISC002	Basketball	Accor Arena
DISC003	Tennis	Stade Roland Garros
\.


--
-- TOC entry 5012 (class 0 OID 16699)
-- Dependencies: 224
-- Data for Name: evenement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.evenement (idevenement, nomevenement, dateevenement, heureevenement, heurefinevenement, capacitemax, iddiscipline) FROM stdin;
EVE002	Chicago Bulls vs Detroit Pistons	2024-10-15	21:00:00	23:00:00	20000	DISC002
EVE003	Djokovic vs Nadal	2025-01-01	19:30:00	23:00:00	15000	DISC003
EVE001	France vs Belgique	2024-11-15	19:00:00	21:00:00	70000	DISC001
\.


--
-- TOC entry 5017 (class 0 OID 16795)
-- Dependencies: 229
-- Data for Name: gere; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gere (idadmineve, idevenement) FROM stdin;
ADM003	EVE001
ADM004	EVE002
ADM004	EVE003
\.


--
-- TOC entry 5015 (class 0 OID 16766)
-- Dependencies: 227
-- Data for Name: peutetrescanne; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.peutetrescanne (idticket, idscanner) FROM stdin;
TCK003	SCN003
TCK001	SCN001
\.


--
-- TOC entry 5013 (class 0 OID 16716)
-- Dependencies: 225
-- Data for Name: place; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.place (idplace, numeroplace, idevenement, idzone, typeplace) FROM stdin;
PLC001	A1	EVE001	Z001	VIP
PLC002	A2	EVE002	Z002	Normale
PLC003	A3	EVE003	Z003	Handicapee
\.


--
-- TOC entry 5011 (class 0 OID 16667)
-- Dependencies: 223
-- Data for Name: responsablede; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.responsablede (idadmindisc, iddiscipline) FROM stdin;
ADM001	DISC001
ADM002	DISC002
ADM002	DISC003
\.


--
-- TOC entry 5008 (class 0 OID 16642)
-- Dependencies: 220
-- Data for Name: scanner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scanner (idscanner, emplacement, modelescanner) FROM stdin;
SCN003	Stade Roland Garros Tribune C	Honeywell Voyager 1202g
SCN002	Accor Arena Tribune VIP	Ingenico iPP350
SCN001	Stade de France Tribune A	Zebra DS2208
\.


--
-- TOC entry 5007 (class 0 OID 16633)
-- Dependencies: 219
-- Data for Name: spectateur; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spectateur (idspectateur, nomspectateur, prenomspectateur, emailspectateur) FROM stdin;
SP001	Durand	Marc	marc.durand@gmail.com
SP002	Leblanc	Sophie	sophie.leblanc@gmail.com
SP003	Owens	Frank	frank.owens@gmail.com
\.


--
-- TOC entry 5014 (class 0 OID 16742)
-- Dependencies: 226
-- Data for Name: ticket; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ticket (idticket, dateachat, idevenement, idspectateur, prixticket) FROM stdin;
TCK001	2024-10-30	EVE001	SP001	150.5
TCK002	2024-09-16	EVE002	SP002	90
TCK003	2024-12-01	EVE003	SP003	120.9
\.


--
-- TOC entry 5016 (class 0 OID 16783)
-- Dependencies: 228
-- Data for Name: ticketvalide; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ticketvalide (idlogscan, heurescan, id_ticket_valide, idscanner) FROM stdin;
LOG001	2024-10-27 14:54:54	TCK003	SCN003
\.


--
-- TOC entry 5009 (class 0 OID 16649)
-- Dependencies: 221
-- Data for Name: zone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.zone (idzone, nomzone, capacitezone) FROM stdin;
Z001	Stade de France Tribune A	20000
Z002	Accor Arena Tribune VIP	3000
Z003	Stade Roland Garros Tribune C	1000
\.


--
-- TOC entry 4791 (class 2606 OID 17099)
-- Name: scanner ModeleScanner_contrainte; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.scanner
    ADD CONSTRAINT "ModeleScanner_contrainte" CHECK (((modelescanner)::text ~ '^[a-zA-Z0-9 ]+$'::text)) NOT VALID;


--
-- TOC entry 4823 (class 2606 OID 16592)
-- Name: admindiscipline admindiscipline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admindiscipline
    ADD CONSTRAINT admindiscipline_pkey PRIMARY KEY (idadmindisc);


--
-- TOC entry 4776 (class 2606 OID 16580)
-- Name: administrateur alphab1; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.administrateur
    ADD CONSTRAINT alphab1 CHECK (((nomadmin)::text ~ '^[a-zA-Z]+$'::text)) NOT VALID;


--
-- TOC entry 4777 (class 2606 OID 16581)
-- Name: administrateur alphab2; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.administrateur
    ADD CONSTRAINT alphab2 CHECK (((prenomadmin)::text ~ '^[a-zA-Z]+$'::text)) NOT VALID;


--
-- TOC entry 4778 (class 2606 OID 16578)
-- Name: administrateur alphanum1; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.administrateur
    ADD CONSTRAINT alphanum1 CHECK (((idadministrateur)::text ~ '^[a-zA-Z0-9]+$'::text)) NOT VALID;


--
-- TOC entry 4803 (class 2606 OID 16823)
-- Name: evenement alphanum2_eve; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.evenement
    ADD CONSTRAINT alphanum2_eve CHECK (((nomevenement)::text ~ '^[a-zA-Z0-9\s]+$'::text)) NOT VALID;


--
-- TOC entry 4782 (class 2606 OID 16593)
-- Name: admindiscipline alphanumid; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.admindiscipline
    ADD CONSTRAINT alphanumid CHECK (((idadmindisc)::text ~ '^[a-zA-Z0-9]+$'::text)) NOT VALID;


--
-- TOC entry 4794 (class 2606 OID 17117)
-- Name: zone capacitezone_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.zone
    ADD CONSTRAINT capacitezone_check CHECK (((capacitezone > 0) AND (capacitezone < 100000))) NOT VALID;


--
-- TOC entry 4806 (class 2606 OID 16827)
-- Name: evenement date; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.evenement
    ADD CONSTRAINT date CHECK ((dateevenement >= CURRENT_DATE)) NOT VALID;


--
-- TOC entry 4779 (class 2606 OID 16813)
-- Name: administrateur email; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.administrateur
    ADD CONSTRAINT email CHECK (((emailadmin)::text ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text)) NOT VALID;


--
-- TOC entry 4790 (class 2606 OID 16822)
-- Name: spectateur email_spect; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.spectateur
    ADD CONSTRAINT email_spect CHECK (((emailspectateur)::text ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,}$'::text)) NOT VALID;


--
-- TOC entry 4825 (class 2606 OID 16622)
-- Name: adminevenement idadmineve_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adminevenement
    ADD CONSTRAINT idadmineve_pk PRIMARY KEY (idadmineve);


--
-- TOC entry 4783 (class 2606 OID 17121)
-- Name: admindiscipline idcontratdisc; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.admindiscipline
    ADD CONSTRAINT idcontratdisc CHECK (((idcontratdisc)::text ~ '^[a-zA-Z0-9-]+$'::text)) NOT VALID;


--
-- TOC entry 4786 (class 2606 OID 17122)
-- Name: adminevenement idcontrateve_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.adminevenement
    ADD CONSTRAINT idcontrateve_check CHECK (((idcontrateve)::text ~ '^[a-zA-Z0-9-]+$'::text)) NOT VALID;


--
-- TOC entry 4841 (class 2606 OID 16724)
-- Name: place idplace_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.place
    ADD CONSTRAINT idplace_pk PRIMARY KEY (idplace);


--
-- TOC entry 4845 (class 2606 OID 16772)
-- Name: peutetrescanne idticket_idscanner_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.peutetrescanne
    ADD CONSTRAINT idticket_idscanner_pk PRIMARY KEY (idticket, idscanner);


--
-- TOC entry 4843 (class 2606 OID 16750)
-- Name: ticket idticket_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT idticket_pk PRIMARY KEY (idticket);


--
-- TOC entry 4831 (class 2606 OID 16656)
-- Name: zone idzone_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zone
    ADD CONSTRAINT idzone_pk PRIMARY KEY (idzone);


--
-- TOC entry 4819 (class 2606 OID 16577)
-- Name: administrateur mot_de_passe; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.administrateur
    ADD CONSTRAINT mot_de_passe UNIQUE (motdepasse);


--
-- TOC entry 4780 (class 2606 OID 16812)
-- Name: administrateur mot_de_passe_admin; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.administrateur
    ADD CONSTRAINT mot_de_passe_admin CHECK (((length(motdepasse) >= 8) AND (motdepasse ~ '.*[A-Za-z].*'::text) AND (motdepasse ~ '.*[0-9].*'::text) AND (motdepasse ~ '.*[=@#?!%&*].*'::text))) NOT VALID;


--
-- TOC entry 4796 (class 2606 OID 16821)
-- Name: zone nom_zone; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.zone
    ADD CONSTRAINT nom_zone CHECK (((nomzone)::text ~ '^[a-zA-Z0-9 ]+$'::text)) NOT VALID;


--
-- TOC entry 4833 (class 2606 OID 16819)
-- Name: zone nomzone_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zone
    ADD CONSTRAINT nomzone_unique UNIQUE (nomzone);


--
-- TOC entry 4829 (class 2606 OID 16648)
-- Name: scanner pk1_scann; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scanner
    ADD CONSTRAINT pk1_scann PRIMARY KEY (idscanner);


--
-- TOC entry 4821 (class 2606 OID 16596)
-- Name: administrateur pk_admin; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.administrateur
    ADD CONSTRAINT pk_admin PRIMARY KEY (idadministrateur);


--
-- TOC entry 4849 (class 2606 OID 16801)
-- Name: gere pk_composee_gere; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gere
    ADD CONSTRAINT pk_composee_gere PRIMARY KEY (idadmineve, idevenement);


--
-- TOC entry 4837 (class 2606 OID 16673)
-- Name: responsablede pk_composee_respo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.responsablede
    ADD CONSTRAINT pk_composee_respo PRIMARY KEY (idadmindisc, iddiscipline);


--
-- TOC entry 4839 (class 2606 OID 16710)
-- Name: evenement pk_evenem; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evenement
    ADD CONSTRAINT pk_evenem PRIMARY KEY (idevenement);


--
-- TOC entry 4827 (class 2606 OID 16641)
-- Name: spectateur pk_spectateur; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.spectateur
    ADD CONSTRAINT pk_spectateur PRIMARY KEY (idspectateur);


--
-- TOC entry 4835 (class 2606 OID 16666)
-- Name: discipline pkdiscip; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discipline
    ADD CONSTRAINT pkdiscip PRIMARY KEY (iddiscipline);


--
-- TOC entry 4847 (class 2606 OID 16789)
-- Name: ticketvalide pkidlogscan; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticketvalide
    ADD CONSTRAINT pkidlogscan PRIMARY KEY (idlogscan);


--
-- TOC entry 4812 (class 2606 OID 17111)
-- Name: ticket prixticket_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.ticket
    ADD CONSTRAINT prixticket_check CHECK ((prixticket > ((0)::numeric)::double precision)) NOT VALID;


--
-- TOC entry 4781 (class 2606 OID 16583)
-- Name: administrateur typeadmin; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.administrateur
    ADD CONSTRAINT typeadmin CHECK (((typeadmin)::text = ANY ((ARRAY['admindiscipline'::character varying, 'adminevenement'::character varying])::text[]))) NOT VALID;


--
-- TOC entry 4808 (class 2606 OID 17116)
-- Name: place typeplace; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.place
    ADD CONSTRAINT typeplace CHECK (((typeplace)::text = ANY (ARRAY[('VIP'::character varying)::text, ('Normale'::character varying)::text, ('Handicapee'::character varying)::text]))) NOT VALID;


--
-- TOC entry 4859 (class 2606 OID 16802)
-- Name: gere fh1_gere; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gere
    ADD CONSTRAINT fh1_gere FOREIGN KEY (idadmineve) REFERENCES public.adminevenement(idadmineve);


--
-- TOC entry 4852 (class 2606 OID 16674)
-- Name: responsablede fk1_resp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.responsablede
    ADD CONSTRAINT fk1_resp FOREIGN KEY (idadmindisc) REFERENCES public.admindiscipline(idadmindisc);


--
-- TOC entry 4860 (class 2606 OID 16807)
-- Name: gere fk2_gere; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gere
    ADD CONSTRAINT fk2_gere FOREIGN KEY (idevenement) REFERENCES public.evenement(idevenement);


--
-- TOC entry 4853 (class 2606 OID 16679)
-- Name: responsablede fk2_resp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.responsablede
    ADD CONSTRAINT fk2_resp FOREIGN KEY (iddiscipline) REFERENCES public.discipline(iddiscipline);


--
-- TOC entry 4854 (class 2606 OID 16711)
-- Name: evenement fk_evene; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evenement
    ADD CONSTRAINT fk_evene FOREIGN KEY (iddiscipline) REFERENCES public.discipline(iddiscipline);


--
-- TOC entry 4851 (class 2606 OID 16624)
-- Name: adminevenement fk_idadmin; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adminevenement
    ADD CONSTRAINT fk_idadmin FOREIGN KEY (idadmineve) REFERENCES public.administrateur(idadministrateur);


--
-- TOC entry 4855 (class 2606 OID 16751)
-- Name: ticket fk_idevenement; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT fk_idevenement FOREIGN KEY (idevenement) REFERENCES public.evenement(idevenement);


--
-- TOC entry 4857 (class 2606 OID 16778)
-- Name: peutetrescanne fk_idscanner; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.peutetrescanne
    ADD CONSTRAINT fk_idscanner FOREIGN KEY (idscanner) REFERENCES public.scanner(idscanner);


--
-- TOC entry 4856 (class 2606 OID 16756)
-- Name: ticket fk_idspectateur; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT fk_idspectateur FOREIGN KEY (idspectateur) REFERENCES public.spectateur(idspectateur);


--
-- TOC entry 4858 (class 2606 OID 16773)
-- Name: peutetrescanne fk_idticket; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.peutetrescanne
    ADD CONSTRAINT fk_idticket FOREIGN KEY (idticket) REFERENCES public.ticket(idticket);


--
-- TOC entry 4850 (class 2606 OID 16597)
-- Name: admindiscipline heritage; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admindiscipline
    ADD CONSTRAINT heritage FOREIGN KEY (idadmindisc) REFERENCES public.administrateur(idadministrateur) NOT VALID;


-- Completed on 2024-11-22 18:15:52

--
-- PostgreSQL database dump complete
--

