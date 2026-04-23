-- ============================================================================
-- Script de Corrección de Datos para Facturación AFIP
-- ============================================================================
-- Este script corrige problemas comunes encontrados en la verificación
--
-- IMPORTANTE: Revisa cada sección antes de ejecutar
-- Ejecutar con: psql -U postgres -d comara -f 02_corregir_datos_afip.sql
-- ============================================================================

\echo '========================================='
\echo 'CORRECCIÓN DE DATOS PARA AFIP'
\echo '========================================='
\echo ''

-- 1. Asegurar que existan los porcentajes de IVA más comunes
\echo '1. Verificando/Agregando porcentajes de IVA estándar...'

-- Insertar IVA 0% si no existe
INSERT INTO "IVA" (id, porcentaje)
SELECT 1, 0
WHERE NOT EXISTS (SELECT 1 FROM "IVA" WHERE porcentaje = 0)
ON CONFLICT (id) DO NOTHING;

-- Insertar IVA 10.5% si no existe
INSERT INTO "IVA" (id, porcentaje)
SELECT 2, 10.5
WHERE NOT EXISTS (SELECT 1 FROM "IVA" WHERE porcentaje = 10.5)
ON CONFLICT (id) DO NOTHING;

-- Insertar IVA 21% si no existe
INSERT INTO "IVA" (id, porcentaje)
SELECT 3, 21
WHERE NOT EXISTS (SELECT 1 FROM "IVA" WHERE porcentaje = 21)
ON CONFLICT (id) DO NOTHING;

-- Insertar IVA 27% si no existe
INSERT INTO "IVA" (id, porcentaje)
SELECT 4, 27
WHERE NOT EXISTS (SELECT 1 FROM "IVA" WHERE porcentaje = 27)
ON CONFLICT (id) DO NOTHING;

\echo 'IVA actualizado.'
\echo ''

-- 2. Asegurar que existan los tipos de documento más comunes
\echo '2. Verificando/Agregando tipos de documento...'

INSERT INTO "tipoDocumento" (id, "codigoAfip", descripcion)
VALUES
    (1, 80, 'CUIT'),
    (2, 96, 'DNI'),
    (3, 99, 'Doc. Trib. No Residentes'),
    (4, 86, 'CUIL')
ON CONFLICT (id) DO UPDATE SET
    "codigoAfip" = EXCLUDED."codigoAfip",
    descripcion = EXCLUDED.descripcion;

\echo 'Tipos de documento actualizados.'
\echo ''

-- 3. Asegurar que existan los tipos de comprobante
\echo '3. Verificando/Agregando tipos de comprobante...'

INSERT INTO "tipoComprobante" (id, "codigoAfip", descripcion)
VALUES
    (1, 1, 'Factura A'),
    (2, 6, 'Factura B'),
    (3, 11, 'Factura C'),
    (4, 3, 'Nota de Crédito A'),
    (5, 8, 'Nota de Crédito B'),
    (6, 13, 'Nota de Crédito C')
ON CONFLICT (id) DO UPDATE SET
    "codigoAfip" = EXCLUDED."codigoAfip",
    descripcion = EXCLUDED.descripcion;

\echo 'Tipos de comprobante actualizados.'
\echo ''

-- 4. Asegurar que existan las condiciones de IVA
\echo '4. Verificando/Agregando condiciones de IVA...'

INSERT INTO "condicionIVA" (id, "codigoAfip", descripcion)
VALUES
    (1, 1, 'Responsable Inscripto'),
    (2, 4, 'Exento'),
    (3, 5, 'Consumidor Final'),
    (4, 6, 'Responsable Monotributo'),
    (5, 13, 'No Responsable')
ON CONFLICT (id) DO UPDATE SET
    "codigoAfip" = EXCLUDED."codigoAfip",
    descripcion = EXCLUDED.descripcion;

\echo 'Condiciones de IVA actualizadas.'
\echo ''

-- 5. Corregir artículos sin IVA (asignar 21% por defecto)
\echo '5. Corrigiendo artículos sin IVA (asignando 21% por defecto)...'

UPDATE "ARTICULOS"
SET "ivaCod" = (SELECT id FROM "IVA" WHERE porcentaje = 21 LIMIT 1)
WHERE "ivaCod" IS NULL
   OR "ivaCod" NOT IN (SELECT id FROM "IVA");

SELECT COUNT(*) as articulos_corregidos
FROM "ARTICULOS"
WHERE "ivaCod" = (SELECT id FROM "IVA" WHERE porcentaje = 21 LIMIT 1);

\echo ''

-- 6. OPCIONAL: Configurar cliente genérico "Consumidor Final"
-- Descomentar si necesitas un cliente por defecto

-- INSERT INTO "CLIENTES" (
--     "cliNombre",
--     "cliTipoDoc",
--     "cliNumDoc",
--     "cliCondicionIVA"
-- )
-- VALUES (
--     'Consumidor Final',
--     (SELECT id FROM "tipoDocumento" WHERE "codigoAfip" = 96 LIMIT 1), -- DNI
--     '0',
--     (SELECT id FROM "condicionIVA" WHERE "codigoAfip" = 5 LIMIT 1) -- Consumidor Final
-- )
-- ON CONFLICT DO NOTHING;

\echo '========================================='
\echo 'CORRECCIÓN COMPLETADA'
\echo '========================================='
\echo ''
\echo 'Ejecuta nuevamente 01_verificar_datos_afip.sql para verificar los cambios'
\echo ''
\echo 'IMPORTANTE: Recuerda configurar manualmente:'
\echo '  - Tipo de documento y número para cada cliente real'
\echo '  - Condición de IVA para cada cliente'
\echo '  - Tipo de comprobante para cada venta antes de facturar'
\echo ''
