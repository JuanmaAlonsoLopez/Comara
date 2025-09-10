--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

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
-- Name: ARTICULOS; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ARTICULOS" (
    "artCod" integer NOT NULL,
    "artDesc" character varying(40) NOT NULL,
    activo bytea,
    "artStock" real,
    "artUni" integer NOT NULL,
    "artStockMin" real,
    "artExist" boolean,
    "rubCod" integer NOT NULL,
    "srubCod" integer NOT NULL,
    "marCod" integer NOT NULL,
    "ivaCod" integer NOT NULL,
    "artAlt1" character varying(18),
    "artAlt2" character varying(18),
    "artL1" real,
    "artL2" real,
    "artL3" real,
    "artL4" real,
    "artL5" real,
    coef1 real,
    coef2 real,
    coef3 real,
    "artDestino" integer,
    iva real,
    imp_interno real,
    "artTalonario" integer,
    "artCbteNro" integer,
    "FechCom" date,
    "FechMod" date,
    "FechVto" date,
    "artDesc2" text,
    "Foto" text,
    exento integer,
    conjunto text,
    "proCod" integer NOT NULL
);


ALTER TABLE public."ARTICULOS" OWNER TO postgres;

--
-- Name: COLUMN "ARTICULOS"."proCod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."ARTICULOS"."proCod" IS 'Supplier id';


--
-- Name: CLIENTES; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CLIENTES" (
    "cliCod" integer NOT NULL,
    "cliNombre" character varying(100) NOT NULL,
    "cliCUIT" character varying(20),
    "cliDireccion" character varying(200),
    "cliTelefono" character varying(20),
    "cliEmail" character varying(100)
);


ALTER TABLE public."CLIENTES" OWNER TO postgres;

--
-- Name: CLIENTES_cliCod_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."CLIENTES_cliCod_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."CLIENTES_cliCod_seq" OWNER TO postgres;

--
-- Name: CLIENTES_cliCod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."CLIENTES_cliCod_seq" OWNED BY public."CLIENTES"."cliCod";


--
-- Name: COBROS; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."COBROS" (
    "cobCod" integer NOT NULL,
    "cliCod" integer NOT NULL,
    "cobFech" date NOT NULL,
    "cobMonto" real NOT NULL,
    "cobMetodo" character varying(50)
);


ALTER TABLE public."COBROS" OWNER TO postgres;

--
-- Name: COBROS_cobCod_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."COBROS_cobCod_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."COBROS_cobCod_seq" OWNER TO postgres;

--
-- Name: COBROS_cobCod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."COBROS_cobCod_seq" OWNED BY public."COBROS"."cobCod";


--
-- Name: COTIZACIONES; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."COTIZACIONES" (
    "cotCod" integer NOT NULL,
    "cotFech" date NOT NULL,
    "cliCod" integer NOT NULL,
    "cotTotal" real NOT NULL,
    "cotEstado" character varying(20)
);


ALTER TABLE public."COTIZACIONES" OWNER TO postgres;

--
-- Name: COTIZACIONES_cotCod_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."COTIZACIONES_cotCod_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."COTIZACIONES_cotCod_seq" OWNER TO postgres;

--
-- Name: COTIZACIONES_cotCod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."COTIZACIONES_cotCod_seq" OWNED BY public."COTIZACIONES"."cotCod";


--
-- Name: CUENTAS_CORRIENTES; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CUENTAS_CORRIENTES" (
    "cctaCod" integer NOT NULL,
    "cliCod" integer NOT NULL,
    "cctaFech" date NOT NULL,
    "cctaMovimiento" character varying(10),
    "cctaMonto" real NOT NULL,
    "cctaSaldo" real NOT NULL,
    "cctaDesc" character varying(255)
);


ALTER TABLE public."CUENTAS_CORRIENTES" OWNER TO postgres;

--
-- Name: CUENTAS_CORRIENTES_cctaCod_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."CUENTAS_CORRIENTES_cctaCod_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."CUENTAS_CORRIENTES_cctaCod_seq" OWNER TO postgres;

--
-- Name: CUENTAS_CORRIENTES_cctaCod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."CUENTAS_CORRIENTES_cctaCod_seq" OWNED BY public."CUENTAS_CORRIENTES"."cctaCod";


