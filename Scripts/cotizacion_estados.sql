-- ============================================================
-- Script SQL: Estados de Cotización
-- Ejecutar en: PostgreSQL (local y Google Cloud)
-- Fecha: 2026-01-18
-- ============================================================

-- 1. Crear tabla de estados de cotización
CREATE TABLE IF NOT EXISTS "cotizacionEstados" (
    "id" SERIAL PRIMARY KEY,
    "descripcion" VARCHAR(50) NOT NULL,
    "color" VARCHAR(20) DEFAULT 'secondary'
);

-- 2. Insertar estados de cotización
INSERT INTO "cotizacionEstados" ("id", "descripcion", "color") VALUES
(1, 'Pendiente', 'warning'),
(2, 'Convertida', 'success'),
(3, 'Cancelada', 'danger'),
(4, 'Vencida', 'secondary')
ON CONFLICT ("id") DO UPDATE SET
    "descripcion" = EXCLUDED."descripcion",
    "color" = EXCLUDED."color";

-- 3. Agregar columna FK de estado en COTIZACIONES (si no existe)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'COTIZACIONES' AND column_name = 'cotEstadoId') THEN
        ALTER TABLE "COTIZACIONES" ADD COLUMN "cotEstadoId" INTEGER DEFAULT 1;
    END IF;
END $$;

-- 4. Migrar datos existentes del campo string al nuevo campo FK
UPDATE "COTIZACIONES" SET "cotEstadoId" = 1 WHERE "cotEstado" = 'Pendiente' OR "cotEstado" IS NULL;
UPDATE "COTIZACIONES" SET "cotEstadoId" = 2 WHERE "cotEstado" = 'Convertida';
UPDATE "COTIZACIONES" SET "cotEstadoId" = 3 WHERE "cotEstado" = 'Cancelada';
UPDATE "COTIZACIONES" SET "cotEstadoId" = 4 WHERE "cotEstado" = 'Vencida';

-- 5. Agregar FK de Cotización a cotizacionEstados (si no existe)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints
                   WHERE constraint_name = 'FK_COTIZACIONES_ESTADO') THEN
        ALTER TABLE "COTIZACIONES" ADD CONSTRAINT "FK_COTIZACIONES_ESTADO"
            FOREIGN KEY ("cotEstadoId") REFERENCES "cotizacionEstados"("id") ON DELETE SET NULL;
    END IF;
END $$;

-- 6. Verificar la estructura
SELECT 'Tabla cotizacionEstados creada:' as info, COUNT(*) as registros FROM "cotizacionEstados";
SELECT 'Columna cotEstadoId en COTIZACIONES:' as info,
       EXISTS(SELECT 1 FROM information_schema.columns WHERE table_name = 'COTIZACIONES' AND column_name = 'cotEstadoId') as existe;

-- ============================================================
-- NOTA: El campo "cotEstado" (string) se mantiene por compatibilidad.
-- En una futura migración se puede eliminar una vez verificado
-- que todo funciona correctamente con la FK.
-- ============================================================
