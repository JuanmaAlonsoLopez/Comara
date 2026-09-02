# Comara

Sistema web de gestión comercial desarrollado con **ASP.NET Core MVC y PostgreSQL**. Centraliza clientes, proveedores, artículos, stock, cotizaciones, ventas, cobranzas, caja, precios, reportes y facturación electrónica argentina.

> **English summary:** Business management web application built with .NET 8, ASP.NET Core MVC, Entity Framework Core and PostgreSQL, including inventory, sales, reporting and ARCA/AFIP electronic invoicing workflows.

## Funcionalidades principales

- Gestión de clientes, proveedores, usuarios, marcas y artículos.
- Control de stock, listas de precios y movimientos comerciales.
- Cotizaciones, ventas, facturas, cobranzas y caja.
- Reportes y exportación de información.
- Generación de comprobantes PDF, archivos Excel y códigos QR.
- Integración con servicios de facturación electrónica de ARCA/AFIP, con modo de prueba.
- Autenticación mediante cookies, autorización por roles y limitación de intentos de acceso.
- Logging estructurado, reintentos y circuit breaker para integraciones externas.

## Stack técnico

- **Backend:** C#, .NET 8, ASP.NET Core MVC
- **Persistencia:** Entity Framework Core, PostgreSQL, Npgsql
- **Frontend:** Razor Views, HTML, CSS, JavaScript y Bootstrap
- **Documentos:** QuestPDF, EPPlus y QRCoder
- **Observabilidad y resiliencia:** Serilog y Polly
- **Infraestructura:** Docker, Google Cloud Run y Cloud SQL

## Arquitectura

El proyecto sigue la estructura MVC de ASP.NET Core y separa responsabilidades mediante controladores, modelos, servicios, filtros y componentes de vista. Las integraciones con ARCA/AFIP y la generación de documentos se encapsulan en servicios específicos.

## Ejecución local

### Requisitos

- .NET 8 SDK
- PostgreSQL
- Docker (opcional)

### Configuración

1. Clonar el repositorio y entrar en la carpeta del proyecto.
2. Crear una base de datos PostgreSQL.
3. Configurar las credenciales con .NET User Secrets:

```powershell
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "Host=localhost;Database=comara;Username=postgres;Password=TU_PASSWORD"
dotnet user-secrets set "Afip:CertificadoPassword" "TU_PASSWORD_CERTIFICADO"
```

4. Guardar el certificado localmente en `App_Data/Certificados/`. Esta carpeta está excluida de Git.
5. Aplicar las migraciones y ejecutar:

```powershell
dotnet ef database update
dotnet run
```

## Docker

```powershell
docker build -t comara .
```

En producción, las credenciales se suministran mediante variables de entorno o un gestor de secretos. El repositorio no debe contener contraseñas, certificados ni copias de bases de datos.

## Seguridad

- Las configuraciones versionadas contienen únicamente valores de demostración.
- Las credenciales de desarrollo se administran con User Secrets.
- Las credenciales de producción se inyectan mediante variables de entorno o Secret Manager.
- Certificados, claves, logs, backups y artefactos de compilación están excluidos mediante `.gitignore`.

## Estado

Proyecto en evolución orientado a resolver procesos comerciales reales y a demostrar experiencia práctica con .NET, PostgreSQL, integraciones externas y despliegue en la nube.
