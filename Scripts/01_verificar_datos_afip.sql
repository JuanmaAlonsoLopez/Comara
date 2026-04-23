-- ============================================================================
-- Script de Verificacion de Datos para Facturacion AFIP
-- ============================================================================
-- Este script verifica que todos los datos necesarios esten correctamente
-- configurados antes de intentar facturar con AFIP
--
-- Ejecutar con: psql -U postgres -d comara -f 01_verificar_datos_afip.sql
-- ============================================================================

\echo '========================================='
\echo 'VERIFICACION DE DATOS PARA AFIP'
\echo '========================================='
\echo ''

-- 1. Verificar tabla IVA
\echo '1. Verificando porcentajes de IVA configurados...'
SELECT
    id,
    porcentaje,
    CASE
        WHEN porcentaje = 0 THEN 'Codigo AFIP: 3'
        WHEN porcentaje = 2.5 THEN 'Codigo AFIP: 9'
        WHEN porcentaje = 5 THEN 'Codigo AFIP: 8'
        WHEN porcentaje = 10.5 THEN 'Codigo AFIP: 4'
        WHEN porcentaje = 21 THEN 'Codigo AFIP: 5'
        WHEN porcentaje = 27 THEN 'Codigo AFIP: 6'
        ELSE 'ADVERTENCIA: PORCENTAJE NO SOPORTADO POR AFIP'
    END as mapeo_afip
FROM "IVA"
ORDER BY porcentaje;
\echo ''

-- 2. Verificar clientes sin tipo de documento
\echo '2. Verificando clientes sin tipo de documento...'
SELECT
    COUNT(*) as total_clientes_sin_tipo_doc,
    STRING_AGG(id::text || ' - ' || "cliNombre", ', ') as clientes
FROM "CLIENTES"
WHERE "cliTipoDoc" IS NULL;
\echo ''

-- 3. Verificar clientes sin numero de documento
\echo '3. Verificando clientes sin numero de documento...'
SELECT
    COUNT(*) as total_clientes_sin_num_doc,
    STRING_AGG(id::text || ' - ' || "cliNombre", ', ') as clientes
FROM "CLIENTES"
WHERE "cliNumDoc" IS NULL OR "cliNumDoc" = '';
\echo ''

-- 4. Verificar articulos sin IVA configurado
\echo '4. Verificando artculos sin IVA...'
SELECT
    COUNT(*) as total_articulos_sin_iva,
    STRING_AGG("artCod" || ' - ' || "artDesc", ', ') as articulos
FROM "ARTICULOS"
WHERE "ivaCod" IS NULL
   OR "ivaCod" NOT IN (SELECT id FROM "IVA");
\echo ''

-- 5. Verificar tipos de comprobante configurados
\echo '5. Verificando tipos de comprobante configurados...'
SELECT
    id,
    "codigoAfip",
    descripcion
FROM "tipoComprobante"
ORDER BY "codigoAfip";
\echo ''

-- 6. Verificar tipos de documento configurados
\echo '6. Verificando tipos de documento configurados...'
SELECT
    id,
    "codigoAfip",
    descripcion
FROM "tipoDocumento"
ORDER BY "codigoAfip";
\echo ''

-- 7. Verificar ventas recientes sin facturar
\echo '7. Verificando ventas recientes pendientes de facturacion...'
SELECT
    v."venCod",
    v."venFech",
    c."cliNombre",
    v."venTotal",
    v."venTipoCbte",
    v."venCAE",
    CASE
        WHEN v."venCAE" IS NOT NULL THEN 'OK - Facturada'
        WHEN v."venTipoCbte" IS NULL THEN 'ERROR - Sin tipo de comprobante'
        WHEN c."cliTipoDoc" IS NULL THEN 'ERROR - Cliente sin tipo doc'
        WHEN c."cliNumDoc" IS NULL THEN 'ERROR - Cliente sin numero doc'
        ELSE 'OK - Lista para facturar'
    END as estado
FROM "VENTAS" v
INNER JOIN "CLIENTES" c ON v."cliCod" = c.id
ORDER BY v."venCod" DESC
LIMIT 10;
\echo ''

-- 8. Verificar ultimos logs de AFIP
\echo '8. Verificando ultimos intentos de facturacion AFIP...'
SELECT
    fecha,
    "tipoOperacion",
    "venCod",
    exitoso,
    LEFT("mensajeError", 100) as error,
    cae
FROM "afipLogs"
WHERE "tipoOperacion" = 'AutorizarFactura'
ORDER BY fecha DESC
LIMIT 5;
\echo ''

\echo '========================================='
\echo 'VERIFICACION COMPLETADA'
\echo '========================================='
\echo ''
\echo 'Si encontraste problemas, ejecuta el script 02_corregir_datos_afip.sql'
\echo ''
