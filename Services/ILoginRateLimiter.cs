namespace comara.Services
{
    /// <summary>
    /// Servicio de rate limiting para proteger contra ataques de fuerza bruta en login
    /// </summary>
    public interface ILoginRateLimiter
    {
        /// <summary>
        /// Verifica si un identificador (IP o username) esta bloqueado
        /// </summary>
        bool IsBlocked(string identifier);

        /// <summary>
        /// Registra un intento fallido de login
        /// </summary>
        void RecordFailedAttempt(string identifier);

        /// <summary>
        /// Limpia los intentos fallidos despues de un login exitoso
        /// </summary>
        void ClearAttempts(string identifier);

        /// <summary>
        /// Obtiene el tiempo restante de bloqueo en segundos
        /// </summary>
        int GetRemainingBlockTime(string identifier);

        /// <summary>
        /// Obtiene el numero de intentos fallidos
        /// </summary>
        int GetFailedAttemptCount(string identifier);
    }
}
