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

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ARTICULOS; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ARTICULOS" (
    "artCod" character varying(20) NOT NULL,
    "artDesc" character varying(55) NOT NULL,
    activo bytea,
    "artStock" numeric(15,4),
    "artUni" integer NOT NULL,
    "artStockMin" numeric(15,4),
    "artExist" boolean,
    "rubCod" integer NOT NULL,
    "srubCod" integer NOT NULL,
    "marCod" integer NOT NULL,
    "ivaCod" integer NOT NULL,
    "artAlt1" character varying(18),
    "artAlt2" character varying(18),
    "artL1" numeric(15,2),
    "artL2" numeric(15,2),
    "artL3" numeric(15,2),
    "artL4" numeric(15,2),
    "artL5" numeric(15,2),
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
    "proCod" integer NOT NULL,
    "artCosto" numeric(10,2),
    id integer NOT NULL
);


ALTER TABLE public."ARTICULOS" OWNER TO postgres;

--
-- Name: COLUMN "ARTICULOS"."proCod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."ARTICULOS"."proCod" IS 'Supplier id';


--
-- Name: ARTICULOS_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ARTICULOS_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ARTICULOS_id_seq" OWNER TO postgres;

--
-- Name: ARTICULOS_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ARTICULOS_id_seq" OWNED BY public."ARTICULOS".id;


--
-- Name: CHEQUES; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CHEQUES" (
    "chqCod" integer NOT NULL,
    "pagCod" integer NOT NULL,
    "chqNumero" character varying(50) NOT NULL,
    "chqBanco" character varying(100) NOT NULL,
    "chqFechaEmision" date NOT NULL,
    "chqFechaCobro" date NOT NULL,
    "chqMonto" numeric(15,2) NOT NULL,
    "chqLibrador" character varying(100) NOT NULL,
    "chqCUIT" character varying(20),
    "chqEnCaja" boolean DEFAULT true NOT NULL,
    "chqFechaSalida" timestamp without time zone,
    "chqObservaciones" character varying(255)
);


ALTER TABLE public."CHEQUES" OWNER TO postgres;

--
-- Name: TABLE "CHEQUES"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."CHEQUES" IS 'Cheques recibidos como pago, con seguimiento de estado en caja';


--
-- Name: COLUMN "CHEQUES"."chqEnCaja"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."CHEQUES"."chqEnCaja" IS 'Indica si el cheque estÃ¡ fÃ­sicamente en caja';


--
-- Name: COLUMN "CHEQUES"."chqFechaSalida"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."CHEQUES"."chqFechaSalida" IS 'Fecha en que el cheque saliÃ³ de caja (depositado, entregado, etc.)';


--
-- Name: CHEQUES_chqCod_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."CHEQUES_chqCod_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."CHEQUES_chqCod_seq" OWNER TO postgres;

--
-- Name: CHEQUES_chqCod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."CHEQUES_chqCod_seq" OWNED BY public."CHEQUES"."chqCod";


--
-- Name: CLIENTES; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CLIENTES" (
    "cliNombre" character varying(100) NOT NULL,
    "cliDireccion" character varying(200),
    "cliTelefono" character varying(20),
    "cliEmail" character varying(100),
    id integer NOT NULL,
    "cliTipoDoc" integer,
    "cliNumDoc" character varying(20),
    "cliCondicionIVA" integer,
    "cliFormaPago" integer
);


ALTER TABLE public."CLIENTES" OWNER TO postgres;

--
-- Name: CLIENTES_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."CLIENTES_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."CLIENTES_id_seq" OWNER TO postgres;

--
-- Name: CLIENTES_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."CLIENTES_id_seq" OWNED BY public."CLIENTES".id;


--
-- Name: COBROS; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."COBROS" (
    "cobCod" integer NOT NULL,
    "cliCod" integer NOT NULL,
    "cobFech" date NOT NULL,
    "cobMonto" numeric(15,2) NOT NULL,
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
    "cotTotal" numeric(15,2) NOT NULL,
    "cotEstado" character varying(20),
    "cotEstadoId" integer DEFAULT 1
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
    "cctaMonto" numeric(15,2) NOT NULL,
    "cctaSaldo" numeric(15,2) NOT NULL,
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
    "detCant" numeric(15,4) NOT NULL,
    "detPrecio" numeric(15,2) NOT NULL,
    "detSubtotal" numeric(15,2) NOT NULL,
    "artCod" integer NOT NULL
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
    "detCant" numeric(15,4) NOT NULL,
    "detPrecio" numeric(15,2) NOT NULL,
    "detSubtotal" numeric(15,2) NOT NULL,
    "artCod" integer NOT NULL
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
-- Name: IVA; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."IVA" (
    id integer NOT NULL,
    porcentaje numeric(5,2) NOT NULL
);


ALTER TABLE public."IVA" OWNER TO postgres;

--
-- Name: LISTAS; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."LISTAS" (
    "listCod" integer NOT NULL,
    "listDesc" character varying(50) NOT NULL,
    "listPercent" numeric(10,2) NOT NULL,
    "listStatus" boolean DEFAULT false
);


ALTER TABLE public."LISTAS" OWNER TO postgres;

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
-- Name: MOVIMIENTOS_CAJA; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."MOVIMIENTOS_CAJA" (
    "movCod" integer NOT NULL,
    "movFecha" date NOT NULL,
    "movTipo" integer NOT NULL,
    "movMetodoPago" integer NOT NULL,
    "movMonto" numeric(15,2) NOT NULL,
    "movDescripcion" character varying(255),
    "chqCod" integer
);


ALTER TABLE public."MOVIMIENTOS_CAJA" OWNER TO postgres;

--
-- Name: TABLE "MOVIMIENTOS_CAJA"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."MOVIMIENTOS_CAJA" IS 'Movimientos de ingresos y egresos de caja (efectivo y cheques)';


--
-- Name: MOVIMIENTOS_CAJA_movCod_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."MOVIMIENTOS_CAJA_movCod_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."MOVIMIENTOS_CAJA_movCod_seq" OWNER TO postgres;

--
-- Name: MOVIMIENTOS_CAJA_movCod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."MOVIMIENTOS_CAJA_movCod_seq" OWNED BY public."MOVIMIENTOS_CAJA"."movCod";


--
-- Name: PAGOS; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PAGOS" (
    "pagCod" integer NOT NULL,
    "cliCod" integer NOT NULL,
    "pagFech" date NOT NULL,
    "pagMonto" numeric(15,2) NOT NULL,
    "pagMetodoPago" integer NOT NULL,
    "pagDesc" character varying(255),
    "cctaCod" integer,
    "venCod" integer
);


ALTER TABLE public."PAGOS" OWNER TO postgres;

--
-- Name: TABLE "PAGOS"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."PAGOS" IS 'Registro de pagos realizados por clientes (mÃ³dulo Caja)';


--
-- Name: COLUMN "PAGOS"."pagCod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."PAGOS"."pagCod" IS 'CÃ³digo Ãºnico del pago';


--
-- Name: COLUMN "PAGOS"."cliCod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."PAGOS"."cliCod" IS 'CÃ³digo del cliente que realiza el pago';


--
-- Name: COLUMN "PAGOS"."pagFech"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."PAGOS"."pagFech" IS 'Fecha del pago';


--
-- Name: COLUMN "PAGOS"."pagMonto"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."PAGOS"."pagMonto" IS 'Monto del pago';


--
-- Name: COLUMN "PAGOS"."pagMetodoPago"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."PAGOS"."pagMetodoPago" IS 'MÃ©todo de pago (FK a ventaTipoMetodoPagos, excluye Cuenta Corriente)';


--
-- Name: COLUMN "PAGOS"."pagDesc"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."PAGOS"."pagDesc" IS 'DescripciÃ³n del pago';


--
-- Name: COLUMN "PAGOS"."cctaCod"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."PAGOS"."cctaCod" IS 'Referencia al movimiento en cuenta corriente';


--
-- Name: PAGOS_pagCod_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PAGOS_pagCod_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."PAGOS_pagCod_seq" OWNER TO postgres;

--
-- Name: PAGOS_pagCod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."PAGOS_pagCod_seq" OWNED BY public."PAGOS"."pagCod";


--
-- Name: PROVEEDORES; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PROVEEDORES" (
    "proCod" integer NOT NULL,
    "proNombre" character varying(100) NOT NULL,
    "proCUIT" character varying(20),
    "proContacto" character varying(100),
    "proDescuento" numeric(5,2) DEFAULT 0.00,
    "proEmail" character varying(100),
    "proCelular" character varying(20)
);


ALTER TABLE public."PROVEEDORES" OWNER TO postgres;

--
-- Name: COLUMN "PROVEEDORES"."proDescuento"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."PROVEEDORES"."proDescuento" IS 'Descuento del proveedor en porcentaje (ej: 10.50 = 10.5%)';


--
-- Name: COLUMN "PROVEEDORES"."proEmail"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."PROVEEDORES"."proEmail" IS 'Email del proveedor (opcional)';


--
-- Name: COLUMN "PROVEEDORES"."proCelular"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."PROVEEDORES"."proCelular" IS 'Número de celular del proveedor (opcional)';


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
-- Name: USUARIOS; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."USUARIOS" (
    id integer NOT NULL,
    "usuUsername" character varying(50) NOT NULL,
    "usuPasswordHash" character varying(255) NOT NULL,
    "usuRole" character varying(20) DEFAULT 'user'::character varying NOT NULL,
    "usuNombreCompleto" character varying(100) NOT NULL,
    "usuEmail" character varying(100),
    "usuActivo" boolean DEFAULT true NOT NULL,
    "usuFechaCreacion" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "usuUltimoLogin" timestamp without time zone,
    "usuCreadoPor" integer,
    "usuModificadoPor" integer,
    "usuFechaModificacion" timestamp without time zone
);


ALTER TABLE public."USUARIOS" OWNER TO postgres;

--
-- Name: USUARIOS_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."USUARIOS_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."USUARIOS_id_seq" OWNER TO postgres;

--
-- Name: USUARIOS_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."USUARIOS_id_seq" OWNED BY public."USUARIOS".id;


--
-- Name: VENTAS; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."VENTAS" (
    "venCod" integer NOT NULL,
    "venFech" date NOT NULL,
    "cliCod" integer NOT NULL,
    "venTotal" numeric(15,2) NOT NULL,
    "venTipoCbte" integer,
    "venEstado" integer,
    "venMetodoPago" integer,
    "venPuntoVenta" integer,
    "venNumComprobante" bigint,
    "venCAE" character varying(20),
    "venCAEVencimiento" timestamp without time zone,
    "venFechaAutorizacion" timestamp without time zone,
    "venResultadoAfip" character varying(1),
    "venObservacionesAfip" text,
    "venLista" integer,
    "venFechVenta" timestamp without time zone,
    "venEstadoPago" integer DEFAULT 1
);


ALTER TABLE public."VENTAS" OWNER TO postgres;

--
-- Name: COLUMN "VENTAS"."venLista"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."VENTAS"."venLista" IS 'Lista de precios utilizada en la venta';


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
-- Name: __EFMigrationsHistory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL
);


ALTER TABLE public."__EFMigrationsHistory" OWNER TO postgres;

--
-- Name: afipLogs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."afipLogs" (
    id integer NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "tipoOperacion" character varying(50) NOT NULL,
    "venCod" integer,
    "tipoComprobante" integer,
    "puntoVenta" integer,
    "numeroComprobante" bigint,
    request text NOT NULL,
    response text,
    exitoso boolean NOT NULL,
    "mensajeError" text,
    cae character varying(20),
    "duracionMs" integer,
    "ipAddress" character varying(45)
);


ALTER TABLE public."afipLogs" OWNER TO postgres;

--
-- Name: TABLE "afipLogs"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."afipLogs" IS 'Registro de todas las comunicaciones con AFIP';


--
-- Name: COLUMN "afipLogs"."tipoOperacion"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."afipLogs"."tipoOperacion" IS 'AuthWSAA, AutorizarFactura, ConsultarComprobante, etc.';


--
-- Name: COLUMN "afipLogs".request; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."afipLogs".request IS 'XML/JSON del request enviado a AFIP';


--
-- Name: COLUMN "afipLogs".response; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."afipLogs".response IS 'XML/JSON de la respuesta de AFIP';


--
-- Name: COLUMN "afipLogs"."duracionMs"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."afipLogs"."duracionMs" IS 'Tiempo de respuesta en milisegundos';


--
-- Name: afipLogs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."afipLogs_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."afipLogs_id_seq" OWNER TO postgres;

--
-- Name: afipLogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."afipLogs_id_seq" OWNED BY public."afipLogs".id;


--
-- Name: afip_auth_tickets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.afip_auth_tickets (
    id integer NOT NULL,
    cuit_representado character varying(11) NOT NULL,
    token text NOT NULL,
    sign text NOT NULL,
    generated_at timestamp with time zone NOT NULL,
    expiration_time timestamp with time zone NOT NULL,
    environment character varying(20) NOT NULL
);


ALTER TABLE public.afip_auth_tickets OWNER TO postgres;

--
-- Name: afip_auth_tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.afip_auth_tickets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.afip_auth_tickets_id_seq OWNER TO postgres;

--
-- Name: afip_auth_tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.afip_auth_tickets_id_seq OWNED BY public.afip_auth_tickets.id;


--
-- Name: clienteTipoFormaPago_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."clienteTipoFormaPago_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."clienteTipoFormaPago_id_seq" OWNER TO postgres;

--
-- Name: clienteTipoFormaPago; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."clienteTipoFormaPago" (
    id integer DEFAULT nextval('public."clienteTipoFormaPago_id_seq"'::regclass) NOT NULL,
    descripcion character varying(50) NOT NULL
);


ALTER TABLE public."clienteTipoFormaPago" OWNER TO postgres;

--
-- Name: condicionIVA; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."condicionIVA" (
    id integer NOT NULL,
    "codigoAfip" integer NOT NULL,
    descripcion character varying(100) NOT NULL
);


ALTER TABLE public."condicionIVA" OWNER TO postgres;

--
-- Name: condicionIVA_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."condicionIVA" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."condicionIVA_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cotizacionEstados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."cotizacionEstados" (
    id integer NOT NULL,
    descripcion character varying(50) NOT NULL,
    color character varying(20) DEFAULT 'secondary'::character varying
);


ALTER TABLE public."cotizacionEstados" OWNER TO postgres;

--
-- Name: cotizacionEstados_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."cotizacionEstados_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."cotizacionEstados_id_seq" OWNER TO postgres;

--
-- Name: cotizacionEstados_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."cotizacionEstados_id_seq" OWNED BY public."cotizacionEstados".id;


--
-- Name: iva_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.iva_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.iva_id_seq OWNER TO postgres;

--
-- Name: iva_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.iva_id_seq OWNED BY public."IVA".id;


--
-- Name: listas_listCod_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."listas_listCod_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."listas_listCod_seq" OWNER TO postgres;

--
-- Name: listas_listCod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."listas_listCod_seq" OWNED BY public."LISTAS"."listCod";


--
-- Name: tipoComprobante; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."tipoComprobante" (
    id integer NOT NULL,
    "codigoAfip" integer NOT NULL,
    descripcion character varying(100) NOT NULL,
    "requiereCAE" boolean DEFAULT true NOT NULL
);


ALTER TABLE public."tipoComprobante" OWNER TO postgres;

--
-- Name: tipoComprobante_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."tipoComprobante" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."tipoComprobante_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: tipoDocumento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."tipoDocumento" (
    id integer NOT NULL,
    "codigoAfip" integer NOT NULL,
    descripcion character varying(50) NOT NULL
);


ALTER TABLE public."tipoDocumento" OWNER TO postgres;

--
-- Name: tipoDocumento_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."tipoDocumento" ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public."tipoDocumento_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: tipoMovimientoCaja; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."tipoMovimientoCaja" (
    id integer NOT NULL,
    descripcion character varying(50) NOT NULL,
    tipo character varying(10) NOT NULL
);


ALTER TABLE public."tipoMovimientoCaja" OWNER TO postgres;

--
-- Name: TABLE "tipoMovimientoCaja"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."tipoMovimientoCaja" IS 'Tipos de movimientos de caja (categorÃ­as)';


--
-- Name: tipoMovimientoCaja_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."tipoMovimientoCaja_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."tipoMovimientoCaja_id_seq" OWNER TO postgres;

--
-- Name: tipoMovimientoCaja_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."tipoMovimientoCaja_id_seq" OWNED BY public."tipoMovimientoCaja".id;


--
-- Name: ventaEstadoPago; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ventaEstadoPago" (
    id integer NOT NULL,
    descripcion character varying(50) NOT NULL
);


ALTER TABLE public."ventaEstadoPago" OWNER TO postgres;

--
-- Name: ventaEstadoPago_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ventaEstadoPago_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ventaEstadoPago_id_seq" OWNER TO postgres;

--
-- Name: ventaEstadoPago_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ventaEstadoPago_id_seq" OWNED BY public."ventaEstadoPago".id;


--
-- Name: ventaTipoEstado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ventaTipoEstado" (
    id integer NOT NULL,
    descripcion character varying(50) NOT NULL
);


ALTER TABLE public."ventaTipoEstado" OWNER TO postgres;

--
-- Name: ventaTipoEstado_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ventaTipoEstado_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ventaTipoEstado_id_seq" OWNER TO postgres;

--
-- Name: ventaTipoEstado_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ventaTipoEstado_id_seq" OWNED BY public."ventaTipoEstado".id;


--
-- Name: ventaTipoMetodoPagos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ventaTipoMetodoPagos" (
    id integer NOT NULL,
    descripcion character varying(50) NOT NULL
);


ALTER TABLE public."ventaTipoMetodoPagos" OWNER TO postgres;

--
-- Name: ventaTipoMetodoPagos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ventaTipoMetodoPagos_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ventaTipoMetodoPagos_id_seq" OWNER TO postgres;

--
-- Name: ventaTipoMetodoPagos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ventaTipoMetodoPagos_id_seq" OWNED BY public."ventaTipoMetodoPagos".id;


--
-- Name: ARTICULOS id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ARTICULOS" ALTER COLUMN id SET DEFAULT nextval('public."ARTICULOS_id_seq"'::regclass);


--
-- Name: CHEQUES chqCod; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CHEQUES" ALTER COLUMN "chqCod" SET DEFAULT nextval('public."CHEQUES_chqCod_seq"'::regclass);


--
-- Name: CLIENTES id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CLIENTES" ALTER COLUMN id SET DEFAULT nextval('public."CLIENTES_id_seq"'::regclass);


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
-- Name: IVA id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."IVA" ALTER COLUMN id SET DEFAULT nextval('public.iva_id_seq'::regclass);


--
-- Name: LISTAS listCod; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."LISTAS" ALTER COLUMN "listCod" SET DEFAULT nextval('public."listas_listCod_seq"'::regclass);


--
-- Name: MARCAS marCod; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MARCAS" ALTER COLUMN "marCod" SET DEFAULT nextval('public."MARCAS_marCod_seq"'::regclass);


--
-- Name: MOVIMIENTOS_CAJA movCod; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MOVIMIENTOS_CAJA" ALTER COLUMN "movCod" SET DEFAULT nextval('public."MOVIMIENTOS_CAJA_movCod_seq"'::regclass);


--
-- Name: PAGOS pagCod; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PAGOS" ALTER COLUMN "pagCod" SET DEFAULT nextval('public."PAGOS_pagCod_seq"'::regclass);


--
-- Name: PROVEEDORES proCod; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PROVEEDORES" ALTER COLUMN "proCod" SET DEFAULT nextval('public."PROVEEDORES_proCod_seq"'::regclass);


--
-- Name: USUARIOS id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."USUARIOS" ALTER COLUMN id SET DEFAULT nextval('public."USUARIOS_id_seq"'::regclass);


--
-- Name: VENTAS venCod; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."VENTAS" ALTER COLUMN "venCod" SET DEFAULT nextval('public."VENTAS_venCod_seq"'::regclass);


--
-- Name: afipLogs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."afipLogs" ALTER COLUMN id SET DEFAULT nextval('public."afipLogs_id_seq"'::regclass);


--
-- Name: afip_auth_tickets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afip_auth_tickets ALTER COLUMN id SET DEFAULT nextval('public.afip_auth_tickets_id_seq'::regclass);


--
-- Name: cotizacionEstados id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."cotizacionEstados" ALTER COLUMN id SET DEFAULT nextval('public."cotizacionEstados_id_seq"'::regclass);


--
-- Name: tipoMovimientoCaja id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tipoMovimientoCaja" ALTER COLUMN id SET DEFAULT nextval('public."tipoMovimientoCaja_id_seq"'::regclass);


--
-- Name: ventaEstadoPago id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ventaEstadoPago" ALTER COLUMN id SET DEFAULT nextval('public."ventaEstadoPago_id_seq"'::regclass);


--
-- Name: ventaTipoEstado id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ventaTipoEstado" ALTER COLUMN id SET DEFAULT nextval('public."ventaTipoEstado_id_seq"'::regclass);


--
-- Name: ventaTipoMetodoPagos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ventaTipoMetodoPagos" ALTER COLUMN id SET DEFAULT nextval('public."ventaTipoMetodoPagos_id_seq"'::regclass);


