-- ============================================================================
-- Script de Preparacion de Datos para Facturacion AFIP
-- Sistema COMARA
-- Fecha: 2025-11-27
-- ============================================================================

-- Este script prepara la base de datos para probar la facturacion con AFIP
-- en modo homologacion.

BEGIN;

-- ============================================================================
-- 1. CORREGIR TABLA IVA CON CODIGOS AFIP CORRECTOS
-- ============================================================================

-- IMPORTANTE: AFIP requiere estos IDs especificos:
-- 3 = 0% (No gravado)
-- 4 = 10.5%
-- 5 = 21%
-- 6 = 27%

-- PRIMERO: Insertar o actualizar los IVAs correctos
INSERT INTO "IVA" (id, porcentaje) VALUES
(3, 0.00),
(4, 10.50),
(5, 21.00),
(6, 27.00)
ON CONFLICT (id) DO UPDATE SET porcentaje = EXCLUDED.porcentaje;

-- SEGUNDO: Actualizar articulos que usen IVAs incorrectos
UPDATE "ARTICULOS"
SET "ivaCod" = 5  -- IVA 21% por defecto
WHERE "ivaCod" NOT IN (3, 4, 5, 6) OR "ivaCod" IS NULL;

-- TERCERO: Eliminar IVAs que no sean los correctos de AFIP
DELETE FROM "IVA" WHERE id NOT IN (3, 4, 5, 6);

-- Resetear la secuencia para que el proximo ID sea 7
SELECT setval(pg_get_serial_sequence('"IVA"', 'id'),
              GREATEST(7, (SELECT COALESCE(MAX(id), 0) + 1 FROM "IVA")),
              false);

-- ============================================================================
-- 2. VERIFICAR TIPOS DE DOCUMENTO (ya existen en tu backup)
-- ============================================================================

-- Verificar que existan los tipos de documento necesarios
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM "tipoDocumento" WHERE "codigoAfip" = 80) THEN
        INSERT INTO "tipoDocumento" (id, "codigoAfip", descripcion)
        VALUES (1, 80, 'CUIT');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM "tipoDocumento" WHERE "codigoAfip" = 96) THEN
        INSERT INTO "tipoDocumento" (id, "codigoAfip", descripcion)
        VALUES (3, 96, 'DNI');
    END IF;
END $$;

-- ============================================================================
-- 3. VERIFICAR CONDICIONES DE IVA (ya existen en tu backup)
-- ============================================================================

-- Ya tienes las condiciones de IVA necesarias, solo verificamos
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM "condicionIVA" WHERE "codigoAfip" IN (1, 4, 5, 6)) THEN
        RAISE EXCEPTION 'Faltan condiciones de IVA en la base de datos';
    END IF;
END $$;

-- ============================================================================
-- 4. VERIFICAR TIPOS DE COMPROBANTE (ya existen en tu backup)
-- ============================================================================

-- Ya tienes los tipos de comprobante necesarios, solo verificamos
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM "tipoComprobante" WHERE "codigoAfip" IN (1, 6, 11)) THEN
        RAISE EXCEPTION 'Faltan tipos de comprobante en la base de datos';
    END IF;
END $$;

-- ============================================================================
-- 5. ACTUALIZAR ARTICULOS EXISTENTES CON IVA CORRECTO
-- ============================================================================

-- Actualizar articulos para que tengan IVA 21% (codigo 5)
UPDATE "ARTICULOS"
SET "ivaCod" = 5,  -- IVA 21% (FK a tabla IVA)
    iva = 5        -- Campo adicional que tambien usa IVA
WHERE "artCod" IN ('3214', '12345', 'JUA345', '22222');

-- Si tus articulos no tienen precio en artL1, agregarlos
UPDATE "ARTICULOS"
SET "artL1" = 1500.00
WHERE "artCod" = '3214' AND ("artL1" IS NULL OR "artL1" = 0);

UPDATE "ARTICULOS"
SET "artL1" = 1200.00
WHERE "artCod" = '12345' AND ("artL1" IS NULL OR "artL1" = 0);

UPDATE "ARTICULOS"
SET "artL1" = 1000.00
WHERE "artCod" = 'JUA345' AND ("artL1" IS NULL OR "artL1" = 0);

-- ============================================================================
-- 6. ACTUALIZAR CLIENTE EXISTENTE CON DATOS VALIDOS
-- ============================================================================

-- Actualizar el cliente existente "Cliente Prueba AFIP" (id=11)
UPDATE "CLIENTES"
SET "cliTipoDoc" = 3,           -- ID del tipo documento DNI en tu tabla
    "cliNumDoc" = '20123456789', -- DNI de prueba para homologacion
    "cliCondicionIVA" = 3,       -- Consumidor Final (id=3 en tu tabla)
    "cliFormaPago" = 2           -- Efectivo
WHERE id = 11;

-- Verificar que se actualizo
DO $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM "CLIENTES"
    WHERE id = 11
      AND "cliTipoDoc" IS NOT NULL
      AND "cliNumDoc" IS NOT NULL;

    IF v_count = 0 THEN
        RAISE WARNING 'No se pudo actualizar el cliente. Verifica manualmente.';
    END IF;
END $$;

-- ============================================================================
-- 7. CREAR VENTA DE PRUEBA LISTA PARA FACTURAR
-- ============================================================================

