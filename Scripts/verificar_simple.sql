-- Script Simple de Verificacion (sin comandos especiales de psql)

-- 1. Verificar IVA configurados
SELECT 'TABLA IVA:' as seccion;
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
        ELSE 'ADVERTENCIA: PORCENTAJE NO SOPORTADO'
    END as mapeo_afip
FROM "IVA"
ORDER BY porcentaje;

-- 2. Clientes sin configurar
SELECT 'CLIENTES SIN TIPO DOC:' as seccion;
SELECT COUNT(*) as total FROM "CLIENTES" WHERE "cliTipoDoc" IS NULL;

SELECT 'CLIENTES SIN NUMERO DOC:' as seccion;
SELECT COUNT(*) as total FROM "CLIENTES" WHERE "cliNumDoc" IS NULL OR "cliNumDoc" = '';

-- 3. Articulos sin IVA
SELECT 'ARTICULOS SIN IVA:' as seccion;
SELECT COUNT(*) as total FROM "ARTICULOS"
WHERE "ivaCod" IS NULL OR "ivaCod" NOT IN (SELECT id FROM "IVA");

-- 4. Ventas recientes
SELECT 'ULTIMAS 10 VENTAS:' as seccion;
SELECT
    v."venCod",
    v."venFech",
    c."cliNombre",
    v."venTotal",
    v."venCAE",
    CASE
        WHEN v."venCAE" IS NOT NULL THEN 'OK - Facturada'
        WHEN v."venTipoCbte" IS NULL THEN 'ERROR - Sin tipo comprobante'
        WHEN c."cliTipoDoc" IS NULL THEN 'ERROR - Cliente sin tipo doc'
        WHEN c."cliNumDoc" IS NULL THEN 'ERROR - Cliente sin num doc'
        ELSE 'OK - Lista para facturar'
    END as estado
FROM "VENTAS" v
INNER JOIN "CLIENTES" c ON v."cliCod" = c.id
ORDER BY v."venCod" DESC
LIMIT 10;

-- 5. Logs de AFIP
SELECT 'ULTIMOS INTENTOS AFIP:' as seccion;
SELECT
    fecha,
    "tipoOperacion",
    "venCod",
    exitoso,
    LEFT(COALESCE("mensajeError", ''), 100) as error
FROM "afipLogs"
WHERE "tipoOperacion" = 'AutorizarFactura'
ORDER BY fecha DESC
LIMIT 5;
