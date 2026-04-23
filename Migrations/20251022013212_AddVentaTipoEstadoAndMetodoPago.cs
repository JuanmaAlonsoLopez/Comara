using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace comara.Migrations
{
    /// <inheritdoc />
    public partial class AddVentaTipoEstadoAndMetodoPago : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "CLIENTES",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    cliCod = table.Column<int>(type: "integer", nullable: false),
                    cliNombre = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    cliCUIT = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: true),
                    cliDireccion = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: true),
                    cliTelefono = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: true),
                    cliEmail = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CLIENTES", x => x.id);
                    table.UniqueConstraint("AK_CLIENTES_cliCod", x => x.cliCod);
                });

            migrationBuilder.CreateTable(
                name: "IVA",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    porcentaje = table.Column<decimal>(type: "numeric(5,2)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_IVA", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "LISTAS",
                columns: table => new
                {
                    listCod = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    listDesc = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    listPercent = table.Column<float>(type: "real", nullable: false),
                    listStatus = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_LISTAS", x => x.listCod);
                });

            migrationBuilder.CreateTable(
                name: "MARCAS",
                columns: table => new
                {
                    marCod = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    marNombre = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MARCAS", x => x.marCod);
                });

            migrationBuilder.CreateTable(
                name: "PROVEEDORES",
                columns: table => new
                {
                    proCod = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    proNombre = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    proCUIT = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: true),
                    proContacto = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PROVEEDORES", x => x.proCod);
                });

            migrationBuilder.CreateTable(
                name: "ventaTipoEstado",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    descripcion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ventaTipoEstado", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "ventaTipoMetodoPagos",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    descripcion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ventaTipoMetodoPagos", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "COBROS",
                columns: table => new
                {
                    cobCod = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    cliCod = table.Column<int>(type: "integer", nullable: false),
                    cobFech = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    cobMonto = table.Column<float>(type: "real", nullable: false),
                    cobMetodo = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_COBROS", x => x.cobCod);
                    table.ForeignKey(
                        name: "FK_COBROS_CLIENTES_cliCod",
                        column: x => x.cliCod,
                        principalTable: "CLIENTES",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "COTIZACIONES",
                columns: table => new
                {
                    cotCod = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    cotFech = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    cliCod = table.Column<int>(type: "integer", nullable: false),
                    cotTotal = table.Column<float>(type: "real", nullable: false),
                    cotEstado = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_COTIZACIONES", x => x.cotCod);
                    table.ForeignKey(
                        name: "FK_COTIZACIONES_CLIENTES_cliCod",
                        column: x => x.cliCod,
                        principalTable: "CLIENTES",
                        principalColumn: "cliCod",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "CUENTAS_CORRIENTES",
                columns: table => new
                {
                    cctaCod = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    cliCod = table.Column<int>(type: "integer", nullable: false),
                    cctaFech = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    cctaMovimiento = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: true),
                    cctaMonto = table.Column<float>(type: "real", nullable: false),
                    cctaSaldo = table.Column<float>(type: "real", nullable: false),
                    cctaDesc = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CUENTAS_CORRIENTES", x => x.cctaCod);
                    table.ForeignKey(
                        name: "FK_CUENTAS_CORRIENTES_CLIENTES_cliCod",
                        column: x => x.cliCod,
                        principalTable: "CLIENTES",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ARTICULOS",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    artCod = table.Column<int>(type: "integer", nullable: false),
                    artDesc = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: false),
                    activo = table.Column<byte[]>(type: "bytea", nullable: true),
                    artStock = table.Column<float>(type: "real", nullable: true),
                    artUni = table.Column<int>(type: "integer", nullable: false),
                    artStockMin = table.Column<float>(type: "real", nullable: true),
                    artExist = table.Column<bool>(type: "boolean", nullable: true),
                    rubCod = table.Column<int>(type: "integer", nullable: false),
                    srubCod = table.Column<int>(type: "integer", nullable: false),
                    marCod = table.Column<int>(type: "integer", nullable: false),
                    ivaCod = table.Column<int>(type: "integer", nullable: false),
                    artAlt1 = table.Column<string>(type: "character varying(18)", maxLength: 18, nullable: true),
                    artAlt2 = table.Column<string>(type: "character varying(18)", maxLength: 18, nullable: true),
                    artL1 = table.Column<float>(type: "real", nullable: true),
                    artL2 = table.Column<float>(type: "real", nullable: true),
                    artL3 = table.Column<float>(type: "real", nullable: true),
                    artL4 = table.Column<float>(type: "real", nullable: true),
                    artL5 = table.Column<float>(type: "real", nullable: true),
                    proCod = table.Column<int>(type: "integer", nullable: false),
                    artCosto = table.Column<decimal>(type: "numeric", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ARTICULOS", x => x.id);
                    table.UniqueConstraint("AK_ARTICULOS_artCod", x => x.artCod);
                    table.ForeignKey(
                        name: "FK_ARTICULOS_IVA_ivaCod",
                        column: x => x.ivaCod,
                        principalTable: "IVA",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ARTICULOS_MARCAS_marCod",
                        column: x => x.marCod,
                        principalTable: "MARCAS",
                        principalColumn: "marCod",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ARTICULOS_PROVEEDORES_proCod",
                        column: x => x.proCod,
                        principalTable: "PROVEEDORES",
                        principalColumn: "proCod",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "VENTAS",
                columns: table => new
                {
                    venCod = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    venFech = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    cliCod = table.Column<int>(type: "integer", nullable: false),
                    venTotal = table.Column<float>(type: "real", nullable: false),
                    venEstado = table.Column<int>(type: "integer", nullable: true),
                    venTipoCbte = table.Column<int>(type: "integer", nullable: true),
                    venMetodoPago = table.Column<int>(type: "integer", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_VENTAS", x => x.venCod);
                    table.ForeignKey(
                        name: "FK_VENTAS_CLIENTES_cliCod",
                        column: x => x.cliCod,
                        principalTable: "CLIENTES",
                        principalColumn: "cliCod",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_VENTAS_ventaTipoEstado_venEstado",
                        column: x => x.venEstado,
                        principalTable: "ventaTipoEstado",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_VENTAS_ventaTipoMetodoPagos_venMetodoPago",
                        column: x => x.venMetodoPago,
                        principalTable: "ventaTipoMetodoPagos",
                        principalColumn: "id");
                });

            migrationBuilder.CreateTable(
                name: "DETALLE_COTIZACIONES",
                columns: table => new
                {
                    detCotCod = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    cotCod = table.Column<int>(type: "integer", nullable: false),
                    artCod = table.Column<int>(type: "integer", nullable: false),
                    detCant = table.Column<float>(type: "real", nullable: false),
                    detPrecio = table.Column<float>(type: "real", nullable: false),
                    detSubtotal = table.Column<float>(type: "real", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DETALLE_COTIZACIONES", x => x.detCotCod);
                    table.ForeignKey(
                        name: "FK_DETALLE_COTIZACIONES_ARTICULOS_artCod",
                        column: x => x.artCod,
                        principalTable: "ARTICULOS",
                        principalColumn: "artCod",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_DETALLE_COTIZACIONES_COTIZACIONES_cotCod",
                        column: x => x.cotCod,
                        principalTable: "COTIZACIONES",
                        principalColumn: "cotCod",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "DETALLE_VENTAS",
                columns: table => new
                {
                    detCod = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    venCod = table.Column<int>(type: "integer", nullable: false),
                    artCod = table.Column<int>(type: "integer", nullable: false),
                    detCant = table.Column<float>(type: "real", nullable: false),
                    detPrecio = table.Column<float>(type: "real", nullable: false),
                    detSubtotal = table.Column<float>(type: "real", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DETALLE_VENTAS", x => x.detCod);
                    table.ForeignKey(
                        name: "FK_DETALLE_VENTAS_ARTICULOS_artCod",
                        column: x => x.artCod,
                        principalTable: "ARTICULOS",
                        principalColumn: "artCod",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_DETALLE_VENTAS_VENTAS_venCod",
                        column: x => x.venCod,
                        principalTable: "VENTAS",
                        principalColumn: "venCod",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ARTICULOS_artCod",
                table: "ARTICULOS",
                column: "artCod",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_ARTICULOS_ivaCod",
                table: "ARTICULOS",
                column: "ivaCod");

            migrationBuilder.CreateIndex(
                name: "IX_ARTICULOS_marCod",
                table: "ARTICULOS",
                column: "marCod");

            migrationBuilder.CreateIndex(
                name: "IX_ARTICULOS_proCod",
                table: "ARTICULOS",
                column: "proCod");

            migrationBuilder.CreateIndex(
                name: "IX_CLIENTES_cliCod",
                table: "CLIENTES",
                column: "cliCod",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_COBROS_cliCod",
                table: "COBROS",
                column: "cliCod");

            migrationBuilder.CreateIndex(
                name: "IX_COTIZACIONES_cliCod",
                table: "COTIZACIONES",
                column: "cliCod");

            migrationBuilder.CreateIndex(
                name: "IX_CUENTAS_CORRIENTES_cliCod",
                table: "CUENTAS_CORRIENTES",
                column: "cliCod");

            migrationBuilder.CreateIndex(
                name: "IX_DETALLE_COTIZACIONES_artCod",
                table: "DETALLE_COTIZACIONES",
                column: "artCod");

            migrationBuilder.CreateIndex(
                name: "IX_DETALLE_COTIZACIONES_cotCod",
                table: "DETALLE_COTIZACIONES",
                column: "cotCod");

            migrationBuilder.CreateIndex(
                name: "IX_DETALLE_VENTAS_artCod",
                table: "DETALLE_VENTAS",
                column: "artCod");

            migrationBuilder.CreateIndex(
                name: "IX_DETALLE_VENTAS_venCod",
                table: "DETALLE_VENTAS",
                column: "venCod");

            migrationBuilder.CreateIndex(
                name: "IX_VENTAS_cliCod",
                table: "VENTAS",
                column: "cliCod");

            migrationBuilder.CreateIndex(
                name: "IX_VENTAS_venEstado",
                table: "VENTAS",
                column: "venEstado");

            migrationBuilder.CreateIndex(
                name: "IX_VENTAS_venMetodoPago",
                table: "VENTAS",
                column: "venMetodoPago");

            // Insert initial data for ventaTipoEstado
            migrationBuilder.InsertData(
                table: "ventaTipoEstado",
                columns: new[] { "id", "descripcion" },
                values: new object[,]
                {
                    { 1, "Completada" },
                    { 2, "Pendiente" },
                    { 3, "Cancelada" }
                });

            // Insert initial data for ventaTipoMetodoPagos
            migrationBuilder.InsertData(
                table: "ventaTipoMetodoPagos",
                columns: new[] { "id", "descripcion" },
                values: new object[,]
                {
                    { 1, "Débito" },
                    { 2, "Crédito" },
                    { 3, "Cuenta Corriente" },
                    { 4, "Cheque" },
                    { 5, "Efectivo" }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "COBROS");

            migrationBuilder.DropTable(
                name: "CUENTAS_CORRIENTES");

            migrationBuilder.DropTable(
                name: "DETALLE_COTIZACIONES");

            migrationBuilder.DropTable(
                name: "DETALLE_VENTAS");

            migrationBuilder.DropTable(
                name: "LISTAS");

            migrationBuilder.DropTable(
                name: "COTIZACIONES");

            migrationBuilder.DropTable(
                name: "ARTICULOS");

            migrationBuilder.DropTable(
                name: "VENTAS");

            migrationBuilder.DropTable(
                name: "IVA");

            migrationBuilder.DropTable(
                name: "MARCAS");

            migrationBuilder.DropTable(
                name: "PROVEEDORES");

            migrationBuilder.DropTable(
                name: "CLIENTES");

            migrationBuilder.DropTable(
                name: "ventaTipoEstado");

            migrationBuilder.DropTable(
                name: "ventaTipoMetodoPagos");
        }
    }
}
