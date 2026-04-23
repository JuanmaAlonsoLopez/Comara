-- ============================================================================
-- Script para Ver Últimos Errores de AFIP
-- ============================================================================
-- Muestra información detallada de los últimos intentos de facturación
-- incluyendo el request y response completos
--
-- Ejecutar con: psql -U postgres -d comara -f 03_ver_ultimos_errores_afip.sql
-- ============================================================================

\echo '========================================='
\echo 'ÚLTIMOS ERRORES DE FACTURACIÓN AFIP'
\echo '========================================='
\echo ''

-- Ver últimos 5 intentos fallidos
\echo '--- INTENTOS FALLIDOS ---'
\echo ''

SELECT
    id,
    fecha,
    "tipoOperacion",
    "venCod",
    "tipoComprobante",
    "puntoVenta",
    "numeroComprobante",
    exitoso,
    "mensajeError",
    "duracionMs"
FROM "afipLogs"
WHERE exitoso = false
ORDER BY fecha DESC
LIMIT 5;

\echo ''
\echo '--- DETALLE DEL ÚLTIMO ERROR ---'
\echo ''

-- Ver el request y response del último error
SELECT
    '=== INFORMACIÓN GENERAL ===' as seccion,
    NULL as contenido
UNION ALL
SELECT
    'ID',
    id::text
FROM "afipLogs"
WHERE exitoso = false
ORDER BY fecha DESC
LIMIT 1
UNION ALL
SELECT
    'Fecha',
    fecha::text
FROM "afipLogs"
WHERE exitoso = false
ORDER BY fecha DESC
LIMIT 1
UNION ALL
SELECT
    'Venta ID',
    "venCod"::text
FROM "afipLogs"
WHERE exitoso = false
ORDER BY fecha DESC
LIMIT 1
UNION ALL
SELECT
    '',
    ''
UNION ALL
SELECT
    '=== ERROR ===',
    NULL
UNION ALL
SELECT
    'Mensaje',
    "mensajeError"
FROM "afipLogs"
WHERE exitoso = false
ORDER BY fecha DESC
LIMIT 1;

\echo ''
\echo '--- REQUEST ENVIADO A AFIP ---'
\echo ''

\pset format unaligned
\pset tuples_only on

SELECT request
FROM "afipLogs"
WHERE exitoso = false
ORDER BY fecha DESC
LIMIT 1;

\pset format aligned
\pset tuples_only off

\echo ''
\echo '--- RESPONSE DE AFIP ---'
\echo ''

\pset format unaligned
\pset tuples_only on

SELECT COALESCE(response, 'Sin respuesta')
FROM "afipLogs"
WHERE exitoso = false
ORDER BY fecha DESC
LIMIT 1;

\pset format aligned
\pset tuples_only off

\echo ''
\echo ''
\echo '========================================='
\echo 'ESTADÍSTICAS GENERALES'
\echo '========================================='
\echo ''

SELECT
    "tipoOperacion",
    COUNT(*) as total_intentos,
    SUM(CASE WHEN exitoso THEN 1 ELSE 0 END) as exitosos,
    SUM(CASE WHEN NOT exitoso THEN 1 ELSE 0 END) as fallidos,
    ROUND(AVG("duracionMs")::numeric, 2) as duracion_promedio_ms
FROM "afipLogs"
GROUP BY "tipoOperacion"
ORDER BY total_intentos DESC;

\echo ''
\echo '--- ERRORES MÁS COMUNES ---'
\echo ''

SELECT
    LEFT("mensajeError", 80) as error,
    COUNT(*) as veces
FROM "afipLogs"
WHERE exitoso = false
  AND "mensajeError" IS NOT NULL
GROUP BY LEFT("mensajeError", 80)
ORDER BY veces DESC
LIMIT 5;

\echo ''
