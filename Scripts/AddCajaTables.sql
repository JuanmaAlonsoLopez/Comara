-- Script para agregar tablas del módulo de Caja
-- Ejecutar este script manualmente en la base de datos PostgreSQL

-- Tabla tipoMovimientoCaja
CREATE TABLE IF NOT EXISTS "tipoMovimientoCaja" (
    id SERIAL PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL,
    tipo VARCHAR(10) NOT NULL -- 'INGRESO' o 'EGRESO'
);

-- Datos iniciales para tipoMovimientoCaja
INSERT INTO "tipoMovimientoCaja" (descripcion, tipo) VALUES
('Venta en Efectivo', 'INGRESO'),
('Depósito Inicial', 'INGRESO'),
('Otro Ingreso', 'INGRESO'),
('Pago a Proveedor', 'EGRESO'),
('Gasto Operativo', 'EGRESO'),
('Retiro Personal', 'EGRESO'),
('Depositar Cheque en Banco', 'EGRESO'),
('Entregar Cheque a Tercero', 'EGRESO'),
('Otro Egreso', 'EGRESO')
ON CONFLICT DO NOTHING;

-- Tabla CHEQUES
CREATE TABLE IF NOT EXISTS "CHEQUES" (
    "chqCod" SERIAL PRIMARY KEY,
    "pagCod" INTEGER NOT NULL,
    "chqNumero" VARCHAR(50) NOT NULL,
    "chqBanco" VARCHAR(100) NOT NULL,
    "chqFechaEmision" DATE NOT NULL,
    "chqFechaCobro" DATE NOT NULL,
    "chqMonto" REAL NOT NULL,
    "chqLibrador" VARCHAR(100) NOT NULL,
    "chqCUIT" VARCHAR(20),
    "chqEnCaja" BOOLEAN NOT NULL DEFAULT TRUE,
    "chqFechaSalida" TIMESTAMP,
    "chqObservaciones" VARCHAR(255),
    CONSTRAINT "FK_CHEQUES_PAGOS" FOREIGN KEY ("pagCod")
        REFERENCES "PAGOS"("pagCod") ON DELETE RESTRICT
);

-- Tabla MOVIMIENTOS_CAJA
CREATE TABLE IF NOT EXISTS "MOVIMIENTOS_CAJA" (
    "movCod" SERIAL PRIMARY KEY,
    "movFecha" DATE NOT NULL,
    "movTipo" INTEGER NOT NULL,
    "movMetodoPago" INTEGER NOT NULL,
    "movMonto" REAL NOT NULL,
    "movDescripcion" VARCHAR(255),
    "chqCod" INTEGER,
    CONSTRAINT "FK_MOVIMIENTOS_CAJA_tipoMovimientoCaja" FOREIGN KEY ("movTipo")
        REFERENCES "tipoMovimientoCaja"(id) ON DELETE RESTRICT,
    CONSTRAINT "FK_MOVIMIENTOS_CAJA_ventaTipoMetodoPagos" FOREIGN KEY ("movMetodoPago")
        REFERENCES "ventaTipoMetodoPagos"(id) ON DELETE RESTRICT,
    CONSTRAINT "FK_MOVIMIENTOS_CAJA_CHEQUES" FOREIGN KEY ("chqCod")
        REFERENCES "CHEQUES"("chqCod") ON DELETE SET NULL
);

-- Índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS "IX_CHEQUES_pagCod" ON "CHEQUES"("pagCod");
CREATE INDEX IF NOT EXISTS "IX_CHEQUES_chqEnCaja" ON "CHEQUES"("chqEnCaja");
CREATE INDEX IF NOT EXISTS "IX_CHEQUES_chqFechaCobro" ON "CHEQUES"("chqFechaCobro");

CREATE INDEX IF NOT EXISTS "IX_MOVIMIENTOS_CAJA_movFecha" ON "MOVIMIENTOS_CAJA"("movFecha" DESC);
CREATE INDEX IF NOT EXISTS "IX_MOVIMIENTOS_CAJA_movTipo" ON "MOVIMIENTOS_CAJA"("movTipo");
CREATE INDEX IF NOT EXISTS "IX_MOVIMIENTOS_CAJA_movMetodoPago" ON "MOVIMIENTOS_CAJA"("movMetodoPago");

-- Comentarios para documentación
COMMENT ON TABLE "CHEQUES" IS 'Cheques recibidos como pago, con seguimiento de estado en caja';
COMMENT ON TABLE "MOVIMIENTOS_CAJA" IS 'Movimientos de ingresos y egresos de caja (efectivo y cheques)';
COMMENT ON TABLE "tipoMovimientoCaja" IS 'Tipos de movimientos de caja (categorías)';

COMMENT ON COLUMN "CHEQUES"."chqEnCaja" IS 'Indica si el cheque está físicamente en caja';
COMMENT ON COLUMN "CHEQUES"."chqFechaSalida" IS 'Fecha en que el cheque salió de caja (depositado, entregado, etc.)';
