-- ============================================================================
-- INDICES DE OPTIMIZACION PARA COMARA - PostgreSQL
-- Ejecutar manualmente en la base de datos local y en Google Cloud Console
-- ============================================================================

-- IMPORTANTE: Ejecutar estos scripts durante horarios de baja actividad
-- ya que la creación de índices puede bloquear temporalmente las tablas.

-- ============================================================================
-- 1. INDICES PARA REPORTES POR FECHA (Alta prioridad)
-- ============================================================================

-- Índice para búsquedas y reportes de ventas por fecha
CREATE INDEX IF NOT EXISTS idx_venta_fecha
ON "VENTAS"("venFech")
WHERE "venFech" IS NOT NULL;

-- Índice para búsquedas y reportes de cotizaciones por fecha
CREATE INDEX IF NOT EXISTS idx_cotizacion_fecha
ON "COTIZACIONES"("cotFech")
WHERE "cotFech" IS NOT NULL;

-- Índice para movimientos de cuenta corriente por fecha
CREATE INDEX IF NOT EXISTS idx_cuentacorriente_fecha
ON "CUENTAS_CORRIENTES"("cctaFech");

-- ============================================================================
-- 2. INDICES PARA FILTROS DE MOVIMIENTOS Y ESTADOS (Alta prioridad)
-- ============================================================================

-- Índice para filtrar movimientos DEBE/HABER en cuentas corrientes
CREATE INDEX IF NOT EXISTS idx_cuentacorriente_movimiento
ON "CUENTAS_CORRIENTES"("cctaMovimiento");

-- Índice compuesto para queries comunes de ventas (estado + fecha)
CREATE INDEX IF NOT EXISTS idx_venta_estado_fecha
ON "VENTAS"("venEstado", "venFech");

-- Índice para estado de pago en ventas
CREATE INDEX IF NOT EXISTS idx_venta_estadopago
ON "VENTAS"("venEstadoPago")
WHERE "venEstadoPago" IS NOT NULL;

-- ============================================================================
-- 3. INDICES PARA BUSQUEDAS DE ARTICULOS (Crítico para rendimiento)
-- ============================================================================

-- Índice para búsquedas por descripción de artículo (patrón LIKE 'term%')
CREATE INDEX IF NOT EXISTS idx_articulo_descripcion
ON "ARTICULOS"("artDesc" varchar_pattern_ops)
WHERE "artDesc" IS NOT NULL;

-- Índice para búsquedas por código de artículo (patrón LIKE 'term%')
CREATE INDEX IF NOT EXISTS idx_articulo_codigo_pattern
ON "ARTICULOS"("artCod" varchar_pattern_ops)
WHERE "artCod" IS NOT NULL;

-- Índice compuesto para filtros por marca y proveedor
CREATE INDEX IF NOT EXISTS idx_articulo_marca_proveedor
ON "ARTICULOS"("marCod", "proCod");

-- Índice para artículos con stock crítico (reportes)
CREATE INDEX IF NOT EXISTS idx_articulo_stock
ON "ARTICULOS"("artStock")
WHERE "artStock" IS NOT NULL;

-- ============================================================================
-- 4. INDICES PARA BUSQUEDAS DE CLIENTES (Media prioridad)
-- ============================================================================

-- Índice para búsquedas por nombre de cliente
CREATE INDEX IF NOT EXISTS idx_cliente_nombre
ON "CLIENTES"("cliNombre" varchar_pattern_ops)
WHERE "cliNombre" IS NOT NULL;

-- Índice para búsquedas por número de documento
CREATE INDEX IF NOT EXISTS idx_cliente_numdoc
ON "CLIENTES"("cliNumDoc")
WHERE "cliNumDoc" IS NOT NULL;

-- ============================================================================
-- 5. INDICES PARA MARCAS Y PROVEEDORES (Media prioridad)
-- ============================================================================

-- Índice para búsquedas por nombre de marca
CREATE INDEX IF NOT EXISTS idx_marca_nombre
ON "MARCAS"("marNombre" varchar_pattern_ops)
WHERE "marNombre" IS NOT NULL;

-- Índice para búsquedas por nombre de proveedor
CREATE INDEX IF NOT EXISTS idx_proveedor_nombre
ON "PROVEEDORES"("proNombre" varchar_pattern_ops)
WHERE "proNombre" IS NOT NULL;

-- ============================================================================
-- 6. INDICES PARA DETALLES DE VENTA/COTIZACION (Media prioridad)
-- ============================================================================

-- Índice para búsquedas de detalles por venta
CREATE INDEX IF NOT EXISTS idx_detalleventa_venta
ON "DETALLE_VENTAS"("venCod");

-- Índice para búsquedas de detalles por cotización
CREATE INDEX IF NOT EXISTS idx_detallecotizacion_cotizacion
ON "DETALLE_COTIZACIONES"("cotCod");

-- ============================================================================
-- 7. INDICES PARA PAGOS Y COBRANZAS (Media prioridad)
-- ============================================================================

-- Índice para pagos por venta
CREATE INDEX IF NOT EXISTS idx_pago_venta
ON "PAGOS"("venCod")
WHERE "venCod" IS NOT NULL;

-- Índice para cobros por cliente
CREATE INDEX IF NOT EXISTS idx_cobro_cliente
ON "COBROS"("cliCod");

-- Índice para cobros por fecha
CREATE INDEX IF NOT EXISTS idx_cobro_fecha
ON "COBROS"("cobFech");

-- ============================================================================
-- 8. FULL-TEXT SEARCH PARA ARTICULOS (Opcional - mejora búsquedas)
-- ============================================================================

-- NOTA: Estos índices GIN son más pesados pero permiten búsquedas de texto
-- más inteligentes. Descomentar si se necesita búsqueda avanzada.

-- CREATE INDEX IF NOT EXISTS idx_articulo_fts_descripcion
-- ON "ARTICULOS" USING gin(to_tsvector('spanish', "artDesc"));

-- CREATE INDEX IF NOT EXISTS idx_cliente_fts_nombre
-- ON "CLIENTES" USING gin(to_tsvector('spanish', "cliNombre"));

-- ============================================================================
-- 9. VERIFICAR INDICES CREADOS
-- ============================================================================

-- Ejecutar esta consulta para verificar que los índices se crearon:
-- SELECT indexname, indexdef FROM pg_indexes WHERE tablename IN
-- ('VENTAS', 'COTIZACIONES', 'ARTICULOS', 'CLIENTES', 'CUENTAS_CORRIENTES', 'MARCAS', 'PROVEEDORES');

-- ============================================================================
-- 10. ANALIZAR TABLAS DESPUES DE CREAR INDICES
-- ============================================================================

-- Ejecutar ANALYZE para actualizar estadísticas del planificador:
ANALYZE "VENTAS";
ANALYZE "COTIZACIONES";
ANALYZE "ARTICULOS";
ANALYZE "CLIENTES";
ANALYZE "CUENTAS_CORRIENTES";
ANALYZE "MARCAS";
ANALYZE "PROVEEDORES";
ANALYZE "DETALLE_VENTAS";
ANALYZE "DETALLE_COTIZACIONES";
ANALYZE "PAGOS";
ANALYZE "COBROS";
