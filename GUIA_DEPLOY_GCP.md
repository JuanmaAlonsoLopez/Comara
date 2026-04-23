# Guía de Migración a Google Cloud Platform (Nueva Cuenta)

Esta guía te ayudará a migrar el proyecto COMARA desde tu cuenta anterior de Google Cloud a una nueva cuenta oficial.

## Índice
1. [Prerrequisitos](#prerrequisitos)
2. [Configuración Inicial de GCP](#configuración-inicial-de-gcp)
3. [Configurar Base de Datos en Cloud SQL](#configurar-base-de-datos-en-cloud-sql)
4. [Preparar la Aplicación](#preparar-la-aplicación)
5. [Subir Docker a Artifact Registry](#subir-docker-a-artifact-registry)
6. [Desplegar en Cloud Run](#desplegar-en-cloud-run)
7. [Migrar la Base de Datos](#migrar-la-base-de-datos)
8. [Verificación y Pruebas](#verificación-y-pruebas)

---

## Prerrequisitos

### 1. Instalar Google Cloud CLI
```bash
# Descargar e instalar desde: https://cloud.google.com/sdk/docs/install
# Verificar instalación
gcloud --version
```

### 2. Herramientas necesarias
- Docker Desktop instalado y corriendo
- PostgreSQL client (pg_dump, psql)
- Acceso a tu base de datos actual

---

## Configuración Inicial de GCP

### 1. Iniciar sesión con la nueva cuenta
```bash
# Cerrar sesión de la cuenta anterior
gcloud auth revoke

# Iniciar sesión con la nueva cuenta oficial
gcloud auth login

# Configurar aplicación por defecto
gcloud auth application-default login
```

### 2. Crear un nuevo proyecto GCP
```bash
# Crear proyecto (elige un ID único)
gcloud projects create comara-produccion --name="COMARA Sistema"

# Configurar como proyecto por defecto
gcloud config set project comara-produccion

# Habilitar APIs necesarias
gcloud services enable \
  cloudbuild.googleapis.com \
  run.googleapis.com \
  sqladmin.googleapis.com \
  artifactregistry.googleapis.com \
  compute.googleapis.com \
  secretmanager.googleapis.com
```

### 3. Configurar facturación
```bash
# Listar cuentas de facturación disponibles
gcloud billing accounts list

# Asociar cuenta de facturación al proyecto (reemplaza BILLING_ACCOUNT_ID)
gcloud billing projects link comara-produccion --billing-account=BILLING_ACCOUNT_ID
```

---

## Configurar Base de Datos en Cloud SQL

### 1. Crear instancia de Cloud SQL PostgreSQL
```bash
# Crear instancia (esto puede tardar varios minutos)
gcloud sql instances create comara-db \
  --database-version=POSTGRES_15 \
  --tier=db-f1-micro \
  --region=us-central1 \
  --root-password=TU_PASSWORD_SEGURO

# Para producción, considera un tier más robusto:
# --tier=db-custom-2-7680 (2 vCPUs, 7.5 GB RAM)
```

### 2. Crear la base de datos
```bash
# Crear database dentro de la instancia
gcloud sql databases create comara --instance=comara-db

# Crear usuario de aplicación (opcional, más seguro que usar postgres)
gcloud sql users create comara_app \
  --instance=comara-db \
  --password=PASSWORD_APP_SEGURO
```

### 3. Configurar conexión privada (recomendado para Cloud Run)
```bash
# Obtener el connection name de la instancia
gcloud sql instances describe comara-db --format="value(connectionName)"
# Guardar este valor, lo necesitarás: PROJECT_ID:REGION:INSTANCE_NAME
```

---

## Preparar la Aplicación

### 1. Verificar appsettings.Production.json

El archivo `appsettings.Production.json` ya está creado con valores vacíos para las credenciales.
La aplicación lee automáticamente las credenciales desde variables de entorno (Secret Manager).

**NO es necesario modificar este archivo.** Las credenciales se inyectan en runtime desde Secret Manager.

```
Flujo de configuración:
1. Cloud Run inicia con ASPNETCORE_ENVIRONMENT=Production
2. La app carga appsettings.Production.json (sin credenciales)
3. Secret Manager inyecta DB_PASSWORD y AFIP_CERT_PASSWORD como variables de entorno
4. Program.cs detecta las variables y construye el connection string automáticamente
```

### 2. Guardar secretos en Secret Manager

**IMPORTANTE:** Los nombres de los secretos deben coincidir con las variables de entorno que espera la aplicación.

```bash
# Crear secretos (usar nombres que coincidan con las variables de entorno)
echo -n "TU_PASSWORD_DB_SEGURO" | gcloud secrets create DB_PASSWORD --data-file=-
echo -n "TU_PASSWORD_CERTIFICADO_AFIP" | gcloud secrets create AFIP_CERT_PASSWORD --data-file=-

# Opcional: Instancia Cloud SQL personalizada (default: comara-produccion:us-central1:comara-db)
echo -n "tu-proyecto:tu-region:tu-instancia" | gcloud secrets create CLOUD_SQL_INSTANCE --data-file=-

# Verificar
gcloud secrets list

# Dar permisos a Cloud Run para acceder a los secretos
gcloud secrets add-iam-policy-binding DB_PASSWORD \
  --member="serviceAccount:PROJECT_NUMBER-compute@developer.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor"

gcloud secrets add-iam-policy-binding AFIP_CERT_PASSWORD \
  --member="serviceAccount:PROJECT_NUMBER-compute@developer.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor"
```

**Nota:** La aplicación construye automáticamente el connection string de Cloud SQL usando:
- `DB_PASSWORD`: Password de la base de datos
- `CLOUD_SQL_INSTANCE`: (opcional) Nombre de la instancia Cloud SQL

---

## Subir Docker a Artifact Registry

### 1. Crear repositorio de Docker
```bash
# Crear repositorio en Artifact Registry
gcloud artifacts repositories create comara-docker \
  --repository-format=docker \
  --location=us-central1 \
  --description="Repositorio Docker para COMARA"

# Configurar Docker para autenticación
gcloud auth configure-docker us-central1-docker.pkg.dev
```

### 2. Construir y subir imagen
```bash
# Construir imagen localmente
docker build -t comara:latest .

# Etiquetar para Artifact Registry
docker tag comara:latest us-central1-docker.pkg.dev/comara-produccion/comara-docker/comara:latest

# Subir imagen
docker push us-central1-docker.pkg.dev/comara-produccion/comara-docker/comara:latest
```

---

## Desplegar en Cloud Run

### 1. Desplegar aplicación
```bash
gcloud run deploy comara \
  --image=us-central1-docker.pkg.dev/comara-produccion/comara-docker/comara:latest \
  --platform=managed \
  --region=us-central1 \
  --add-cloudsql-instances=comara-produccion:us-central1:comara-db \
  --set-env-vars="ASPNETCORE_ENVIRONMENT=Production" \
  --set-secrets="DB_PASSWORD=DB_PASSWORD:latest,AFIP_CERT_PASSWORD=AFIP_CERT_PASSWORD:latest" \
  --allow-unauthenticated \
  --min-instances=1 \
  --max-instances=10 \
  --memory=512Mi \
  --cpu=1 \
  --timeout=300
```

**Explicación de secretos:**
- `DB_PASSWORD=DB_PASSWORD:latest` → Variable de entorno `DB_PASSWORD` = secreto `DB_PASSWORD` (última versión)
- `AFIP_CERT_PASSWORD=AFIP_CERT_PASSWORD:latest` → Variable de entorno `AFIP_CERT_PASSWORD` = secreto `AFIP_CERT_PASSWORD`

La aplicación automáticamente construye el connection string usando estas variables.

### 2. Configurar dominio personalizado (opcional)
```bash
# Mapear dominio personalizado
gcloud run services update comara \
  --region=us-central1 \
  --domain=tudominio.com
```

---

## Migrar la Base de Datos

### Opción A: Desde base de datos local

```bash
# 1. Exportar base de datos local
pg_dump -h localhost -U postgres -d comara -F c -b -v -f comara_backup.dump

# 2. Subir a Cloud Storage (temporal)
gsutil mb gs://comara-db-backup
gsutil cp comara_backup.dump gs://comara-db-backup/

# 3. Importar a Cloud SQL
gcloud sql import sql comara-db \
  gs://comara-db-backup/comara_backup.dump \
  --database=comara
```

### Opción B: Desde tu cuenta GCP anterior

```bash
# 1. En la cuenta anterior, exportar
gcloud config set project PROYECTO_ANTERIOR
gcloud sql export sql INSTANCIA_ANTERIOR \
  gs://BUCKET_ANTERIOR/comara_export.sql \
  --database=comara

# 2. Hacer público el archivo temporalmente o compartir bucket
gsutil acl ch -u NUEVA_CUENTA_EMAIL:R gs://BUCKET_ANTERIOR/comara_export.sql

# 3. En la cuenta nueva, importar
gcloud config set project comara-produccion
gsutil cp gs://BUCKET_ANTERIOR/comara_export.sql gs://comara-db-backup/
gcloud sql import sql comara-db \
  gs://comara-db-backup/comara_export.sql \
  --database=comara
```

### Opción C: Usando Cloud SQL Proxy (más control)

```bash
# 1. Instalar Cloud SQL Proxy
# Descargar desde: https://cloud.google.com/sql/docs/postgres/sql-proxy

# 2. Conectar a Cloud SQL
./cloud-sql-proxy comara-produccion:us-central1:comara-db

# 3. En otra terminal, restaurar
psql -h 127.0.0.1 -U postgres -d comara < backup_local.sql
```

---

## Verificación y Pruebas

### 1. Verificar deployment
```bash
# Ver URL del servicio
gcloud run services describe comara --region=us-central1 --format="value(status.url)"

# Ver logs en tiempo real
gcloud run services logs tail comara --region=us-central1
```

### 2. Probar conexión a base de datos
```bash
# Conectar con Cloud SQL Proxy
./cloud-sql-proxy comara-produccion:us-central1:comara-db &

# Conectar con psql
psql -h 127.0.0.1 -U postgres -d comara

# Verificar tablas
\dt
```

### 3. Pruebas de la aplicación
- Acceder a la URL de Cloud Run
- Verificar que carga correctamente
- Probar funcionalidades principales
- Revisar logs de errores

---

## Comandos Útiles de Administración

### Ver logs
```bash
# Logs de Cloud Run
gcloud run services logs read comara --region=us-central1 --limit=50

# Logs de Cloud SQL
gcloud sql operations list --instance=comara-db
```

### Actualizar aplicación
```bash
# Reconstruir y desplegar
docker build -t us-central1-docker.pkg.dev/comara-produccion/comara-docker/comara:latest .
docker push us-central1-docker.pkg.dev/comara-produccion/comara-docker/comara:latest
gcloud run services update comara --region=us-central1 \
  --image=us-central1-docker.pkg.dev/comara-produccion/comara-docker/comara:latest
```

### Backups automáticos
```bash
# Configurar backups automáticos (ya están habilitados por defecto)
gcloud sql instances patch comara-db \
  --backup-start-time=03:00 \
  --enable-bin-log
```

### Escalar recursos
```bash
# Actualizar tier de base de datos
gcloud sql instances patch comara-db --tier=db-custom-2-7680

# Actualizar Cloud Run
gcloud run services update comara --region=us-central1 \
  --memory=1Gi \
  --cpu=2 \
  --max-instances=20
```

---

## Costos Estimados

### Cloud SQL (db-f1-micro)
- ~$7-10 USD/mes

### Cloud Run
- $0.00002400 por vCPU-segundo
- $0.00000250 por GiB-segundo
- $0.40 por millón de requests
- Estimado: $5-20 USD/mes (depende del tráfico)

### Artifact Registry
- $0.10 por GB/mes de almacenamiento
- Estimado: <$1 USD/mes

### Total estimado: $15-35 USD/mes

---

## Troubleshooting

### Error: "Cannot connect to Cloud SQL"
- Verificar que el connection name es correcto
- Verificar que Cloud SQL está en la misma región que Cloud Run
- Revisar permisos de service account

### Error: "Database does not exist"
- Crear la base de datos: `gcloud sql databases create comara --instance=comara-db`
- Verificar nombre de database en connection string

### Error: "Access denied"
- Verificar password del usuario
- Verificar que el usuario tiene permisos: `GRANT ALL ON DATABASE comara TO postgres;`

### Aplicación no inicia
- Revisar logs: `gcloud run services logs read comara --region=us-central1`
- Verificar variables de entorno y secretos
- Verificar que el certificado AFIP está incluido en la imagen Docker

---

## Checklist de Migración

- [ ] Cuenta GCP nueva creada y configurada
- [ ] Proyecto GCP creado
- [ ] Facturación habilitada
- [ ] APIs habilitadas
- [ ] Cloud SQL instancia creada
- [ ] Base de datos creada
- [ ] Artifact Registry repositorio creado
- [ ] Secretos guardados en Secret Manager
- [ ] Imagen Docker construida y subida
- [ ] Cloud Run servicio desplegado
- [ ] Base de datos migrada
- [ ] Aplicación accesible y funcionando
- [ ] Backups configurados
- [ ] Monitoreo configurado (opcional)
- [ ] Dominio personalizado configurado (opcional)

---

## Recursos Adicionales

- [Documentación de Cloud Run](https://cloud.google.com/run/docs)
- [Documentación de Cloud SQL](https://cloud.google.com/sql/docs)
- [Mejores prácticas de seguridad](https://cloud.google.com/security/best-practices)
- [Pricing Calculator](https://cloud.google.com/products/calculator)
