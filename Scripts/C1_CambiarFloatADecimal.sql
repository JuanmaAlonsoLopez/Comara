-- =====================================================
-- Script C1: Cambiar tipos float (real) a decimal (numeric)
-- Sistema COMARA - Facturación AFIP
-- Fecha: 25/01/2026
-- =====================================================
-- IMPORTANTE:
-- 1. Hacer BACKUP de la base de datos antes de ejecutar
-- 2. Los datos existentes se redondearán automáticamente
-- 3. Ejecutar en una transacción para poder revertir si hay errores
-- =====================================================

BEGIN;

-- =====================================================
-- TABLA: ARTICULOS
-- =====================================================
ALTER TABLE "ARTICULOS"
    ALTER COLUMN "artStock" TYPE numeric(15,4) USING "artStock"::numeric(15,4);

ALTER TABLE "ARTICULOS"
    ALTER COLUMN "artStockMin" TYPE numeric(15,4) USING "artStockMin"::numeric(15,4);

ALTER TABLE "ARTICULOS"
    ALTER COLUMN "artL1" TYPE numeric(15,2) USING "artL1"::numeric(15,2);

ALTER TABLE "ARTICULOS"
    ALTER COLUMN "artL2" TYPE numeric(15,2) USING "artL2"::numeric(15,2);

ALTER TABLE "ARTICULOS"
    ALTER COLUMN "artL3" TYPE numeric(15,2) USING "artL3"::numeric(15,2);

ALTER TABLE "ARTICULOS"
    ALTER COLUMN "artL4" TYPE numeric(15,2) USING "artL4"::numeric(15,2);

ALTER TABLE "ARTICULOS"
    ALTER COLUMN "artL5" TYPE numeric(15,2) USING "artL5"::numeric(15,2);

-- =====================================================
-- TABLA: DETALLE_VENTAS
-- =====================================================
ALTER TABLE "DETALLE_VENTAS"
    ALTER COLUMN "detCant" TYPE numeric(15,4) USING "detCant"::numeric(15,4);

ALTER TABLE "DETALLE_VENTAS"
    ALTER COLUMN "detPrecio" TYPE numeric(15,2) USING "detPrecio"::numeric(15,2);

ALTER TABLE "DETALLE_VENTAS"
    ALTER COLUMN "detSubtotal" TYPE numeric(15,2) USING "detSubtotal"::numeric(15,2);

-- =====================================================
-- TABLA: VENTAS
-- =====================================================
ALTER TABLE "VENTAS"
    ALTER COLUMN "venTotal" TYPE numeric(15,2) USING "venTotal"::numeric(15,2);

-- =====================================================
-- TABLA: DETALLE_COTIZACIONES
-- =====================================================
ALTER TABLE "DETALLE_COTIZACIONES"
    ALTER COLUMN "detCant" TYPE numeric(15,4) USING "detCant"::numeric(15,4);

ALTER TABLE "DETALLE_COTIZACIONES"
    ALTER COLUMN "detPrecio" TYPE numeric(15,2) USING "detPrecio"::numeric(15,2);

ALTER TABLE "DETALLE_COTIZACIONES"
    ALTER COLUMN "detSubtotal" TYPE numeric(15,2) USING "detSubtotal"::numeric(15,2);

-- =====================================================
-- TABLA: COTIZACIONES
-- =====================================================
ALTER TABLE "COTIZACIONES"
    ALTER COLUMN "cotTotal" TYPE numeric(15,2) USING "cotTotal"::numeric(15,2);

-- =====================================================
-- TABLA: COBROS
-- =====================================================
ALTER TABLE "COBROS"
    ALTER COLUMN "cobMonto" TYPE numeric(15,2) USING "cobMonto"::numeric(15,2);

-- =====================================================
-- TABLA: CHEQUES
-- =====================================================
ALTER TABLE "CHEQUES"
    ALTER COLUMN "chqMonto" TYPE numeric(15,2) USING "chqMonto"::numeric(15,2);