--
-- Data for Name: ARTICULOS; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ARTICULOS" ("artCod", "artDesc", activo, "artStock", "artUni", "artStockMin", "artExist", "rubCod", "srubCod", "marCod", "ivaCod", "artAlt1", "artAlt2", "artL1", "artL2", "artL3", "artL4", "artL5", coef1, coef2, coef3, "artDestino", iva, imp_interno, "artTalonario", "artCbteNro", "FechCom", "FechMod", "FechVto", "artDesc2", "Foto", exento, conjunto, "proCod", "artCosto", id) FROM stdin;
2	ESMALTE SINTETICO 500 ML TABACO	\N	2.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6055.81	2636
3	ESMALTE SINTETICO 500 ML OCRE	\N	1.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6055.81	2637
4	ESMALTE SINTETICO 500 ML MARRON	\N	1.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6055.81	2638
5	ESMALTE SINTETICO 500 ML ALUMINIO	\N	3.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6055.81	2639
6	ESMALTE SINTETICO 500 ML BLANCO BRILLANT	\N	5.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6055.81	2640
7	ESMALTE SINTETICO 500 ML GRIS ESPACIAL	\N	3.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6055.81	2641
8	ESMALTE SINTETICO 500 ML GRIS	\N	3.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6055.81	2642
9	ESMALTE SINTETICO 500 ML NEGRO SATINADO	\N	2.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6055.81	2643
10	ESMALTE SINTETICO 500 ML AMARILLO	\N	1.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6055.81	2644
11	ESMALTE SINTETICO 500 ML VERDE CLARO	\N	1.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6055.81	2645
12	ESMALTE SINTETICO 500 ML BERMELLON	\N	1.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6055.81	2646
13	ESMALTE SINTETICO 500 ML AMARILLO MEDIAN	\N	1.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6055.81	2647
15	ESMALTE SINTETICO 500 ML BLANCO SATINADO	\N	2.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6055.81	2649
16	ESMALTE SINTETICO 500 ML BLANCO MATE	\N	2.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6055.81	2650
17	ESMALTE SINTETICO 500 ML NEGRO MATE	\N	3.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6055.81	2651
18	ESMALTE SINTETICO 1 LT AMARILLO MEDIANO	\N	1.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	12334.27	2652
19	ESMALTE SINTETICO 1 LT NEGRO BRILLANTE	\N	6.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	12334.28	2653
20	ESMALTE SINTETICO 1 LT ALUMINIO	\N	2.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	12334.28	2654
22	ESMALTE SINTETICO 1 LT BLANCO BRILLANTE	\N	4.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	12334.28	2656
23	ESMALTE SINTETICO 1 LT NEGRO SATINADO	\N	4.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	12334.28	2657
24	ESMALTE SINTETICO 1 LT BERMELLON	\N	1.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	12334.28	2658
25	ESMALTE SINTETICO 1 LT MARFIL CHAMPAGNE	\N	1.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	12334.28	2659
26	ESMALTE SINTETICO 1 LT MARRON	\N	2.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	12334.28	2660
27	ESMALTE SINTETICO 1 LT AZUL MARINO	\N	1.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	12334.28	2661
28	ESMALTE SINTETICO 1 LT VERDE CLARO	\N	3.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	12334.28	2662
29	ESMALTE SINTETICO 1 LT GRIS	\N	1.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	12334.28	2663
30	ESMALTE SINTETICO 1 LT AMARILLO	\N	1.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	12334.28	2664
31	ESMALTE SINTETICO 1 LT NEGRO MATE	\N	3.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	12334.28	2665
32	ESMALTE SINTETICO 1 LT BLANCO MATE	\N	2.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	12334.28	2666
33	FONDO BLANCO X 1 LT	\N	6.0000	0	1.0000	\N	0	0	60	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	10292.95	2667
35	FIJADOR AL AGUA X 1 LT	\N	4.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	5261.12	2669
36	CONVERTIDOR DE OXIDO X 1 LT NEGRO	\N	6.0000	0	1.0000	\N	0	0	10	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	8237.92	2670
37	BARNIZ MARINO X 1 LT SATINADO	\N	5.0000	0	1.0000	\N	0	0	10	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	7450.93	2671
38	BARNIZ MARINO X 1 LT BRILLANTE	\N	4.0000	0	1.0000	\N	0	0	10	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6903.31	2672
39	BARNIZ MARINO X 500 CC SATINADO	\N	5.0000	0	1.0000	\N	0	0	10	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	4656.42	2673
41	CONVERTIDOR DE OXIDO X 500 CC NEGRO	\N	6.0000	0	1.0000	\N	0	0	10	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	5149.45	2675
42	ESMALTE SINTETICO X 500 CC NARANJA	\N	1.0000	0	1.0000	\N	0	0	10	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6550.91	2676
43	ESMALTE SINTETICO X 500 CC VERDE INGLES	\N	1.0000	0	1.0000	\N	0	0	10	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6550.91	2677
44	ESMALTE SINTETICO X 500 CC CEDRO	\N	1.0000	0	1.0000	\N	0	0	10	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6550.91	2678
45	ESMALTE SINTETICO X 500 CC AZUL TRAFUL	\N	1.0000	0	1.0000	\N	0	0	10	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6550.91	2679
46	ESMALTE SINTETICO X 500 CC BLANCO	\N	1.0000	0	1.0000	\N	0	0	62	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6550.91	2680
47	ESMALTE SINTETICO X 500 CC MARFIL CHAMPA	\N	1.0000	0	1.0000	\N	0	0	60	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6550.91	2681
48	FONDO BLANCO X 500 CC	\N	6.0000	0	1.0000	\N	0	0	60	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6955.91	2682
49	SERRUCHO CARPINTERO SUPERCUT 22"	\N	1.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	19421.04	2683
50	SERRUCHO CARPINTERO PROFESIONAL 24"	\N	1.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	14785.04	2684
51	SERRUCHO CARPINTERO 20"	\N	3.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	12654.91	2685
52	SERRUCHO CARPINTERO 16"	\N	1.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	12310.33	2686
53	SERRUCHO CARPINTERO SUPERCUT 20"	\N	1.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	17761.74	2687
54	LLAVE COMBINADA 6MM	\N	3.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1785.54	2688
55	LLAVE COMBINADA 7MM	\N	3.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2004.73	2689
56	LLAVE COMBINADA 8MM	\N	5.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2067.35	2690
57	LLAVE COMBINADA 9MM	\N	5.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2098.66	2691
58	LLAVE COMBINADA 10MM	\N	5.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2129.98	2692
59	LLAVE COMBINADA 11MM	\N	6.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2192.75	2693
60	LLAVE COMBINADA 12MM	\N	4.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2255.38	2694
61	LLAVE COMBINADA 13MM	\N	4.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2380.62	2695
62	LLAVE COMBINADA 14MM	\N	4.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2693.90	2696
63	LLAVE COMBINADA 15MM	\N	4.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3132.42	2697
64	LLAVE COMBINADA 16MM	\N	4.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3383.06	2698
65	LLAVE COMBINADA 17MM	\N	5.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3758.96	2699
66	LLAVE COMBINADA 18MM	\N	6.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4197.48	2700
67	LLAVE COMBINADA 19MM	\N	6.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4228.79	2701
68	LLAVE COMBINADA 20MM	\N	6.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5231.08	2702
21	ESMALTE SINTETICO 1 LT AZUL TRAFUL	\N	2.5000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	12334.28	2655
69	LLAVE COMBINADA 21MM	\N	4.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5606.98	2703
34	ENDUIDO X 1 LT	\N	0.0000	0	1.0000	\N	0	0	61	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4720.04	2668
70	LLAVE COMBINADA 22MM	\N	4.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5857.62	2704
71	LLAVE COMBINADA 23MM	\N	4.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6202.21	2705
72	LLAVE COMBINADA 24MM	\N	3.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6578.10	2706
73	CRICKET 1/2" (10)	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	25059.33	2707
74	MANGO DE FUERZA 1/2" (10)	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	19389.73	2708
75	MANGO DE FUERZA 1/2" (15)	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	25936.37	2709
76	LLAVE COMBINADA 15MM	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4291.42	2710
77	LLAVE COMBINADA 16MM	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4385.35	2711
78	LLAVE COMBINADA 17MM	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5011.90	2712
79	LLAVE COMBINADA 18MM	\N	3.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5450.42	2713
80	LLAVE COMBINADA 19MM	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5669.75	2714
81	LLAVE COMBINADA 20MM	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6672.04	2715
82	LLAVE COMBINADA 21MM	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6860.06	2716
83	LLAVE COMBINADA 22MM	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7298.58	2717
84	LLAVE COMBINADA 23MM	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	8019.06	2718
85	LLAVE COMBINADA 24MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	8050.38	2719
86	LLAVE COMBINADA 25MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	9459.87	2720
87	LLAVE COMBINADA 26MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	9867.08	2721
88	LLAVE COMBINADA 28MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	12842.94	2722
89	TUBO ENCASTRE 1/2" 8MM	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2380.47	2723
90	TUBO ENCASTRE 1/2" 9MM	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2380.47	2724
91	TUBO ENCASTRE 1/2" 10MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2380.47	2725
92	TUBO ENCASTRE 1/2" 11MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2380.47	2726
93	TUBO ENCASTRE 1/2" 12MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2380.47	2727
94	TUBO ENCASTRE 1/2" 13MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2380.47	2728
95	TUBO ENCASTRE 1/2" 14MM	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2380.47	2729
96	TUBO ENCASTRE 1/2" 15MM	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2380.47	2730
97	TUBO ENCASTRE 1/2" 16MM	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2405.70	2731
98	TUBO ENCASTRE 1/2" 17MM	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2557.55	2732
964	FICHA HEMBRA INDUSTRIAL 10A NEGRA	\N	12.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1272.21	3663
14	ESMALTE SINTETICO 500 ML NEGRO BRILLANTE	\N	1.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6055.81	2648
793	TERMO AUTOCEBANTE X 750 ML NEGRO	\N	3.0000	0	1.0000	\N	0	0	125	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	14892.56	3493
99	TUBO ENCASTRE 1/2" 18MM	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2785.55	2777
756	TORNILLO PUNTA MECHA C/TANQUE 8 X 1/2	\N	214.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	11.04	3456
757	TORNILLO PUNTA MECHA C/TANQUE 8 X 3/4	\N	241.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	15.68	3457
785	TERMO AUTOCEBANTE X 500 ML NEGRO	\N	5.0000	0	1.0000	\N	0	0	125	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	13140.50	3485
100	TUBO ENCASTRE 1/2" 20MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3266.78	2799
101	TUBO ENCASTRE 1/2" 21MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3520.02	2800
102	TUBO ENCASTRE 1/2" 22MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3748.02	2801
103	TUBO ENCASTRE 1/2" 23MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3748.02	2802
104	TUBO ENCASTRE 1/2" 24MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4051.71	2803
105	TUBO ENCASTRE 1/2" 26MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4786.18	2804
106	TUBO ENCASTRE 1/2" 27MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4862.02	2805
107	TUBO ENCASTRE 1/2" 28MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5267.41	2806
108	TUBO ENCASTRE 1/2" LARGO 10MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4794.38	2807
109	TUBO ENCASTRE 1/2" LARGO 11MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4830.56	2808
110	TUBO ENCASTRE 1/2" LARGO 12MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4902.61	2809
111	TUBO ENCASTRE 1/2" LARGO 13MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5082.73	2810
112	TUBO ENCASTRE 1/2" LARGO 14MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5082.73	2811
113	TUBO ENCASTRE 1/2" LARGO 15MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5082.73	2812
114	TUBO ENCASTRE 1/2" LARGO 16MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5082.73	2813
115	TUBO ENCASTRE 1/2" LARGO 17MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5082.73	2814
116	TUBO ENCASTRE 1/2" LARGO 18MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5082.73	2815
117	TUBO ENCASTRE 1/2" LARGO 19MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5082.73	2816
118	TUBO ENCASTRE 1/2" LARGO 21MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5335.20	2817
119	TUBO ENCASTRE 1/2" LARGO 24MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5911.89	2818
120	TUBO ENCASTRE 1/2" LARGO 27MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6907.34	2819
121	AEROSOL SUPER COLOR 350ML BLANCO BRILLANTE	\N	2.0000	0	1.0000	\N	0	0	59	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	4462.81	2822
122	AEROSOL SUPER COLOR 350ML NEGRO BRILLANTE	\N	2.0000	0	1.0000	\N	0	0	59	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	4462.81	2823
123	AEROSOL SUPER COLOR 350ML BLANCO MATE	\N	1.0000	0	1.0000	\N	0	0	59	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	4462.81	2824
124	AEROSOL SUPER COLOR 350ML ROJO	\N	1.0000	0	1.0000	\N	0	0	59	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	4462.81	2825
125	AEROSOL SUPER COLOR 350ML BARNIZ	\N	2.0000	0	1.0000	\N	0	0	59	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	4462.81	2826
126	AEROSOL SUPER COLOR 200 ML NEGRO BRILLANTE	\N	3.0000	0	1.0000	\N	0	0	59	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2809.92	2827
127	AEROSOL SUPER COLOR 200 ML NEGRO MATE	\N	4.0000	0	1.0000	\N	0	0	59	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2809.92	2828
128	AEROSOL SUPER COLOR 200 ML MARRON	\N	1.0000	0	1.0000	\N	0	0	59	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2809.92	2829
129	AEROSOL SUPER COLOR 200 ML BLANCO MATE	\N	2.0000	0	1.0000	\N	0	0	59	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2809.92	2830
130	AEROSOL SUPER COLOR 200 ML BLANCO SATINADO	\N	5.0000	0	1.0000	\N	0	0	59	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2809.92	2831
131	AEROSOL SUPER COLOR 200 ML AZUL	\N	2.0000	0	1.0000	\N	0	0	59	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2809.92	2832
132	AEROSOL SUPER COLOR 200 ML AMARILLO	\N	3.0000	0	1.0000	\N	0	0	59	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2809.92	2833
133	AEROSOL SUPER COLOR 200 ML GRAFITO	\N	1.0000	0	1.0000	\N	0	0	59	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2809.92	2834
134	AEROSOL SUPER COLOR 200 ML ALUMINIO	\N	1.0000	0	1.0000	\N	0	0	59	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2809.92	2835
135	AEROSOL SUPER COLOR 200 ML VERDE OSCURO	\N	1.0000	0	1.0000	\N	0	0	59	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2809.92	2836
136	AEROSOL SUPER COLOR 200 ML ROJO	\N	2.0000	0	1.0000	\N	0	0	59	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2809.92	2837
137	AEROSOL SUPER COLOR 200 ML VERDE	\N	1.0000	0	1.0000	\N	0	0	59	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2809.92	2838
138	AEROSOL SUPER COLOR 200 ML NARANJA	\N	1.0000	0	1.0000	\N	0	0	59	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2809.92	2839
139	AEROSOL SUPER COLOR 200 ML BARNIZ	\N	2.0000	0	1.0000	\N	0	0	59	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2809.92	2840
140	MECHA C/AVELLANADOR 3MM - 7548	\N	3.0000	0	1.0000	\N	0	0	94	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	6	3402.65	2841
141	MECHA C/AVELLANADOR 4MM - 7549	\N	3.0000	0	1.0000	\N	0	0	94	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	6	3448.03	2842
142	MECHA C/AVELLANADOR 5MM - 7550	\N	3.0000	0	1.0000	\N	0	0	94	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	6	4336.80	2843
143	MECHA C/AVELLANADOR 6MM - 7551	\N	3.0000	0	1.0000	\N	0	0	94	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	6	3629.50	2844
144	MECHA C/AVELLANADOR 8MM - 7552	\N	3.0000	0	1.0000	\N	0	0	94	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	6	3810.98	2845
145	MECHA FOSNER PARA BISAGRA 26 MM - 7526	\N	3.0000	0	1.0000	\N	0	0	94	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	6	5172.04	2846
146	MECHA FOSNER PARA BISAGRA 26 MM - 7526	\N	3.0000	0	1.0000	\N	0	0	94	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	6	6896.05	2847
147	TIJERA AVIACION CORTE RECTO	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	21092.74	2848
148	PINZA UNIVERSAL 7"	\N	3.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	9476.74	2849
149	SERRUCHO P/DURLOCK 6"	\N	2.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	9563.23	2850
150	ESCUADRA METALICA 12" 30 cm	\N	1.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3730.38	2851
151	ESCUADRA METALICA 10" 25 cm	\N	1.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3730.38	2852
152	ARCO SIERRA MINI	\N	1.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2787.83	2853
153	ARCO SIERRA FIJO 12"	\N	6.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6296.14	2854
154	ARCO SIERRA 12" EXTENSIBLE	\N	2.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	11276.73	2855
155	ARCO SIERRA TRAMONTINA 12" FIJO PROFESIONAL	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	0.00	2856
156	LLAVE AJUSTABLE 15"	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	69377.97	2857
157	CAJA HERRAMIENTA PVC 13" CIERRE METAL	\N	1.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	11715.25	2858
158	CAJA HERRAMIENTA PVC 20" CIERRE METAL	\N	1.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	28838.66	2859
159	MECHA MADERA PLANA 1/2	\N	1.0000	0	1.0000	\N	0	0	44	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3748.69	2860
160	MECHA MADERA PLANA 3/8	\N	1.0000	0	1.0000	\N	0	0	44	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2563.61	2861
161	MECHA MADERA PLANA 3/4	\N	1.0000	0	1.0000	\N	0	0	44	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4361.47	2862
162	MECHA MADERA PLANA 1/4	\N	1.0000	0	1.0000	\N	0	0	44	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2472.76	2863
163	MECHA MADERA PLANA 1 3/8	\N	1.0000	0	1.0000	\N	0	0	44	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6420.76	2864
164	MECHA MADERA PLANA 1	\N	1.0000	0	1.0000	\N	0	0	44	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5422.33	2865
165	ARCO SIERRA 12" INYECTADO	\N	2.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	9682.40	2866
166	MECHA 3 PUNTAS 5 X 86	\N	2.0000	0	1.0000	\N	0	0	44	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1351.95	2867
167	MECHA 3 PUNTAS 8 X 117	\N	2.0000	0	1.0000	\N	0	0	44	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1831.55	2868
168	MECHA 3 PUNTAS 10 X 133	\N	2.0000	0	1.0000	\N	0	0	44	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2268.19	2869
169	MECHA 6 X 110 SDS PLUS	\N	1.0000	0	1.0000	\N	0	0	47	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1970.90	2870
170	MECHA 6 X 160 SDS PLUS	\N	1.0000	0	1.0000	\N	0	0	47	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2304.63	2871
171	MECHA SDS PLUS 6 x 310	\N	1.0000	0	1.0000	\N	0	0	45	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6648.31	2872
172	MECHA SDS PLUS 8 x 460	\N	1.0000	0	1.0000	\N	0	0	47	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	8264.81	2873
173	MECHA SDS PLUS 8 x 210	\N	2.0000	0	1.0000	\N	0	0	47	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3541.67	2874
174	MECHA SDS PLUS 10 x 160	\N	1.0000	0	1.0000	\N	0	0	47	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2774.05	2875
175	MECHA SDS PLUS 10 x 460	\N	1.0000	0	1.0000	\N	0	0	47	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	9741.67	2876
176	MECHA SDS PLUS 10 x 310	\N	2.0000	0	1.0000	\N	0	0	45	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4648.67	2877
177	MECHA SDS PLUS 12 x 350	\N	2.0000	0	1.0000	\N	0	0	47	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7527.71	2878
178	LLAVE AJUSTABLE 18"	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	106030.94	2879
179	MECHA WIDIA 8	\N	10.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2020.74	2880
180	MECHA WIDIA 10	\N	8.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2979.44	2881
181	MECHA WIDIA 14	\N	5.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6837.89	2882
182	MECHA WIDIA 14 X 400	\N	2.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	13614.88	2883
183	MECHA WIDIA 12 X 400	\N	1.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	10731.86	2884
184	CANDADO BRONCEADO 20MM	\N	4.0000	0	1.0000	\N	0	0	57	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1604.41	2885
185	CANDADO BRONCEADO 50 MM	\N	6.0000	0	1.0000	\N	0	0	57	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3883.70	2886
186	CANDADO BRONCEADO 63	\N	2.0000	0	1.0000	\N	0	0	57	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5774.88	2887
187	PINCEL CERDA BLANCA 1 VIROLA 1/2	\N	12.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	683.60	2888
189	PINCEL CERDA BLANCA 1 VIROLA 1/2	\N	17.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	900.26	2890
191	PINCEL CERDA BLANCA 1 VIROLA 2	\N	3.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1563.80	2892
192	PINCEL CERDA BLANCA 1 VIROLA 2 1/2	\N	10.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2034.21	2893
193	PINCEL CERDA BLANCA 1 VIROLA 3	\N	5.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2544.70	2894
194	PINCEL CERDA BLANCA PROFESIONAL 2 VIROLAS 1/2	\N	11.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	925.40	2895
195	PINCEL CERDA BLANCA PROFESIONAL 2 VIROLAS 3/4	\N	11.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1129.30	2896
196	PINCEL CERDA BLANCA PROFESIONAL 2 VIROLAS 1	\N	11.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1077.80	2897
197	PINCEL CERDA BLANCA PROFESIONAL 2 VIROLAS 1 1 /2	\N	11.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1700.29	2898
198	PINCEL CERDA BLANCA PROFESIONAL 2 VIROLAS 2	\N	12.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2411.22	2899
199	PINCEL CERDA BLANCA PROFESIONAL 2 VIROLAS 2 1/2	\N	10.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2992.64	2900
200	LLAVE STILSON 14''	\N	1.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	21688.58	2901
201	LLAVE STILSON 18''	\N	1.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	31341.18	2902
202	MARTILLO GALPONERO 27	\N	6.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	9334.62	2903
203	MARTILLO GALPONERO 29	\N	5.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	10744.12	2904
204	PINZA PRESION 10'' RECTA	\N	1.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	13338.61	2905
205	PINZA PRESION 10'' CURVA	\N	1.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	13338.61	2906
206	SOGA POLIPROPILENO METRO 2 MM	\N	58.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	58.25	2907
207	SOGA POLIPROPILENO METRO 4 MM	\N	46.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	65.21	2908
208	SOGA POLIPROPILENO METRO 6 MM	\N	80.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	171.09	2909
209	SOGA POLIPROPILENO METRO 8 MM	\N	80.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	307.77	2910
210	SOGA POLIPROPILENO METRO 10 MM	\N	360.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	469.54	2911
211	BULON HEXAGONAL BRONCEADO G5 SAE 7/16 X 3	\N	20.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	683.89	2912
212	BULON HEXAGONAL BRONCEADO G5 SAE 7/16 X 4	\N	19.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	490.59	2913
213	BULON HEXAGONAL BRONCEADO G5 SAE 7/16 X 5	\N	10.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	541.24	2914
214	BULON HEXAGONAL BRONCEADO G5 SAE 5/8 X 1 1/2	\N	10.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	690.94	2915
215	BULON HEXAGONAL BRONCEADO G5 SAE 5/8 X 2	\N	10.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	857.29	2916
216	BULON HEXAGONAL BRONCEADO G5 SAE 5/8 X 2 1/2	\N	9.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1002.86	2917
217	BULON HEXAGONAL BRONCEADO G5 SAE 1/2 X 1	\N	50.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4427.00	2918
218	BULON HEXAGONAL BRONCEADO G5 SAE 1/2 X 1 1/2	\N	50.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5307.23	2919
219	BULON HEXAGONAL BRONCEADO G5 SAE 1/2 X 2	\N	20.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5773.11	2920
220	BULON HEXAGONAL BRONCEADO G5 SAE 1/2 X 2 1/2	\N	20.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6100.15	2921
221	BULON HEXAGONAL BRONCEADO G5 SAE 7/16 X 1	\N	50.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	252.93	2922
222	BULON HEXAGONAL BRONCEADO G5 SAE 7/16 X 2	\N	25.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	403.04	2923
223	BULON HEXAGONAL BRONCEADO G5 SAE 5/16 X 1	\N	99.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	102.10	2924
224	BULON HEXAGONAL BRONCEADO G5 SAE 5/16 X 2	\N	98.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	164.86	2925
225	BULON HEXAGONAL BRONCEADO G5 SAE 5/16 X 2 1/2	\N	37.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	218.30	2926
226	BULON HEXAGONAL BRONCEADO G5 SAE 5/16 X 3	\N	50.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	250.63	2927
227	BULON HEXAGONAL BRONCEADO G5 SAE 5/16 X 1 1/2	\N	100.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	133.48	2928
228	BULON HEXAGONAL BRONCEADO G5 SAE 5/16 X 4	\N	44.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	331.53	2929
229	TORNILLO CABEZA REDONDA 5/16 X 2	\N	30.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	420.83	2930
230	BULON HEXAGONAL BRONCEADO G5 SAE 1/4 X 2	\N	47.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	102.10	2931
231	TUERCA MARIPOSA 1/4	\N	25.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	877.16	2932
232	TUERCA MARIPOSA 3/16	\N	50.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	126.31	2933
233	TUERCA MARIPOSA 1/8	\N	50.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	126.31	2934
234	PORTA LAMPARA CON CHICOTE E27	\N	122.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	716.11	2935
235	TUERCA MARIPOSA 8 X 1,25	\N	48.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	234.80	2936
236	TUERCA MARIPOSA 1/2	\N	46.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	877.16	2937
237	TUERCA MARIPOSA 3/8	\N	50.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	422.12	2938
238	TUERCA MARIPOSA 5 X 1	\N	25.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	234.80	2939
240	TUERCA MARIPOSA BRONCE 1/8	\N	48.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	510.40	2941
241	TUERCA MARIPOSA BRONCE 3/8	\N	25.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	924.84	2942
242	TUERCA MARIPOSA BRONCE 7/16	\N	25.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1305.43	2943
243	TUERCA MARIPOSA BRONCE 1/2	\N	25.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1305.43	2944
244	DESTORNILLADOR PLANO 6X200	\N	6.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1974.78	2945
245	DESTORNILLADOR PLANO 6X250	\N	5.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2213.12	2946
246	DESTORNILLADOR PHILLIPS 6X200	\N	6.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1634.30	2947
247	DESTORNILLADOR PHILLIPS 6X150	\N	6.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1464.06	2948
248	DESTORNILLADOR PHILLIPS 6X125	\N	4.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1464.06	2949
249	DESTORNILLADOR PHILLIPS 6X100	\N	4.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1464.06	2950
250	DESTORNILLADOR PHILLIPS 6X38	\N	6.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1055.49	2951
251	DESTORNILLADOR PHILLIPS 5X38	\N	6.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1055.49	2952
252	DESTORNILLADOR PHILLIPS 5X150	\N	4.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1259.78	2953
253	DESTORNILLADOR PHILLIPS 5X125	\N	6.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1464.06	2954
254	DESTORNILLADOR PHILLIPS 5X100	\N	5.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1464.06	2955
255	DESTORNILLADOR PHILLIPS 5X75	\N	4.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1157.63	2956
256	DESTORNILLADOR PHILLIPS 3X150	\N	5.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	953.34	2957
257	DESTORNILLADOR PHILLIPS 3X125	\N	6.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	885.25	2958
258	DESTORNILLADOR PHILLIPS 3X100	\N	6.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	885.25	2959
259	DESTORNILLADOR PHILLIPS 3X75	\N	8.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	885.25	2960
260	DESTORNILLADOR PHILLIPS 8X150	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3783.58	2961
261	DESTORNILLADOR PHILLIPS 6X200	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3902.75	2962
262	DESTORNILLADOR PHILLIPS 6X150	\N	0.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2949.41	2963
263	DESTORNILLADOR PHILLIPS 6X125	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2830.24	2964
264	DESTORNILLADOR PHILLIPS 6X100	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2770.66	2965
265	DESTORNILLADOR PHILLIPS 5X150	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2502.53	2966
266	DESTORNILLADOR PHILLIPS 5X125	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2383.36	2967
267	DESTORNILLADOR PHILLIPS 5X100	\N	3.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2323.78	2968
268	DESTORNILLADOR PHILLIPS 5X75	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2293.98	2969
269	DESTORNILLADOR PHILLIPS 5X38	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1966.27	2970
270	DESTORNILLADOR PHILLIPS 3X150	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2085.44	2971
271	DESTORNILLADOR PHILLIPS 3X125	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2293.98	2972
272	DESTORNILLADOR PHILLIPS 3X100	\N	3.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1966.27	2973
273	DESTORNILLADOR PHILLIPS 3X75	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1966.27	2974
274	DESTORNILLADOR PLANO 6X150	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2949.41	2975
275	DESTORNILLADOR PLANO 6X125	\N	3.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2830.24	2976
276	DESTORNILLADOR PLANO 6X100	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2800.45	2977
277	DESTORNILLADOR PLANO 5X150	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2711.07	2978
278	DESTORNILLADOR PLANO 5X125	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2562.11	2979
279	DESTORNILLADOR PLANO 5X75	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2562.11	2980
280	DESTORNILLADOR PLANO 3X75	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1966.27	2981
281	DESTORNILLADOR PLANO 3X100	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1996.08	2982
282	DESTORNILLADOR PLANO 3X125	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1996.08	2983
283	DESTORNILLADOR PLANO 3X150	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1996.08	2984
284	DESTORNILLADOR C/JGO PUNTAS INTERCAMB X 6U	\N	2.0000	0	1.0000	\N	0	0	76	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7284.90	2985
285	JUEGO DESTORNILLADOR X 6U	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6571.26	2986
286	FORMON 1 1/2	\N	1.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6421.39	2987
287	FORMON 1 1/4	\N	1.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5544.35	2988
288	FORMON 1	\N	2.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5074.52	2989
289	FORMON 7/8	\N	2.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4729.94	2990
290	FORMON 5/8	\N	2.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4103.54	2991
291	FORMON 1/2	\N	2.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3915.52	2992
292	FORMON 3/8	\N	1.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3884.21	2993
293	FORMON 1/4	\N	2.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4134.86	2994
294	BANDEJA CARTON 23X16 X100 U	\N	4.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	3193.17	2995
295	BANDEJA CARTON 17X15 X100 U	\N	5.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	1650.24	2996
296	BANDEJA CARTON 20X17 X100 U	\N	10.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	2058.44	2997
297	BANDEJA CARTON 29X26 UNIDAD	\N	38.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	3895.98	2998
298	BANDEJA PLASTICA OVALADA 23X18 UN	\N	730.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	43.68	2999
299	BANDEJA ALUMINIO REDONDA 24 CM UNIDAD	\N	49.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	132.56	3000
300	BANDEJA ALUMINIO REDONDA 27 CM UNIDAD	\N	50.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	151.30	3001
301	BANDEJA ALUMINIO REDONDA 30 CM UNIDAD	\N	50.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	216.44	3002
302	BANDEJA ALUMINIO RECTANGULAR 18X13 UNIDAD	\N	26.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	79.36	3003
303	BOLSA CAMISETA RESIST. AZUL 30X40 PAQ	\N	99.0000	0	1.0000	\N	0	0	88	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	473.00	3004
304	BOLSA CAMISETA FUNDA AMARILLA 30X40 PAQ	\N	100.0000	0	1.0000	\N	0	0	89	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	427.69	3005
305	BOLSA CAMISETA FUNDA AMARILLA 40X50 PAQ	\N	100.0000	0	1.0000	\N	0	0	89	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	764.82	3006
306	BOLSA CAMISETA FUNDA AMARILLA 45X60 PAQ	\N	46.0000	0	1.0000	\N	0	0	89	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	1475.40	3007
307	BOLSA CAMISETA RESIST. AZUL 40X50 PAQ	\N	95.0000	0	1.0000	\N	0	0	88	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	657.19	3008
308	BOLSA RESIDUO 50X70 ROLLO X 10 U	\N	9.0000	0	1.0000	\N	0	0	90	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	399.10	3009
309	BOLSA CONSORCIO 80X100 ROLLO X 10 U	\N	8.0000	0	1.0000	\N	0	0	91	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	941.49	3010
310	BOLSA CONSORCIO 60X90 ROLLO X 10 U	\N	8.0000	0	1.0000	\N	0	0	92	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	526.17	3011
311	BOLSA PAPEL KRAFT N5 PAQUETE X 100 U	\N	5.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	1415.46	3012
312	BOLSA PAPEL KRAFT N6L PAQUETE X 100 U	\N	5.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	1715.36	3013
313	BOLSA PAPEL KRAFT N7 PAQUETE X 100 U	\N	5.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	2007.08	3014
314	BOLSA CAMISETA SUPER REFORZADA 60X80 PAQUETE	\N	3.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	6358.23	3015
315	BOLSA CAMISETA SUPER REFORZADA 50X70 PAQUETE	\N	3.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	2445.60	3016
316	BOLSA CAMISETA SUPER REFORZADA 50X60 PAQUETE	\N	5.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	1992.75	3017
317	BOLSA CAMISETA SUPER REFORZADA 20X30 PAQUETE	\N	1.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	619.95	3018
318	BOLSA ARRANQUE 20X25 ROLLO	\N	40.0000	0	1.0000	\N	0	0	98	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	2042.88	3019
319	BOLSA ARRANQUE 15X25 ROLLO	\N	8.0000	0	1.0000	\N	0	0	88	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	1307.33	3020
320	BOLSA ARRANQUE 25X35 ROLLO	\N	21.0000	0	1.0000	\N	0	0	99	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	1675.66	3021
321	BOLSA ARRANQUE 40X50 ROLLO	\N	6.0000	0	1.0000	\N	0	0	88	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	4271.30	3022
322	BOLSA ARRANQUE 30X40 ROLLO	\N	6.0000	0	1.0000	\N	0	0	88	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	4784.30	3023
323	BOLSA ARRANQUE 40X50 ROLLO	\N	12.0000	0	1.0000	\N	0	0	99	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	1675.66	3024
324	BOLSA ARRANQUE 30X40 ROLLO	\N	12.0000	0	1.0000	\N	0	0	99	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	1675.66	3025
325	BOLSA ARRANQUE 35X45 ROLLO	\N	9.0000	0	1.0000	\N	0	0	88	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	3547.74	3026
326	BOLSA ARRANQUE 35X45 ROLLO	\N	12.0000	0	1.0000	\N	0	0	99	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	1675.66	3027
327	BOLSA ARRANQUE 20X30 ROLLO	\N	12.0000	0	1.0000	\N	0	0	99	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	1675.66	3028
328	BOLSA ARRANQUE 60X90 ROLLO	\N	3.0000	0	1.0000	\N	0	0	98	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	6704.39	3029
329	BOLSA ARRANQUE 50X60 ROLLO	\N	6.0000	0	1.0000	\N	0	0	98	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	4388.51	3030
330	BOLSA ARRANQUE 20X30 ROLLO	\N	1.0000	0	1.0000	\N	0	0	88	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	2838.47	3031
331	TOSTADOR ENLOZADO	\N	1.0000	0	1.0000	\N	0	0	100	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	4863.00	3032
332	COLADOR ALUMINIO N24	\N	2.0000	0	1.0000	\N	0	0	75	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	8086.00	3033
333	CUCHARA DE POSTRE NEW KOLOR X 3	\N	3.0000	0	1.0000	\N	0	0	76	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	2545.61	3034
334	TENEDOR NEW KOLOR X 3	\N	4.0000	0	1.0000	\N	0	0	76	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	2377.95	3035
335	CUCHILLO X UNIDAD	\N	10.0000	0	1.0000	\N	0	0	76	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	839.13	3036
336	CUCHARA CAFÉ ACERO X UNIDAD	\N	12.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	522.07	3037
337	CUCHARA POSTRE ACERO X UNIDAD	\N	6.0000	0	1.0000	\N	0	0	101	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	522.07	3038
338	TENEDOR POSTRE X UNIDAD	\N	6.0000	0	1.0000	\N	0	0	101	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	792.65	3039
339	CUCHARA POSTRE MANGO PLASTICO X UN	\N	5.0000	0	1.0000	\N	0	0	101	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	522.07	3040
340	CUCHILLO POSTRE ACERO X UNIDAD	\N	6.0000	0	1.0000	\N	0	0	101	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	839.13	3041
341	TERMO LUMILAGRO BANDERA X 950CC	\N	2.0000	0	1.0000	\N	0	0	74	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	15166.00	3042
342	VASO 1L SIN ASA ACERO	\N	2.0000	0	1.0000	\N	0	0	75	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	6496.00	3043
343	LECHERA ACERO INOX S/TAPA	\N	1.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	5880.00	3044
344	PAVA CHAROLADA N16	\N	1.0000	0	1.0000	\N	0	0	75	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	9675.00	3045
345	PAVA CHAROLADA N18	\N	2.0000	0	1.0000	\N	0	0	75	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	12255.00	3046
346	PALILLOS DE MADERA ENVASE	\N	8.0000	0	1.0000	\N	0	0	102	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	291.58	3047
347	TAZA DE CAFÉ X 280ML IMPERIAL X 3 UN	\N	1.0000	0	1.0000	\N	0	0	103	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	6197.94	3048
348	JARRO CAFÉ X 200ML UNIDAD	\N	3.0000	0	1.0000	\N	0	0	104	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	4545.45	3049
349	FRASCO VIDRIO HEXAGONAL CON TAPA	\N	12.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	826.45	3050
350	VASO TERMICO 240CC UNIDAD	\N	1000.0000	0	1.0000	\N	0	0	106	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	49.26	3051
351	VASO TERMICO 180CC UNIDAD	\N	1015.0000	0	1.0000	\N	0	0	106	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	46.12	3052
352	VASO PLASTICO DESC BLANCO 180 CC UN	\N	447.0000	0	1.0000	\N	0	0	109	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	18.54	3053
353	VASO PLASTICO DESCART TRANS. 110CC UN	\N	300.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	20.52	3054
354	VASO POLIPAPEL 12 OZ BLANCO	\N	50.0000	0	1.0000	\N	0	0	106	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	64.25	3055
355	DISPENSER JABON LIQUIDO P/AMURAR	\N	2.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	11634.23	3056
356	SORBETE PLASTICO DESCARTABLE	\N	800.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	3.56	3057
357	PLATO PLASTICO DESC TORTA PAQ X 50 U	\N	11.0000	0	1.0000	\N	0	0	108	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	1547.70	3058
358	GUANTE NITRILO TALLE L CAJA X 100U	\N	3.0000	0	1.0000	\N	0	0	112	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	3532.65	3059
359	GUANTE NITRILO TALLE L X PAR	\N	45.0000	0	1.0000	\N	0	0	112	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	90.00	3060
360	CUCHARA PLASTICA DESC SUNDAE X 50U	\N	2.0000	0	1.0000	\N	0	0	113	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	547.13	3061
361	TENEDOR PLASTICO DESC BLANCO X 50 U	\N	2.0000	0	1.0000	\N	0	0	113	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	767.62	3062
362	AEROSOL ESMALTE SINTETICO 440 CM3 AZUL	\N	4.0000	0	1.0000	\N	0	0	64	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	4911.56	3063
363	AEROSOL ESMALTE SINTETICO 440 CM3 VERDE	\N	6.0000	0	1.0000	\N	0	0	64	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	4911.56	3064
364	AEROSOL ESMALTE SINTETICO 440 CM3 NARANJA	\N	4.0000	0	1.0000	\N	0	0	64	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	4911.56	3065
365	AEROSOL ESMALTE SINTETICO 440 CM3 ROJO	\N	4.0000	0	1.0000	\N	0	0	64	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	4911.56	3066
366	AEROSOL ESMALTE SINTETICO 440 CM3 BLANCO MATE	\N	2.0000	0	1.0000	\N	0	0	64	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	4911.56	3067
367	AEROSOL ESMALTE SINTETICO 440 CM3 BLANCO SEAL	\N	6.0000	0	1.0000	\N	0	0	64	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	4911.56	3068
368	AEROSOL ESMALTE SINTETICO 440 CM3 NEGRO	\N	5.0000	0	1.0000	\N	0	0	64	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	4911.56	3069
369	AEROSOL ESMALTE SINTETICO 440 CM3 AMARILLO	\N	6.0000	0	1.0000	\N	0	0	64	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	4911.56	3070
370	AEROSOL ESMALTE SINTETICO 440 CM3 VIOLETA	\N	3.0000	0	1.0000	\N	0	0	64	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	4911.56	3071
371	CONVERTIDOR OXIDO 240 CM3 AEROSOL	\N	2.0000	0	1.0000	\N	0	0	35	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3232.60	3072
372	LATEX X 4L INT/EXT ESPLENDOR	\N	1.0000	0	1.0000	\N	0	0	68	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	9853.94	3073
373	ENDUIDO INTERIOR LINEA PRE X 4L	\N	1.0000	0	1.0000	\N	0	0	60	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	8713.43	3074
374	FONDO BLANCO X 4L	\N	4.0000	0	1.0000	\N	0	0	60	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	32954.38	3075
375	LATEX PARA FRENTE X 4L	\N	2.0000	0	1.0000	\N	0	0	77	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	16504.90	3076
376	FIJADOR AL AGUA X 4L	\N	2.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	12692.60	3077
377	LATEX BLANCO X 4L	\N	2.0000	0	1.0000	\N	0	0	63	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	9853.94	3078
378	ESMALTE ANTIOXIDO MARRON X4L	\N	2.0000	0	1.0000	\N	0	0	60	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	45519.83	3079
379	ESMALTE SINTETICO X 4L NEGRO MATE	\N	2.0000	0	1.0000	\N	0	0	77	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	27723.13	3080
380	ESMALTE SINTETICO X 4L ALUMINIO	\N	1.0000	0	1.0000	\N	0	0	77	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	40572.71	3081
381	ESMALTE SINTETICO X 4L BLANCO MATE	\N	1.0000	0	1.0000	\N	0	0	77	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	33836.00	3082
382	PRE-MEZCLA ADHESIVA PLASTICA MIX X 1250 GR	\N	3.0000	0	1.0000	\N	0	0	78	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3477.12	3083
383	PRE-MEZCLA ADHESIVA PLASTICA MIX X 500 GR	\N	3.0000	0	1.0000	\N	0	0	78	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2145.89	3084
384	ESMALTE SINTETICO X 4L NARANJA	\N	1.0000	0	1.0000	\N	0	0	77	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	40572.70	3085
385	LATEX PERFORMA INT/EXT BLANCO X4L	\N	3.0000	0	1.0000	\N	0	0	77	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	12654.60	3086
386	CONVERTIDOR OXIDO NEGRO X 4L	\N	2.0000	0	1.0000	\N	0	0	10	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	45519.83	3087
387	BARNIZ X 4L SATINADO	\N	4.0000	0	1.0000	\N	0	0	10	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	27396.02	3088
388	BARNIZ X 4L	\N	3.0000	0	1.0000	\N	0	0	10	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	25380.82	3089
389	LATEX PARA FRENTE PLAVIPINT X 1L	\N	6.0000	0	1.0000	\N	0	0	77	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	4327.30	3090
390	PASTA PULIR ZEOCAR FINA X 480 CM3	\N	2.0000	0	1.0000	\N	0	0	66	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	7465.51	3091
391	PASTA PULIR ZEOCAR GRUESA X 480 CM3	\N	2.0000	0	1.0000	\N	0	0	66	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	7465.51	3092
392	CAUCHO LIQUIDO EN AEROSOL 440 CM3 TRANSPARENTE	\N	3.0000	0	1.0000	\N	0	0	67	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	6	9509.47	3093
393	CAUCHO LIQUIDO EN AEROSOL 440 CM3 BLANCA	\N	3.0000	0	1.0000	\N	0	0	67	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	6	9509.47	3094
394	CAUCHO LIQUIDO EN AEROSOL 440 CM3 NEGRA	\N	3.0000	0	1.0000	\N	0	0	67	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	6	9509.47	3095
395	SELLADOR BASE CAUCHO EN GEL X 250 ML	\N	3.0000	0	1.0000	\N	0	0	67	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	6	6074.84	3096
396	SELLADOR BASE CAUCHO EN GEL X 500 ML	\N	2.0000	0	1.0000	\N	0	0	67	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	6	7920.19	3097
397	ENDUIDO X 1L EXTERIOR	\N	2.0000	0	1.0000	\N	0	0	60	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2518.82	3098
398	ALICATE UNIVERSAL 10"	\N	3.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	14538.50	3099
399	ALICATE UNIVERSAL 12"	\N	2.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	14894.27	3100
400	PINZA PICO LORO 10"	\N	5.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	14553.85	3101
401	LLAVE FUERZA STILSON 10"	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	23399.18	3102
402	PINZA DE PUNTA 6"	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	13019.10	3103
403	PINZA UNIVERSAL 8"	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	14538.50	3104
404	PINZA UNIVERSAL 7"	\N	3.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	13138.27	3105
405	PINZA PICO LORO 12"	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	28005.54	3106
406	LLAVE AJUSTABLE 6"	\N	2.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	8300.87	3107
407	JUEGO DE LLAVES 6 PIEZAS	\N	2.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	15670.59	3108
408	JUEGO DE LLAVES 8 PIEZAS	\N	2.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	20824.61	3109
409	JUEGO DE LLAVES 10 PIEZAS	\N	2.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	25442.37	3110
410	TIJERA DE PODA 7MM	\N	2.0000	0	1.0000	\N	0	0	76	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6296.14	3111
411	TIJERA DE PODA 17MM	\N	3.0000	0	1.0000	\N	0	0	76	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	31085.82	3112
412	MECHA WIDIA COMUN 22	\N	2.0000	0	1.0000	\N	0	0	47	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	23444.45	3113
413	MECHA WIDIA COMUN 12 X 200	\N	0.0000	0	1.0000	\N	0	0	47	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	12384.95	3114
414	MECHA WIDIA COMUN 10	\N	12.0000	0	1.0000	\N	0	0	47	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3552.90	3115
415	MECHA WIDIA COMUN 8 X 200	\N	1.0000	0	1.0000	\N	0	0	47	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	792.72	3116
416	MECHA ACERO RAPIDO 1,00 MM	\N	1.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1117.53	3117
417	MECHA ACERO RAPIDO 1,50 MM	\N	0.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1117.53	3118
418	MECHA ACERO RAPIDO 2,00 MM	\N	13.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	978.77	3119
419	MECHA ACERO RAPIDO 2,25 MM	\N	10.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	978.77	3120
420	MECHA ACERO RAPIDO 2,50 MM	\N	7.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	978.77	3121
421	MECHA ACERO RAPIDO 2,75 MM	\N	14.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1003.20	3122
422	MECHA ACERO RAPIDO 3,00 MM	\N	11.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1060.49	3123
423	MECHA ACERO RAPIDO 3,25 MM	\N	10.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1119.92	3124
424	MECHA ACERO RAPIDO 3,50 MM	\N	6.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1192.89	3125
425	MECHA ACERO RAPIDO 3,75 MM	\N	11.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1298.15	3126
427	MECHA ACERO RAPIDO 4,50 MM	\N	32.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1849.55	3128
429	MECHA ACERO RAPIDO 5,50 MM	\N	15.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2387.74	3130
430	MECHA ACERO RAPIDO 6,00 MM	\N	6.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2528.31	3131
431	MECHA ACERO RAPIDO 6,50 MM	\N	6.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2943.92	3132
432	MECHA ACERO RAPIDO 7,00 MM	\N	4.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	370.45	3133
433	MECHA ACERO RAPIDO 7,50 MM	\N	3.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3933.58	3134
434	MECHA ACERO RAPIDO 8,00 MM	\N	5.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4645.23	3135
435	MECHA ACERO RAPIDO 8,50 MM	\N	2.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5026.47	3136
436	MECHA ACERO RAPIDO 8,75 MM	\N	3.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5467.47	3137
437	MECHA ACERO RAPIDO 4,25 MM	\N	10.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1683.06	3138
439	MECHA ACERO RAPIDO 5,25 MM	\N	10.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2200.19	3140
440	MECHA ACERO RAPIDO 5,75 MM	\N	10.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2467.21	3141
441	MECHA ACERO RAPIDO 6,25MM	\N	10.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2856.76	3142
442	MECHA ACERO RAPIDO 6,75 MM	\N	2.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3401.24	3143
443	MECHA ACERO RAPIDO 7,25 MM	\N	2.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3763.15	3144
444	MECHA ACERO RAPIDO 7,75 MM	\N	2.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4361.79	3145
445	MECHA ACERO RAPIDO 8,25 MM	\N	2.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5002.64	3146
447	MECHA ACERO RAPIDO 9,00 MM	\N	2.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5745.89	3147
448	MECHA ACERO RAPIDO 9,25 MM	\N	2.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6118.72	3148
449	MECHA ACERO RAPIDO 9,50 MM	\N	2.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6373.43	3149
450	MECHA ACERO RAPIDO 9,75 MM	\N	2.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6913.30	3150
451	MECHA ACERO RAPIDO 10,00 MM	\N	13.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7290.41	3151
452	MECHA ACERO RAPIDO 10,25 MM	\N	2.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	8621.44	3152
453	MECHA ACERO RAPIDO 10,50 MM	\N	3.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	8930.50	3153
454	MECHA ACERO RAPIDO 10,75 MM	\N	2.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	9732.49	3154
455	MECHA ACERO RAPIDO 11,00 MM	\N	3.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	10024.64	3155
456	MECHA ACERO RAPIDO 11,25 MM	\N	2.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	10778.45	3156
457	MECHA ACERO RAPIDO 11,50 MM	\N	2.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	11003.38	3157
458	MECHA ACERO RAPIDO 11,75 MM	\N	1.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	11741.39	3158
459	MECHA ACERO RAPIDO 12,00 MM	\N	3.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	12452.33	3159
460	MECHA ACERO RAPIDO 12,25 MM	\N	1.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	13489.81	3160
461	MECHA ACERO RAPIDO 12,50 MM	\N	2.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	13981.76	3161
462	MECHA ACERO RAPIDO 12,75 MM	\N	2.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	15344.30	3162
463	MECHA ACERO RAPIDO 13,00 MM	\N	2.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	15785.52	3163
464	MECHA ACERO RAPIDO 13,50 MM	\N	2.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	29950.20	3164
465	MECHA ACERO RAPIDO 14,00 MM	\N	0.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	31789.20	3165
466	CANDADOS ROTTWEILLER 60MM PERNO HORIZONTAL	\N	6.0000	0	1.0000	\N	0	0	55	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7961.03	3166
467	CANDADOS TITANIO ARO LARGO 30MM	\N	12.0000	0	1.0000	\N	0	0	54	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4219.83	3167
468	CANDADOS TITANIO ARO LARGO 40MM	\N	11.0000	0	1.0000	\N	0	0	54	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5253.63	3168
469	CANDADOS TITANIO ARO LARGO 50MM	\N	8.0000	0	1.0000	\N	0	0	54	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	8037.56	3169
470	CANDADOS TITANIO 25MM	\N	5.0000	0	1.0000	\N	0	0	54	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2906.00	3170
471	CANDADOS TITANIO 30MM	\N	11.0000	0	1.0000	\N	0	0	54	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3716.35	3171
472	CANDADOS TITANIO 40MM	\N	15.0000	0	1.0000	\N	0	0	54	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4512.58	3172
473	CANDADOS TITANIO 50MM	\N	9.0000	0	1.0000	\N	0	0	54	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6903.39	3173
474	CANDADOS TITANIO 60MM	\N	8.0000	0	1.0000	\N	0	0	54	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	9101.39	3174
475	CANDADOS BRONCE 700 MEDIUN 30MM	\N	1.0000	0	1.0000	\N	0	0	54	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7895.27	3175
476	CANDADOS KRONOS 60MM	\N	2.0000	0	1.0000	\N	0	0	54	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6668.96	3176
477	DESTORNILLADOR PHILIPS 409 A -3-150	\N	5.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4396.42	3177
478	DESTORNILLADOR PHILIPS 409 A -2-150	\N	3.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3127.48	3178
479	DESTORNILLADOR PHILIPS 409 A -1-125	\N	5.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2734.41	3179
480	DESTORNILLADOR PHILIPS 409 A -2-125	\N	5.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3127.48	3180
481	DESTORNILLADOR PHILIPS 409 A -2-100	\N	5.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2734.41	3181
482	DESTORNILLADOR PHILIPS 409 A -1-100	\N	4.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2734.41	3182
483	LLAVE COMBINADA 6MM	\N	3.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3101.10	3183
484	LLAVE COMBINADA 7MM	\N	3.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3132.42	3184
485	LLAVE COMBINADA 8MM	\N	3.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3195.04	3185
486	LLAVE COMBINADA 9MM	\N	3.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3226.35	3186
487	LLAVE COMBINADA 10MM	\N	3.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3257.66	3187
488	LLAVE COMBINADA 11MM	\N	3.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3445.69	3188
489	LLAVE COMBINADA 12MM	\N	3.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3570.97	3189
490	LLAVE COMBINADA 13MM	\N	3.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3664.87	3190
491	LLAVE COMBINADA 14MM	\N	3.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4197.48	3191
492	LLAVE COMBINADA 15MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4291.42	3192
493	LLAVE COMBINADA 16MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4385.35	3193
494	LLAVE COMBINADA 17MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5011.90	3194
495	LLAVE COMBINADA 19MM	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5669.75	3195
496	LLAVE COMBINADA 7/8"	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7705.79	3196
497	LLAVE COMBINADA 1"	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	9459.87	3197
498	LLAVE COMBINADA 9/16"	\N	3.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4322.76	3198
499	LLAVE COMBINADA 11/16"	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5011.90	3199
500	LLAVE COMBINADA 3/4"	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5980.25	3200
501	LLAVE COMBINADA 5/8"	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4510.75	3201
502	LLAVE COMBINADA 1/2"	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3758.96	3202
503	LLAVE COMBINADA 7/16"	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3539.62	3203
504	LLAVE COMBINADA 3/8"	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3383.06	3204
505	LLAVE COMBINADA 5/16"	\N	3.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3195.04	3205
506	LLAVE COMBINADA 1/4"	\N	2.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3163.73	3206
507	LLAVE MEDIA LUNA 10X12	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7184.13	3207
508	LLAVE MEDIA LUNA 10X16	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7184.13	3208
509	LLAVE MEDIA LUNA 11X13	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7286.27	3209
510	LLAVE MEDIA LUNA 15X17	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	8171.52	3210
511	LLAVE MEDIA LUNA 19X22	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	8988.67	3211
512	TUBO SACA BUJIAS 16 MM(44715/016)	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6734.66	3212
513	TUBO SACA BUJIAS 21 MM(44715/021)	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6954.00	3213
514	MANGO DE FUERZA 1/2 (44835/110)	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	19389.73	3214
515	PROLONGACION 1/2 (44836/105)	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	9773.14	3215
516	PROLONGACION 1/2 (44836/110)	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	11558.69	3216
517	MOVIMIENTO UNIVERSAL 1/2 (44838/001)	\N	1.0000	0	1.0000	\N	0	0	39	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5520.64	3217
518	ANAFE 2000W (2018)	\N	1.0000	0	1.0000	\N	0	0	87	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	35171.90	3218
519	JUEGO DE TUBOS 129-101-4	\N	2.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	151934.62	3219
520	JUEGO DE TUBOS 129-58-4	\N	2.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	152278.27	3220
521	PRENSA SARGENTO AUTOMATICO 254-450-2	\N	3.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	10054.25	3221
522	PRENSA SARGENTO AUTOMATICO 254-600-2	\N	2.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	11356.41	3222
523	JUEGO DE PUNTAS 475-32-1 (1/4X32)	\N	1.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	19562.81	3223
524	DESTORNILLADOR PORTA PUNTAS 47512-1/4-110	\N	1.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	28403.69	3224
525	MANGO DE FUERZA 1/2 125-52-1 (375 MM)	\N	1.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	15381.54	3225
526	PINZA PICO LORO 459A-6-B	\N	4.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	14283.18	3226
527	PINZA PICO LORO 459A-9-B	\N	1.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	14597.28	3227
528	JUEGO TUBOS CON CRIKET 1/2 129-12-4	\N	1.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	39508.43	3228
529	CUTTER 668-150-1	\N	1.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5297.89	3229
530	ALICATE 624-160	\N	0.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	12461.81	3230
531	JUEGO LLAVES ALLEN 48-9-H	\N	4.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	14094.90	3231
532	LLAVE FRANCESA 12"	\N	3.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	27945.64	3232
533	LLAVE FRANCESA 10"	\N	2.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	17251.57	3233
534	LLAVE FRANCESA 8"	\N	3.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	12802.10	3234
535	LLAVE FRANCESA 6"	\N	1.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	9482.56	3235
536	CRIKET 125-70-1	\N	2.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	20899.72	3236
537	CRIKET 105-70-1	\N	1.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	21480.14	3237
538	MANGO DE FUERZA 125-52-1	\N	1.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	15381.54	3238
539	PROLONGADOR 125-23-1	\N	2.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5640.00	3239
540	ALICATE 632-220-AC5	\N	1.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	15112.29	3240
541	PINZA DE PUNTA 612-200	\N	1.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	12121.46	3241
542	PINZA UNIVERSAL 601-180	\N	1.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	13405.16	3242
543	LINTERNA A PILAS	\N	7.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3820.87	3243
544	LLAVE COMBINADA 9MM	\N	3.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3757.36	3244
545	LLAVE COMBINADA 10MM	\N	1.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4251.53	3245
546	LLAVE COMBINADA 11MM	\N	4.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4456.06	3246
547	LLAVE COMBINADA 12MM	\N	4.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4525.54	3247
548	LLAVE COMBINADA 13MM	\N	4.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4830.79	3248
549	LLAVE COMBINADA 14MM	\N	4.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5348.37	3249
550	LLAVE COMBINADA 15MM	\N	4.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5887.81	3250
551	LLAVE COMBINADA 16MM	\N	3.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6471.75	3251
552	LLAVE COMBINADA 17MM	\N	3.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7846.51	3252
553	LLAVE COMBINADA 18MM	\N	3.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	8022.66	3253
554	LLAVE COMBINADA 19MM	\N	3.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	8588.15	3254
555	LLAVE COMBINADA 20MM	\N	2.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	9280.61	3255
556	LLAVE COMBINADA 21MM	\N	2.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	10172.91	3256
557	LLAVE COMBINADA 24MM	\N	2.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	13536.82	3257
558	DESTORNILLADOR PLANO 407A-4-100	\N	5.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2734.41	3258
559	DESTORNILLADOR PLANO 407A-4-125	\N	5.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3127.48	3259
560	DESTORNILLADOR PLANO 407A-55-100	\N	5.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2734.41	3260
561	DESTORNILLADOR PLANO 407A-55-125	\N	5.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3127.48	3261
562	DESTORNILLADOR PLANO 407A-55-150	\N	5.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3127.48	3262
563	DESTORNILLADOR PLANO 407A-8-150	\N	5.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4396.42	3263
564	PANEL LED CUADRADO APLICAR 12 W CALIDA	\N	5.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	6699.17	3264
565	PANEL LED REDONDO APLICAR 12 W CALIDA	\N	3.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	6699.17	3265
566	PANEL LED CUADRADO APLICAR 6 W CALIDA	\N	4.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	2947.19	3266
567	PANEL LED CUADRADO APLICAR 6 W FRIA	\N	4.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	2947.19	3267
568	PANEL LED REDONDO APLICAR 6 W FRIA	\N	7.0000	0	1.0000	\N	0	0	19	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3947.19	3268
569	PANEL LED REDONDO 6 W FRIA	\N	4.0000	0	1.0000	\N	0	0	96	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	4575.51	3269
570	PANEL LED REDONDO 12 W FRIA	\N	5.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	4064.63	3270
571	PANEL LED CUADRADO 12 W FRIA	\N	6.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	3677.69	3271
572	PANEL LED REDONDO 12 W FRIA	\N	6.0000	0	1.0000	\N	0	0	19	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6699.17	3272
573	PANEL LED CUADRADO 24 W CALIDA	\N	4.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	8871.68	3273
574	PANEL LED REDONDO 18 W CALIDA	\N	2.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	7421.48	3274
575	PANEL LED REDONDO 18 W FRIO	\N	4.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	7421.48	3275
576	PANEL LED CUADRADO 24 W CALIDA	\N	6.0000	0	1.0000	\N	0	0	19	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	8871.68	3276
577	LAMPARA LED 6,5W CALIDA	\N	7.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	561.98	3277
578	LAMPARA LED 6,5W FRIA	\N	11.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	561.98	3278
579	LAMPARA LED 7W FRIA	\N	15.0000	0	1.0000	\N	0	0	96	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	561.98	3279
580	LAMPARA LED 5,5W FRIA	\N	30.0000	0	1.0000	\N	0	0	105	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	18	561.98	3280
581	LAMPARA LED 9W FRIA	\N	1.0000	0	1.0000	\N	0	0	19	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	923.70	3281
582	LAMPARA LED 9,5W FRIA	\N	4.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	578.51	3282
583	LAMPARA LED 11,5W FRIA	\N	12.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	743.80	3283
584	LAMPARA LED 14,5W FRIA	\N	3.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	867.77	3284
585	LAMPARA LED 14,5W CALIDA	\N	9.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	867.77	3285
586	LAMPARA LED 14W FRIA	\N	7.0000	0	1.0000	\N	0	0	19	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1355.54	3286
587	LAMPARA LED 14W CALIDA	\N	2.0000	0	1.0000	\N	0	0	19	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1355.54	3287
588	LAMPARA LED 7W FRIA	\N	1.0000	0	1.0000	\N	0	0	19	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	852.26	3288
589	LAMPARA LED 15W FRIA	\N	1.0000	0	1.0000	\N	0	0	18	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	884.18	3289
590	LAMPARA DICROICA 7W CALIDA	\N	1.0000	0	1.0000	\N	0	0	19	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1567.88	3290
591	LAMPARA DICROICA 7W CALIDA	\N	8.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	909.10	3291
592	LAMPARA DICROICA 5W CALIDA	\N	5.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	826.45	3292
593	LAMPARA DICROICA 7W FRIA	\N	5.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	909.10	3293
594	LAMPARA DICROICA 5W FRIA	\N	11.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	826.45	3294
595	LAMPARA LED 12W FRIA	\N	50.0000	0	1.0000	\N	0	0	110	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	18	679.00	3295
596	LAMPARA LED 15W FRIA	\N	50.0000	0	1.0000	\N	0	0	110	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	18	833.00	3296
597	LAMPARA GALPONERA 50 W	\N	50.0000	0	1.0000	\N	0	0	111	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	18	4404.13	3297
598	PROYECTOR LED FRIO 10W	\N	5.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	2933.88	3298
599	PROYECTOR LED FRIO 30W	\N	1.0000	0	1.0000	\N	0	0	95	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	18	2933.88	3299
600	PROYECTOR LED FRIO 50W	\N	3.0000	0	1.0000	\N	0	0	111	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	18	4321.00	3300
601	PROYECTOR LED FRIO 50W	\N	3.0000	0	1.0000	\N	0	0	110	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	18	4321.00	3301
602	CAJA RECTANGULAR EXTERIOR PVC 10X5	\N	14.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1251.32	3302
603	PORTA LAMPARA EDISON 3 PIEZAS E27	\N	18.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	925.58	3303
604	PLANCHA A VAPOR ES2350	\N	1.0000	0	1.0000	\N	0	0	69	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	14876.03	3304
605	BATIDORA B-1500 BL	\N	1.0000	0	1.0000	\N	0	0	70	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	10126.75	3305
606	PAVA ELECTRICA AC. INOXIDABLE 2 LT	\N	9.0000	0	1.0000	\N	0	0	71	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	7988.98	3306
607	CAFETERA CF1500MG 12 TAZAS	\N	1.0000	0	1.0000	\N	0	0	70	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	20264.77	3307
608	TOSTADORA VL-307 T	\N	3.0000	0	1.0000	\N	0	0	72	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	13223.14	3308
609	LICUADORA OPTIMIX PLUS	\N	2.0000	0	1.0000	\N	0	0	73	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	56132.71	3309
610	TOALLAS INTERCALADAS 4 PANELES 19X24 CM X 100U	\N	5.0000	0	1.0000	\N	0	0	79	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	7364.40	3310
611	SERVILLETAS BLANCAS 18X18 CM X 850U	\N	80.0000	0	1.0000	\N	0	0	80	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	3842.00	3311
612	BANDEJA RECTANGULAR PLASTICA TRANS 15X10 X 100U	\N	12.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	24.60	3312
613	BANDEJA RECTANGULAR PLASTICA TRANS 18X12 X 100U	\N	10.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	31.15	3313
614	SERVILLETAS 32X27 CM X 850U	\N	2.0000	0	1.0000	\N	0	0	81	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	6883.30	3314
615	TOALLAS INTERCALADAS 19X24 CM X 2250 U	\N	1.0000	0	1.0000	\N	0	0	82	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	18640.68	3315
616	TERMO PICO CEBADOR TO270 950CC	\N	2.0000	0	1.0000	\N	0	0	74	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	8975.00	3316
617	BATIDOR DE ALAMBRE N30	\N	2.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	3668.59	3317
618	JARRO ALUMINIO	\N	2.0000	0	1.0000	\N	0	0	75	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	5880.00	3318
619	COMPOTERA VIDRIO 425ML	\N	36.0000	0	1.0000	\N	0	0	86	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	1300.00	3319
620	TAZON AMANECER 370ML	\N	36.0000	0	1.0000	\N	0	0	86	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	1392.50	3320
621	OLLA ALUMINIO N24 5,5LT C/TAPA	\N	2.0000	0	1.0000	\N	0	0	83	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	20696.00	3321
622	ENSALADERA VIDRIO GRANDE	\N	12.0000	0	1.0000	\N	0	0	86	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	2272.50	3322
623	PLATO HONDO VIDRIO X 780 ML	\N	34.0000	0	1.0000	\N	0	0	86	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	1212.50	3323
624	PLATO PLAYO VIDRIO	\N	35.0000	0	1.0000	\N	0	0	86	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	1212.50	3324
625	CUCHILLO PAN INOX. 1405 BR	\N	6.0000	0	1.0000	\N	0	0	84	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	3890.00	3325
626	PIZZERA N35 REFORZADA ALUMINIO	\N	6.0000	0	1.0000	\N	0	0	75	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	4464.00	3326
627	ESPATULA 27 CM C/ORIFICIOS ACERO INOX	\N	1.0000	0	1.0000	\N	0	0	85	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	4999.00	3327
628	VASOS COPO X 290 ML JUEGO X 6 UNIDADES	\N	8.0000	0	1.0000	\N	0	0	86	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	5950.00	3328
629	COPA DUBLIN CERVEZA	\N	12.0000	0	1.0000	\N	0	0	103	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	3467.00	3329
630	RALLADOR 21 CM 4 CARAS ACERO INOX	\N	2.0000	0	1.0000	\N	0	0	41	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	3875.00	3330
631	COLADOR DE MANO 7,5 CM ACERO. INOX.	\N	2.0000	0	1.0000	\N	0	0	41	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	2738.00	3331
632	CUCHARA SOPERA NEW KOLOR X 3U	\N	2.0000	0	1.0000	\N	0	0	76	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	2545.61	3332
634	CABLE 1X1 BLANCO X MTS	\N	100.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	249.55	3334
635	CABLE 1X2,5 NEGRO X MTS	\N	80.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	531.78	3335
636	CABLE 1X1,5 AZUL	\N	20.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	311.62	3336
637	CABLE 1X2,5 MARRON X MTS	\N	80.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	531.78	3337
638	DESTORNILLADOR PLANO 3X100	\N	5.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	749.06	3338
639	DESTORNILLADOR PLANO 3X125	\N	6.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	814.15	3339
640	DESTORNILLADOR PLANO 3X75	\N	5.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	715.01	3340
641	DESTORNILLADOR PLANO 5X100	\N	6.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	987.39	3341
642	DESTORNILLADOR PLANO 5X125	\N	5.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1157.63	3342
643	DESTORNILLADOR PLANO 5X150	\N	5.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1259.78	3343
644	DESTORNILLADOR PLANO 6X100	\N	6.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1327.87	3344
645	DESTORNILLADOR PLANO 6X125	\N	6.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1395.97	3345
646	DESTORNILLADOR PLANO 6X150	\N	4.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1395.97	3346
647	DESTORNILLADOR PLANO 6X200	\N	6.0000	0	1.0000	\N	0	0	42	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1974.78	3347
648	CINTA METRICA ECONOMICA 3M	\N	4.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3542.50	3348
649	CINTA METRICA ECONOMICA 5M	\N	4.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4567.50	3349
650	CINTA METRICA ECONOMICA 7,5M	\N	1.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	8267.50	3350
651	CINTA METRICA ECONOMICA 10M	\N	2.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	10130.00	3351
652	TORNILLOC/FRESADA 1/8X1	\N	100.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	109.44	3352
653	TORNILLOC/FRESADA 1/2X2	\N	105.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	139.45	3353
654	TORNILLOC/FRESADA 3/16X5/8	\N	199.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	153.82	3354
655	CINTA METRICA ART. 102 2MT	\N	2.0000	0	1.0000	\N	0	0	46	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4181.84	3355
656	CINTA METRICA ART. 103 3MT	\N	4.0000	0	1.0000	\N	0	0	46	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5468.25	3356
657	CINTA METRICA ART. 525 5MT	\N	3.0000	0	1.0000	\N	0	0	46	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	12623.40	3357
658	CINTA METRICA ART. 508 8MT	\N	2.0000	0	1.0000	\N	0	0	46	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	19101.20	3358
659	CINTA METRICA ART. 510 10MT	\N	4.0000	0	1.0000	\N	0	0	46	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	23633.95	3359
660	CINTAMETRICA 3MT ART. 980	\N	7.0000	0	1.0000	\N	0	0	40	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	6	3926.59	3360
661	LLAVE MANDRIL COD. EVOL1970 13 MM	\N	3.0000	0	1.0000	\N	0	0	55	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1333.76	3361
662	GIRA MACHO 5/32 A 1/4	\N	1.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5307.48	3362
663	GIRA MACHO 7/32 A 3/8	\N	1.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7315.38	3363
664	GIRA MACHO 3/32 A 1/6	\N	1.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4686.48	3364
665	GIRA MACHO 3/8 A 1/2	\N	1.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	8822.34	3365
666	MANDRIL P/TALADRO C/LLAVE 10 MM ROSCA 3/8	\N	1.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7154.58	3366
667	LLAVE MANDRIL EVOL1960 10 MM	\N	1.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1047.96	3367
668	TORNILLO GALV. C/TANQUE 5/32X1 1/2	\N	100.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	38.24	3368
669	TORNILLO GALV. C/TANQUE 1/4X1 1/2	\N	100.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	95.21	3369
670	TORNILLO GALV. C/TANQUE 3/16X1 3/4	\N	92.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	52.90	3370
671	TORNILLO GALV. C/TANQUE 3/16X5/8	\N	57.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	25.97	3371
672	TORNILLO GALV. C/TANQUE 3/16X7/8	\N	91.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	31.74	3372
673	TORNILLO GALV. C/TANQUE 5/32X1 1/2	\N	99.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	38.24	3373
674	TORNILLO GALV. C/TANQUE 3/16X1 1/4	\N	89.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	39.43	3374
675	GRAMPA CAJONERA 12X16	\N	2500.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6.63	3375
676	GRAMPA P/CABLE 2"	\N	624.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	75.10	3376
677	GRAMPA P/CABLE 1 1/2"	\N	300.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	49.02	3377
678	GRAMPA P/CABLE 1"	\N	572.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	36.51	3378
679	BULON CARROCERO 9X70	\N	48.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	201.23	3379
680	BULON CARROCERO 8X120	\N	10.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	226.00	3380
681	BULON CARROCERO 8X13	\N	20.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	244.58	3381
682	BULON CARROCERO 8X90	\N	57.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	170.27	3382
683	BULON CARROCERO 8X70	\N	50.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	138.69	3383
684	BULON CARROCERO 11X70	\N	24.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	255.85	3384
685	BULON CARROCERO 11X110	\N	19.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	473.45	3385
686	BULON CARROCERO 9X32	\N	49.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	130.34	3386
687	BULON CARROCERO 6X50	\N	90.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	63.00	3387
688	ARANDELA PRESION 3/8	\N	500.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	17.72	3388
689	ARANDELA PRESION 5/8	\N	125.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	66.04	3389
690	ARANDELA PRESION 5/16	\N	1168.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	12.74	3390
691	ARANDELA PRESION 7/16	\N	258.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	25.63	3391
692	ARANDELA PRESION 9/16	\N	125.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	49.52	3392
693	ARANDELA PRESION 1/4	\N	1912.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7.91	3393
694	ARANDELA PRESION 3/4	\N	50.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	108.40	3394
695	ARANDELA PRESION 5/32	\N	1050.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3.64	3395
696	ARANDELA PRESION 3/16	\N	1026.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3.90	3396
697	BULON CABEZA HEXAG. 5/16X4	\N	90.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	331.53	3397
698	ARANDELA PRESION 1"	\N	50.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	242.97	3398
699	ARANDELA PRESION 7/8	\N	47.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	168.76	3399
700	ARANDELA PRESION 1 1/2	\N	25.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	711.47	3400
701	ARANDELA PRESION 10MM	\N	495.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	14.23	3401
702	ARANDELA PRESION 12MM	\N	250.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	21.12	3402
703	ARANDELA CUBETA	\N	38.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	76.15	3403
704	ARANDELA PLANA 1/8	\N	2200.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4.99	3404
705	ARANDELA PLANA 3/16	\N	1038.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4.60	3405
706	ARANDELA PLANA HIERRO 1/4	\N	1592.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4.81	3406
707	ARANDELA PLANA 9/16	\N	67.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	34.00	3407
708	ARANDELA PLANA 5/16	\N	468.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6.82	3408
709	ARANDELA PLANA 3/8	\N	373.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	9.91	3409
710	ARANDELA PLANA ZINCADA 1/4	\N	1895.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7.96	3410
711	TORNILLO CABEZA TANQUE 1/4 X 1 3/4	\N	100.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	104.83	3411
712	TORNILLO CABEZA TANQUE 5/32 X 2	\N	93.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	48.25	3412
713	TORNILLO CABEZA FRESADA METAL 1/4 X 3/4	\N	93.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	318.59	3413
714	TORNILLO CABEZA FRESADA METAL 1/4 X 1 1/4	\N	33.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	436.85	3414
715	TORNILLO CABEZA FRESADA METAL 3/16 X 1 1/4	\N	16.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	241.68	3415
716	TORNILLO CABEZA FRESADA METAL 1/4 X 2 1/2	\N	38.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	767.75	3416
717	TORNILLO CHAPA C/FIJADORA PARKER 8 X 5/8	\N	95.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	19.55	3417
718	TORNILLO CHAPA C/FIJADORA PARKER 10 X 5/8	\N	163.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	79.08	3418
719	TORNILLO CHAPA C/FIJADORA PARKER 12 X 5/8	\N	213.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	103.51	3419
720	TORNILLO CHAPA C/FIJADORA PARKER 14 X 5/8	\N	199.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	51.09	3420
721	TORNILLO CHAPA C/FIJADORA PARKER 14 X 1 1/2	\N	199.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	90.92	3421
722	TORNILLO CHAPA C/FIJADORA PARKER 14 X 2	\N	199.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	114.24	3422
723	ARANDELA PRESION 6 MM	\N	488.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6.42	3423
724	ARANDELA PRESION 7 MM	\N	998.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6.58	3424
725	ARANDELA PRESION 8 MM	\N	937.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	9.34	3425
726	ARANDELA PRESION 1/2	\N	248.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	35.93	3426
727	ARANDELA PLANA 2"	\N	13.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	89.42	3427
728	ARANDELA PLANA 1 1/2"	\N	21.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	168.86	3428
729	ARANDELA PLANA 7/8	\N	20.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	177.30	3429
730	ARANDELA PLANA 1 1/4	\N	30.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	111.33	3430
731	ARANDELA PLANA 9/16	\N	78.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	42.82	3431
732	ARANDELA PLANA 1 1/8	\N	35.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	101.34	3432
733	ARANDELA PLANA 1"	\N	40.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	83.50	3433
734	ARANDELA PLANA 3/4	\N	37.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	90.27	3434
735	TORNILLO CHAPA C/FIJADORA PARKER 12 X 3/4	\N	195.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	40.72	3435
736	TORNILLO CHAPA C/FIJADORA PARKER 14 X 3/4	\N	198.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	54.78	3436
737	TORNILLO CHAPA C/FIJADORA PARKER 10 X 1 1/4	\N	156.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	46.46	3437
738	TORNILLO CHAPA C/FIJADORA PARKER 8 X 1 1/2	\N	187.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	40.13	3438
739	TORNILLO CHAPA C/FIJADORA PARKER 10 X 1 1/2	\N	200.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	51.42	3439
740	TORNILLO CHAPA C/FIJADORA PARKER 12 X 1 1/2	\N	202.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	74.03	3440
741	TORNILLO CHAPA C/FIJADORA PARKER 8 X 3/4	\N	158.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	21.99	3441
742	TORNILLO CHAPA C/FIJADORA PARKER 14 X 2	\N	195.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	114.24	3442
743	TORNILLO AUTOP. HEXAG. MECHA C/ARAND 12 X 1	\N	294.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	40.87	3443
744	TORNILLO AUTOP. HEXAG. MECHA C/ARAND 12 X 1 1/4	\N	0.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	58.28	3444
745	TORNILLO AUTOP. HEXAG. MECHA C/ARAND 12 X 1 1/2	\N	0.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	51.28	3445
746	TORNILLO AUTOPERF. HEXAGONAL 12 X 2 1/4	\N	169.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	65.35	3446
747	TORNILLO AUTOPERF. HEXAGONAL 12 X 3 1/2	\N	84.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	78.29	3447
748	TORNILLO AUTOPERF. HEXAGONAL 12 X 1	\N	322.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	40.87	3448
749	TORNILLO AUTOPERF. HEXAGONAL 12 X 2	\N	254.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	61.87	3449
750	TORNILLO PUNTA AGUJA C/TANQUE 8 X 1	\N	61.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	16.47	3450
751	TORNILLO PUNTA AGUJA C/TANQUE 8 X 1 5/8	\N	436.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	16.53	3451
752	TORNILLO PUNTA AGUJA C/TANQUE 8 X 1/2	\N	2595.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	11.16	3452
753	TORNILLO PUNTA MECHA C/FREZADA 6 X 1	\N	1193.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	26.26	3453
754	TORNILLO PUNTA MECHA C/FREZADA 6 X 1 1/8	\N	104.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	20.20	3454
755	TORNILLO PUNTA MECHA C/FREZADA 8 X 1 1/2	\N	156.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	43.57	3455
758	TORNILLO PUNTA MECHA C/TANQUE 8 X 1	\N	76.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	18.64	3458
759	TORNILLO PUNTA MECHA C/TANQUE 8 X 1 1/2	\N	137.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	21.95	3459
760	VASO PLASTICO TRAGO LARGO TRANSP X 280 CC	\N	250.0000	0	1.0000	\N	0	0	113	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	66.85	3460
761	SERVILLETA 33 X 33 BLANCA PAQ X 80	\N	8.0000	0	1.0000	\N	0	0	82	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	922.40	3461
762	PAPEL COCINA X 200 PAÑOS ROLLO	\N	5.0000	0	1.0000	\N	0	0	116	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	1258.76	3462
763	BOBINA MULTIUSO DOBLE HOJA 1000 USOS UN	\N	6.0000	0	1.0000	\N	0	0	117	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	5991.79	3463
764	BOBINA PAPEL HIGIENICO X 300 MTS UNIDAD	\N	5.0000	0	1.0000	\N	0	0	82	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	2313.55	3464
765	FILM PVC ADHERENTE 38 CM X 500 MTS ROLLO	\N	2.0000	0	1.0000	\N	0	0	118	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	14226.37	3465
766	FILM PVC ADHEREBTE 38 CM X 300 MTS ROLLO	\N	8.0000	0	1.0000	\N	0	0	119	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	6161.40	3466
767	BOBINA PAPEL MADERA 40 CM X 5KG ROLLO	\N	3.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	1472.31	3467
768	FILM PVC CUTTER BOX 38 CM X 200 MTS ROLLO	\N	3.0000	0	1.0000	\N	0	0	120	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	7371.51	3468
769	FILM PVC ADHERENTE 38 CM X 380 MTS ROLLO	\N	11.0000	0	1.0000	\N	0	0	121	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	3041.50	3469
770	CEPILLO DENTAL PREMIER CLEAN MEDIO UNIDAD	\N	8.0000	0	1.0000	\N	0	0	122	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	22	906.91	3470
771	FILM STRETCH EMBALAJE 50 CM BOBINA MANUAL	\N	1.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	12455.25	3471
772	PAPEL MANTECA PURO VEGETAL ROLLO	\N	36.0000	0	1.0000	\N	0	0	123	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	933.95	3472
773	FILM PVC ADHERENTE ROLLO CHICO	\N	36.0000	0	1.0000	\N	0	0	123	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	643.34	3473
774	CLORO EN PASTILLA X 50G CADA UNA X 500G	\N	7.0000	0	1.0000	\N	0	0	124	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	21	3760.66	3474
775	CLORO EN PASTILLA X 200G CADA UNA X 1KG	\N	1.0000	0	1.0000	\N	0	0	124	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	21	5454.55	3475
776	CLORO GRANULADO X 1 KG	\N	11.0000	0	1.0000	\N	0	0	124	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	21	5123.97	3476
777	CLARIFICANTE PILETA X 1 L	\N	10.0000	0	1.0000	\N	0	0	124	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	21	2727.27	3477
778	ALGUICIDA PILETA X 1 L	\N	10.0000	0	1.0000	\N	0	0	124	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	21	2727.27	3478
779	ALGUICIDA PILETA X 5 L	\N	1.0000	0	1.0000	\N	0	0	124	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	21	11157.03	3479
780	CLARIFICANTE PILETA X 5 L	\N	1.0000	0	1.0000	\N	0	0	124	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	21	11157.03	3480
781	BOYA PARA CLORO	\N	4.0000	0	1.0000	\N	0	0	124	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1397.54	3481
782	TERMO AUTOCEBANTE X 500 ML LILA	\N	3.0000	0	1.0000	\N	0	0	125	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	13140.50	3482
783	TERMO AUTOCEBANTE X 500 ML AZUL	\N	5.0000	0	1.0000	\N	0	0	125	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	13140.50	3483
784	TERMO AUTOCEBANTE X 500 ML BORDO	\N	7.0000	0	1.0000	\N	0	0	125	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	13140.50	3484
786	TERMO AUTOCEBANTE X 500 ML VERDE	\N	5.0000	0	1.0000	\N	0	0	125	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	13140.50	3486
787	TERMO AUTOCEBANTE X 500 ML ROSADO	\N	4.0000	0	1.0000	\N	0	0	125	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	13140.50	3487
788	TERMO AUTOCEBANTE X 500 ML BLANCO	\N	3.0000	0	1.0000	\N	0	0	125	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	13140.50	3488
789	TERMO AUTOCEBANTE X 750 ML BLANCO	\N	4.0000	0	1.0000	\N	0	0	125	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	14892.56	3489
790	TERMO AUTOCEBANTE X 750 ML ROSADO	\N	4.0000	0	1.0000	\N	0	0	125	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	14892.56	3490
792	TERMO AUTOCEBANTE X 750 ML VERDE	\N	4.0000	0	1.0000	\N	0	0	125	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	14892.56	3492
794	TERMO AUTOCEBANTE X 750 ML LILA	\N	3.0000	0	1.0000	\N	0	0	125	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	14892.56	3494
795	TERMO AUTOCEBANTE X 750 ML BORDO	\N	4.0000	0	1.0000	\N	0	0	125	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	14892.56	3495
796	CADENA PARA BICICLETA CON COMBINACION	\N	1.0000	0	1.0000	\N	0	0	126	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3921.75	3496
797	CADENA PARA BICICLETA CON CANDADO	\N	1.0000	0	1.0000	\N	0	0	127	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7698.25	3497
798	POLEA 230	\N	1.0000	0	1.0000	\N	0	0	128	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	12949.68	3498
799	SOGA POLIETILENO 4MM FORRADA EN PVC X MTS	\N	180.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	173.46	3499
800	CABLE ACERO PLASTIFICADO X MTS	\N	110.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	258.79	3500
801	BARRA SILICONA 7 MM X 30 CM	\N	73.0000	0	1.0000	\N	0	0	129	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	357.50	3501
802	BARRA SILICONA 11 MM X 30 CM	\N	102.0000	0	1.0000	\N	0	0	129	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	357.50	3502
803	REPUESTO PARA DIBUJO BLANCAS X 8 UNIDADES	\N	3.0000	0	1.0000	\N	0	0	130	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	135.00	3503
804	LIBRO ADIVINANZAS PARA COMPARTIR	\N	1.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	2035.00	3504
805	LIBRO CUENTO DE ANIMALES	\N	1.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	2035.00	3505
806	CARPETA CARTULINA A4 ROSADAS	\N	15.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	2803.00	3506
807	LIBRO INVENTARIO 3 COLUMNAS 40 HOJAS	\N	8.0000	0	1.0000	\N	0	0	131	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	11833.93	3507
808	TIZAS BLANCAS CAJA X 144 U	\N	3.0000	0	1.0000	\N	0	0	132	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	3713.15	3508
809	TIZAS COLOR CAJA X 144 U	\N	3.0000	0	1.0000	\N	0	0	132	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	5686.74	3509
810	PAPEL CREPE AZUL X UNIDAD	\N	5.0000	0	1.0000	\N	0	0	133	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	1813.18	3510
811	PAPEL ARAÑA AZUL X UNIDAD	\N	10.0000	0	1.0000	\N	0	0	133	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	1813.18	3511
812	HILO COSER POLIESTER VERDE AGUA (230) 2000 YARDAS	\N	36.0000	0	1.0000	\N	0	0	134	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	1424.80	3512
813	JUEGO AJEDREZ	\N	1.0000	0	1.0000	\N	0	0	135	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	30984.85	3513
814	MARCADOR JUMBO LAVABLE COLORES	\N	50.0000	0	1.0000	\N	0	0	136	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	686.06	3514
815	FIBRAS COLORES ESCOLARES 2210 CHICAS X 10 U	\N	1.0000	0	1.0000	\N	0	0	136	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	120.38	3515
816	MINI ESCALIMETRO 10 CM	\N	10.0000	0	1.0000	\N	0	0	137	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	2293.92	3516
817	TEMPERA AMARILLO X 250 CC	\N	2.0000	0	1.0000	\N	0	0	138	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	1846.33	3517
818	TEMPERA BLANCO X 250 CC	\N	2.0000	0	1.0000	\N	0	0	138	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	1846.33	3518
819	TEMPERA ROJO X 250 CC	\N	2.0000	0	1.0000	\N	0	0	138	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	1846.33	3519
820	REGLA 20 CM	\N	9.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	907.82	3520
821	REGLA 30 CM AZUL	\N	6.0000	0	1.0000	\N	0	0	129	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	2777.69	3521
822	MINAS PARA PORTAMINAS 7.0 MM CAJA	\N	20.0000	0	1.0000	\N	0	0	136	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	89.57	3522
823	MARCADOR PERMANENTE DOBLE PUNTA NEGRO	\N	5.0000	0	1.0000	\N	0	0	129	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	1632.57	3523
824	BROCHE DORADO N10 X 100 U	\N	1.0000	0	1.0000	\N	0	0	56	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	2403.75	3524
825	PINCEL CHATO N2	\N	1.0000	0	1.0000	\N	0	0	139	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	780.83	3525
826	PINCEL CHATO N00	\N	1.0000	0	1.0000	\N	0	0	139	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	707.30	3526
827	PINCEL CHATO N6	\N	1.0000	0	1.0000	\N	0	0	139	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	1125.80	3527
828	PINCEL CHATO N4	\N	1.0000	0	1.0000	\N	0	0	139	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	873.09	3528
829	PINCEL CHATO N0	\N	1.0000	0	1.0000	\N	0	0	139	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	1414.60	3529
830	PINCEL CHATO N10	\N	1.0000	0	1.0000	\N	0	0	139	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	3578.51	3530
831	BASE ACRILICA ROSA PRINCESA X 200 CC	\N	2.0000	0	1.0000	\N	0	0	140	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	2603.90	3531
832	BASE ACRILICA NARANJA X 200 CC	\N	1.0000	0	1.0000	\N	0	0	140	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	2603.90	3532
833	BASE ACRILICA VERDE MANZANA X 50 CC	\N	1.0000	0	1.0000	\N	0	0	140	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	1082.90	3533
834	BASE ACRILICA DORADO IRIDISCENTE X 50 CC	\N	1.0000	0	1.0000	\N	0	0	140	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	1082.90	3534
835	PINTURA PARA SUBLIMACION AZUL TALO X 37 ML	\N	2.0000	0	1.0000	\N	0	0	141	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	4236.12	3535
836	PINTURA PARA SUBLIMACION MAGENTA X 37 ML	\N	2.0000	0	1.0000	\N	0	0	141	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	4236.12	3536
837	HOJA PARA CUTTER 18 MM PAQUETE	\N	25.0000	0	1.0000	\N	0	0	152	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	913.63	3537
838	CINTA PARA MOCHILA X MT	\N	3.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	1379.60	3538
839	HILO COSER POLIESTER VERDE INGLES (230) 2000 YARDAS	\N	1.0000	0	1.0000	\N	0	0	134	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	1424.80	3539
840	HILO COSER VERDE CLARO 1829 MTS	\N	1.0000	0	1.0000	\N	0	0	143	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	1424.80	3540
841	ALGODÓN HIDROFILO X 70 G PAQUETE	\N	1.0000	0	1.0000	\N	0	0	144	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	22	791.50	3541
791	TERMO AUTOCEBANTE X 750 ML AZUL	\N	3.0000	0	1.0000	\N	0	0	125	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	14892.56	3491
843	PIOLIN ALBAÑIL N 60 X MTS	\N	400.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	50.89	3543
844	PIOLIN ALBAÑIL N 42 X MTS	\N	375.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	30.53	3544
845	PIOLIN ALBAÑIL N 24 X MTS	\N	570.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	20.82	3545
846	PIOLIN ALBAÑIL N 18 X MTS	\N	770.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	17.24	3546
847	AGUJA CROCHET PLASTICAS N 7	\N	2.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	430.00	3547
848	AGUJA CROCHET PLASTICAS N 6	\N	2.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	430.00	3548
849	AGUJA CROCHET METALICA 3,5 MM	\N	4.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	520.44	3549
850	AGUJA COLCHONERA	\N	16.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	140.03	3550
851	AGUJA PASACINTA LANA PAQUETE SURTIDAS	\N	8.0000	0	1.0000	\N	0	0	145	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	2896.70	3551
852	HILO NYLON ENCERADO N 7 X 60 MTS BOBINA COLOR MAIZ	\N	1.0000	0	1.0000	\N	0	0	146	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	3465.00	3552
853	AGUJA X 10 U PAQUETE	\N	5.0000	0	1.0000	\N	0	0	147	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	2896.70	3553
854	AGUJA COSER N10 PAQUETE	\N	10.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	2896.70	3554
855	TACO NYLON N 14 UNIDAD	\N	1938.0000	0	1.0000	\N	0	0	148	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	132.03	3555
856	TACO NYLON N 5 UNIDAD	\N	2386.0000	0	1.0000	\N	0	0	148	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6.67	3556
859	TACO NYLON N 6 CON TOPE UNIDAD	\N	1000.0000	0	1.0000	\N	0	0	148	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	12.32	3559
860	TACO NYLON N 8 CON TOPE UNIDAD	\N	418.0000	0	1.0000	\N	0	0	148	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	12.63	3560
861	TACO NYLON N 10 UNIDAD	\N	1362.0000	0	1.0000	\N	0	0	148	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	18.27	3561
862	COFIA UNIDAD	\N	100.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	7	37.58	3562
863	GASA ESTERIL 20X20 X 4 TROZOS X SOBRE	\N	13.0000	0	1.0000	\N	0	0	150	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	23	318.60	3563
864	JABON GLICERINA 120G	\N	1.0000	0	1.0000	\N	0	0	151	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	22	1063.28	3564
865	APOSITO AUTOADHESIVO TRANSPARENTE 10X12 X SOBRE	\N	20.0000	0	1.0000	\N	0	0	153	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	23	920.00	3565
866	AGUA OXIGENADA 10 VOL C 500 CC	\N	1.0000	0	1.0000	\N	0	0	154	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	23	678.00	3566
867	GASA ESTERIL 10X10 X SOBRE	\N	6.0000	0	1.0000	\N	0	0	155	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	23	160.58	3567
868	JUEGO ESTECAS PLASTICAS X 6 U	\N	6.0000	0	1.0000	\N	0	0	156	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	9620.30	3568
869	JUEGO ESTECAS PLASTICAS X 10 U	\N	4.0000	0	1.0000	\N	0	0	156	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	16033.81	3569
870	AGUJA CROCHET N00	\N	2.0000	0	1.0000	\N	0	0	157	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	520.44	3570
871	SILICONA LIQUIDA X 30LM	\N	2.0000	0	1.0000	\N	0	0	145	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	676.68	3571
872	LUBRICANTE DE HILOS SL10 X 100CC	\N	1.0000	0	1.0000	\N	0	0	158	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	10964.18	3572
873	ADHESIVO VINILICO X 250G	\N	2.0000	0	1.0000	\N	0	0	159	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	1148.09	3573
874	SACAPUNTA METALICO	\N	3.0000	0	1.0000	\N	0	0	160	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	513.62	3574
875	RESALTADOR AMARILLO	\N	2.0000	0	1.0000	\N	0	0	136	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	755.04	3575
876	RESALTADOR ROSADO	\N	2.0000	0	1.0000	\N	0	0	136	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	55.04	3576
877	RESALTADOR NARANJA	\N	2.0000	0	1.0000	\N	0	0	136	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	755.04	3577
878	LANA RENDIDORA X 100G AZUL	\N	1.0000	0	1.0000	\N	0	0	161	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	2274.41	3578
879	LANA RENDIDORA X 100G AMARILLO	\N	1.0000	0	1.0000	\N	0	0	161	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	2274.41	3579
880	LANA RENDIDORA X 100G ROJO	\N	1.0000	0	1.0000	\N	0	0	161	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	2274.41	3580
881	PINCEL PLANO N12	\N	6.0000	0	1.0000	\N	0	0	139	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	8186.65	3581
882	CURITAS X 8 U CAJA	\N	7.0000	0	1.0000	\N	0	0	162	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	23	806.97	3582
883	CURITAS X 20 U CAJA	\N	1.0000	0	1.0000	\N	0	0	162	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	23	1517.05	3583
884	VENDA TIPO CAMBRIC 7 CM X 3 MTS	\N	1.0000	0	1.0000	\N	0	0	164	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	23	1570.24	3584
885	VENDA TIPO CAMBRIC 5 CM X 3 MTS	\N	1.0000	0	1.0000	\N	0	0	164	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	23	1487.60	3585
886	VENDA TIPO CAMBRIC 10 CM X 3 MTS	\N	1.0000	0	1.0000	\N	0	0	164	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	23	1735.54	3586
887	AGUA OXIGENADA 10 VOL C 250 CC	\N	1.0000	0	1.0000	\N	0	0	165	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	23	426.00	3587
888	VIDRIO PORTA OBJETOS	\N	37.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	23	64.85	3588
889	MOLDE DE SILICONA PARA GUARDAS	\N	3.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	5199.17	3589
890	GRAMPAS PARA ENGRAMPADORA 8MM X 1000 U	\N	13.0000	0	1.0000	\N	0	0	142	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1014.21	3590
891	GRAMPA PARA TAPICERIA 8414 TIRAS	\N	19.0000	0	1.0000	\N	0	0	168	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	760.95	3591
892	MINAS PARA PORTAMINAS 5.0 MM CAJA	\N	14.0000	0	1.0000	\N	0	0	169	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	789.57	3592
893	BANDERA PLASTICA ARGENTINA 15X25 X 12U	\N	4.0000	0	1.0000	\N	0	0	170	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	24	2945.45	3593
894	SACAPUNTA METALICO	\N	18.0000	0	1.0000	\N	0	0	136	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	755.29	3594
895	TACHUELA ZAPATERO 1/2" 13MM X 100G CAJA	\N	4.0000	0	1.0000	\N	0	0	142	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	25	2385.95	3595
896	GOMA BORRAR BLANCA UNIDAD	\N	20.0000	0	1.0000	\N	0	0	129	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	90.96	3596
897	CIERRE 20CM FUCSIA	\N	10.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	1143.25	3597
898	CIERRE 20CM BLANCO	\N	5.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	1143.25	3598
899	CIERRE 20CM BEIGE	\N	10.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	1143.25	3599
900	CIERRE 20CM AZUL OSCURO	\N	10.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	1143.25	3600
901	CIERRE 20CM NEGRO	\N	10.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	1143.25	3601
902	CIERRE 20CM GRIS OSCURO	\N	9.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	1143.25	3602
903	ABROJO BLANCO 20MM X MTS	\N	10.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	370.58	3603
904	ABROJO NEGRO 5 CM X MTS	\N	9.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	478.40	3604
905	LANA ALGODÓN SEIS CABOS BLANCA 100 G	\N	1.0000	0	1.0000	\N	0	0	161	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	2509.00	3605
906	ELASTICO 5MM X MTS	\N	50.0000	0	1.0000	\N	0	0	171	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	203.84	3606
907	ELASTICO 2MM X MTS	\N	50.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	136.36	3607
908	RODILLO PLASTICO 20 CM PARA PLASTILINA	\N	6.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	587.00	3608
909	MOLDES CORTANTES PLASTICOS FORMAS VARIAS	\N	27.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	299.00	3609
910	PERFORADORA BASE MADERA	\N	2.0000	0	1.0000	\N	0	0	172	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	24860.31	3610
911	LLAVERO IDENTIFICADOR PLASTICO	\N	20.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	130.97	3611
912	PICO PARA DECORAR 401	\N	9.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	3607.44	3612
858	TACO NYLON N 6 UNIDAD	\N	3980.0000	0	1.0000	\N	0	0	148	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	9.65	3558
913	HILO VIOLETA X 100 YARDAS	\N	5.0000	0	1.0000	\N	0	0	173	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	669.14	3613
914	HILO BLANCO X 100 YARDAS	\N	5.0000	0	1.0000	\N	0	0	173	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	669.14	3614
915	HILO NYLON 0.7 MM TRANSPARENTE X 10 MTS	\N	5.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	13	1795.86	3615
917	PUNTA PH1 X 25 MM	\N	7.0000	0	1.0000	\N	0	0	45	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2647.10	3616
918	PUNTA PH2 X 25 MM	\N	40.0000	0	1.0000	\N	0	0	51	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	523.69	3617
920	PUNTA PH2 DOBLE	\N	33.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	335.62	3619
921	PUNTA PH1 X 50 MM	\N	12.0000	0	1.0000	\N	0	0	45	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3185.50	3620
922	PUNTA PH3 X 50 MM	\N	8.0000	0	1.0000	\N	0	0	45	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3409.83	3621
923	PITON ABIERTO 23-90	\N	51.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	202.92	3622
924	PITON ABIERTO 24-100	\N	26.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	262.42	3623
925	PITON CERRADO 24-100	\N	35.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	262.42	3624
926	ARANDELA CHAPA C GOMA	\N	600.0000	0	1.0000	\N	0	0	107	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	20	18.64	3625
927	CLAVO ACERO 2,5X50	\N	55.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	442.41	3626
928	CLAVO ACERO 3,3X60	\N	71.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	870.07	3627
929	CLAVO ACERO 2,0X24	\N	89.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	211.27	3628
930	CLAVO ACERO 3,2X40	\N	103.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	589.97	3629
931	CLAVO ACERO 3,2X25	\N	100.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	416.71	3630
932	CLAVO ACERO 2,5X30	\N	98.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	319.01	3631
933	CLAVO ACERO 2,0X25	\N	224.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	21.13	3632
934	MECHA ESCALONADA 4 A 20MM (TOU302)	\N	2.0000	0	1.0000	\N	0	0	115	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	11281.74	3633
935	MECHA ESCALONADA 4 A 12MM (TOU302)	\N	1.0000	0	1.0000	\N	0	0	115	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7416.84	3634
916	PINCEL N12 PELO DE PONY	\N	5.0000	0	1.0000	\N	0	0	174	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	15	5450.44	3635
937	BOCALLAVE MAGNETICA 7/16	\N	1.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1202.98	3636
939	BOCALLAVE MAGNETICA 1/4	\N	5.0000	0	1.0000	\N	0	0	55	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	962.08	3638
940	BOCALLAVE MAGNETICA 5/16	\N	9.0000	0	1.0000	\N	0	0	55	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1008.77	3639
941	PUNTA TORX T30	\N	30.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1604.68	3640
942	PITON 14X20 CERRADO	\N	54.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	38.65	3641
943	PITON 6 ABIERTO C/TOPE	\N	6.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	142.05	3642
944	PITON 6 CERRADO C/TOPE	\N	10.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	142.05	3643
945	PITON 8L	\N	88.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	158.79	3644
946	TERMINAL X9 43-5/16 OJAL GRANDE	\N	52.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	149.14	3645
947	TERMINAL 43-3/8	\N	97.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	434.00	3646
948	TERMINAL X 7(9354)	\N	205.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	235.00	3647
949	TERMINAL 416 (9351)	\N	196.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	287.00	3648
950	TERMINAL X9 (9352)	\N	199.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	312.00	3649
951	MODULO TOMA 10A HORIZONTAL	\N	12.0000	0	1.0000	\N	0	0	23	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	797.45	3650
953	MODULO PULZADOR TIMBRE	\N	11.0000	0	1.0000	\N	0	0	23	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1085.15	3652
954	MODULO LLAVE 1 PUNTO	\N	10.0000	0	1.0000	\N	0	0	23	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	801.74	3653
955	MODULO TOMA 10A HORIZONTAL	\N	28.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	740.92	3654
956	MODULO LLAVE 1 PUNTO	\N	99.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	685.98	3655
957	MODULO TAPA CIEGA	\N	64.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	89.18	3656
958	MODULO PULZADOR TIMBRE	\N	2.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1085.15	3657
959	FICHA MACHO 20A	\N	24.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2094.59	3658
960	FICHA MACHO 10A	\N	5.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	931.63	3659
961	FICHA HEMBRA 20A	\N	28.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2104.59	3660
963	FICHA MACHO HEAVY DUTY 10A NEGRA	\N	5.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1204.98	3662
965	FICHA MACHO 10A AXIAL	\N	10.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	891.79	3664
966	FICHA MACHO HEAVY DUTY 10A BLANCA	\N	1.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1204.98	3665
967	FICHA HEMBRA 10A 2 PING	\N	11.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	668.29	3666
968	ZOCALO TUBO DE ARRIMAR CON CHICOTE	\N	22.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	458.75	3667
969	ZOCALO TUBO DE ARRIMAR SIN CHICOTE	\N	20.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	107.45	3668
970	ZOCALO EQUIPO SIMPLE SIN CHICOTE	\N	8.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	714.56	3669
971	ZOCALO GU10 CON CHICOTE CERAMICO	\N	13.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	760.76	3670
972	BASE TOMA EXTERIOR ARMADA 20A SIMPLE	\N	4.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2765.87	3671
974	BASE 2 TOMA EXTERIOR 10A	\N	2.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2277.32	3673
975	BASE EXTERIOR 1 PUNTO Y 1 TOMA 10A	\N	4.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2568.24	3674
976	BASE EXTERIOR ARMADA 1 PUNTO	\N	10.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1511.98	3675
977	BASE EXTERIOR 1 TOMA	\N	35.0000	0	1.0000	\N	0	0	23	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1183.90	3676
978	BASE EXTERIOR TOMA ARMADA 10A	\N	4.0000	0	1.0000	\N	0	0	23	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1183.90	3677
979	LLAVE ARMADA DOS PUNTOS DUNA	\N	3.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1531.87	3678
980	LLAVE ARMADA DOS PUNTOS Y UNA TOMA DUNA	\N	2.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2020.38	3679
983	LLAVE ARMADA 2 TOMA URBANA	\N	5.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1642.97	3681
984	LLAVE ARMADA 1 TOMA URBANA	\N	1.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1221.85	3682
985	LLAVE ARMADA 2 PUNTOS Y 1 TOMA URBANA	\N	1.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2020.38	3683
986	LLAVE ARMADA 1 PUNTO Y 1 TOMA URBANA	\N	1.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1642.97	3684
938	BOCALLAVE MAGNETICA 3/8	\N	8.0000	0	1.0000	\N	0	0	55	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1050.56	3637
962	FICHA HEMBRA HEAVY DUTY 10A NEGRA	\N	18.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1272.21	3661
919	PUNTA PH2 X 50 MM	\N	27.0000	0	1.0000	\N	0	0	51	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	737.57	3618
987	LLAVE ARMADA PULSADOR TIMBRE URBANA	\N	1.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1345.98	3685
988	LLAVE ARMADA 1 PUNTO	\N	6.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2122.17	3686
989	LLAVE ARMADA 3 PUNTO URBANA	\N	1.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2090.98	3687
990	LLAVE ARMADA 1 TOMA	\N	3.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1978.91	3688
991	LLAVE ARMADA 2 PUNTOS	\N	5.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3468.69	3689
992	LLAVE ARMADA UNA TOMA	\N	3.0000	0	1.0000	\N	0	0	23	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1221.85	3690
994	BASTIDOR	\N	5.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	308.65	3692
995	BASTIDOR	\N	12.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	389.95	3693
996	TAPA BASTIDOR	\N	4.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	603.45	3694
997	TAPA BASTIDOR	\N	1.0000	0	1.0000	\N	0	0	23	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	603.45	3695
998	MODULO TOMA 20A DUNA	\N	6.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1769.86	3696
999	MODULO TOMA DOBLE DUNA	\N	2.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2184.98	3697
1000	BASE 32 A TRIFASICA	\N	2.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6457.86	3698
1001	BASE 13A INDUSTRIAL	\N	5.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	5802.40	3699
1002	CONECTOR CAÑO PVC 16 MM	\N	149.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	157.89	3700
1003	CONECTOR CAÑO PVC 20 MM	\N	78.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	159.83	3701
1004	CONECTOR CAÑO PVC 22 MM	\N	156.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	219.79	3702
1005	CONECTOR CAÑO PVC 25 MM	\N	18.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	230.73	3703
1006	CUPLA UNION PVC GRIS 16 MM	\N	50.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	116.36	3704
1007	CUPLA UNION PVC GRIS 20 MM	\N	14.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	117.66	3705
1008	CUPLA UNION PVC GRIS 22 MM	\N	96.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	159.73	3706
1009	CUPLA UNION PVC GRIS 25 MM	\N	51.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	181.88	3707
1010	CAJA OCTOGONAL PVC GRIS	\N	10.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	421.33	3708
1011	CURVA PVC GRIS 16 MM	\N	15.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	256.80	3709
1012	CURVA PVC NEGRA 16 MM	\N	6.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	276.80	3710
1013	CURVA PVC GRIS 22 MM	\N	8.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	323.03	3711
1014	CURVA PVC GRIS 25 MM	\N	46.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	525.00	3712
1015	CURVA PVC GRIS 32 MM	\N	32.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	998.56	3713
1016	CAJA CAPSULADA EXTERIOR SIN MODULO	\N	2.0000	0	1.0000	\N	0	0	149	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	18	1321.00	3714
1017	CAJA CAPSULADA EXTERIOR 1 TOMA 10 A	\N	10.0000	0	1.0000	\N	0	0	149	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	18	2020.00	3715
1018	CAJA CAPSULADA EXTERIOR 1 PUNTO	\N	19.0000	0	1.0000	\N	0	0	149	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	18	1846.00	3716
1019	CAJA CAPSULADA EXT 1 PUNTO 1 TOMA 10 A	\N	20.0000	0	1.0000	\N	0	0	149	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	18	3866.00	3717
1020	CAJA ESTANCA 20 X 20 X 10	\N	3.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	5619.84	3718
1021	CAJA ESTANCA 15 X 10 X 7	\N	1.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	2272.73	3719
1022	CAJA ESTANCA 10 X 15 X 10	\N	2.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	4090.91	3720
1023	CAJA ESTANCA 20 X 20 X 10	\N	1.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4820.81	3721
1024	CAJA ESTANCA TERMICA 8 MODULOS	\N	1.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	8211.26	3722
1025	CAJA ESTANCA TERMICA 4 MODULOS	\N	1.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3982.85	3723
1026	CAJA ESTANCA TERMICA 2 MODULOS	\N	1.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2824.59	3724
1027	CAJA ESTANCA 10 X 10 X 7	\N	1.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	2272.73	3725
1028	CAJA PVC EMBUTIR NEGRA RECT 10 X 5	\N	100.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	18	144.00	3726
1029	LINTERNA LED 2 PILAS GRANDES	\N	1.0000	0	1.0000	\N	0	0	21	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	8932.68	3727
1030	LINTERNA LED 2 PILAS GRANDES	\N	2.0000	0	1.0000	\N	0	0	25	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	6330.96	3728
1031	LINTERNA LED RECARGABLE	\N	1.0000	0	1.0000	\N	0	0	21	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	14270.06	3729
1032	FLORON BLANCO PARED E27	\N	7.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	2798.98	3730
1033	FLORON NEGRO	\N	3.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	2798.98	3731
1034	CINTA PASACABLE 10 M PLASTICA	\N	5.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4122.50	3732
1035	CINTA PASACABLE 15 M PLASTICA	\N	3.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	4754.89	3733
1036	FICHA MACHO 10 A GRIS	\N	3.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1204.98	3734
1037	FICHA HEMBRA 10 A GRIS	\N	3.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1272.21	3735
1038	ADAPTADOR MULTINORMA SIMPLE PATA PLANA	\N	51.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	735.00	3736
1040	ADAPTADOR TRIPLE MULTINORMA PIN REDONDO	\N	12.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	754.00	3738
1041	GRAMPA PVC GRIS 20 MM	\N	117.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	112.74	3739
1042	CONECTOR MEMA FOTOVIN	\N	13.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	3920.62	3740
1043	PORTA LAMPARA EDISON OBLICUO E27	\N	9.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1360.45	3741
1044	CAJA RECTANGULAR 10 X 15 EXT. GRIS	\N	10.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3385.84	3742
1045	CAJA RECTANGULAR 10 X 15 EMBUTIR GRIS	\N	2.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	467.62	3743
1046	CAJA CUADRADA 5 X 5 SUPERFICIE GRIS	\N	1.0000	0	1.0000	\N	0	0	17	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2490.98	3744
1047	DISYUNTOR DIFERENCIAL BIPOLAR 25A	\N	1.0000	0	1.0000	\N	0	0	23	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	30315.18	3745
1048	DISYUNTOR DIFERENCIAL BIPOLAR 40A	\N	2.0000	0	1.0000	\N	0	0	23	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	30315.18	3746
1050	LLAVE TERMICA BIPOLAR 16A	\N	2.0000	0	1.0000	\N	0	0	23	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7381.58	3748
1051	LLAVE TERMICA BIPOLAR 25A	\N	6.0000	0	1.0000	\N	0	0	23	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7381.58	3749
1052	LLAVE TERMICA BIPOLAR 32A	\N	2.0000	0	1.0000	\N	0	0	23	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7381.58	3750
1053	LLAVE TERMICA BIPOLAR 6A	\N	2.0000	0	1.0000	\N	0	0	23	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	8716.59	3751
1054	LLAVE TERMICA BIPOLAR 10A	\N	2.0000	0	1.0000	\N	0	0	23	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7381.58	3752
1055	DISYUNTOR TETRAPOLAR 40A	\N	1.0000	0	1.0000	\N	0	0	23	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	49254.84	3753
1056	CONTACTOR 24 220V	\N	1.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	11532.00	3754
1057	TERMICA UNIPOLAR 6A	\N	2.0000	0	1.0000	\N	0	0	166	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3015.68	3755
1039	ADAPTADOR TRIPLE MULTINORMA PATA PLANA	\N	22.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	16	754.00	3737
1058	TERMICA UNIPOLAR 10A	\N	1.0000	0	1.0000	\N	0	0	166	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3015.68	3756
1059	TERMICA UNIPOLAR 20A	\N	1.0000	0	1.0000	\N	0	0	166	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3015.68	3757
1060	TERMICA UNIPOLAR 32A	\N	3.0000	0	1.0000	\N	0	0	166	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3015.68	3758
1061	TERMICA UNIPOLAR 40A	\N	1.0000	0	1.0000	\N	0	0	23	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	3015.68	3759
1062	ZAPATILLA SIN CABLE MULTINORMA 4 TOMAS	\N	50.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	18	674.00	3760
1063	ZAPATILLA 4 TOMAS MULTINORMA 1,5 MT C/INT	\N	8.0000	0	1.0000	\N	0	0	167	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	18	3130.00	3761
1064	ZAPATILLA 4 TOMAS MULTINORMA 2,5 MT C/INT	\N	7.0000	0	1.0000	\N	0	0	167	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	18	3977.00	3762
1065	ZAPATILLA 4 TOMAS MULTINORMA 3 MT C/INT	\N	6.0000	0	1.0000	\N	0	0	167	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	18	4265.00	3763
1066	ZAPATILLA 4 TOMAS MULTINORMA 5 MT C/INT	\N	10.0000	0	1.0000	\N	0	0	167	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	18	5528.00	3764
1067	ZAPATILLA 4 TOMAS MULTINORMA 5 MT C/INTERR	\N	2.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	15778.34	3765
1069	TORNILLO AUTOP. HEXAG. P/MECHA C/ARAND 14X1 1/2	\N	113.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	70.90	3767
1070	TORNILLO AUTOP. HEXAG. P/MECHA C/ARAND 14X2	\N	52.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	76.55	3768
1071	TORNILLO AUTOP. HEXAG. P/MECHA C/ARAND 14X3	\N	29.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	101.79	3769
1072	TORNILLO AUTOP. HEXAG. P/MECHA C/ARAND 14X4	\N	70.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	138.64	3770
1073	TORNILLO AUTOP. C/ALAS P/MECHA 10X1 5/8	\N	199.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	57.03	3771
1074	TORNILLO AUTOP. C/ALAS P/MECHA 10X2	\N	133.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	71.46	3772
1075	TORNILLO AUTOP. C/ALAS P/MECHA 8X1 1/4	\N	18.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	34.09	3773
1076	TORNILLO AUTOP. C/ALAS P/MECHA 8X1 1/2	\N	300.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	38.84	3774
1077	TORNILLO AUTOP. C/ALAS P/MECHA 10X1 1/2	\N	199.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	55.93	3775
1078	TORNILLO DRYWALL PASO GRUESO 6X5/8	\N	182.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	7.50	3776
1079	TORNILLO DRYWALL PASO GRUESO 6X3/4	\N	200.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	8.38	3777
1080	TORNILLO DRYWALL PASO FINO 6X1	\N	1954.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	10.19	3778
1081	TORNILLO DRYWALL PASO GRUESO 10X1 1/2	\N	122.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	19.62	3779
1082	TORNILLO DRYWALL PASO GRUESO 10X3	\N	187.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	49.03	3780
1084	TORNILLO DRYWALL PASO GRUESO 8X1 1/2	\N	337.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	14.57	3782
1085	TORNILLO DRYWALL PASO GRUESO 8X2 1/2	\N	154.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	22.84	3783
1086	TORNILLO DRYWALL PASO GRUESO 6X2	\N	305.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	16.29	3784
1087	TORNILLO DRYWALL PASO GRUESO 6X1 1/4	\N	1216.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	12.76	3785
40	BARNIZ MARINO X 500 CC BRILLANTE	\N	5.0000	0	1.0000	\N	0	0	10	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	4389.79	2674
188	PINCEL CERDA BLANCA 1 VIROLA 3/4	\N	20.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	805.34	2889
190	PINCEL CERDA BLANCA 1 VIROLA 1 1/2	\N	6.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1191.73	2891
239	CLAVO DE ACERO CP50	\N	460.0000	0	20.0000	\N	0	0	107	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	11.60	2940
426	MECHA ACERO RAPIDO 4,00 MM	\N	20.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1423.38	3127
428	MECHA ACERO RAPIDO 5,00 MM	\N	14.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2066.13	3129
438	MECHA ACERO RAPIDO 4,75 MM	\N	9.0000	0	1.0000	\N	0	0	34	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1958.08	3139
842	PIOLIN CHORICERO CHICO 50G BOBINA	\N	0.0000	0	1.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	597.87	3542
857	TACO NYLON N 8 UNIDAD	\N	1663.0000	0	1.0000	\N	0	0	148	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	20.00	3557
952	MODULO TOMA 10A VERTICAL	\N	5.0000	0	1.0000	\N	0	0	23	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1485.97	3651
973	BASE TOMA EXTERIOR ARMADA 10A DOBLE	\N	12.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	2071.21	3672
982	LLAVE ARMADA 1 PUNTO DUNA	\N	0.0000	0	1.0000	\N	0	0	22	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1020.76	3680
993	LLAVE ARMADA DOS TOMAS	\N	0.0000	0	1.0000	\N	0	0	23	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	1642.97	3691
1049	LLAVE TERMICA BIPOLAR 20A	\N	5.0000	0	1.0000	\N	0	0	163	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	19	5155.00	3747
1068	TORNILLO AUTOP. HEXAG. P/MECHA C/ARAND 14X1	\N	111.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	56.49	3766
1083	TORNILLO DRYWALL PASO GRUESO 8X1	\N	150.0000	0	20.0000	\N	0	0	16	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	4	10.63	3781
1	ESMALTE SINTETICO 500 ML AZUL MARINO	\N	1.0000	0	1.0000	\N	0	0	7	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	6055.81	2635
633	ABRELATA UÑA BLANCO	\N	3.0000	0	1.0000	\N	0	0	41	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	17	1891.00	3333
\.


