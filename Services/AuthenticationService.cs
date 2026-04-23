using comara.Data;
using comara.Models;
using Microsoft.EntityFrameworkCore;

namespace comara.Services
{
    public class AuthenticationService : IAuthenticationService
    {
        private readonly ApplicationDbContext _context;
        private readonly IPasswordService _passwordService;
        private readonly ILoginRateLimiter _rateLimiter;
        private readonly ILogger<AuthenticationService> _logger;

        public AuthenticationService(
            ApplicationDbContext context,
            IPasswordService passwordService,
            ILoginRateLimiter rateLimiter,
            ILogger<AuthenticationService> logger)
        {
            _context = context;
            _passwordService = passwordService;
            _rateLimiter = rateLimiter;
            _logger = logger;
        }

        public async Task<Usuario?> ValidateUserAsync(string username, string password)
        {
            return await ValidateUserAsync(username, password, null);
        }

        public async Task<(Usuario? Usuario, string? ErrorMessage)> ValidateUserWithRateLimitAsync(
            string username, string password, string? ipAddress)
        {
            // Verificar rate limit por IP y por usuario
            var identifiers = new List<string> { username };
            if (!string.IsNullOrEmpty(ipAddress))
            {
                identifiers.Add(ipAddress);
            }

            foreach (var identifier in identifiers)
            {
                if (_rateLimiter.IsBlocked(identifier))
                {
                    var remainingTime = _rateLimiter.GetRemainingBlockTime(identifier);
                    var minutes = remainingTime / 60;
                    var seconds = remainingTime % 60;

                    _logger.LogWarning(
                        "Login bloqueado para '{Identifier}'. Tiempo restante: {Minutes}m {Seconds}s",
                        identifier, minutes, seconds);

                    return (null, $"Demasiados intentos fallidos. Intente nuevamente en {minutes} minutos y {seconds} segundos.");
                }
            }

            try
            {
                var usuario = await _context.Usuarios
                    .FirstOrDefaultAsync(u => u.UsuUsername == username && u.UsuActivo);

                if (usuario == null)
                {
                    _logger.LogWarning("Login attempt failed: User '{Username}' not found or inactive", username);
                    RecordFailedAttempts(identifiers);
                    return (null, "Usuario o contraseña incorrectos");
                }

                bool isValidPassword = _passwordService.VerifyPassword(password, usuario.UsuPasswordHash);

                if (!isValidPassword)
                {
                    _logger.LogWarning("Login attempt failed: Invalid password for user '{Username}'", username);
                    RecordFailedAttempts(identifiers);
                    return (null, "Usuario o contraseña incorrectos");
                }

                // Login exitoso - limpiar intentos fallidos
                foreach (var identifier in identifiers)
                {
                    _rateLimiter.ClearAttempts(identifier);
                }

                _logger.LogInformation("User '{Username}' validated successfully", username);
                return (usuario, null);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error validating user '{Username}'", username);
                return (null, "Error interno al validar usuario");
            }
        }

        private async Task<Usuario?> ValidateUserAsync(string username, string password, string? ipAddress)
        {
            var (usuario, _) = await ValidateUserWithRateLimitAsync(username, password, ipAddress);
            return usuario;
        }

        private void RecordFailedAttempts(List<string> identifiers)
        {
            foreach (var identifier in identifiers)
            {
                _rateLimiter.RecordFailedAttempt(identifier);
            }
        }

        public async Task<bool> UpdateLastLoginAsync(int usuarioId)
        {
            try
            {
                var usuario = await _context.Usuarios.FindAsync(usuarioId);
                if (usuario == null)
                    return false;

                usuario.UsuUltimoLogin = DateTime.UtcNow;
                await _context.SaveChangesAsync();

                _logger.LogInformation("Updated last login for user ID {UsuarioId}", usuarioId);
                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating last login for user ID {UsuarioId}", usuarioId);
                return false;
            }
        }

        public async Task<bool> ChangePasswordAsync(int usuarioId, string currentPassword, string newPassword)
        {
            try
            {
                var usuario = await _context.Usuarios.FindAsync(usuarioId);
                if (usuario == null)
                {
                    _logger.LogWarning("Password change failed: User ID {UsuarioId} not found", usuarioId);
                    return false;
                }

                bool isCurrentPasswordValid = _passwordService.VerifyPassword(currentPassword, usuario.UsuPasswordHash);
                if (!isCurrentPasswordValid)
                {
                    _logger.LogWarning("Password change failed: Invalid current password for user '{Username}'", usuario.UsuUsername);
                    return false;
                }

                usuario.UsuPasswordHash = _passwordService.HashPassword(newPassword);
                usuario.UsuFechaModificacion = DateTime.UtcNow;
                usuario.UsuModificadoPor = usuarioId;

                await _context.SaveChangesAsync();

                _logger.LogInformation("Password changed successfully for user '{Username}'", usuario.UsuUsername);
                return true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error changing password for user ID {UsuarioId}", usuarioId);
                return false;
            }
        }

        public async Task<Usuario?> GetUserByIdAsync(int usuarioId)
        {
            return await _context.Usuarios.FindAsync(usuarioId);
        }

        public async Task<Usuario?> GetUserByUsernameAsync(string username)
        {
            return await _context.Usuarios
                .FirstOrDefaultAsync(u => u.UsuUsername == username);
        }
    }
}