-- =====================================================
-- TABLA: MOVIMIENTOS_CAJA
-- =====================================================
ALTER TABLE "MOVIMIENTOS_CAJA"
    ALTER COLUMN "movMonto" TYPE numeric(15,2) USING "movMonto"::numeric(15,2);

-- =====================================================
-- TABLA: CUENTAS_CORRIENTES
-- =====================================================
ALTER TABLE "CUENTAS_CORRIENTES"
    ALTER COLUMN "cctaMonto" TYPE numeric(15,2) USING "cctaMonto"::numeric(15,2);

ALTER TABLE "CUENTAS_CORRIENTES"
    ALTER COLUMN "cctaSaldo" TYPE numeric(15,2) USING "cctaSaldo"::numeric(15,2);

-- =====================================================
-- TABLA: PAGOS
-- =====================================================
ALTER TABLE "PAGOS"
    ALTER COLUMN "pagMonto" TYPE numeric(15,2) USING "pagMonto"::numeric(15,2);

-- =====================================================
-- TABLA: LISTAS
-- =====================================================
ALTER TABLE "LISTAS"
    ALTER COLUMN "listPercent" TYPE numeric(10,2) USING "listPercent"::numeric(10,2);

-- =====================================================
-- Verificar cambios
-- =====================================================
SELECT
    table_name,
    column_name,
    data_type,
    numeric_precision,
    numeric_scale
FROM information_schema.columns
WHERE table_schema = 'public'
AND data_type = 'numeric'
AND table_name IN (
    'ARTICULOS', 'DETALLE_VENTAS', 'VENTAS',
    'DETALLE_COTIZACIONES', 'COTIZACIONES',
    'COBROS', 'CHEQUES', 'MOVIMIENTOS_CAJA',
    'CUENTAS_CORRIENTES', 'PAGOS', 'LISTAS'
)
ORDER BY table_name, column_name;

-- Si todo está correcto, confirmar la transacción
COMMIT;

-- Si hay errores, descomentar la siguiente línea para revertir:
-- ROLLBACK;

-- =====================================================
-- Script C2: Tabla de Auditoría
-- Sistema COMARA
-- Fecha: 31/01/2026
-- =====================================================
-- Esta tabla registra automáticamente los cambios
-- realizados en las tablas principales del sistema
-- =====================================================

-- Tabla de auditoría para registrar cambios en el sistema
CREATE TABLE IF NOT EXISTS public."AUDIT_LOG" (
    id SERIAL PRIMARY KEY,
    tabla VARCHAR(100) NOT NULL,
    registro_id VARCHAR(50) NOT NULL,
    accion VARCHAR(10) NOT NULL, -- INSERT, UPDATE, DELETE
    usuario_id INTEGER,
    usuario_nombre VARCHAR(100),
    fecha TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    valores_anteriores JSONB,
    valores_nuevos JSONB,
    ip_address VARCHAR(45)
);

-- Índices para mejorar consultas
CREATE INDEX IF NOT EXISTS IX_AUDIT_LOG_tabla ON public."AUDIT_LOG" (tabla);
CREATE INDEX IF NOT EXISTS IX_AUDIT_LOG_fecha ON public."AUDIT_LOG" (fecha DESC);
CREATE INDEX IF NOT EXISTS IX_AUDIT_LOG_usuario_id ON public."AUDIT_LOG" (usuario_id);
CREATE INDEX IF NOT EXISTS IX_AUDIT_LOG_accion ON public."AUDIT_LOG" (accion);

-- Comentarios
COMMENT ON TABLE public."AUDIT_LOG" IS 'Registro de auditoría de cambios en el sistema';
COMMENT ON COLUMN public."AUDIT_LOG".accion IS 'INSERT, UPDATE o DELETE';
COMMENT ON COLUMN public."AUDIT_LOG".valores_anteriores IS 'JSON con valores antes del cambio (NULL en INSERT)';
COMMENT ON COLUMN public."AUDIT_LOG".valores_nuevos IS 'JSON con valores después del cambio (NULL en DELETE)';