--
-- Name: DETALLE_COTIZACIONES; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."DETALLE_COTIZACIONES" (
    "detCotCod" integer NOT NULL,
    "cotCod" integer NOT NULL,
    "artCod" integer NOT NULL,
    "detCant" real NOT NULL,
    "detPrecio" real NOT NULL,
    "detSubtotal" real NOT NULL
);


ALTER TABLE public."DETALLE_COTIZACIONES" OWNER TO postgres;

--
-- Name: DETALLE_COTIZACIONES_detCotCod_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."DETALLE_COTIZACIONES_detCotCod_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."DETALLE_COTIZACIONES_detCotCod_seq" OWNER TO postgres;

--
-- Name: DETALLE_COTIZACIONES_detCotCod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."DETALLE_COTIZACIONES_detCotCod_seq" OWNED BY public."DETALLE_COTIZACIONES"."detCotCod";


--
-- Name: DETALLE_VENTAS; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."DETALLE_VENTAS" (
    "detCod" integer NOT NULL,
    "venCod" integer NOT NULL,
    "artCod" integer NOT NULL,
    "detCant" real NOT NULL,
    "detPrecio" real NOT NULL,
    "detSubtotal" real NOT NULL
);


ALTER TABLE public."DETALLE_VENTAS" OWNER TO postgres;

--
-- Name: DETALLE_VENTAS_detCod_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."DETALLE_VENTAS_detCod_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."DETALLE_VENTAS_detCod_seq" OWNER TO postgres;

--
-- Name: DETALLE_VENTAS_detCod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."DETALLE_VENTAS_detCod_seq" OWNED BY public."DETALLE_VENTAS"."detCod";


--
-- Name: MARCAS; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."MARCAS" (
    "marCod" integer NOT NULL,
    "marNombre" character varying(50) NOT NULL
);


ALTER TABLE public."MARCAS" OWNER TO postgres;

--
-- Name: MARCAS_marCod_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."MARCAS_marCod_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."MARCAS_marCod_seq" OWNER TO postgres;

--
-- Name: MARCAS_marCod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."MARCAS_marCod_seq" OWNED BY public."MARCAS"."marCod";


--
-- Name: PROVEEDORES; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PROVEEDORES" (
    "proCod" integer NOT NULL,
    "proNombre" character varying(100) NOT NULL,
    "proCUIT" character varying(20),
    "proContacto" character varying(100)
);


ALTER TABLE public."PROVEEDORES" OWNER TO postgres;

--
-- Name: PROVEEDORES_proCod_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PROVEEDORES_proCod_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."PROVEEDORES_proCod_seq" OWNER TO postgres;

--
-- Name: PROVEEDORES_proCod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."PROVEEDORES_proCod_seq" OWNED BY public."PROVEEDORES"."proCod";


--
-- Name: VENTAS; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."VENTAS" (
    "venCod" integer NOT NULL,
    "venFech" date NOT NULL,
    "cliCod" integer NOT NULL,
    "venTotal" real NOT NULL,
    "venEstado" character varying(20),
    "venTipoCbte" integer
);


ALTER TABLE public."VENTAS" OWNER TO postgres;

--
-- Name: VENTAS_venCod_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."VENTAS_venCod_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."VENTAS_venCod_seq" OWNER TO postgres;

--
-- Name: VENTAS_venCod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."VENTAS_venCod_seq" OWNED BY public."VENTAS"."venCod";


--
-- Name: CLIENTES cliCod; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CLIENTES" ALTER COLUMN "cliCod" SET DEFAULT nextval('public."CLIENTES_cliCod_seq"'::regclass);


--
-- Name: COBROS cobCod; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."COBROS" ALTER COLUMN "cobCod" SET DEFAULT nextval('public."COBROS_cobCod_seq"'::regclass);


--
-- Name: COTIZACIONES cotCod; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."COTIZACIONES" ALTER COLUMN "cotCod" SET DEFAULT nextval('public."COTIZACIONES_cotCod_seq"'::regclass);


--
-- Name: CUENTAS_CORRIENTES cctaCod; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CUENTAS_CORRIENTES" ALTER COLUMN "cctaCod" SET DEFAULT nextval('public."CUENTAS_CORRIENTES_cctaCod_seq"'::regclass);


--
-- Name: DETALLE_COTIZACIONES detCotCod; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DETALLE_COTIZACIONES" ALTER COLUMN "detCotCod" SET DEFAULT nextval('public."DETALLE_COTIZACIONES_detCotCod_seq"'::regclass);


