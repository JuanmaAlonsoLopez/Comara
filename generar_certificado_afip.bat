@echo off
echo ===============================================
echo  Generador de Certificado para AFIP Testing
echo ===============================================
echo.

cd certificados

echo Paso 1: Generando clave privada...
openssl genrsa -out afip_testing.key 2048
if %ERRORLEVEL% NEQ 0 goto error

echo.
echo Paso 2: Creando archivo de configuracion...
(
echo [req]
echo default_bits = 2048
echo prompt = no
echo default_md = sha256
echo distinguished_name = dn
echo.
echo [dn]
echo C=AR
echo O=COMARA
echo CN=comara
echo serialNumber=CUIT 20409378472
) > afip_config.cnf

echo.
echo Paso 3: Generando CSR con formato AFIP...
openssl req -new -key afip_testing.key -out afip_testing.csr -config afip_config.cnf
if %ERRORLEVEL% NEQ 0 goto error

echo.
echo Paso 4: Generando certificado autofirmado temporal...
openssl x509 -req -days 365 -in afip_testing.csr -signkey afip_testing.key -out afip_testing.crt
if %ERRORLEVEL% NEQ 0 goto error

echo.
echo Paso 5: Creando archivo PFX...
openssl pkcs12 -export -out certificado_testing.pfx -inkey afip_testing.key -in afip_testing.crt -passout pass:Abccd123$
if %ERRORLEVEL% NEQ 0 goto error

echo.
echo ===============================================
echo  CERTIFICADO GENERADO EXITOSAMENTE
echo ===============================================
echo.
echo Archivos creados en la carpeta certificados:
echo   - afip_testing.key (clave privada)
echo   - afip_testing.csr (solicitud de certificado)
echo   - afip_testing.crt (certificado temporal)
echo   - certificado_testing.pfx (para usar con AFIP)
echo.
echo IMPORTANTE: Este certificado tiene el formato correcto
echo pero AFIP aun puede rechazarlo en Homologacion.
echo.
echo PROXIMOS PASOS:
echo 1. Ve a: https://auth.afip.gob.ar
echo 2. Ingresa con Clave Fiscal
echo 3. Busca "Administrador de Relaciones"
echo 4. Solicita acceso a "WSASS" (Testing de Web Services)
echo 5. Sube el archivo afip_testing.csr
echo 6. Descarga el certificado .crt que AFIP genere
echo 7. Crea el PFX con el certificado de AFIP
echo.
echo ===============================================
pause
goto end

:error
echo.
echo ERROR: Hubo un problema al generar el certificado
echo Verifica que OpenSSL este instalado y en el PATH
pause

:end