--
-- Data for Name: CHEQUES; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."CHEQUES" ("chqCod", "pagCod", "chqNumero", "chqBanco", "chqFechaEmision", "chqFechaCobro", "chqMonto", "chqLibrador", "chqCUIT", "chqEnCaja", "chqFechaSalida", "chqObservaciones") FROM stdin;
\.


--
-- Data for Name: CLIENTES; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."CLIENTES" ("cliNombre", "cliDireccion", "cliTelefono", "cliEmail", id, "cliTipoDoc", "cliNumDoc", "cliCondicionIVA", "cliFormaPago") FROM stdin;
Juan Pérez	Calle Falsa 123	1155556666	juan@ejemplo.com	12	2	12345678	3	1
María García - Monotributo	Av. Libertador 456	1166667777	maria@monotributo.com	13	1	27987654321	4	1
Juan Test	Calle Prueba 456	1155556666	juan@test.com	15	2	11111111	3	1
María Test Monotributo	Av. Mono 789	1166667777	maria@mono.com	16	1	27222222223	4	1
Cliente Test RI AFIP	Av. Test 1234	1144445555	test@afip.gob.ar	14	1	20111111112	1	3
Empresa Prueba S.A.	Av. Corrientes 1234	1144445555	prueba@empresatest.com	11	1	30123456789	1	3
CONS. FINAL	\N	\N	\N	18	5	9999999999	5	2
\.


