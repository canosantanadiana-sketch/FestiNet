--
-- PostgreSQL database dump
--

\restrict kjw8lVGYHP66pVvlxgtkdkOgVDMzEzkV4Skjr9foYhQWE24JF6EvHpXVRn44bh9

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-15 12:15:19

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
-- TOC entry 233 (class 1255 OID 16592)
-- Name: aceptar_solicitud(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.aceptar_solicitud(IN p_id_solicitud integer)
    LANGUAGE plpgsql
    AS $$
begin
update solicitudes
set estado ='Aceptada'
WHERE id_solicitud = p_id_solicitud;
END;
$$;


ALTER PROCEDURE public.aceptar_solicitud(IN p_id_solicitud integer) OWNER TO postgres;

--
-- TOC entry 234 (class 1255 OID 16593)
-- Name: media_resenas_artista(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.media_resenas_artista(artista_id integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    media NUMERIC;
BEGIN
    SELECT AVG(puntuacion)
    INTO media
    FROM resenias
    WHERE id_artista = artista_id;

    RETURN media;
END;
$$;


ALTER FUNCTION public.media_resenas_artista(artista_id integer) OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 16594)
-- Name: validar_fecha_evento(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validar_fecha_evento() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.fecha_evento < CURRENT_DATE THEN
        RAISE EXCEPTION 'No se pueden crear eventos en fechas pasadas';
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.validar_fecha_evento() OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 16595)
-- Name: validar_puntuacion(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validar_puntuacion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.puntuacion < 1 OR NEW.puntuacion > 5 THEN
        RAISE EXCEPTION 'La puntuacion debe estar entre 1 y 5';
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.validar_puntuacion() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 16596)
-- Name: artistas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artistas (
    id_artista integer NOT NULL,
    email character varying(100) NOT NULL,
    password_hash character varying(255) NOT NULL,
    genero_musical character varying(50) NOT NULL,
    nombre character varying(50),
    CONSTRAINT chk_genero_musical CHECK (((genero_musical)::text = ANY (ARRAY[('Pop'::character varying)::text, ('Rock'::character varying)::text, ('Electrónica'::character varying)::text, ('Urbano'::character varying)::text, ('Indie'::character varying)::text, ('Jazz'::character varying)::text])))
);


ALTER TABLE public.artistas OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16604)
-- Name: artistas_id_artista_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.artistas ALTER COLUMN id_artista ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.artistas_id_artista_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 221 (class 1259 OID 16605)
-- Name: eventos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eventos (
    id_evento integer NOT NULL,
    id_local integer NOT NULL,
    nombre_evento character varying(100) NOT NULL,
    fecha_evento date NOT NULL,
    hora_evento time without time zone NOT NULL,
    aforo integer,
    descripcion text,
    CONSTRAINT eventos_aforo_check CHECK ((aforo > 0))
);


ALTER TABLE public.eventos OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16616)
-- Name: eventos_id_evento_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.eventos_id_evento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.eventos_id_evento_seq OWNER TO postgres;

--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 222
-- Name: eventos_id_evento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.eventos_id_evento_seq OWNED BY public.eventos.id_evento;


--
-- TOC entry 223 (class 1259 OID 16617)
-- Name: imagenes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.imagenes (
    id_imagen integer NOT NULL,
    id_artista integer,
    id_local integer,
    ruta_imagen character varying(255) NOT NULL,
    fecha_subida timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.imagenes OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16623)
-- Name: imagenes_id_imagen_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.imagenes_id_imagen_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.imagenes_id_imagen_seq OWNER TO postgres;

--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 224
-- Name: imagenes_id_imagen_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.imagenes_id_imagen_seq OWNED BY public.imagenes.id_imagen;


--
-- TOC entry 225 (class 1259 OID 16624)
-- Name: locales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locales (
    id_local integer NOT NULL,
    email character varying(100) NOT NULL,
    password_hash character varying(255) NOT NULL,
    capacidad integer NOT NULL,
    nombre character varying(100),
    CONSTRAINT locales_capacidad_check CHECK ((capacidad > 20))
);


