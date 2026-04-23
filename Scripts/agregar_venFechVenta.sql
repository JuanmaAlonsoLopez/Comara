-- Script para agregar el campo venFechVenta a la tabla VENTAS
-- Este campo registra la fecha en que se factura o se genera el presupuesto de una venta
-- Ejecutar en pgAdmin4

-- Agregar la columna venFechVenta (permite nulos porque las ventas existentes no tienen esta fecha)
ALTER TABLE public."VENTAS"
ADD COLUMN "venFechVenta" timestamp without time zone NULL;

-- Agregar comentario para documentar el campo
COMMENT ON COLUMN public."VENTAS"."venFechVenta" IS 'Fecha en que se facturó o generó el presupuesto de la venta';

-- Verificar que la columna se agregó correctamente
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'VENTAS' AND column_name = 'venFechVenta';