--
-- Data for Name: COBROS; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."COBROS" ("cobCod", "cliCod", "cobFech", "cobMonto", "cobMetodo") FROM stdin;
\.


--
-- Data for Name: COTIZACIONES; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."COTIZACIONES" ("cotCod", "cotFech", "cliCod", "cotTotal", "cotEstado", "cotEstadoId") FROM stdin;
\.


--
-- Data for Name: CUENTAS_CORRIENTES; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."CUENTAS_CORRIENTES" ("cctaCod", "cliCod", "cctaFech", "cctaMovimiento", "cctaMonto", "cctaSaldo", "cctaDesc") FROM stdin;
2	12	2026-01-17	HABER	200.00	-200.00	Pago Factura #34 - 0001-00000021
\.


--
-- Data for Name: DETALLE_COTIZACIONES; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."DETALLE_COTIZACIONES" ("detCotCod", "cotCod", "detCant", "detPrecio", "detSubtotal", "artCod") FROM stdin;
\.


--
-- Data for Name: DETALLE_VENTAS; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."DETALLE_VENTAS" ("detCod", "venCod", "detCant", "detPrecio", "detSubtotal", "artCod") FROM stdin;
40	38	1.0000	1429.50	1429.50	3127
41	38	1.0000	1966.50	1966.50	3139
42	38	50.0000	56.73	2836.50	3766
43	38	1.0000	1055.08	1055.08	3637
44	38	2.0000	808.80	1617.60	2889
45	38	200.0000	11.65	2330.00	2940
46	38	1.0000	1025.15	1025.15	3680
47	38	1.0000	600.44	600.44	3542
48	38	1.0000	1650.03	1650.03	3691
49	38	1.0000	1492.36	1492.36	3651
50	38	12.0000	2080.12	24961.44	3672
51	38	40.0000	20.09	803.60	3557
52	38	1.0000	5311.65	5311.65	2674
53	38	1.0000	6237.55	6237.55	3747
54	38	2.0000	1196.85	2393.70	2891
55	38	3.0000	2075.01	6225.03	3129
56	39	1.0000	912.34	912.34	3737
57	39	20.0000	9.69	193.80	3558
58	39	1.0000	740.74	740.74	3618
59	39	3.0000	4740.34	14221.02	2668
60	39	30.0000	10.68	320.40	3781
61	39	1.0000	7327.53	7327.53	2648
62	39	1.0000	18020.00	18020.00	3491
63	39	1.0000	18020.00	18020.00	3493
64	40	8.0000	17.74	141.92	3456
65	40	8.0000	25.20	201.60	3457
\.


