using System.Collections.Concurrent;

namespace comara.Services
{
    /// <summary>
    /// Implementacion en memoria del rate limiter para login.
    /// Protege contra ataques de fuerza bruta limitando intentos fallidos.
    /// </summary>
    public class LoginRateLimiter : ILoginRateLimiter
    {
        private readonly ConcurrentDictionary<string, LoginAttemptInfo> _attempts = new();
        private readonly ILogger<LoginRateLimiter> _logger;

        // Configuracion
        private const int MaxFailedAttempts = 5;
        private const int BlockDurationMinutes = 15;
        private const int AttemptWindowMinutes = 30;

        public LoginRateLimiter(ILogger<LoginRateLimiter> logger)
        {
            _logger = logger;
        }

        public bool IsBlocked(string identifier)
        {
            if (string.IsNullOrEmpty(identifier))
                return false;

            var key = NormalizeKey(identifier);

            if (!_attempts.TryGetValue(key, out var info))
                return false;

            // Limpiar si el bloqueo ya expiro
            if (info.BlockedUntil.HasValue && info.BlockedUntil.Value <= DateTime.UtcNow)
            {
                ClearAttempts(identifier);
                return false;
            }

            return info.BlockedUntil.HasValue && info.BlockedUntil.Value > DateTime.UtcNow;
        }

        public void RecordFailedAttempt(string identifier)
        {
            if (string.IsNullOrEmpty(identifier))
                return;

            var key = NormalizeKey(identifier);
            var now = DateTime.UtcNow;

            _attempts.AddOrUpdate(key,
                // Agregar nuevo
                _ => new LoginAttemptInfo
                {
                    FailedAttempts = 1,
                    FirstAttempt = now,
                    LastAttempt = now
                },
                // Actualizar existente
                (_, existing) =>
                {
                    // Si la ventana de tiempo expiro, reiniciar contador
                    if (existing.FirstAttempt.AddMinutes(AttemptWindowMinutes) < now)
                    {
                        return new LoginAttemptInfo
                        {
                            FailedAttempts = 1,
                            FirstAttempt = now,
                            LastAttempt = now
                        };
                    }

                    existing.FailedAttempts++;
                    existing.LastAttempt = now;

                    // Si alcanzo el limite, bloquear
                    if (existing.FailedAttempts >= MaxFailedAttempts)
                    {
                        existing.BlockedUntil = now.AddMinutes(BlockDurationMinutes);
                        _logger.LogWarning(
                            "Rate limit alcanzado para '{Identifier}'. Bloqueado hasta {BlockedUntil}",
                            identifier, existing.BlockedUntil);
                    }

                    return existing;
                });

            var currentInfo = _attempts[key];
            _logger.LogDebug(
                "Intento fallido #{Count} para '{Identifier}'",
                currentInfo.FailedAttempts, identifier);
        }

        public void ClearAttempts(string identifier)
        {
            if (string.IsNullOrEmpty(identifier))
                return;

            var key = NormalizeKey(identifier);
            _attempts.TryRemove(key, out _);
        }

        public int GetRemainingBlockTime(string identifier)
        {
            if (string.IsNullOrEmpty(identifier))
                return 0;

            var key = NormalizeKey(identifier);

            if (!_attempts.TryGetValue(key, out var info))
                return 0;

            if (!info.BlockedUntil.HasValue)
                return 0;

            var remaining = (info.BlockedUntil.Value - DateTime.UtcNow).TotalSeconds;
            return remaining > 0 ? (int)Math.Ceiling(remaining) : 0;
        }

        public int GetFailedAttemptCount(string identifier)
        {
            if (string.IsNullOrEmpty(identifier))
                return 0;

            var key = NormalizeKey(identifier);

            if (!_attempts.TryGetValue(key, out var info))
                return 0;

            return info.FailedAttempts;
        }

        private static string NormalizeKey(string identifier)
        {
            return identifier.ToLowerInvariant().Trim();
        }

        private class LoginAttemptInfo
        {
            public int FailedAttempts { get; set; }
            public DateTime FirstAttempt { get; set; }
            public DateTime LastAttempt { get; set; }
            public DateTime? BlockedUntil { get; set; }
        }
    }
}