--
-- Name: DETALLE_VENTAS detCod; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DETALLE_VENTAS" ALTER COLUMN "detCod" SET DEFAULT nextval('public."DETALLE_VENTAS_detCod_seq"'::regclass);


--
-- Name: MARCAS marCod; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MARCAS" ALTER COLUMN "marCod" SET DEFAULT nextval('public."MARCAS_marCod_seq"'::regclass);


--
-- Name: PROVEEDORES proCod; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PROVEEDORES" ALTER COLUMN "proCod" SET DEFAULT nextval('public."PROVEEDORES_proCod_seq"'::regclass);


--
-- Name: VENTAS venCod; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."VENTAS" ALTER COLUMN "venCod" SET DEFAULT nextval('public."VENTAS_venCod_seq"'::regclass);


--
-- Data for Name: ARTICULOS; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ARTICULOS" ("artCod", "artDesc", activo, "artStock", "artUni", "artStockMin", "artExist", "rubCod", "srubCod", "marCod", "ivaCod", "artAlt1", "artAlt2", "artL1", "artL2", "artL3", "artL4", "artL5", coef1, coef2, coef3, "artDestino", iva, imp_interno, "artTalonario", "artCbteNro", "FechCom", "FechMod", "FechVto", "artDesc2", "Foto", exento, conjunto, "proCod") FROM stdin;
654654	Caño de agua de prueba	\N	5	0	\N	\N	0	0	1	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1
\.


--
-- Data for Name: CLIENTES; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."CLIENTES" ("cliCod", "cliNombre", "cliCUIT", "cliDireccion", "cliTelefono", "cliEmail") FROM stdin;
\.


--
-- Data for Name: COBROS; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."COBROS" ("cobCod", "cliCod", "cobFech", "cobMonto", "cobMetodo") FROM stdin;
\.


--
-- Data for Name: COTIZACIONES; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."COTIZACIONES" ("cotCod", "cotFech", "cliCod", "cotTotal", "cotEstado") FROM stdin;
\.


--
-- Data for Name: CUENTAS_CORRIENTES; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."CUENTAS_CORRIENTES" ("cctaCod", "cliCod", "cctaFech", "cctaMovimiento", "cctaMonto", "cctaSaldo", "cctaDesc") FROM stdin;
\.


--
-- Data for Name: DETALLE_COTIZACIONES; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."DETALLE_COTIZACIONES" ("detCotCod", "cotCod", "artCod", "detCant", "detPrecio", "detSubtotal") FROM stdin;
\.


--
-- Data for Name: DETALLE_VENTAS; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."DETALLE_VENTAS" ("detCod", "venCod", "artCod", "detCant", "detPrecio", "detSubtotal") FROM stdin;
\.


--
-- Data for Name: MARCAS; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."MARCAS" ("marCod", "marNombre") FROM stdin;
1	Tigre
\.


--
-- Data for Name: PROVEEDORES; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."PROVEEDORES" ("proCod", "proNombre", "proCUIT", "proContacto") FROM stdin;
1	Katsuda	20-44309956-6	Marcelo
\.


--
-- Data for Name: VENTAS; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."VENTAS" ("venCod", "venFech", "cliCod", "venTotal", "venEstado", "venTipoCbte") FROM stdin;
\.


--
-- Name: CLIENTES_cliCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."CLIENTES_cliCod_seq"', 1, false);


--
-- Name: COBROS_cobCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."COBROS_cobCod_seq"', 1, false);


--
-- Name: COTIZACIONES_cotCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."COTIZACIONES_cotCod_seq"', 1, false);


--
-- Name: CUENTAS_CORRIENTES_cctaCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."CUENTAS_CORRIENTES_cctaCod_seq"', 1, false);


--
-- Name: DETALLE_COTIZACIONES_detCotCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."DETALLE_COTIZACIONES_detCotCod_seq"', 1, false);


--
-- Name: DETALLE_VENTAS_detCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."DETALLE_VENTAS_detCod_seq"', 1, false);


--
-- Name: MARCAS_marCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."MARCAS_marCod_seq"', 1, true);


--
-- Name: PROVEEDORES_proCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."PROVEEDORES_proCod_seq"', 1, true);


--
-- Name: VENTAS_venCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."VENTAS_venCod_seq"', 1, false);