--
-- Data for Name: IVA; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."IVA" (id, porcentaje) FROM stdin;
6	27.00
3	0.00
4	10.50
5	21.00
\.


--
-- Data for Name: LISTAS; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."LISTAS" ("listCod", "listDesc", "listPercent", "listStatus") FROM stdin;
3	LIST3	75.00	t
4	LIST4	100.00	t
1	LIST1	25.00	t
2	LIST2	50.00	t
\.


--
-- Data for Name: MARCAS; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."MARCAS" ("marCod", "marNombre") FROM stdin;
6	IPS
7	PLAVICON
8	FEDERAL TOOLS
9	DUCA
10	UXELL
11	SIN PAR
12	NORTON
13	CARBO
14	GINYPLAST
15	FERRUM
16	IND. ARG.
17	KALOP
18	BAW
19	ALIC
20	ENERGIZER
21	EVEREADY
22	EXULTT
23	JELUZ
24	MACROLED
25	RAYOVAC
26	VALINCO
27	DUKE
28	EPOXI
29	GALI
30	IDEAL
31	PEIRANO
32	LATYN
33	TIGRE
34	ESSAMET
35	KUWAIT
36	PRISOL
37	RAPIFIX
38	MANN
40	IRIMO
41	HUDSON
39	TRAMONTINA PRO
42	TRAMONTINA MASTER
43	ACYTRA
44	BIASSONI
45	BOSCH
46	EVEL
47	EZETA
48	FORTEX
49	HORMIKILL
50	KALLAY
51	METZ
52	NITANYL
53	PENETRIT
54	PROLL
55	ROTTWEILER
57	STOK
58	TACSA
59	TEK BOND
60	NETCOLOR
61	TENTO
62	WALL
63	AQUATEX
64	KWT
65	PERFORMA
66	ZEOCAR
67	MEMBRANA FACIL
68	MI COLOR
69	GROWEN
71	RAF
73	MOULINEX
74	LUMILAGRO
75	EL SIGLO
76	TRAMONTINA
77	PLAVIPINT
70	SINDELEN
78	HUNTER
72	U-LINE
79	FARTOLL
80	SERVETTE
81	FARSER
82	ELEGANTE
83	JESICA
84	SIMONAGGIO
85	JOSEPH
86	RIGOLLEAU
87	ADMIRAL
88	AD
89	POLYFILM
90	ATA FACIL
91	FLOWI
92	SON BUENAS
93	MOVAR
94	BREMEN
95	KING
96	NOVA
97	NADIR
98	VICTORIA
99	DRAGONCITO
100	JOVIFEL
101	CAROL
102	DESAFIO
103	KIMGLASS
104	CRYSTAL ROCK
105	LEDVANCE
106	ENPOLEX
107	FISCHER
109	BULEVARES
110	CANDELA
111	FEDERAL LIGHT
112	DEXAL
113	KOVAL PLAST
115	PITBUILD
116	SUSSEX
117	ELITE
118	PURITY
119	ROLOFILM
120	ROLOPAC
121	MAXIFILM
122	COLGATE
123	MAR DE FLOR
124	TRACAL
125	LUO
126	BICYCLE LOOK
127	QUALITY PRODUCT
128	PRADO
129	EZCO
130	TRIUNFANTE
131	RAB
132	PLAYCOLOR
133	LUMA
134	EDE
135	YUYO
136	FILGO
137	PLANTEC
138	TINTORETTO
56	SIFAP
139	OLAMI
140	EQ
141	ETERNA
142	ONZA
143	SOL
144	DONCELLA
145	CBX
146	VAHE
147	GROZ BECKER
148	PY
149	MYG
150	HIDROGASA
151	NOGALY
152	CABRERA
153	HONY MEDICAL
154	LAZARO
155	SYRA
156	BOLONG
157	SILVER
158	LUBRIND
159	STA
160	MAPED
161	CISNE
162	CURITAS
163	SICA
164	ALFOLATEX
165	DROGAL
166	INTERELEC
167	GENESIS
168	DORKING
169	HB
170	EMBLEMAS ARGENTINOS
171	BENTLEY
172	OTA
173	CADENA
174	PICASSO
108	BAL PLAST
175	LA ESPONJA
176	ROMYL
177	MAKE
178	JOSMART
179	TIO MOPIN
180	MR TRAPO
182	ASAPRACTIC
183	PIRAGUA
184	SUPY
185	LA GAUCHITA
186	TODO ESPONJA
187	ECONOMAX
188	PLUMITA
189	SEGOD
190	LUSQTOFF
191	RERAR
192	EL ROBLE
193	ANEMI
194	LA HACENDOSA
195	ESAB
\.


