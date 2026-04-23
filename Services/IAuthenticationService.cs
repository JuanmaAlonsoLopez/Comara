using comara.Models;

namespace comara.Services
{
    public interface IAuthenticationService
    {
        Task<Usuario?> ValidateUserAsync(string username, string password);

        /// <summary>
        /// Valida usuario con proteccion de rate limiting.
        /// Retorna el usuario y un mensaje de error si falla.
        /// </summary>
        Task<(Usuario? Usuario, string? ErrorMessage)> ValidateUserWithRateLimitAsync(
            string username, string password, string? ipAddress);

        Task<bool> UpdateLastLoginAsync(int usuarioId);
        Task<bool> ChangePasswordAsync(int usuarioId, string currentPassword, string newPassword);
        Task<Usuario?> GetUserByIdAsync(int usuarioId);
        Task<Usuario?> GetUserByUsernameAsync(string username);
    }
}