ALTER TABLE public.locales OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16632)
-- Name: locales_id_local_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.locales ALTER COLUMN id_local ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.locales_id_local_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 227 (class 1259 OID 16633)
-- Name: mensajes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mensajes (
    id_mensaje integer NOT NULL,
    id_artista integer NOT NULL,
    id_local integer NOT NULL,
    mensaje character varying(500) NOT NULL,
    fecha_envio timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.mensajes OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16643)
-- Name: mensajes_id_mensaje_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.mensajes ALTER COLUMN id_mensaje ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.mensajes_id_mensaje_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 229 (class 1259 OID 16644)
-- Name: resenias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resenias (
    id_resenia integer NOT NULL,
    id_artista integer NOT NULL,
    id_local integer NOT NULL,
    puntuacion integer NOT NULL,
    comentario character varying(200),
    fecha_resenia timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT resenias_puntuacion_check CHECK (((puntuacion >= 1) AND (puntuacion <= 10)))
);


ALTER TABLE public.resenias OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16653)
-- Name: resenias_id_resenia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.resenias ALTER COLUMN id_resenia ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.resenias_id_resenia_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 231 (class 1259 OID 16654)
-- Name: solicitudes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.solicitudes (
    id_solicitud integer NOT NULL,
    id_artista integer NOT NULL,
    id_local integer NOT NULL,
    fecha_solicitud timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado character varying(20) DEFAULT ''::character varying,
    mensaje text,
    id_evento integer,
    CONSTRAINT solicitudes_estado_check CHECK (((estado)::text = ANY (ARRAY[('Pendiente'::character varying)::text, ('Aceptada'::character varying)::text, ('Rechazada'::character varying)::text, (''::character varying)::text])))
);


ALTER TABLE public.solicitudes OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16665)
-- Name: solicitudes_id_solicitud_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.solicitudes ALTER COLUMN id_solicitud ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.solicitudes_id_solicitud_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 4890 (class 2604 OID 16666)
-- Name: eventos id_evento; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventos ALTER COLUMN id_evento SET DEFAULT nextval('public.eventos_id_evento_seq'::regclass);


--
-- TOC entry 4891 (class 2604 OID 16667)
-- Name: imagenes id_imagen; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagenes ALTER COLUMN id_imagen SET DEFAULT nextval('public.imagenes_id_imagen_seq'::regclass);


--
-- TOC entry 5079 (class 0 OID 16596)
-- Dependencies: 219
-- Data for Name: artistas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artistas (id_artista, email, password_hash, genero_musical, nombre) FROM stdin;
3	nova@festinet.com	hash1	Electrónica	DJ Nova
4	soles@festinet.com	hash2	Pop	Los Soles
5	rockfire@festinet.com	hash3	Rock	RockFire
6	urban@festinet.com	hash4	Urbano	Urban Beats
7	indie@festinet.com	hash5	Indie	Indie Waves
8	jazz@festinet.com	hash6	Jazz	Blue Jazz
9	yanblock@festinet.com	hash7	Urbano	Yan Block
10	grecas@festinet.com	hash8	Urbano	Grecas
11	kaseo@festinet.com	hash9	Urbano	Kase.O
\.


--
-- TOC entry 5081 (class 0 OID 16605)
-- Dependencies: 221
-- Data for Name: eventos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.eventos (id_evento, id_local, nombre_evento, fecha_evento, hora_evento, aforo, descripcion) FROM stdin;
3	22	Noche Urbana	2027-06-15	22:00:00	1200	Evento dedicado a la musica urbana.
\.


--
-- TOC entry 5083 (class 0 OID 16617)
-- Dependencies: 223
-- Data for Name: imagenes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.imagenes (id_imagen, id_artista, id_local, ruta_imagen, fecha_subida) FROM stdin;
2	9	\N	uploads/artistas/yanblock.jpg	2026-10-04 14:06:32.653311
\.


