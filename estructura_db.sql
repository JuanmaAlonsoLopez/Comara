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
-- Name: AUDIT_LOG; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."AUDIT_LOG" (
    id integer NOT NULL,
    tabla character varying(100) NOT NULL,
    registro_id character varying(50) NOT NULL,
    accion character varying(10) NOT NULL,
    usuario_id integer,
    usuario_nombre character varying(100),
    fecha timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    valores_anteriores jsonb,
    valores_nuevos jsonb,
    ip_address character varying(45)
);


ALTER TABLE public."AUDIT_LOG" OWNER TO postgres;

--
-- Name: TABLE "AUDIT_LOG"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."AUDIT_LOG" IS 'Registro de auditoría de cambios en el sistema';


--
-- Name: COLUMN "AUDIT_LOG".accion; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."AUDIT_LOG".accion IS 'INSERT, UPDATE o DELETE';


--
-- Name: COLUMN "AUDIT_LOG".valores_anteriores; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."AUDIT_LOG".valores_anteriores IS 'JSON con valores antes del cambio (NULL en
   INSERT)';


--
-- Name: COLUMN "AUDIT_LOG".valores_nuevos; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public."AUDIT_LOG".valores_nuevos IS 'JSON con valores después del cambio (NULL en
  DELETE)';


--
-- Name: AUDIT_LOG_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."AUDIT_LOG_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."AUDIT_LOG_id_seq" OWNER TO postgres;

--
-- Name: AUDIT_LOG_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."AUDIT_LOG_id_seq" OWNED BY public."AUDIT_LOG".id;


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
    "cotEstadoId" integer DEFAULT 1,
    "listaCod" integer
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
-- Name: AUDIT_LOG id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AUDIT_LOG" ALTER COLUMN id SET DEFAULT nextval('public."AUDIT_LOG_id_seq"'::regclass);


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
-- Name: ARTICULOS ARTICULOS_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ARTICULOS"
    ADD CONSTRAINT "ARTICULOS_pkey" PRIMARY KEY (id);


--
-- Name: AUDIT_LOG AUDIT_LOG_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AUDIT_LOG"
    ADD CONSTRAINT "AUDIT_LOG_pkey" PRIMARY KEY (id);


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
-- Name: idx_articulo_codigo_pattern; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_articulo_codigo_pattern ON public."ARTICULOS" USING btree ("artCod" varchar_pattern_ops) WHERE ("artCod" IS NOT NULL);


--
-- Name: idx_articulo_descripcion; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_articulo_descripcion ON public."ARTICULOS" USING btree ("artDesc" varchar_pattern_ops) WHERE ("artDesc" IS NOT NULL);


--
-- Name: idx_articulo_marca_proveedor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_articulo_marca_proveedor ON public."ARTICULOS" USING btree ("marCod", "proCod");


--
-- Name: idx_articulo_stock; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_articulo_stock ON public."ARTICULOS" USING btree ("artStock") WHERE ("artStock" IS NOT NULL);


--
-- Name: idx_cliente_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cliente_nombre ON public."CLIENTES" USING btree ("cliNombre" varchar_pattern_ops) WHERE ("cliNombre" IS NOT NULL);


--
-- Name: idx_cliente_numdoc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cliente_numdoc ON public."CLIENTES" USING btree ("cliNumDoc") WHERE ("cliNumDoc" IS NOT NULL);


--
-- Name: idx_cobro_cliente; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cobro_cliente ON public."COBROS" USING btree ("cliCod");


--
-- Name: idx_cobro_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cobro_fecha ON public."COBROS" USING btree ("cobFech");


--
-- Name: idx_cotizacion_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cotizacion_fecha ON public."COTIZACIONES" USING btree ("cotFech") WHERE ("cotFech" IS NOT NULL);


--
-- Name: idx_cuentacorriente_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cuentacorriente_fecha ON public."CUENTAS_CORRIENTES" USING btree ("cctaFech");


--
-- Name: idx_cuentacorriente_movimiento; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cuentacorriente_movimiento ON public."CUENTAS_CORRIENTES" USING btree ("cctaMovimiento");


--
-- Name: idx_detalle_cotizaciones_artcod; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_detalle_cotizaciones_artcod ON public."DETALLE_COTIZACIONES" USING btree ("artCod");


--
-- Name: idx_detalle_ventas_artcod; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_detalle_ventas_artcod ON public."DETALLE_VENTAS" USING btree ("artCod");


--
-- Name: idx_detallecotizacion_cotizacion; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_detallecotizacion_cotizacion ON public."DETALLE_COTIZACIONES" USING btree ("cotCod");


--
-- Name: idx_detalleventa_venta; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_detalleventa_venta ON public."DETALLE_VENTAS" USING btree ("venCod");


--
-- Name: idx_marca_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_marca_nombre ON public."MARCAS" USING btree ("marNombre" varchar_pattern_ops) WHERE ("marNombre" IS NOT NULL);


--
-- Name: idx_pago_venta; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pago_venta ON public."PAGOS" USING btree ("venCod") WHERE ("venCod" IS NOT NULL);


--
-- Name: idx_proveedor_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_proveedor_nombre ON public."PROVEEDORES" USING btree ("proNombre" varchar_pattern_ops) WHERE ("proNombre" IS NOT NULL);


--
-- Name: idx_venta_estado_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_venta_estado_fecha ON public."VENTAS" USING btree ("venEstado", "venFech");


--
-- Name: idx_venta_estadopago; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_venta_estadopago ON public."VENTAS" USING btree ("venEstadoPago") WHERE ("venEstadoPago" IS NOT NULL);


--
-- Name: idx_venta_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_venta_fecha ON public."VENTAS" USING btree ("venFech") WHERE ("venFech" IS NOT NULL);


--
-- Name: ix_articulos_artcod; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_articulos_artcod ON public."ARTICULOS" USING btree ("artCod");


--
-- Name: ix_audit_log_accion; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_audit_log_accion ON public."AUDIT_LOG" USING btree (accion);


--
-- Name: ix_audit_log_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_audit_log_fecha ON public."AUDIT_LOG" USING btree (fecha DESC);


--
-- Name: ix_audit_log_tabla; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_audit_log_tabla ON public."AUDIT_LOG" USING btree (tabla);


--
-- Name: ix_audit_log_usuario_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_audit_log_usuario_id ON public."AUDIT_LOG" USING btree (usuario_id);


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

