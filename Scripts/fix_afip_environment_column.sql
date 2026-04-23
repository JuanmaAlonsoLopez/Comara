-- Script para expandir el campo environment en afip_auth_tickets
-- De VARCHAR(10) a VARCHAR(20) para soportar "Homologacion" y "Produccion"

ALTER TABLE afip_auth_tickets
ALTER COLUMN environment TYPE VARCHAR(20);

-- Verificar el cambio
SELECT column_name, data_type, character_maximum_length
FROM information_schema.columns
WHERE table_name = 'afip_auth_tickets'
  AND column_name = 'environment';
