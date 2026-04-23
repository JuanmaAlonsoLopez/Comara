-- ============================================================
-- Script SQL: Integración Módulos Facturación y Caja
-- Ejecutar en: PostgreSQL (local y Google Cloud)
-- Fecha: 2026-01-18
-- ============================================================

-- 1. Crear tabla de estados de pago de factura
CREATE TABLE IF NOT EXISTS "ventaEstadoPago" (
    "id" SERIAL PRIMARY KEY,
    "descripcion" VARCHAR(50) NOT NULL
);

-- 2. Insertar estados de pago
INSERT INTO "ventaEstadoPago" ("id", "descripcion") VALUES
(1, 'Pendiente'),
(2, 'Parcialmente Pagada'),
(3, 'Pagada')
ON CONFLICT ("id") DO NOTHING;

-- 3. Agregar columna de estado de pago a VENTAS (si no existe)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'VENTAS' AND column_name = 'venEstadoPago') THEN
        ALTER TABLE "VENTAS" ADD COLUMN "venEstadoPago" INTEGER DEFAULT 1;
    END IF;
END $$;

-- 4. Agregar FK a Venta en PAGOS (si no existe)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'PAGOS' AND column_name = 'venCod') THEN
        ALTER TABLE "PAGOS" ADD COLUMN "venCod" INTEGER;
    END IF;
END $$;

-- 5. Agregar FK de Pago a Venta (si no existe)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints
                   WHERE constraint_name = 'FK_PAGOS_VENTAS') THEN
        ALTER TABLE "PAGOS" ADD CONSTRAINT "FK_PAGOS_VENTAS"
            FOREIGN KEY ("venCod") REFERENCES "VENTAS"("venCod") ON DELETE SET NULL;
    END IF;
END $$;

-- 6. Agregar FK de Venta a ventaEstadoPago (si no existe)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints
                   WHERE constraint_name = 'FK_VENTAS_ESTADOPAGO') THEN
        ALTER TABLE "VENTAS" ADD CONSTRAINT "FK_VENTAS_ESTADOPAGO"
            FOREIGN KEY ("venEstadoPago") REFERENCES "ventaEstadoPago"("id") ON DELETE SET NULL;
    END IF;
END $$;

-- 7. Inicializar ClienteTipoFormaPago (si no existen los valores)
INSERT INTO "clienteTipoFormaPago" ("id", "descripcion") VALUES
(1, 'Cuenta Corriente'),
(2, 'Efectivo'),
(3, 'Ambos')
ON CONFLICT ("id") DO NOTHING;

-- 8. Actualizar ventas facturadas existentes como "Pendiente de pago"
-- Las que tienen CAE pero no tienen estado de pago definido
UPDATE "VENTAS"
SET "venEstadoPago" = 1
WHERE "venCAE" IS NOT NULL
  AND "venCAE" != ''
  AND ("venEstadoPago" IS NULL OR "venEstadoPago" = 0);

-- 9. Verificar la estructura
SELECT 'Tabla ventaEstadoPago creada:' as info, COUNT(*) as registros FROM "ventaEstadoPago";
SELECT 'Columna venEstadoPago en VENTAS:' as info,
       EXISTS(SELECT 1 FROM information_schema.columns WHERE table_name = 'VENTAS' AND column_name = 'venEstadoPago') as existe;
SELECT 'Columna venCod en PAGOS:' as info,
       EXISTS(SELECT 1 FROM information_schema.columns WHERE table_name = 'PAGOS' AND column_name = 'venCod') as existe;
SELECT 'Registros en clienteTipoFormaPago:' as info, COUNT(*) as registros FROM "clienteTipoFormaPago";

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================
