-- ============================================================================
-- Script SIMPLE de reparacion - SIN borrar datos
-- ============================================================================

BEGIN;

-- 1. Actualizar TODOS los articulos para usar IVA 21% (codigo 5)
UPDATE "ARTICULOS"
SET "ivaCod" = 5
WHERE "ivaCod" IS NULL OR "ivaCod" NOT IN (3, 4, 5, 6);

-- 2. Asegurar que existan los IVAs correctos
DELETE FROM "IVA" WHERE id NOT IN (3, 4, 5, 6);

INSERT INTO "IVA" (id, porcentaje) VALUES
(3, 0.00),
(4, 10.50),
(5, 21.00),
(6, 27.00)
ON CONFLICT (id) DO UPDATE SET porcentaje = EXCLUDED.porcentaje;

-- 3. Actualizar cliente existente
UPDATE "CLIENTES"
SET "cliTipoDoc" = 3,
    "cliNumDoc" = '20123456789',
    "cliCondicionIVA" = 3,
    "cliFormaPago" = 2
WHERE id = 11;

-- 4. Crear venta de prueba
DO $$
DECLARE
    v_venta_id INTEGER;
    v_cliente_id INTEGER;
    v_articulo_id INTEGER;
    v_articulo_cod VARCHAR(20);
    v_precio DECIMAL(10,2);
BEGIN
    -- Buscar cliente
    SELECT id INTO v_cliente_id
    FROM "CLIENTES"
    WHERE "cliTipoDoc" IS NOT NULL
      AND "cliNumDoc" IS NOT NULL
    LIMIT 1;

    -- Buscar articulo
    SELECT id, "artCod", COALESCE("artL1", 1000.00)
    INTO v_articulo_id, v_articulo_cod, v_precio
    FROM "ARTICULOS"
    WHERE "ivaCod" = 5
    LIMIT 1;

    IF v_cliente_id IS NULL OR v_articulo_id IS NULL THEN
        RAISE NOTICE 'No se pudo crear venta de prueba - faltan datos';
        RAISE NOTICE 'Cliente encontrado: %', v_cliente_id;
        RAISE NOTICE 'Articulo encontrado: %', v_articulo_id;
    ELSE
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
            v_cliente_id,
            CURRENT_DATE,
            v_precio * 2 * 1.21,  -- 2 unidades con IVA
            1,
            1,
            2,  -- Factura B
            1,
            1
        )
        RETURNING "venCod" INTO v_venta_id;

        -- Insertar detalle
        INSERT INTO "DETALLE_VENTAS" (
            "venCod",
            "artCod",
            "detCant",
            "detPrecio",
            "detSubtotal"
        ) VALUES (
            v_venta_id,
            v_articulo_cod,
            2,
            v_precio,
            v_precio * 2
        );

        RAISE NOTICE 'Venta creada con ID: %', v_venta_id;
    END IF;
END $$;

-- 5. Mostrar resumen
DO $$
DECLARE
    v_ivas INTEGER;
    v_clientes INTEGER;
    v_articulos INTEGER;
    v_ventas INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_ivas FROM "IVA" WHERE id IN (3,4,5,6);
    SELECT COUNT(*) INTO v_clientes FROM "CLIENTES" WHERE "cliTipoDoc" IS NOT NULL;
    SELECT COUNT(*) INTO v_articulos FROM "ARTICULOS" WHERE "ivaCod" IN (3,4,5,6);
    SELECT COUNT(*) INTO v_ventas FROM "VENTAS" WHERE "VenCAE" IS NULL;

    RAISE NOTICE '';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'RESUMEN';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'IVAs: %', v_ivas;
    RAISE NOTICE 'Clientes validos: %', v_clientes;
    RAISE NOTICE 'Articulos con IVA: %', v_articulos;
    RAISE NOTICE 'Ventas sin CAE: %', v_ventas;
    RAISE NOTICE '========================================';
END $$;

COMMIT;
