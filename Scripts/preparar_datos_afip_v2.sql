-- ============================================================================
-- Script CORREGIDO de Preparacion de Datos para Facturacion AFIP
-- ============================================================================

BEGIN;

-- ----------------------------------------------------------------------------
-- PASO CRÍTICO: Eliminar temporalmente la restricción FK para evitar el error
-- ----------------------------------------------------------------------------
ALTER TABLE public."ARTICULOS" DROP CONSTRAINT IF EXISTS fk_articulos_iva;

-- ============================================================================
-- 1. CORREGIR TABLA IVA CON CODIGOS AFIP CORRECTOS
-- ============================================================================

-- Limpiamos primero los IDs destino para asegurar que no haya conflictos
DELETE FROM "IVA" WHERE id IN (3, 4, 5, 6);

-- Insertamos los IVAs oficiales de AFIP limpios
INSERT INTO "IVA" (id, porcentaje) VALUES
(3, 0.00),
(4, 10.50),
(5, 21.00),
(6, 27.00);

-- Actualizar secuencia por si acaso
SELECT setval(pg_get_serial_sequence('"IVA"', 'id'), 7, false);

-- ============================================================================
-- 2. ACTUALIZAR ARTICULOS (Ahora seguro porque la FK no estorba)
-- ============================================================================

-- Actualizar todos los articulos viejos (IDs 1, 2, etc) para que apunten al IVA 21% (ID 5)
UPDATE "ARTICULOS"
SET "ivaCod" = 5,
    iva = 5
WHERE "ivaCod" NOT IN (3, 4, 5, 6) OR "ivaCod" IS NULL;

-- Asegurar precios en articulos clave
UPDATE "ARTICULOS" SET "artL1" = 1500.00 WHERE "artCod" = '3214';
UPDATE "ARTICULOS" SET "artL1" = 1200.00 WHERE "artCod" = '12345';
UPDATE "ARTICULOS" SET "artL1" = 1000.00 WHERE "artCod" = 'JUA345';

-- ============================================================================
-- 3. LIMPIEZA Y RESTAURACIÓN DE RESTRICCIONES
-- ============================================================================

-- Borrar los IVAs viejos que ya no usa ningun articulo
DELETE FROM "IVA" WHERE id NOT IN (3, 4, 5, 6);

-- VOLVER A CREAR LA RESTRICCIÓN (Ahora funcionará porque los datos son consistentes)
ALTER TABLE public."ARTICULOS" 
    ADD CONSTRAINT fk_articulos_iva 
    FOREIGN KEY ("ivaCod") REFERENCES public."IVA"(id);

-- ============================================================================
-- 4. VERIFICACIONES DE DATOS FALTANTES (Tipos Doc, Condiciones, etc)
-- ============================================================================

INSERT INTO "tipoDocumento" (id, "codigoAfip", descripcion)
SELECT 1, 80, 'CUIT' WHERE NOT EXISTS (SELECT 1 FROM "tipoDocumento" WHERE "codigoAfip" = 80);

INSERT INTO "tipoDocumento" (id, "codigoAfip", descripcion)
SELECT 3, 96, 'DNI' WHERE NOT EXISTS (SELECT 1 FROM "tipoDocumento" WHERE "codigoAfip" = 96);

-- ============================================================================
-- 5. ACTUALIZAR CLIENTE DE PRUEBA
-- ============================================================================

UPDATE "CLIENTES"
SET "cliTipoDoc" = 3,           -- DNI
    "cliNumDoc" = '20123456789', 
    "cliCondicionIVA" = 3,      -- Consumidor Final
    "cliFormaPago" = 2          -- Efectivo
WHERE id = 11;

-- ============================================================================
-- 6. CREAR VENTA DE PRUEBA
-- ============================================================================

DO $$
DECLARE
    v_venta_id INTEGER;
    v_articulo_cod VARCHAR(20);
    v_precio DECIMAL(10,2);
    v_subtotal DECIMAL(10,2);
    v_total DECIMAL(10,2);
BEGIN
    -- Buscar un articulo valido (ya sabemos que tienen ivaCod 5)
    SELECT "artCod", COALESCE("artL1", 1000.00) INTO v_articulo_cod, v_precio
    FROM "ARTICULOS" WHERE "ivaCod" = 5 LIMIT 1;

    IF v_articulo_cod IS NOT NULL THEN
        v_subtotal := v_precio * 2;
        v_total := v_subtotal * 1.21;

        INSERT INTO "VENTAS" (
            "cliCod", "venFech", "venTotal", "venEstado", "venLista", 
            "venTipoCbte", "venPuntoVenta", "venMetodoPago"
        ) VALUES (
            11, CURRENT_DATE, v_total, 1, 1, 2, 1, 1
        ) RETURNING "venCod" INTO v_venta_id;

        INSERT INTO "DETALLE_VENTAS" (
            "venCod", "artCod", "detCant", "detPrecio", "detSubtotal"
        ) VALUES (
            v_venta_id, v_articulo_cod, 2, v_precio, v_subtotal
        );
        
        RAISE NOTICE 'Venta de prueba creada: ID %', v_venta_id;
    END IF;
END $$;

COMMIT;

-- Mensaje final
DO $$
BEGIN
    RAISE NOTICE 'Script ejecutado correctamente. Base de datos lista para AFIP.';
END $$;