DO $$
DECLARE
    v_venta_id INTEGER;
    v_articulo_cod VARCHAR(20);
    v_precio DECIMAL(10,2);
    v_cantidad INTEGER := 2;
    v_subtotal DECIMAL(10,2);
    v_iva_importe DECIMAL(10,2);
    v_total DECIMAL(10,2);
BEGIN
    -- Obtener un articulo con precio
    SELECT "artCod", COALESCE("artL1", 1000.00)
    INTO v_articulo_cod, v_precio
    FROM "ARTICULOS"
    WHERE "ivaCod" = 5  -- IVA 21%
    LIMIT 1;

    -- Verificar que se encontro un articulo
    IF v_articulo_cod IS NULL THEN
        RAISE EXCEPTION 'No se encontro ningun articulo con IVA 21%%. Ejecuta primero el backup para restaurar los datos.';
    END IF;

    -- Calcular montos
    v_subtotal := v_precio * v_cantidad;
    v_iva_importe := v_subtotal * 0.21;  -- IVA 21%
    v_total := v_subtotal + v_iva_importe;

    -- Insertar venta
    INSERT INTO "VENTAS" (
        "cliCod",
        "venFech",
        "venTotal",
        "venEstado",
        "venLista",
        "venTipoCbte",
        "venPuntoVenta",
        "venMetodoPago"
    ) VALUES (
        11,                -- Cliente Prueba AFIP
        CURRENT_DATE,      -- Fecha actual
        v_total,           -- Total con IVA
        1,                 -- Estado: Pendiente (ajusta segun tus estados)
        1,                 -- Lista de precios 1
        2,                 -- Tipo comprobante: Factura B (id=2 en tu tabla)
        1,                 -- Punto de venta 1
        1                  -- Metodo de pago 1
    )
    RETURNING "venCod" INTO v_venta_id;

    -- Insertar detalle de venta
    INSERT INTO "DETALLE_VENTAS" (
        "venCod",
        "artCod",
        "detCant",
        "detPrecio",
        "detSubtotal"
    ) VALUES (
        v_venta_id,
        v_articulo_cod,
        v_cantidad,
        v_precio,
        v_subtotal
    );

    RAISE NOTICE 'Venta de prueba creada exitosamente';
    RAISE NOTICE '  - ID Venta: %', v_venta_id;
    RAISE NOTICE '  - Articulo: % x %', v_articulo_cod, v_cantidad;
    RAISE NOTICE '  - Subtotal: $%', v_subtotal;
    RAISE NOTICE '  - IVA (21%%): $%', v_iva_importe;
    RAISE NOTICE '  - TOTAL: $%', v_total;
    RAISE NOTICE '  - Tipo: Factura B';
    RAISE NOTICE '  - Cliente: Cliente Prueba AFIP (DNI 20123456789)';

EXCEPTION
    WHEN OTHERS THEN
        RAISE WARNING 'Error al crear venta de prueba: %', SQLERRM;
        RAISE WARNING 'Puedes crear una venta manualmente desde la interfaz web';
END $$;

-- ============================================================================
-- 8. VERIFICACION FINAL
-- ============================================================================

-- Mostrar resumen de datos listos para facturar
DO $$
DECLARE
    v_ivas INTEGER;
    v_clientes INTEGER;
    v_ventas INTEGER;
    v_articulos INTEGER;
BEGIN
    -- IVAs
    SELECT COUNT(*) INTO v_ivas FROM "IVA" WHERE id IN (3, 4, 5, 6);
    RAISE NOTICE '';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'RESUMEN DE DATOS PREPARADOS';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'IVAs configurados: %/4', v_ivas;

    -- Clientes validos
    SELECT COUNT(*) INTO v_clientes
    FROM "CLIENTES"
    WHERE "cliTipoDoc" IS NOT NULL AND "cliNumDoc" IS NOT NULL;
    RAISE NOTICE 'Clientes con datos completos: %', v_clientes;

    -- Ventas sin CAE
    SELECT COUNT(*) INTO v_ventas
    FROM "VENTAS"
    WHERE "VenCAE" IS NULL AND "venTipoCbte" IN (1, 2, 3);
    RAISE NOTICE 'Ventas listas para facturar: %', v_ventas;

    -- Articulos con IVA
    SELECT COUNT(*) INTO v_articulos
    FROM "ARTICULOS"
    WHERE "ivaCod" IN (3, 4, 5, 6);
    RAISE NOTICE 'Articulos con IVA correcto: %', v_articulos;

    RAISE NOTICE '========================================';
    RAISE NOTICE '';
END $$;

COMMIT;

-- ============================================================================
-- Consultas de verificacion (ejecutar manualmente despues del script)
-- ============================================================================

-- Ver IVAs configurados:
-- SELECT * FROM "IVA" ORDER BY id;

-- Ver clientes listos para facturar:
-- SELECT id, "cliNombre", "cliTipoDoc", "cliNumDoc", "cliCondicionIVA" FROM "CLIENTES";

-- Ver ventas listas para facturar:
-- SELECT v."venCod", v."venFech", c."cliNombre", v."venTotal", v."VenCAE"
-- FROM "VENTAS" v
-- INNER JOIN "CLIENTES" c ON v."cliCod" = c.id
-- WHERE v."VenCAE" IS NULL
-- ORDER BY v."venCod" DESC;