--
-- Data for Name: MOVIMIENTOS_CAJA; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."MOVIMIENTOS_CAJA" ("movCod", "movFecha", "movTipo", "movMetodoPago", "movMonto", "movDescripcion", "chqCod") FROM stdin;
1	2025-12-02	1	5	22869.00	Presupuesto Venta #29 - Cliente Prueba AFIP	\N
2	2026-01-02	1	5	4356.00	Presupuesto Venta #32 - Empresa Prueba S.A.	\N
3	2026-01-17	1	5	6528.75	Pago Factura #35 - 0001-00000001 - Empresa Prueba S.A.	\N
4	2026-01-17	1	2	3000.00	Pago Factura #35 - 0001-00000001 - Empresa Prueba S.A.	\N
5	2026-01-24	1	6	2048.68	Presupuesto Venta #38 - Juan Pérez	\N
\.


--
-- Data for Name: PAGOS; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."PAGOS" ("pagCod", "cliCod", "pagFech", "pagMonto", "pagMetodoPago", "pagDesc", "cctaCod", "venCod") FROM stdin;
1	11	2026-01-17	6528.75	5	Pago Factura 0001-00000001	\N	\N
2	11	2026-01-17	3000.00	2	Pago Factura 0001-00000001	\N	\N
3	12	2026-01-17	1705.75	3	Pago Factura 0001-00000021	\N	\N
4	12	2026-01-17	200.00	3	Pago Factura 0001-00000021	2	\N
\.


