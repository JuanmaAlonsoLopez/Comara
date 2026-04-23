using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace comara.Migrations
{
    /// <inheritdoc />
    public partial class AddUsuariosTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_COTIZACIONES_CLIENTES_cliCod",
                table: "COTIZACIONES");

            migrationBuilder.DropForeignKey(
                name: "FK_DETALLE_COTIZACIONES_ARTICULOS_artCod",
                table: "DETALLE_COTIZACIONES");

            migrationBuilder.DropForeignKey(
                name: "FK_DETALLE_VENTAS_ARTICULOS_artCod",
                table: "DETALLE_VENTAS");

            migrationBuilder.DropForeignKey(
                name: "FK_VENTAS_CLIENTES_cliCod",
                table: "VENTAS");

            migrationBuilder.DropUniqueConstraint(
                name: "AK_CLIENTES_cliCod",
                table: "CLIENTES");

            migrationBuilder.DropIndex(
                name: "IX_CLIENTES_cliCod",
                table: "CLIENTES");

            migrationBuilder.DropUniqueConstraint(
                name: "AK_ARTICULOS_artCod",
                table: "ARTICULOS");

            migrationBuilder.DropColumn(
                name: "cliCod",
                table: "CLIENTES");

            migrationBuilder.RenameColumn(
                name: "cliCUIT",
                table: "CLIENTES",
                newName: "cliNumDoc");

            migrationBuilder.AddColumn<string>(
                name: "venCAE",
                table: "VENTAS",
                type: "character varying(20)",
                maxLength: 20,
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "venCAEVencimiento",
                table: "VENTAS",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "venFechVenta",
                table: "VENTAS",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "venFechaAutorizacion",
                table: "VENTAS",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "venLista",
                table: "VENTAS",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<long>(
                name: "venNumComprobante",
                table: "VENTAS",
                type: "bigint",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "venObservacionesAfip",
                table: "VENTAS",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "venPuntoVenta",
                table: "VENTAS",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "venResultadoAfip",
                table: "VENTAS",
                type: "character varying(1)",
                maxLength: 1,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "proCelular",
                table: "PROVEEDORES",
                type: "character varying(20)",
                maxLength: 20,
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "proDescuento",
                table: "PROVEEDORES",
                type: "numeric",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "proEmail",
                table: "PROVEEDORES",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "cliCondicionIVA",
                table: "CLIENTES",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "cliFormaPago",
                table: "CLIENTES",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "cliTipoDoc",
                table: "CLIENTES",
                type: "integer",
                nullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "artCod",
                table: "ARTICULOS",
                type: "character varying(20)",
                maxLength: 20,
                nullable: false,
                oldClrType: typeof(int),
                oldType: "integer");

            migrationBuilder.CreateTable(
                name: "afip_auth_tickets",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    cuit_representado = table.Column<string>(type: "character varying(11)", maxLength: 11, nullable: false),
                    token = table.Column<string>(type: "text", nullable: false),
                    sign = table.Column<string>(type: "text", nullable: false),
                    generated_at = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    expiration_time = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    environment = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_afip_auth_tickets", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "afipLogs",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    fecha = table.Column<DateTime>(type: "timestamp with time zone", nullable: false, defaultValueSql: "CURRENT_TIMESTAMP"),
                    tipoOperacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    venCod = table.Column<int>(type: "integer", nullable: true),
                    tipoComprobante = table.Column<int>(type: "integer", nullable: true),
                    puntoVenta = table.Column<int>(type: "integer", nullable: true),
                    numeroComprobante = table.Column<long>(type: "bigint", nullable: true),
                    request = table.Column<string>(type: "text", nullable: false),
                    response = table.Column<string>(type: "text", nullable: true),
                    exitoso = table.Column<bool>(type: "boolean", nullable: false),
                    mensajeError = table.Column<string>(type: "text", nullable: true),
                    cae = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: true),
                    duracionMs = table.Column<int>(type: "integer", nullable: true),
                    ipAddress = table.Column<string>(type: "character varying(45)", maxLength: 45, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_afipLogs", x => x.id);
                    table.ForeignKey(
                        name: "FK_afipLogs_VENTAS_venCod",
                        column: x => x.venCod,
                        principalTable: "VENTAS",
                        principalColumn: "venCod",
                        onDelete: ReferentialAction.SetNull);
                });

            migrationBuilder.CreateTable(
                name: "clienteTipoFormaPago",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    descripcion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_clienteTipoFormaPago", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "condicionIVA",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    codigoAfip = table.Column<int>(type: "integer", nullable: false),
                    descripcion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_condicionIVA", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "PAGOS",
                columns: table => new
                {
                    pagCod = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    cliCod = table.Column<int>(type: "integer", nullable: false),
                    pagFech = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    pagMonto = table.Column<float>(type: "real", nullable: false),
                    pagMetodoPago = table.Column<int>(type: "integer", nullable: false),
                    pagDesc = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    cctaCod = table.Column<int>(type: "integer", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PAGOS", x => x.pagCod);
                    table.ForeignKey(
                        name: "FK_PAGOS_CLIENTES_cliCod",
                        column: x => x.cliCod,
                        principalTable: "CLIENTES",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_PAGOS_CUENTAS_CORRIENTES_cctaCod",
                        column: x => x.cctaCod,
                        principalTable: "CUENTAS_CORRIENTES",
                        principalColumn: "cctaCod");
                    table.ForeignKey(
                        name: "FK_PAGOS_ventaTipoMetodoPagos_pagMetodoPago",
                        column: x => x.pagMetodoPago,
                        principalTable: "ventaTipoMetodoPagos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "tipoComprobante",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    codigoAfip = table.Column<int>(type: "integer", nullable: false),
                    descripcion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    requiereCAE = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_tipoComprobante", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "tipoDocumento",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    codigoAfip = table.Column<int>(type: "integer", nullable: false),
                    descripcion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_tipoDocumento", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "tipoMovimientoCaja",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    descripcion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    tipo = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_tipoMovimientoCaja", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "USUARIOS",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    usuUsername = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    usuPasswordHash = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    usuRole = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    usuNombreCompleto = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    usuEmail = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    usuActivo = table.Column<bool>(type: "boolean", nullable: false),
                    usuFechaCreacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuUltimoLogin = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuCreadoPor = table.Column<int>(type: "integer", nullable: true),
                    usuModificadoPor = table.Column<int>(type: "integer", nullable: true),
                    usuFechaModificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_USUARIOS", x => x.id);
                    table.ForeignKey(
                        name: "FK_USUARIOS_USUARIOS_usuCreadoPor",
                        column: x => x.usuCreadoPor,
                        principalTable: "USUARIOS",
                        principalColumn: "id",
                        onDelete: ReferentialAction.SetNull);
                });

            migrationBuilder.CreateTable(
                name: "CHEQUES",
                columns: table => new
                {
                    chqCod = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    pagCod = table.Column<int>(type: "integer", nullable: false),
                    chqNumero = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    chqBanco = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    chqFechaEmision = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    chqFechaCobro = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    chqMonto = table.Column<float>(type: "real", nullable: false),
                    chqLibrador = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    chqCUIT = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: true),
                    chqEnCaja = table.Column<bool>(type: "boolean", nullable: false),
                    chqFechaSalida = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    chqObservaciones = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CHEQUES", x => x.chqCod);
                    table.ForeignKey(
                        name: "FK_CHEQUES_PAGOS_pagCod",
                        column: x => x.pagCod,
                        principalTable: "PAGOS",
                        principalColumn: "pagCod",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "MOVIMIENTOS_CAJA",
                columns: table => new
                {
                    movCod = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    movFecha = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    movTipo = table.Column<int>(type: "integer", nullable: false),
                    movMetodoPago = table.Column<int>(type: "integer", nullable: false),
                    movMonto = table.Column<float>(type: "real", nullable: false),
                    movDescripcion = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    chqCod = table.Column<int>(type: "integer", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MOVIMIENTOS_CAJA", x => x.movCod);
                    table.ForeignKey(
                        name: "FK_MOVIMIENTOS_CAJA_CHEQUES_chqCod",
                        column: x => x.chqCod,
                        principalTable: "CHEQUES",
                        principalColumn: "chqCod");
                    table.ForeignKey(
                        name: "FK_MOVIMIENTOS_CAJA_tipoMovimientoCaja_movTipo",
                        column: x => x.movTipo,
                        principalTable: "tipoMovimientoCaja",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_MOVIMIENTOS_CAJA_ventaTipoMetodoPagos_movMetodoPago",
                        column: x => x.movMetodoPago,
                        principalTable: "ventaTipoMetodoPagos",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_VENTAS_venLista",
                table: "VENTAS",
                column: "venLista");

            migrationBuilder.CreateIndex(
                name: "IX_VENTAS_venTipoCbte",
                table: "VENTAS",
                column: "venTipoCbte");

            migrationBuilder.CreateIndex(
                name: "IX_CLIENTES_cliCondicionIVA",
                table: "CLIENTES",
                column: "cliCondicionIVA");

            migrationBuilder.CreateIndex(
                name: "IX_CLIENTES_cliFormaPago",
                table: "CLIENTES",
                column: "cliFormaPago");

            migrationBuilder.CreateIndex(
                name: "IX_CLIENTES_cliTipoDoc",
                table: "CLIENTES",
                column: "cliTipoDoc");

            migrationBuilder.CreateIndex(
                name: "idx_afip_tickets_expiration",
                table: "afip_auth_tickets",
                columns: new[] { "cuit_representado", "environment", "expiration_time" });

            migrationBuilder.CreateIndex(
                name: "IX_afipLogs_venCod",
                table: "afipLogs",
                column: "venCod");

            migrationBuilder.CreateIndex(
                name: "IX_CHEQUES_pagCod",
                table: "CHEQUES",
                column: "pagCod");

            migrationBuilder.CreateIndex(
                name: "IX_MOVIMIENTOS_CAJA_chqCod",
                table: "MOVIMIENTOS_CAJA",
                column: "chqCod");

            migrationBuilder.CreateIndex(
                name: "IX_MOVIMIENTOS_CAJA_movMetodoPago",
                table: "MOVIMIENTOS_CAJA",
                column: "movMetodoPago");

            migrationBuilder.CreateIndex(
                name: "IX_MOVIMIENTOS_CAJA_movTipo",
                table: "MOVIMIENTOS_CAJA",
                column: "movTipo");

            migrationBuilder.CreateIndex(
                name: "IX_PAGOS_cctaCod",
                table: "PAGOS",
                column: "cctaCod");

            migrationBuilder.CreateIndex(
                name: "IX_PAGOS_cliCod",
                table: "PAGOS",
                column: "cliCod");

            migrationBuilder.CreateIndex(
                name: "IX_PAGOS_pagMetodoPago",
                table: "PAGOS",
                column: "pagMetodoPago");

            migrationBuilder.CreateIndex(
                name: "IX_USUARIOS_usuActivo",
                table: "USUARIOS",
                column: "usuActivo");

            migrationBuilder.CreateIndex(
                name: "IX_USUARIOS_usuCreadoPor",
                table: "USUARIOS",
                column: "usuCreadoPor");

            migrationBuilder.CreateIndex(
                name: "IX_USUARIOS_usuRole",
                table: "USUARIOS",
                column: "usuRole");

            migrationBuilder.CreateIndex(
                name: "IX_USUARIOS_usuUsername",
                table: "USUARIOS",
                column: "usuUsername",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_CLIENTES_clienteTipoFormaPago_cliFormaPago",
                table: "CLIENTES",
                column: "cliFormaPago",
                principalTable: "clienteTipoFormaPago",
                principalColumn: "id");

            migrationBuilder.AddForeignKey(
                name: "FK_CLIENTES_condicionIVA_cliCondicionIVA",
                table: "CLIENTES",
                column: "cliCondicionIVA",
                principalTable: "condicionIVA",
                principalColumn: "id");

            migrationBuilder.AddForeignKey(
                name: "FK_CLIENTES_tipoDocumento_cliTipoDoc",
                table: "CLIENTES",
                column: "cliTipoDoc",
                principalTable: "tipoDocumento",
                principalColumn: "id");

            migrationBuilder.AddForeignKey(
                name: "FK_COTIZACIONES_CLIENTES_cliCod",
                table: "COTIZACIONES",
                column: "cliCod",
                principalTable: "CLIENTES",
                principalColumn: "id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_DETALLE_COTIZACIONES_ARTICULOS_artCod",
                table: "DETALLE_COTIZACIONES",
                column: "artCod",
                principalTable: "ARTICULOS",
                principalColumn: "id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_DETALLE_VENTAS_ARTICULOS_artCod",
                table: "DETALLE_VENTAS",
                column: "artCod",
                principalTable: "ARTICULOS",
                principalColumn: "id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_VENTAS_CLIENTES_cliCod",
                table: "VENTAS",
                column: "cliCod",
                principalTable: "CLIENTES",
                principalColumn: "id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_VENTAS_LISTAS_venLista",
                table: "VENTAS",
                column: "venLista",
                principalTable: "LISTAS",
                principalColumn: "listCod");

            migrationBuilder.AddForeignKey(
                name: "FK_VENTAS_tipoComprobante_venTipoCbte",
                table: "VENTAS",
                column: "venTipoCbte",
                principalTable: "tipoComprobante",
                principalColumn: "id");

            // Seed data: Usuario admin inicial
            // Password: Admin123! (hashed with BCrypt work factor 11)
            string adminPasswordHash = BCrypt.Net.BCrypt.HashPassword("Admin123!", 11);

            migrationBuilder.InsertData(
                table: "USUARIOS",
                columns: new[] { "usuUsername", "usuPasswordHash", "usuRole", "usuNombreCompleto", "usuActivo", "usuFechaCreacion" },
                values: new object[] {
                    "admin",
                    adminPasswordHash,
                    "admin",
                    "Administrador del Sistema",
                    true,
                    DateTime.UtcNow
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_CLIENTES_clienteTipoFormaPago_cliFormaPago",
                table: "CLIENTES");

            migrationBuilder.DropForeignKey(
                name: "FK_CLIENTES_condicionIVA_cliCondicionIVA",
                table: "CLIENTES");

            migrationBuilder.DropForeignKey(
                name: "FK_CLIENTES_tipoDocumento_cliTipoDoc",
                table: "CLIENTES");

            migrationBuilder.DropForeignKey(
                name: "FK_COTIZACIONES_CLIENTES_cliCod",
                table: "COTIZACIONES");

            migrationBuilder.DropForeignKey(
                name: "FK_DETALLE_COTIZACIONES_ARTICULOS_artCod",
                table: "DETALLE_COTIZACIONES");

            migrationBuilder.DropForeignKey(
                name: "FK_DETALLE_VENTAS_ARTICULOS_artCod",
                table: "DETALLE_VENTAS");

            migrationBuilder.DropForeignKey(
                name: "FK_VENTAS_CLIENTES_cliCod",
                table: "VENTAS");

            migrationBuilder.DropForeignKey(
                name: "FK_VENTAS_LISTAS_venLista",
                table: "VENTAS");

            migrationBuilder.DropForeignKey(
                name: "FK_VENTAS_tipoComprobante_venTipoCbte",
                table: "VENTAS");

            migrationBuilder.DropTable(
                name: "afip_auth_tickets");

            migrationBuilder.DropTable(
                name: "afipLogs");

            migrationBuilder.DropTable(
                name: "clienteTipoFormaPago");

            migrationBuilder.DropTable(
                name: "condicionIVA");

            migrationBuilder.DropTable(
                name: "MOVIMIENTOS_CAJA");

            migrationBuilder.DropTable(
                name: "tipoComprobante");

            migrationBuilder.DropTable(
                name: "tipoDocumento");

            migrationBuilder.DropTable(
                name: "USUARIOS");

            migrationBuilder.DropTable(
                name: "CHEQUES");

            migrationBuilder.DropTable(
                name: "tipoMovimientoCaja");

            migrationBuilder.DropTable(
                name: "PAGOS");

            migrationBuilder.DropIndex(
                name: "IX_VENTAS_venLista",
                table: "VENTAS");

            migrationBuilder.DropIndex(
                name: "IX_VENTAS_venTipoCbte",
                table: "VENTAS");

            migrationBuilder.DropIndex(
                name: "IX_CLIENTES_cliCondicionIVA",
                table: "CLIENTES");

            migrationBuilder.DropIndex(
                name: "IX_CLIENTES_cliFormaPago",
                table: "CLIENTES");

            migrationBuilder.DropIndex(
                name: "IX_CLIENTES_cliTipoDoc",
                table: "CLIENTES");

            migrationBuilder.DropColumn(
                name: "venCAE",
                table: "VENTAS");

            migrationBuilder.DropColumn(
                name: "venCAEVencimiento",
                table: "VENTAS");

            migrationBuilder.DropColumn(
                name: "venFechVenta",
                table: "VENTAS");

            migrationBuilder.DropColumn(
                name: "venFechaAutorizacion",
                table: "VENTAS");

            migrationBuilder.DropColumn(
                name: "venLista",
                table: "VENTAS");

            migrationBuilder.DropColumn(
                name: "venNumComprobante",
                table: "VENTAS");

            migrationBuilder.DropColumn(
                name: "venObservacionesAfip",
                table: "VENTAS");

            migrationBuilder.DropColumn(
                name: "venPuntoVenta",
                table: "VENTAS");

            migrationBuilder.DropColumn(
                name: "venResultadoAfip",
                table: "VENTAS");

            migrationBuilder.DropColumn(
                name: "proCelular",
                table: "PROVEEDORES");

            migrationBuilder.DropColumn(
                name: "proDescuento",
                table: "PROVEEDORES");

            migrationBuilder.DropColumn(
                name: "proEmail",
                table: "PROVEEDORES");

            migrationBuilder.DropColumn(
                name: "cliCondicionIVA",
                table: "CLIENTES");

            migrationBuilder.DropColumn(
                name: "cliFormaPago",
                table: "CLIENTES");

            migrationBuilder.DropColumn(
                name: "cliTipoDoc",
                table: "CLIENTES");

            migrationBuilder.RenameColumn(
                name: "cliNumDoc",
                table: "CLIENTES",
                newName: "cliCUIT");

            migrationBuilder.AddColumn<int>(
                name: "cliCod",
                table: "CLIENTES",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AlterColumn<int>(
                name: "artCod",
                table: "ARTICULOS",
                type: "integer",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(20)",
                oldMaxLength: 20);

            migrationBuilder.AddUniqueConstraint(
                name: "AK_CLIENTES_cliCod",
                table: "CLIENTES",
                column: "cliCod");

            migrationBuilder.AddUniqueConstraint(
                name: "AK_ARTICULOS_artCod",
                table: "ARTICULOS",
                column: "artCod");

            migrationBuilder.CreateIndex(
                name: "IX_CLIENTES_cliCod",
                table: "CLIENTES",
                column: "cliCod",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_COTIZACIONES_CLIENTES_cliCod",
                table: "COTIZACIONES",
                column: "cliCod",
                principalTable: "CLIENTES",
                principalColumn: "cliCod",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_DETALLE_COTIZACIONES_ARTICULOS_artCod",
                table: "DETALLE_COTIZACIONES",
                column: "artCod",
                principalTable: "ARTICULOS",
                principalColumn: "artCod",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_DETALLE_VENTAS_ARTICULOS_artCod",
                table: "DETALLE_VENTAS",
                column: "artCod",
                principalTable: "ARTICULOS",
                principalColumn: "artCod",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_VENTAS_CLIENTES_cliCod",
                table: "VENTAS",
                column: "cliCod",
                principalTable: "CLIENTES",
                principalColumn: "cliCod",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
