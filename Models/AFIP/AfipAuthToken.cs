namespace comara.Models.AFIP
{
    public class AfipAuthToken
    {
        public string Token { get; set; } = string.Empty;
        public string Sign { get; set; } = string.Empty;
        public DateTime ExpirationTime { get; set; }

        /// <summary>
        /// Verifica si el token es válido (tiene datos y no ha expirado)
        /// C3: Usar DateTime.UtcNow consistentemente en todo el sistema
        /// </summary>
        public bool IsValid()
        {
            return !string.IsNullOrEmpty(Token)
                   && !string.IsNullOrEmpty(Sign)
                   && ExpirationTime > DateTime.UtcNow.AddMinutes(5);
        }
    }
}