--
-- TOC entry 5085 (class 0 OID 16624)
-- Dependencies: 225
-- Data for Name: locales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locales (id_local, email, password_hash, capacidad, nombre) FROM stdin;
13	bro@festinet.com	hash1	2200	BRØ
14	santarita@festinet.com	hash2	1200	Santa Rita
15	cosanuestra@festinet.com	hash3	2000	Cosa Nuestra
16	towerpower@festinet.com	hash4	350	Tower-Power
17	estudiodance@festinet.com	hash5	500	Estudio.DANCE
18	golddisco@festinet.com	hash6	400	Gold.disco
19	velerosmartinez@festinet.com	hash7	50	Veleros Martínez
20	hzplus@festinet.com	hash8	900	HZ_plus
21	lorura13@festinet.com	hash9	200	Lorura13
22	monumento3@festinet.com	hash10	100	Monumento3
23	pbpub@festinet.com	hash11	250	PB_pub
\.


--
-- TOC entry 5087 (class 0 OID 16633)
-- Dependencies: 227
-- Data for Name: mensajes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mensajes (id_mensaje, id_artista, id_local, mensaje, fecha_envio) FROM stdin;
3	4	18	Hola, me interesa actuar en vuestro local.	2026-10-04 14:04:08.517212
\.


--
-- TOC entry 5089 (class 0 OID 16644)
-- Dependencies: 229
-- Data for Name: resenias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resenias (id_resenia, id_artista, id_local, puntuacion, comentario, fecha_resenia) FROM stdin;
1	8	20	5	Excelente organización y trato.	2026-10-04 14:04:50.998866
\.


--
-- TOC entry 5091 (class 0 OID 16654)
-- Dependencies: 231
-- Data for Name: solicitudes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.solicitudes (id_solicitud, id_artista, id_local, fecha_solicitud, estado, mensaje, id_evento) FROM stdin;
4	7	15	2026-10-03 12:05:46.239655	Pendiente		\N
5	8	18	2026-10-03 12:05:46.239655	Aceptada		\N
6	9	19	2026-10-03 12:05:46.239655	Rechazada		\N
\.


--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 220
-- Name: artistas_id_artista_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.artistas_id_artista_seq', 1, false);


--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 222
-- Name: eventos_id_evento_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.eventos_id_evento_seq', 3, true);


--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 224
-- Name: imagenes_id_imagen_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.imagenes_id_imagen_seq', 2, true);


--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 226
-- Name: locales_id_local_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.locales_id_local_seq', 23, true);


--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 228
-- Name: mensajes_id_mensaje_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mensajes_id_mensaje_seq', 3, true);


--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 230
-- Name: resenias_id_resenia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.resenias_id_resenia_seq', 1, true);


--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 232
-- Name: solicitudes_id_solicitud_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.solicitudes_id_solicitud_seq', 6, true);


--
-- TOC entry 4903 (class 2606 OID 16669)
-- Name: artistas artistas_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artistas
    ADD CONSTRAINT artistas_email_key UNIQUE (email);


--
-- TOC entry 4905 (class 2606 OID 16671)
-- Name: artistas artistas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artistas
    ADD CONSTRAINT artistas_pkey PRIMARY KEY (id_artista);


--
-- TOC entry 4907 (class 2606 OID 16673)
-- Name: eventos eventos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventos
    ADD CONSTRAINT eventos_pkey PRIMARY KEY (id_evento);


--
-- TOC entry 4909 (class 2606 OID 16675)
-- Name: imagenes imagenes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagenes
    ADD CONSTRAINT imagenes_pkey PRIMARY KEY (id_imagen);


--
-- TOC entry 4911 (class 2606 OID 16677)
-- Name: locales locales_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locales
    ADD CONSTRAINT locales_email_key UNIQUE (email);


--
-- TOC entry 4913 (class 2606 OID 16679)
-- Name: locales locales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locales
    ADD CONSTRAINT locales_pkey PRIMARY KEY (id_local);


