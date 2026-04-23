# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

COMARA is an ASP.NET Core 8.0 MVC application for managing inventory, sales, quotations, and pricing for a commercial business. It uses Entity Framework Core with PostgreSQL as the database.

## Essential Commands

### Running the Application
```bash
dotnet run
```

### Building the Project
```bash
dotnet build
```

### Database Migrations
```bash
# Create a new migration
dotnet ef migrations add <MigrationName>

# Apply migrations to database
dotnet ef database update

# Remove last migration (if not applied)
dotnet ef migrations remove
```

### Restoring Dependencies
```bash
dotnet restore
```

## Architecture

### Database-First Approach
This project uses an **existing PostgreSQL database** with tables already defined. The Entity Framework models map to existing tables with explicit table and column mappings.

**Important**: All table names are UPPERCASE (e.g., `ARTICULOS`, `CLIENTES`, `VENTAS`) and column names use camelCase with prefixes (e.g., `artCod`, `cliCod`, `venCod`).

### Core Components

#### Models (comara.Models)
- Each model maps to an existing database table using `[Table]` and `[Column]` attributes
- Primary keys use custom column names (e.g., `artCod`, `cliCod`) mapped via `[Column]` attributes
- Navigation properties are configured for foreign key relationships
- Key entities:
  - **Articulo**: Products/inventory items with stock, pricing (ArtL1-ArtL5 for price lists), brand (Marca), and supplier (Proveedor)
  - **Cotizacion/DetalleCotizacion**: Quotations and their line items
  - **Venta/DetalleVenta**: Sales and their line items
  - **Cliente**: Customers with current account (CuentaCorriente) and payment history (Cobros)
  - **Lista**: Price lists with percentage multipliers
  - **Stock (ArticuloStock)**: Stock movements and tracking

#### DbContext (comara.Data.ApplicationDbContext)
- Configures all entity-to-table mappings in `OnModelCreating`
- Explicitly defines primary keys and foreign key relationships
- Connection string configured in `appsettings.json` pointing to local PostgreSQL instance

#### Controllers
Standard MVC controllers with async operations:
- **ArticulosController**: Product management with stock tracking
- **CotizacionesController**: Quotation creation and management
- **VentasController**: Sales processing
- **PreciosController**: Price list management and bulk price updates
- **StockController**: Stock movements and inventory control
- **CobranzasController**: Payment collection
- **ReportesController**: Reporting functionality
- **ListasController**: Price list configuration

#### Services (comara.Services)
- **IARCAApiService/ARCAApiService**: External API integration for ARCA system
- Services registered in `Program.cs` using dependency injection

### Key Patterns

1. **Column Name Mapping**: Always use `[Column("columnName")]` attributes - database columns don't match C# property names
2. **Foreign Keys**: Explicitly defined in ApplicationDbContext with `.HasOne()/.WithMany()` fluent API
3. **Master-Detail**: Cotizaciones/Ventas use master-detail pattern with navigation collections (DetalleCotizaciones/DetalleVentas)
4. **Price Lists**: Articles have 5 price levels (ArtL1-ArtL5), Lista table defines percentage multipliers
5. **Stock Tracking**: Separate ArticuloStock model for tracking stock movements

## Database Connection

PostgreSQL connection configured in `appsettings.json`:
- Host: localhost
- Database: comara
- Default username: postgres

**Note**: Connection string contains credentials - ensure appsettings.json is in .gitignore for production deployments.

## View Conventions

- Views organized by controller name in Views/ folder
- Uses Razor syntax (.cshtml)
- Shared layout in Views/Shared/_Layout.cshtml
- Bootstrap-based UI components
