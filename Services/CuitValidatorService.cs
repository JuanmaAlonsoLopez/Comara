namespace comara.Services
{
    /// <summary>
    /// Servicio para validar CUIT/CUIL argentinos usando el algoritmo mod 11.
    /// Los CUIT válidos tienen 11 dígitos y pasan la validación del dígito verificador.
    /// </summary>
    public static class CuitValidatorService
    {
        /// <summary>
        /// Valida si un CUIT/CUIL es válido según el algoritmo de AFIP.
        /// </summary>
        /// <param name="cuit">CUIT con o sin guiones (ej: 20-40937847-2 o 20409378472)</param>
        /// <returns>True si el CUIT es válido</returns>
        public static bool ValidarCuit(string? cuit)
        {
            if (string.IsNullOrWhiteSpace(cuit))
                return false;

            // Limpiar el CUIT: remover guiones y espacios
            cuit = cuit.Replace("-", "").Replace(" ", "").Trim();

            // Debe tener exactamente 11 dígitos
            if (cuit.Length != 11)
                return false;

            // Debe ser numérico
            if (!long.TryParse(cuit, out _))
                return false;

            // Validar tipo (primeros 2 dígitos)
            var tipo = cuit.Substring(0, 2);
            var tiposValidos = new[] { "20", "23", "24", "27", "30", "33", "34" };
            if (!tiposValidos.Contains(tipo))
                return false;

            // Algoritmo de validación mod 11
            // Multiplicadores fijos de AFIP
            int[] multiplicadores = { 5, 4, 3, 2, 7, 6, 5, 4, 3, 2 };
            int suma = 0;

            for (int i = 0; i < 10; i++)
            {
                suma += int.Parse(cuit[i].ToString()) * multiplicadores[i];
            }

            int resto = suma % 11;
            int digitoVerificadorCalculado;

            if (resto == 0)
                digitoVerificadorCalculado = 0;
            else if (resto == 1)
                digitoVerificadorCalculado = 9; // Caso especial: si resto es 1, DV es 9 (para sexo M/F ajustado)
            else
                digitoVerificadorCalculado = 11 - resto;

            int digitoVerificadorReal = int.Parse(cuit[10].ToString());

            return digitoVerificadorCalculado == digitoVerificadorReal;
        }

        /// <summary>
        /// Valida el CUIT y retorna un mensaje de error si no es válido.
        /// </summary>
        /// <param name="cuit">CUIT a validar</param>
        /// <returns>Null si es válido, mensaje de error si no lo es</returns>
        public static string? ObtenerErrorValidacion(string? cuit)
        {
            if (string.IsNullOrWhiteSpace(cuit))
                return "El CUIT no puede estar vacío";

            var cuitLimpio = cuit.Replace("-", "").Replace(" ", "").Trim();

            if (cuitLimpio.Length != 11)
                return $"El CUIT debe tener 11 dígitos. El CUIT '{cuit}' tiene {cuitLimpio.Length} dígitos.";

            if (!long.TryParse(cuitLimpio, out _))
                return $"El CUIT '{cuit}' contiene caracteres no numéricos.";

            var tipo = cuitLimpio.Substring(0, 2);
            var tiposValidos = new[] { "20", "23", "24", "27", "30", "33", "34" };
            if (!tiposValidos.Contains(tipo))
                return $"El tipo de CUIT '{tipo}' no es válido. Los tipos válidos son: 20, 23, 24, 27, 30, 33, 34.";

            if (!ValidarCuit(cuit))
                return $"El CUIT '{cuit}' tiene un dígito verificador inválido. Verifique que esté correctamente escrito.";

            return null; // Válido
        }

        /// <summary>
        /// Formatea un CUIT a formato XX-XXXXXXXX-X
        /// </summary>
        public static string FormatearCuit(string? cuit)
        {
            if (string.IsNullOrWhiteSpace(cuit))
                return string.Empty;

            var cuitLimpio = cuit.Replace("-", "").Replace(" ", "").Trim();

            if (cuitLimpio.Length != 11)
                return cuit;

            return $"{cuitLimpio.Substring(0, 2)}-{cuitLimpio.Substring(2, 8)}-{cuitLimpio.Substring(10, 1)}";
        }
    }
}