--
-- TOC entry 4915 (class 2606 OID 16681)
-- Name: mensajes mensajes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mensajes
    ADD CONSTRAINT mensajes_pkey PRIMARY KEY (id_mensaje);


--
-- TOC entry 4917 (class 2606 OID 16683)
-- Name: resenias resenias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resenias
    ADD CONSTRAINT resenias_pkey PRIMARY KEY (id_resenia);


--
-- TOC entry 4919 (class 2606 OID 16685)
-- Name: solicitudes solicitudes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitudes
    ADD CONSTRAINT solicitudes_pkey PRIMARY KEY (id_solicitud);


--
-- TOC entry 4930 (class 2620 OID 16686)
-- Name: eventos trg_validar_fecha_evento; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_validar_fecha_evento BEFORE INSERT OR UPDATE ON public.eventos FOR EACH ROW EXECUTE FUNCTION public.validar_fecha_evento();


--
-- TOC entry 4931 (class 2620 OID 16687)
-- Name: resenias trg_validar_puntuacion; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_validar_puntuacion BEFORE INSERT OR UPDATE ON public.resenias FOR EACH ROW EXECUTE FUNCTION public.validar_puntuacion();


--
-- TOC entry 4920 (class 2606 OID 16688)
-- Name: eventos fk_evento_local; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventos
    ADD CONSTRAINT fk_evento_local FOREIGN KEY (id_local) REFERENCES public.locales(id_local);


--
-- TOC entry 4921 (class 2606 OID 16693)
-- Name: imagenes fk_imagen_artista; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagenes
    ADD CONSTRAINT fk_imagen_artista FOREIGN KEY (id_artista) REFERENCES public.artistas(id_artista);


--
-- TOC entry 4922 (class 2606 OID 16698)
-- Name: imagenes fk_imagen_local; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagenes
    ADD CONSTRAINT fk_imagen_local FOREIGN KEY (id_local) REFERENCES public.locales(id_local);


--
-- TOC entry 4927 (class 2606 OID 16703)
-- Name: solicitudes fk_solicitud_evento; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitudes
    ADD CONSTRAINT fk_solicitud_evento FOREIGN KEY (id_evento) REFERENCES public.eventos(id_evento);


--
-- TOC entry 4923 (class 2606 OID 16708)
-- Name: mensajes mensajes_id_artista_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mensajes
    ADD CONSTRAINT mensajes_id_artista_fkey FOREIGN KEY (id_artista) REFERENCES public.artistas(id_artista);


--
-- TOC entry 4924 (class 2606 OID 16713)
-- Name: mensajes mensajes_id_local_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mensajes
    ADD CONSTRAINT mensajes_id_local_fkey FOREIGN KEY (id_local) REFERENCES public.locales(id_local);


--
-- TOC entry 4925 (class 2606 OID 16718)
-- Name: resenias resenias_id_artista_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resenias
    ADD CONSTRAINT resenias_id_artista_fkey FOREIGN KEY (id_artista) REFERENCES public.artistas(id_artista);


--
-- TOC entry 4926 (class 2606 OID 16723)
-- Name: resenias resenias_id_local_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resenias
    ADD CONSTRAINT resenias_id_local_fkey FOREIGN KEY (id_local) REFERENCES public.locales(id_local);


--
-- TOC entry 4928 (class 2606 OID 16728)
-- Name: solicitudes solicitudes_id_artista_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitudes
    ADD CONSTRAINT solicitudes_id_artista_fkey FOREIGN KEY (id_artista) REFERENCES public.artistas(id_artista);


--
-- TOC entry 4929 (class 2606 OID 16733)
-- Name: solicitudes solicitudes_id_local_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.solicitudes
    ADD CONSTRAINT solicitudes_id_local_fkey FOREIGN KEY (id_local) REFERENCES public.locales(id_local);


-- Completed on 2026-10-15 12:15:20

--
-- PostgreSQL database dump complete
--

\unrestrict kjw8lVGYHP66pVvlxgtkdkOgVDMzEzkV4Skjr9foYhQWE24JF6EvHpXVRn44bh9