--
-- Name: ARTICULOS ARTICULOS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ARTICULOS"
    ADD CONSTRAINT "ARTICULOS_pkey" PRIMARY KEY ("artCod");


--
-- Name: CLIENTES CLIENTES_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CLIENTES"
    ADD CONSTRAINT "CLIENTES_pkey" PRIMARY KEY ("cliCod");


--
-- Name: COBROS COBROS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."COBROS"
    ADD CONSTRAINT "COBROS_pkey" PRIMARY KEY ("cobCod");


--
-- Name: COTIZACIONES COTIZACIONES_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."COTIZACIONES"
    ADD CONSTRAINT "COTIZACIONES_pkey" PRIMARY KEY ("cotCod");


--
-- Name: CUENTAS_CORRIENTES CUENTAS_CORRIENTES_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CUENTAS_CORRIENTES"
    ADD CONSTRAINT "CUENTAS_CORRIENTES_pkey" PRIMARY KEY ("cctaCod");


--
-- Name: DETALLE_COTIZACIONES DETALLE_COTIZACIONES_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DETALLE_COTIZACIONES"
    ADD CONSTRAINT "DETALLE_COTIZACIONES_pkey" PRIMARY KEY ("detCotCod");


--
-- Name: DETALLE_VENTAS DETALLE_VENTAS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DETALLE_VENTAS"
    ADD CONSTRAINT "DETALLE_VENTAS_pkey" PRIMARY KEY ("detCod");


--
-- Name: MARCAS MARCAS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MARCAS"
    ADD CONSTRAINT "MARCAS_pkey" PRIMARY KEY ("marCod");


--
-- Name: PROVEEDORES PROVEEDORES_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PROVEEDORES"
    ADD CONSTRAINT "PROVEEDORES_pkey" PRIMARY KEY ("proCod");


--
-- Name: VENTAS VENTAS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."VENTAS"
    ADD CONSTRAINT "VENTAS_pkey" PRIMARY KEY ("venCod");


--
-- Name: COBROS COBROS_cliCod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."COBROS"
    ADD CONSTRAINT "COBROS_cliCod_fkey" FOREIGN KEY ("cliCod") REFERENCES public."CLIENTES"("cliCod");


--
-- Name: COTIZACIONES COTIZACIONES_cliCod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."COTIZACIONES"
    ADD CONSTRAINT "COTIZACIONES_cliCod_fkey" FOREIGN KEY ("cliCod") REFERENCES public."CLIENTES"("cliCod");


--
-- Name: CUENTAS_CORRIENTES CUENTAS_CORRIENTES_cliCod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CUENTAS_CORRIENTES"
    ADD CONSTRAINT "CUENTAS_CORRIENTES_cliCod_fkey" FOREIGN KEY ("cliCod") REFERENCES public."CLIENTES"("cliCod");


--
-- Name: DETALLE_COTIZACIONES DETALLE_COTIZACIONES_artCod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DETALLE_COTIZACIONES"
    ADD CONSTRAINT "DETALLE_COTIZACIONES_artCod_fkey" FOREIGN KEY ("artCod") REFERENCES public."ARTICULOS"("artCod");


--
-- Name: DETALLE_COTIZACIONES DETALLE_COTIZACIONES_cotCod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DETALLE_COTIZACIONES"
    ADD CONSTRAINT "DETALLE_COTIZACIONES_cotCod_fkey" FOREIGN KEY ("cotCod") REFERENCES public."COTIZACIONES"("cotCod");


--
-- Name: DETALLE_VENTAS DETALLE_VENTAS_artCod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DETALLE_VENTAS"
    ADD CONSTRAINT "DETALLE_VENTAS_artCod_fkey" FOREIGN KEY ("artCod") REFERENCES public."ARTICULOS"("artCod");


--
-- Name: DETALLE_VENTAS DETALLE_VENTAS_venCod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DETALLE_VENTAS"
    ADD CONSTRAINT "DETALLE_VENTAS_venCod_fkey" FOREIGN KEY ("venCod") REFERENCES public."VENTAS"("venCod");


--
-- Name: VENTAS VENTAS_cliCod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."VENTAS"
    ADD CONSTRAINT "VENTAS_cliCod_fkey" FOREIGN KEY ("cliCod") REFERENCES public."CLIENTES"("cliCod");


--
-- PostgreSQL database dump complete
--