--
-- Data for Name: PROVEEDORES; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."PROVEEDORES" ("proCod", "proNombre", "proCUIT", "proContacto", "proDescuento", "proEmail", "proCelular") FROM stdin;
4	ENFER	\N	CAMILA	17.00	\N	\N
5	ARCO IRIS	\N	JORGE	0.00	\N	\N
6	NORTCUYO	\N	PABLO MOLINA	19.00	\N	\N
7	NAVIDAD	\N	\N	0.00	\N	\N
8	PASCUALOTTO	\N	GABRIELA	0.00	\N	\N
9	FEMA	\N	\N	0.00	\N	\N
10	LUJAN AGRICOLA	\N	VICTOR	0.00	\N	\N
11	ENZOMAQ	\N	NICOLAS	0.00	\N	\N
12	EL DEDAL	\N	MARIELA	0.00	\N	\N
13	DALMA	\N	MONICA	0.00	\N	\N
14	MEGAMAYORISTA	\N	\N	0.00	\N	\N
15	OFIMAX	\N	VALERIA	0.00	\N	\N
3	KATSUDA	\N	MARCELO PINA	0.00	\N	\N
16	PLATAFORMAS ONLINE	\N	\N	0.00	\N	\N
17	MANZANO	\N	BELEN	0.00	\N	\N
18	GRANPLAST	\N	\N	0.00	\N	\N
19	MATERIALES BELGRANO	\N	ANA	0.00	\N	\N
20	EICHLER	\N	DIEGO	0.00	\N	\N
21	SABATINI	\N	\N	0.00	\N	\N
22	OSCAR DAVID	\N	\N	0.00	\N	\N
23	DIFUCOR	\N	MARCOS/ NESTOR	0.00	\N	\N
24	EMBLEMAS ARGENTINOS	\N	\N	0.00	\N	\N
25	ZAPATERIA JOSE LUIS	\N	\N	0.00	\N	\N
26	LA ESPONJA	\N	\N	0.00	\N	\N
\.


--
-- Data for Name: USUARIOS; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."USUARIOS" (id, "usuUsername", "usuPasswordHash", "usuRole", "usuNombreCompleto", "usuEmail", "usuActivo", "usuFechaCreacion", "usuUltimoLogin", "usuCreadoPor", "usuModificadoPor", "usuFechaModificacion") FROM stdin;
2	jmalonso	$2a$11$UOh2Ukxiw81ioNruBL27u.zj32Q6H6bN7PV7.HsdU6RIgnRxAuIf2	admin	Juan Manuel Alonso	jmalonso1253@gmail.com	t	2025-12-21 12:44:18.845102	2025-12-21 17:23:54.478241	1	1	2025-12-21 17:23:45.657223
1	admin	$2a$11$n7flzOgnSQwkC.HrO4odaOp.cRPz3RrUB.qWnfLW3JzVzMVmrvXiS	admin	Administrador del Sistema	\N	t	2025-12-19 21:43:17.333933	2026-01-29 21:53:16.932737	\N	\N	\N
\.


--
-- Data for Name: VENTAS; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."VENTAS" ("venCod", "venFech", "cliCod", "venTotal", "venTipoCbte", "venEstado", "venMetodoPago", "venPuntoVenta", "venNumComprobante", "venCAE", "venCAEVencimiento", "venFechaAutorizacion", "venResultadoAfip", "venObservacionesAfip", "venLista", "venFechVenta", "venEstadoPago") FROM stdin;
38	2026-01-24	18	61936.10	\N	1	5	\N	\N	\N	\N	\N	\N	\N	\N	2026-01-24 12:34:45.5346	\N
39	2026-01-24	18	59755.80	\N	1	5	\N	\N	\N	\N	\N	\N	\N	\N	2026-01-24 12:47:03.165737	\N
40	2026-01-24	18	343.52	\N	1	5	\N	\N	\N	\N	\N	\N	\N	1	2026-01-24 13:26:35.377759	\N
\.


--
-- Data for Name: __EFMigrationsHistory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."__EFMigrationsHistory" ("MigrationId", "ProductVersion") FROM stdin;
20251022013212_AddVentaTipoEstadoAndMetodoPago	9.0.10
\.


--
-- Data for Name: afipLogs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."afipLogs" (id, fecha, "tipoOperacion", "venCod", "tipoComprobante", "puntoVenta", "numeroComprobante", request, response, exitoso, "mensajeError", cae, "duracionMs", "ipAddress") FROM stdin;
33	2026-01-03 00:10:53.603233	FECAESolic	\N	\N	\N	\N	{"TipoComprobante":2,"PuntoVenta":1,"NumeroComprobante":1,"Fecha":"2026-01-02T00:00:00","TipoDocCliente":2,"NumeroDocCliente":12345678,"CondicionIVAReceptor":5,"ImporteTotal":5717.25,"ImporteNeto":4725,"ImporteIVA":992.25,"ImporteExento":0,"ImporteTributos":0,"Concepto":"Productos","MonedaId":1,"MonedaCotizacion":1,"ItemsIVA":[{"CodigoIVA":5,"BaseImponible":4725,"Importe":992.25}],"Items":[]}	{"Success":false,"Resultado":"R","CAE":"","CAEVencimiento":null,"NumeroComprobante":1,"Observaciones":"10013: Para comprobantes clase \\u0027A\\u0027 y \\u0027A con leyenda operaci\\u00F3n sujeta a retenci\\u00F3n\\u0027 el campo  DocTipo debe ser igual a 80 (CUIT); 10015: El campo  DocNro es invalido.; 10243: El campo Condicion IVA receptor no es valido para la clase de comprobante informado. Consular metodo FEParamGetCondicionIvaReceptor","Errores":[]}	f			\N	::1
34	2026-01-03 00:47:38.943374	FECAESolic	\N	\N	\N	\N	{"TipoComprobante":6,"PuntoVenta":1,"NumeroComprobante":1,"Fecha":"2026-01-02T00:00:00","TipoDocCliente":96,"NumeroDocCliente":12345678,"CondicionIVAReceptor":5,"ImporteTotal":5717.25,"ImporteNeto":4725,"ImporteIVA":992.25,"ImporteExento":0,"ImporteTributos":0,"Concepto":"Productos","MonedaId":1,"MonedaCotizacion":1,"ItemsIVA":[{"CodigoIVA":5,"BaseImponible":4725,"Importe":992.25}],"Items":[]}	{"Success":false,"Resultado":"R","CAE":"","CAEVencimiento":null,"NumeroComprobante":1,"Observaciones":"","Errores":["10016: El numero o fecha del comprobante no se corresponde con el proximo a autorizar. Consultar metodo FECompUltimoAutorizado."]}	f	10016: El numero o fecha del comprobante no se corresponde con el proximo a autorizar. Consultar metodo FECompUltimoAutorizado.		\N	::1
38	2026-01-11 19:32:17.612299	FECAESolic	\N	\N	\N	\N	{"TipoComprobante":1,"PuntoVenta":1,"NumeroComprobante":2,"Fecha":"2026-01-11T00:00:00","TipoDocCliente":80,"NumeroDocCliente":20292736887,"CondicionIVAReceptor":1,"ImporteTotal":14701.5,"ImporteNeto":12150,"ImporteIVA":2551.5,"ImporteExento":0,"ImporteTributos":0,"Concepto":"Productos","MonedaId":1,"MonedaCotizacion":1,"ItemsIVA":[{"CodigoIVA":5,"BaseImponible":12150,"Importe":2551.5}],"Items":[]}	{"Success":true,"Resultado":"A","CAE":"76023308921742","CAEVencimiento":"2026-01-21T12:00:00Z","NumeroComprobante":2,"Observaciones":"10217: El credito fiscal discriminado en el presente comprobante solo podra ser computado a efectos del Procedimiento permanente de transicion al Regimen General.","Errores":[]}	t	\N	76023308921742	\N	::1
37	2026-01-11 19:15:17.651838	FECAESolic	\N	\N	\N	\N	{"TipoComprobante":1,"PuntoVenta":1,"NumeroComprobante":1,"Fecha":"2026-01-11T00:00:00","TipoDocCliente":80,"NumeroDocCliente":30123456789,"CondicionIVAReceptor":1,"ImporteTotal":9528.75,"ImporteNeto":7875,"ImporteIVA":1653.75,"ImporteExento":0,"ImporteTributos":0,"Concepto":"Productos","MonedaId":1,"MonedaCotizacion":1,"ItemsIVA":[{"CodigoIVA":5,"BaseImponible":7875,"Importe":1653.75}],"Items":[]}	{"Success":true,"Resultado":"A","CAE":"76023308921331","CAEVencimiento":"2026-01-21T12:00:00Z","NumeroComprobante":1,"Observaciones":"10238: DocTipo: 80, DocNro 30123456789 - La CUIT receptora que ingresaste no existe. Tenes que emitir una Nota de Credito o anular la operacion, segun corresponda.","Errores":[]}	t	\N	76023308921331	\N	::1
35	2026-01-03 00:48:32.934326	FECAESolic	\N	\N	\N	\N	{"TipoComprobante":6,"PuntoVenta":1,"NumeroComprobante":1,"Fecha":"2026-01-03T00:00:00","TipoDocCliente":96,"NumeroDocCliente":12345678,"CondicionIVAReceptor":5,"ImporteTotal":1905.75,"ImporteNeto":1575,"ImporteIVA":330.75,"ImporteExento":0,"ImporteTributos":0,"Concepto":"Productos","MonedaId":1,"MonedaCotizacion":1,"ItemsIVA":[{"CodigoIVA":5,"BaseImponible":1575,"Importe":330.75}],"Items":[]}	{"Success":false,"Resultado":"R","CAE":"","CAEVencimiento":null,"NumeroComprobante":1,"Observaciones":"","Errores":["10016: El numero o fecha del comprobante no se corresponde con el proximo a autorizar. Consultar metodo FECompUltimoAutorizado."]}	f	10016: El numero o fecha del comprobante no se corresponde con el proximo a autorizar. Consultar metodo FECompUltimoAutorizado.		\N	::1
36	2026-01-03 01:03:15.412748	FECAESolic	\N	\N	\N	\N	{"TipoComprobante":6,"PuntoVenta":1,"NumeroComprobante":21,"Fecha":"2026-01-03T00:00:00","TipoDocCliente":96,"NumeroDocCliente":12345678,"CondicionIVAReceptor":5,"ImporteTotal":1905.75,"ImporteNeto":1575,"ImporteIVA":330.75,"ImporteExento":0,"ImporteTributos":0,"Concepto":"Productos","MonedaId":1,"MonedaCotizacion":1,"ItemsIVA":[{"CodigoIVA":5,"BaseImponible":1575,"Importe":330.75}],"Items":[]}	{"Success":true,"Resultado":"A","CAE":"76013305580601","CAEVencimiento":"2026-01-13T12:00:00Z","NumeroComprobante":21,"Observaciones":"","Errores":[]}	t	\N	76013305580601	\N	::1
\.


--
-- Data for Name: afip_auth_tickets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.afip_auth_tickets (id, cuit_representado, token, sign, generated_at, expiration_time, environment) FROM stdin;
1	30717637433	PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pgo8c3NvIHZlcnNpb249IjIuMCI+CiAgICA8aWQgc3JjPSJDTj13c2FhaG9tbywgTz1BRklQLCBDPUFSLCBTRVJJQUxOVU1CRVI9Q1VJVCAzMzY5MzQ1MDIzOSIgZHN0PSJDTj13c2ZlLCBPPUFGSVAsIEM9QVIiIHVuaXF1ZV9pZD0iMTIzNDcxNDgxNCIgZ2VuX3RpbWU9IjE3NjQyMTUwMTEiIGV4cF90aW1lPSIxNzY0MjU4MjcxIi8+CiAgICA8b3BlcmF0aW9uIHR5cGU9ImxvZ2luIiB2YWx1ZT0iZ3JhbnRlZCI+CiAgICAgICAgPGxvZ2luIGVudGl0eT0iMzM2OTM0NTAyMzkiIHNlcnZpY2U9IndzZmUiIHVpZD0iU0VSSUFMTlVNQkVSPUNVSVQgMjAyOTI3MzY4ODcsIENOPXBydWViYSIgYXV0aG1ldGhvZD0iY21zIiByZWdtZXRob2Q9IjIyIj4KICAgICAgICAgICAgPHJlbGF0aW9ucz4KICAgICAgICAgICAgICAgIDxyZWxhdGlvbiBrZXk9IjMwNzE3NjM3NDMzIiByZWx0eXBlPSI0Ii8+CiAgICAgICAgICAgIDwvcmVsYXRpb25zPgogICAgICAgIDwvbG9naW4+CiAgICA8L29wZXJhdGlvbj4KPC9zc28+Cg==	GyHvtnZuycgALyI+RutuxpgvO3c/oNXnTokX7uWD0Dbln+WZZeFmuF0Zn75uEv2Por3I7HDFfLWEg5CD9r/+6+VaZUZibqlOKRR1MlQ6/XLF0koevC32VVLmjE3e4llipfTgBl1fhtor6HSO1SfTB0nm/cJuxnSaSl7v67OYfUE=	2025-11-27 00:44:33.762273-03	2025-11-27 12:44:31.206-03	Homologacion
2	30717637433	PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pgo8c3NvIHZlcnNpb249IjIuMCI+CiAgICA8aWQgc3JjPSJDTj13c2FhaG9tbywgTz1BRklQLCBDPUFSLCBTRVJJQUxOVU1CRVI9Q1VJVCAzMzY5MzQ1MDIzOSIgZHN0PSJDTj13c2ZlLCBPPUFGSVAsIEM9QVIiIHVuaXF1ZV9pZD0iNDEzODg4OTQ3MyIgZ2VuX3RpbWU9IjE3NjQzNjE2MjAiIGV4cF90aW1lPSIxNzY0NDA0ODgwIi8+CiAgICA8b3BlcmF0aW9uIHR5cGU9ImxvZ2luIiB2YWx1ZT0iZ3JhbnRlZCI+CiAgICAgICAgPGxvZ2luIGVudGl0eT0iMzM2OTM0NTAyMzkiIHNlcnZpY2U9IndzZmUiIHVpZD0iU0VSSUFMTlVNQkVSPUNVSVQgMjAyOTI3MzY4ODcsIENOPXBydWViYSIgYXV0aG1ldGhvZD0iY21zIiByZWdtZXRob2Q9IjIyIj4KICAgICAgICAgICAgPHJlbGF0aW9ucz4KICAgICAgICAgICAgICAgIDxyZWxhdGlvbiBrZXk9IjMwNzE3NjM3NDMzIiByZWx0eXBlPSI0Ii8+CiAgICAgICAgICAgIDwvcmVsYXRpb25zPgogICAgICAgIDwvbG9naW4+CiAgICA8L29wZXJhdGlvbj4KPC9zc28+Cg==	b4LiCZOU6b7T0ki1bgU4aupAS8i1FmDOGbkFUHGjwEhni12tB8aQ3UVN8a7sEAjzLlCn/Ae211Qf7DhjYuGeqqGgr6bbl6J24jjZlusjIJZ7oGSpe7w40LGJxGguJad6JHfE4IcTxjTbzpL5XW4i3gMY0JGcG4QPmMbkFhjrbp0=	2025-11-28 17:28:00.685156-03	2025-11-29 05:28:00.58-03	Homologacion
3	30717637433	PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pgo8c3NvIHZlcnNpb249IjIuMCI+CiAgICA8aWQgc3JjPSJDTj13c2FhaG9tbywgTz1BRklQLCBDPUFSLCBTRVJJQUxOVU1CRVI9Q1VJVCAzMzY5MzQ1MDIzOSIgZHN0PSJDTj13c2ZlLCBPPUFGSVAsIEM9QVIiIHVuaXF1ZV9pZD0iODEwNTY1ODI2IiBnZW5fdGltZT0iMTc2NDU0NjczMiIgZXhwX3RpbWU9IjE3NjQ1ODk5OTIiLz4KICAgIDxvcGVyYXRpb24gdHlwZT0ibG9naW4iIHZhbHVlPSJncmFudGVkIj4KICAgICAgICA8bG9naW4gZW50aXR5PSIzMzY5MzQ1MDIzOSIgc2VydmljZT0id3NmZSIgdWlkPSJTRVJJQUxOVU1CRVI9Q1VJVCAyMDI5MjczNjg4NywgQ049cHJ1ZWJhIiBhdXRobWV0aG9kPSJjbXMiIHJlZ21ldGhvZD0iMjIiPgogICAgICAgICAgICA8cmVsYXRpb25zPgogICAgICAgICAgICAgICAgPHJlbGF0aW9uIGtleT0iMzA3MTc2Mzc0MzMiIHJlbHR5cGU9IjQiLz4KICAgICAgICAgICAgPC9yZWxhdGlvbnM+CiAgICAgICAgPC9sb2dpbj4KICAgIDwvb3BlcmF0aW9uPgo8L3Nzbz4K	G1CUZfjTNyJ8SkqlbPSOu0sqhMGLUGpQtTVw136swq8EXujYCIIfLmfmKv3uDXiOc34rrB5/1Dk0qNgsjjb5iY782fGWnS5/7M/7mnXYmKBSOC9BRMh0xw8Tg+FTGbYy9uisWl1UtiSYkEehB7SfG7byf35dKV6DMQsLU0kGVGc=	2025-11-30 20:53:11.227769-03	2025-12-01 08:53:12.047-03	Homologacion
4	30717637433	PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pgo8c3NvIHZlcnNpb249IjIuMCI+CiAgICA8aWQgc3JjPSJDTj13c2FhaG9tbywgTz1BRklQLCBDPUFSLCBTRVJJQUxOVU1CRVI9Q1VJVCAzMzY5MzQ1MDIzOSIgZHN0PSJDTj13c2ZlLCBPPUFGSVAsIEM9QVIiIHVuaXF1ZV9pZD0iMTk1NTc5NTkyMSIgZ2VuX3RpbWU9IjE3Njc0MDk3OTEiIGV4cF90aW1lPSIxNzY3NDUzMDUxIi8+CiAgICA8b3BlcmF0aW9uIHR5cGU9ImxvZ2luIiB2YWx1ZT0iZ3JhbnRlZCI+CiAgICAgICAgPGxvZ2luIGVudGl0eT0iMzM2OTM0NTAyMzkiIHNlcnZpY2U9IndzZmUiIHVpZD0iU0VSSUFMTlVNQkVSPUNVSVQgMjAyOTI3MzY4ODcsIENOPXBydWViYSIgYXV0aG1ldGhvZD0iY21zIiByZWdtZXRob2Q9IjIyIj4KICAgICAgICAgICAgPHJlbGF0aW9ucz4KICAgICAgICAgICAgICAgIDxyZWxhdGlvbiBrZXk9IjMwNzE3NjM3NDMzIiByZWx0eXBlPSI0Ii8+CiAgICAgICAgICAgIDwvcmVsYXRpb25zPgogICAgICAgIDwvbG9naW4+CiAgICA8L29wZXJhdGlvbj4KPC9zc28+Cg==	gwx4qNV7QPesDSvuWrZUoMvPxOUO2xIdEcOtkGJmbT7J6FOF/RZiJ3rxDzmlAhS/D7J+tCsMC9LdJmFZfTF0CxC6iPszBdzbOGXGHAHDdrLhQoMZKvjhJdn/kkxjqdwtpqgH5sl5aaix8aYM8+MXr5OGjFOBFNuqArjFl/J6l9c=	2026-01-03 00:10:51.984974-03	2026-01-03 12:10:51.765-03	Homologacion
5	30717637433	PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/Pgo8c3NvIHZlcnNpb249IjIuMCI+CiAgICA8aWQgc3JjPSJDTj13c2FhaG9tbywgTz1BRklQLCBDPUFSLCBTRVJJQUxOVU1CRVI9Q1VJVCAzMzY5MzQ1MDIzOSIgZHN0PSJDTj13c2ZlLCBPPUFGSVAsIEM9QVIiIHVuaXF1ZV9pZD0iMjQ3NTEwODU5MCIgZ2VuX3RpbWU9IjE3NjgxNjk2NTUiIGV4cF90aW1lPSIxNzY4MjEyOTE1Ii8+CiAgICA8b3BlcmF0aW9uIHR5cGU9ImxvZ2luIiB2YWx1ZT0iZ3JhbnRlZCI+CiAgICAgICAgPGxvZ2luIGVudGl0eT0iMzM2OTM0NTAyMzkiIHNlcnZpY2U9IndzZmUiIHVpZD0iU0VSSUFMTlVNQkVSPUNVSVQgMjAyOTI3MzY4ODcsIENOPXBydWViYSIgYXV0aG1ldGhvZD0iY21zIiByZWdtZXRob2Q9IjIyIj4KICAgICAgICAgICAgPHJlbGF0aW9ucz4KICAgICAgICAgICAgICAgIDxyZWxhdGlvbiBrZXk9IjMwNzE3NjM3NDMzIiByZWx0eXBlPSI0Ii8+CiAgICAgICAgICAgIDwvcmVsYXRpb25zPgogICAgICAgIDwvbG9naW4+CiAgICA8L29wZXJhdGlvbj4KPC9zc28+Cg==	WLVK3sN3zjQcAVz0hfqq5HOlqyRxhm9h8sh/4xFFP8LFz/2Re3ThIp2lYx5oyi+0Zbpfdne5Bpf0YojX6+/r09lPEtna6Ayl2y2HOtLIgjmp/k7a1xxhKiRTx0RSjqIx0Oe4p+nxDHX4lM6BwyVYe3NK+Vw4UOngDV22akMz/wM=	2026-01-11 19:15:16.113024-03	2026-01-12 07:15:15.01-03	Homologacion
\.


