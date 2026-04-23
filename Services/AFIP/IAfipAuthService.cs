using comara.Models.AFIP;

namespace comara.Services.AFIP
{
    public interface IAfipAuthService
    {
        Task<AfipAuthToken> GetAuthTokenAsync(string servicio = "wsfe");
        Task<bool> ValidateTokenAsync();
    }
}