--
-- Data for Name: clienteTipoFormaPago; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."clienteTipoFormaPago" (id, descripcion) FROM stdin;
1	Cuenta Corriente
2	Efectivo
3	Ambos
\.


--
-- Data for Name: condicionIVA; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."condicionIVA" (id, "codigoAfip", descripcion) FROM stdin;
6	8	Proveedor del Exterior
7	9	Cliente del Exterior
11	13	Monotributista Social
1	1	Responsable Inscripto
2	4	Exento
3	5	Consumidor Final
4	6	Responsable Monotributo
5	13	No Responsable
9	11	IVA Responsable Inscripto - Agente de Percepción
10	12	Pequeño Contribuyente Eventual
12	14	Pequeño Contribuyente Eventual Social
8	10	IVA Liberado - Ley Nº 19.640
\.


--
-- Data for Name: cotizacionEstados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."cotizacionEstados" (id, descripcion, color) FROM stdin;
1	Pendiente	warning
2	Convertida	success
3	Cancelada	danger
4	Vencida	secondary
\.


--
-- Data for Name: tipoComprobante; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."tipoComprobante" (id, "codigoAfip", descripcion, "requiereCAE") FROM stdin;
13	4	Recibo A	t
14	9	Recibo B	t
15	15	Recibo C	t
16	0	Sin comprobante	f
7	13	Nota de Crédito C	t
8	53	Nota de Crédito M	t
9	2	Nota de Débito A	t
10	7	Nota de Débito B	t
11	12	Nota de Débito C	t
12	52	Nota de Débito M	t
17	99	Comprobante de Cotización	f
1	1	Factura A	t
2	6	Factura B	t
3	11	Factura C	t
4	3	Nota de Crédito A	t
5	8	Nota de Crédito B	t
\.


--
-- Data for Name: tipoDocumento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."tipoDocumento" (id, "codigoAfip", descripcion) FROM stdin;
5	99	Consumidor Final
1	80	CUIT
2	96	DNI
4	86	CUIL
6	99	Sin Identificar
3	94	Doc. Trib. No Residentes
\.


--
-- Data for Name: tipoMovimientoCaja; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."tipoMovimientoCaja" (id, descripcion, tipo) FROM stdin;
1	Venta en Efectivo	INGRESO
3	Otro Ingreso	INGRESO
4	Pago a Proveedor	EGRESO
5	Gasto Operativo	EGRESO
6	Retiro Personal	EGRESO
7	Depositar Cheque en Banco	EGRESO
8	Entregar Cheque a Tercero	EGRESO
9	Otro Egreso	EGRESO
2	Depósito Inicial	INGRESO
\.


--
-- Data for Name: ventaEstadoPago; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ventaEstadoPago" (id, descripcion) FROM stdin;
1	Pendiente
2	Parcialmente Pagada
3	Pagada
\.


--
-- Data for Name: ventaTipoEstado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ventaTipoEstado" (id, descripcion) FROM stdin;
1	Completada
2	Pendiente
3	Cancelada
4	Facturada
\.


--
-- Data for Name: ventaTipoMetodoPagos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ventaTipoMetodoPagos" (id, descripcion) FROM stdin;
3	Cuenta Corriente
4	Cheque
5	Efectivo
1	Débito
2	Crédito
6	Transferencia
\.


--
-- Name: ARTICULOS_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ARTICULOS_id_seq"', 3785, true);


--
-- Name: CHEQUES_chqCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."CHEQUES_chqCod_seq"', 1, false);


--
-- Name: CLIENTES_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."CLIENTES_id_seq"', 18, true);


--
-- Name: COBROS_cobCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."COBROS_cobCod_seq"', 1, false);


--
-- Name: COTIZACIONES_cotCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."COTIZACIONES_cotCod_seq"', 4, true);


--
-- Name: CUENTAS_CORRIENTES_cctaCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."CUENTAS_CORRIENTES_cctaCod_seq"', 1, false);


--
-- Name: DETALLE_COTIZACIONES_detCotCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."DETALLE_COTIZACIONES_detCotCod_seq"', 4, true);


--
-- Name: DETALLE_VENTAS_detCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."DETALLE_VENTAS_detCod_seq"', 65, true);


--
-- Name: MARCAS_marCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."MARCAS_marCod_seq"', 195, true);


--
-- Name: MOVIMIENTOS_CAJA_movCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."MOVIMIENTOS_CAJA_movCod_seq"', 7, true);


--
-- Name: PAGOS_pagCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."PAGOS_pagCod_seq"', 1, false);


--
-- Name: PROVEEDORES_proCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."PROVEEDORES_proCod_seq"', 26, true);


--
-- Name: USUARIOS_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."USUARIOS_id_seq"', 4, true);


--
-- Name: VENTAS_venCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."VENTAS_venCod_seq"', 40, true);


--
-- Name: afipLogs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."afipLogs_id_seq"', 38, true);


--
-- Name: afip_auth_tickets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.afip_auth_tickets_id_seq', 5, true);


--
-- Name: clienteTipoFormaPago_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."clienteTipoFormaPago_id_seq"', 3, true);


--
-- Name: condicionIVA_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."condicionIVA_id_seq"', 12, true);


--
-- Name: cotizacionEstados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."cotizacionEstados_id_seq"', 1, false);


--
-- Name: iva_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.iva_id_seq', 7, false);


--
-- Name: listas_listCod_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."listas_listCod_seq"', 4, true);


--
-- Name: tipoComprobante_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."tipoComprobante_id_seq"', 17, true);


--
-- Name: tipoDocumento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."tipoDocumento_id_seq"', 6, true);


--
-- Name: tipoMovimientoCaja_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."tipoMovimientoCaja_id_seq"', 9, true);


--
-- Name: ventaEstadoPago_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ventaEstadoPago_id_seq"', 1, false);


--
-- Name: ventaTipoEstado_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ventaTipoEstado_id_seq"', 1, true);


--
-- Name: ventaTipoMetodoPagos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ventaTipoMetodoPagos_id_seq"', 1, false);


--
-- Name: ARTICULOS ARTICULOS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ARTICULOS"
    ADD CONSTRAINT "ARTICULOS_pkey" PRIMARY KEY (id);


--
-- Name: CHEQUES CHEQUES_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CHEQUES"
    ADD CONSTRAINT "CHEQUES_pkey" PRIMARY KEY ("chqCod");


--
-- Name: CLIENTES CLIENTES_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CLIENTES"
    ADD CONSTRAINT "CLIENTES_pkey" PRIMARY KEY (id);


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
-- Name: LISTAS LISTAS_pkey_1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."LISTAS"
    ADD CONSTRAINT "LISTAS_pkey_1" PRIMARY KEY ("listCod");


--
-- Name: MARCAS MARCAS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MARCAS"
    ADD CONSTRAINT "MARCAS_pkey" PRIMARY KEY ("marCod");


--
-- Name: MOVIMIENTOS_CAJA MOVIMIENTOS_CAJA_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MOVIMIENTOS_CAJA"
    ADD CONSTRAINT "MOVIMIENTOS_CAJA_pkey" PRIMARY KEY ("movCod");


--
-- Name: PAGOS PAGOS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PAGOS"
    ADD CONSTRAINT "PAGOS_pkey" PRIMARY KEY ("pagCod");


--
-- Name: __EFMigrationsHistory PK___EFMigrationsHistory; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."__EFMigrationsHistory"
    ADD CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId");


--
-- Name: PROVEEDORES PROVEEDORES_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PROVEEDORES"
    ADD CONSTRAINT "PROVEEDORES_pkey" PRIMARY KEY ("proCod");


--
-- Name: USUARIOS USUARIOS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."USUARIOS"
    ADD CONSTRAINT "USUARIOS_pkey" PRIMARY KEY (id);


--
-- Name: USUARIOS USUARIOS_usuUsername_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."USUARIOS"
    ADD CONSTRAINT "USUARIOS_usuUsername_key" UNIQUE ("usuUsername");


--
-- Name: VENTAS VENTAS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."VENTAS"
    ADD CONSTRAINT "VENTAS_pkey" PRIMARY KEY ("venCod");


--
-- Name: afipLogs afipLogs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."afipLogs"
    ADD CONSTRAINT "afipLogs_pkey" PRIMARY KEY (id);


--
-- Name: afip_auth_tickets afip_auth_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afip_auth_tickets
    ADD CONSTRAINT afip_auth_tickets_pkey PRIMARY KEY (id);


--
-- Name: clienteTipoFormaPago clienteTipoFormaPago_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."clienteTipoFormaPago"
    ADD CONSTRAINT "clienteTipoFormaPago_pkey" PRIMARY KEY (id);


--
-- Name: condicionIVA condicionIVA_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."condicionIVA"
    ADD CONSTRAINT "condicionIVA_pkey" PRIMARY KEY (id);


--
-- Name: cotizacionEstados cotizacionEstados_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."cotizacionEstados"
    ADD CONSTRAINT "cotizacionEstados_pkey" PRIMARY KEY (id);


--
-- Name: IVA iva_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."IVA"
    ADD CONSTRAINT iva_pkey PRIMARY KEY (id);


--
-- Name: tipoComprobante tipoComprobante_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tipoComprobante"
    ADD CONSTRAINT "tipoComprobante_pkey" PRIMARY KEY (id);


--
-- Name: tipoDocumento tipoDocumento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tipoDocumento"
    ADD CONSTRAINT "tipoDocumento_pkey" PRIMARY KEY (id);


--
-- Name: tipoMovimientoCaja tipoMovimientoCaja_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tipoMovimientoCaja"
    ADD CONSTRAINT "tipoMovimientoCaja_pkey" PRIMARY KEY (id);


--
-- Name: ventaEstadoPago ventaEstadoPago_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ventaEstadoPago"
    ADD CONSTRAINT "ventaEstadoPago_pkey" PRIMARY KEY (id);


--
-- Name: ventaTipoEstado ventaTipoEstado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ventaTipoEstado"
    ADD CONSTRAINT "ventaTipoEstado_pkey" PRIMARY KEY (id);


--
-- Name: ventaTipoMetodoPagos ventaTipoMetodoPagos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ventaTipoMetodoPagos"
    ADD CONSTRAINT "ventaTipoMetodoPagos_pkey" PRIMARY KEY (id);


--
-- Name: ARTICULOS_artCod_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "ARTICULOS_artCod_unique" ON public."ARTICULOS" USING btree ("artCod");


--
-- Name: IX_CHEQUES_chqEnCaja; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_CHEQUES_chqEnCaja" ON public."CHEQUES" USING btree ("chqEnCaja");


--
-- Name: IX_CHEQUES_chqFechaCobro; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_CHEQUES_chqFechaCobro" ON public."CHEQUES" USING btree ("chqFechaCobro");


--
-- Name: IX_CHEQUES_pagCod; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_CHEQUES_pagCod" ON public."CHEQUES" USING btree ("pagCod");


--
-- Name: IX_CLIENTES_cliCondicionIVA; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_CLIENTES_cliCondicionIVA" ON public."CLIENTES" USING btree ("cliCondicionIVA");


--
-- Name: IX_CLIENTES_cliFormaPago; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_CLIENTES_cliFormaPago" ON public."CLIENTES" USING btree ("cliFormaPago");


--
-- Name: IX_CLIENTES_cliTipoDoc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_CLIENTES_cliTipoDoc" ON public."CLIENTES" USING btree ("cliTipoDoc");


--
-- Name: IX_MOVIMIENTOS_CAJA_movFecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_MOVIMIENTOS_CAJA_movFecha" ON public."MOVIMIENTOS_CAJA" USING btree ("movFecha" DESC);


--
-- Name: IX_MOVIMIENTOS_CAJA_movMetodoPago; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_MOVIMIENTOS_CAJA_movMetodoPago" ON public."MOVIMIENTOS_CAJA" USING btree ("movMetodoPago");


--
-- Name: IX_MOVIMIENTOS_CAJA_movTipo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_MOVIMIENTOS_CAJA_movTipo" ON public."MOVIMIENTOS_CAJA" USING btree ("movTipo");


--
-- Name: IX_PAGOS_cctaCod; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_PAGOS_cctaCod" ON public."PAGOS" USING btree ("cctaCod");


--
-- Name: IX_PAGOS_cliCod; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_PAGOS_cliCod" ON public."PAGOS" USING btree ("cliCod");


--
-- Name: IX_PAGOS_pagFech; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_PAGOS_pagFech" ON public."PAGOS" USING btree ("pagFech" DESC);


--
-- Name: IX_PAGOS_pagMetodoPago; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_PAGOS_pagMetodoPago" ON public."PAGOS" USING btree ("pagMetodoPago");


--
-- Name: IX_USUARIOS_usuActivo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_USUARIOS_usuActivo" ON public."USUARIOS" USING btree ("usuActivo");


--
-- Name: IX_USUARIOS_usuRole; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_USUARIOS_usuRole" ON public."USUARIOS" USING btree ("usuRole");


--
-- Name: IX_USUARIOS_usuUsername; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_USUARIOS_usuUsername" ON public."USUARIOS" USING btree ("usuUsername");


--
-- Name: IX_VENTAS_venCAE; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_VENTAS_venCAE" ON public."VENTAS" USING btree ("venCAE");


--
-- Name: IX_VENTAS_venEstado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_VENTAS_venEstado" ON public."VENTAS" USING btree ("venEstado");


--
-- Name: IX_VENTAS_venLista; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_VENTAS_venLista" ON public."VENTAS" USING btree ("venLista");


--
-- Name: IX_VENTAS_venMetodoPago; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_VENTAS_venMetodoPago" ON public."VENTAS" USING btree ("venMetodoPago");


--
-- Name: IX_VENTAS_venPuntoVenta_venNumComprobante; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_VENTAS_venPuntoVenta_venNumComprobante" ON public."VENTAS" USING btree ("venPuntoVenta", "venNumComprobante");


--
-- Name: IX_VENTAS_venTipoCbte; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_VENTAS_venTipoCbte" ON public."VENTAS" USING btree ("venTipoCbte");


--
-- Name: IX_afipLogs_cae; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_afipLogs_cae" ON public."afipLogs" USING btree (cae);


--
-- Name: IX_afipLogs_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_afipLogs_fecha" ON public."afipLogs" USING btree (fecha DESC);


--
-- Name: IX_afipLogs_tipoOperacion; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_afipLogs_tipoOperacion" ON public."afipLogs" USING btree ("tipoOperacion");


--
-- Name: IX_afipLogs_venCod; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IX_afipLogs_venCod" ON public."afipLogs" USING btree ("venCod");


--
-- Name: idx_afip_tickets_expiration; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_afip_tickets_expiration ON public.afip_auth_tickets USING btree (expiration_time);


--
-- Name: idx_detalle_cotizaciones_artcod; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_detalle_cotizaciones_artcod ON public."DETALLE_COTIZACIONES" USING btree ("artCod");


--
-- Name: idx_detalle_ventas_artcod; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_detalle_ventas_artcod ON public."DETALLE_VENTAS" USING btree ("artCod");


--
-- Name: ix_articulos_artcod; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_articulos_artcod ON public."ARTICULOS" USING btree ("artCod");


--
-- Name: COBROS COBROS_cliCod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."COBROS"
    ADD CONSTRAINT "COBROS_cliCod_fkey" FOREIGN KEY ("cliCod") REFERENCES public."CLIENTES"(id) ON DELETE RESTRICT;


--
-- Name: COTIZACIONES COTIZACIONES_cliCod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."COTIZACIONES"
    ADD CONSTRAINT "COTIZACIONES_cliCod_fkey" FOREIGN KEY ("cliCod") REFERENCES public."CLIENTES"(id) ON DELETE RESTRICT;


--
-- Name: CUENTAS_CORRIENTES CUENTAS_CORRIENTES_cliCod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CUENTAS_CORRIENTES"
    ADD CONSTRAINT "CUENTAS_CORRIENTES_cliCod_fkey" FOREIGN KEY ("cliCod") REFERENCES public."CLIENTES"(id) ON DELETE RESTRICT;


--
-- Name: DETALLE_COTIZACIONES DETALLE_COTIZACIONES_cotCod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DETALLE_COTIZACIONES"
    ADD CONSTRAINT "DETALLE_COTIZACIONES_cotCod_fkey" FOREIGN KEY ("cotCod") REFERENCES public."COTIZACIONES"("cotCod");


--
-- Name: DETALLE_VENTAS DETALLE_VENTAS_venCod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DETALLE_VENTAS"
    ADD CONSTRAINT "DETALLE_VENTAS_venCod_fkey" FOREIGN KEY ("venCod") REFERENCES public."VENTAS"("venCod");


--
-- Name: CHEQUES FK_CHEQUES_PAGOS; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CHEQUES"
    ADD CONSTRAINT "FK_CHEQUES_PAGOS" FOREIGN KEY ("pagCod") REFERENCES public."PAGOS"("pagCod") ON DELETE RESTRICT;


--
-- Name: CLIENTES FK_CLIENTES_clienteTipoFormaPago; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CLIENTES"
    ADD CONSTRAINT "FK_CLIENTES_clienteTipoFormaPago" FOREIGN KEY ("cliFormaPago") REFERENCES public."clienteTipoFormaPago"(id);


--
-- Name: CLIENTES FK_CLIENTES_condicionIVA; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CLIENTES"
    ADD CONSTRAINT "FK_CLIENTES_condicionIVA" FOREIGN KEY ("cliCondicionIVA") REFERENCES public."condicionIVA"(id);


--
-- Name: CLIENTES FK_CLIENTES_tipoDocumento; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CLIENTES"
    ADD CONSTRAINT "FK_CLIENTES_tipoDocumento" FOREIGN KEY ("cliTipoDoc") REFERENCES public."tipoDocumento"(id);


--
-- Name: COTIZACIONES FK_COTIZACIONES_ESTADO; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."COTIZACIONES"
    ADD CONSTRAINT "FK_COTIZACIONES_ESTADO" FOREIGN KEY ("cotEstadoId") REFERENCES public."cotizacionEstados"(id) ON DELETE SET NULL;


--
-- Name: MOVIMIENTOS_CAJA FK_MOVIMIENTOS_CAJA_CHEQUES; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MOVIMIENTOS_CAJA"
    ADD CONSTRAINT "FK_MOVIMIENTOS_CAJA_CHEQUES" FOREIGN KEY ("chqCod") REFERENCES public."CHEQUES"("chqCod") ON DELETE SET NULL;


--
-- Name: MOVIMIENTOS_CAJA FK_MOVIMIENTOS_CAJA_tipoMovimientoCaja; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MOVIMIENTOS_CAJA"
    ADD CONSTRAINT "FK_MOVIMIENTOS_CAJA_tipoMovimientoCaja" FOREIGN KEY ("movTipo") REFERENCES public."tipoMovimientoCaja"(id) ON DELETE RESTRICT;


--
-- Name: MOVIMIENTOS_CAJA FK_MOVIMIENTOS_CAJA_ventaTipoMetodoPagos; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."MOVIMIENTOS_CAJA"
    ADD CONSTRAINT "FK_MOVIMIENTOS_CAJA_ventaTipoMetodoPagos" FOREIGN KEY ("movMetodoPago") REFERENCES public."ventaTipoMetodoPagos"(id) ON DELETE RESTRICT;


--
-- Name: PAGOS FK_PAGOS_CLIENTES; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PAGOS"
    ADD CONSTRAINT "FK_PAGOS_CLIENTES" FOREIGN KEY ("cliCod") REFERENCES public."CLIENTES"(id) ON DELETE RESTRICT;


--
-- Name: PAGOS FK_PAGOS_CUENTAS_CORRIENTES; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PAGOS"
    ADD CONSTRAINT "FK_PAGOS_CUENTAS_CORRIENTES" FOREIGN KEY ("cctaCod") REFERENCES public."CUENTAS_CORRIENTES"("cctaCod") ON DELETE SET NULL;


--
-- Name: PAGOS FK_PAGOS_VENTAS; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PAGOS"
    ADD CONSTRAINT "FK_PAGOS_VENTAS" FOREIGN KEY ("venCod") REFERENCES public."VENTAS"("venCod") ON DELETE SET NULL;


--
-- Name: PAGOS FK_PAGOS_ventaTipoMetodoPagos; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PAGOS"
    ADD CONSTRAINT "FK_PAGOS_ventaTipoMetodoPagos" FOREIGN KEY ("pagMetodoPago") REFERENCES public."ventaTipoMetodoPagos"(id) ON DELETE RESTRICT;


--
-- Name: USUARIOS FK_USUARIOS_USUARIOS_usuCreadoPor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."USUARIOS"
    ADD CONSTRAINT "FK_USUARIOS_USUARIOS_usuCreadoPor" FOREIGN KEY ("usuCreadoPor") REFERENCES public."USUARIOS"(id) ON DELETE SET NULL;


--
-- Name: VENTAS FK_VENTAS_ESTADOPAGO; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."VENTAS"
    ADD CONSTRAINT "FK_VENTAS_ESTADOPAGO" FOREIGN KEY ("venEstadoPago") REFERENCES public."ventaEstadoPago"(id) ON DELETE SET NULL;


--
-- Name: VENTAS FK_VENTAS_tipoComprobante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."VENTAS"
    ADD CONSTRAINT "FK_VENTAS_tipoComprobante" FOREIGN KEY ("venTipoCbte") REFERENCES public."tipoComprobante"(id);


--
-- Name: VENTAS FK_VENTAS_ventaTipoEstado_venEstado; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."VENTAS"
    ADD CONSTRAINT "FK_VENTAS_ventaTipoEstado_venEstado" FOREIGN KEY ("venEstado") REFERENCES public."ventaTipoEstado"(id);


--
-- Name: VENTAS FK_VENTAS_ventaTipoMetodoPagos_venMetodoPago; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."VENTAS"
    ADD CONSTRAINT "FK_VENTAS_ventaTipoMetodoPagos_venMetodoPago" FOREIGN KEY ("venMetodoPago") REFERENCES public."ventaTipoMetodoPagos"(id);


--
-- Name: afipLogs FK_afipLogs_VENTAS; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."afipLogs"
    ADD CONSTRAINT "FK_afipLogs_VENTAS" FOREIGN KEY ("venCod") REFERENCES public."VENTAS"("venCod") ON DELETE SET NULL;


--
-- Name: VENTAS VENTAS_cliCod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."VENTAS"
    ADD CONSTRAINT "VENTAS_cliCod_fkey" FOREIGN KEY ("cliCod") REFERENCES public."CLIENTES"(id) ON DELETE RESTRICT;


--
-- Name: ARTICULOS fk_articulos_iva; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ARTICULOS"
    ADD CONSTRAINT fk_articulos_iva FOREIGN KEY ("ivaCod") REFERENCES public."IVA"(id);


--
-- Name: DETALLE_COTIZACIONES fk_detalle_cotizaciones_articulos; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DETALLE_COTIZACIONES"
    ADD CONSTRAINT fk_detalle_cotizaciones_articulos FOREIGN KEY ("artCod") REFERENCES public."ARTICULOS"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: DETALLE_VENTAS fk_detalle_ventas_articulos; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DETALLE_VENTAS"
    ADD CONSTRAINT fk_detalle_ventas_articulos FOREIGN KEY ("artCod") REFERENCES public."ARTICULOS"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: VENTAS fk_ventas_tipocomprobante; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."VENTAS"
    ADD CONSTRAINT fk_ventas_tipocomprobante FOREIGN KEY ("venTipoCbte") REFERENCES public."tipoComprobante"(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

