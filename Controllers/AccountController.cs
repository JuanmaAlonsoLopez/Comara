using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using comara.Models.ViewModels;
using UserAuthService = comara.Services.IAuthenticationService;

namespace comara.Controllers
{
    public class AccountController : Controller
    {
        private readonly UserAuthService _authService;
        private readonly ILogger<AccountController> _logger;

        public AccountController(
            UserAuthService authService,
            ILogger<AccountController> logger)
        {
            _authService = authService;
            _logger = logger;
        }

        // GET: Account/Login
        [AllowAnonymous]
        public IActionResult Login(string? returnUrl = null)
        {
            // Si ya está autenticado, redirigir a Home
            if (User.Identity?.IsAuthenticated == true)
            {
                return RedirectToAction("Index", "Home");
            }

            ViewData["ReturnUrl"] = returnUrl;
            return View();
        }

        // POST: Account/Login
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            // Obtener IP del cliente para rate limiting
            var clientIp = GetClientIpAddress();

            // Usar metodo con rate limiting
            var (usuario, errorMessage) = await _authService.ValidateUserWithRateLimitAsync(
                model.Username, model.Password, clientIp);

            if (usuario == null)
            {
                ModelState.AddModelError(string.Empty, errorMessage ?? "Usuario o contraseña incorrectos");
                _logger.LogWarning("Failed login attempt for username: {Username} from IP: {IP}",
                    model.Username, clientIp);
                return View(model);
            }

            // Crear claims para el usuario
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.Name, usuario.UsuUsername),
                new Claim(ClaimTypes.NameIdentifier, usuario.Id.ToString()),
                new Claim("FullName", usuario.UsuNombreCompleto),
                new Claim("Role", usuario.UsuRole)
            };

            if (!string.IsNullOrEmpty(usuario.UsuEmail))
            {
                claims.Add(new Claim(ClaimTypes.Email, usuario.UsuEmail));
            }

            var claimsIdentity = new ClaimsIdentity(claims, "CookieAuth");
            var claimsPrincipal = new ClaimsPrincipal(claimsIdentity);

            var authProperties = new AuthenticationProperties
            {
                IsPersistent = model.RememberMe,
                ExpiresUtc = model.RememberMe
                    ? DateTimeOffset.UtcNow.AddDays(30)
                    : DateTimeOffset.UtcNow.AddHours(8)
            };

            await HttpContext.SignInAsync("CookieAuth", claimsPrincipal, authProperties);

            // Actualizar último login
            await _authService.UpdateLastLoginAsync(usuario.Id);

            _logger.LogInformation("User {Username} logged in successfully", usuario.UsuUsername);

            // Redirigir al returnUrl si es válido, sino a Home
            if (!string.IsNullOrEmpty(model.ReturnUrl) && Url.IsLocalUrl(model.ReturnUrl))
            {
                return Redirect(model.ReturnUrl);
            }

            return RedirectToAction("Index", "Home");
        }

        // POST: Account/Logout
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize]
        public async Task<IActionResult> Logout()
        {
            var username = User.Identity?.Name;
            await HttpContext.SignOutAsync("CookieAuth");

            _logger.LogInformation("User {Username} logged out", username);

            return RedirectToAction("Login", "Account");
        }

        // GET: Account/ChangePassword
        [Authorize]
        public IActionResult ChangePassword()
        {
            return View();
        }

        // POST: Account/ChangePassword
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize]
        public async Task<IActionResult> ChangePassword(ChangePasswordViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

            var success = await _authService.ChangePasswordAsync(
                userId,
                model.CurrentPassword,
                model.NewPassword);

            if (!success)
            {
                ModelState.AddModelError(string.Empty, "La contraseña actual es incorrecta");
                return View(model);
            }

            TempData["SuccessMessage"] = "Contraseña cambiada exitosamente";
            _logger.LogInformation("User {Username} changed password", User.Identity?.Name);

            return RedirectToAction("Index", "Home");
        }

        // GET: Account/AccessDenied
        [AllowAnonymous]
        public IActionResult AccessDenied()
        {
            return View();
        }

        /// <summary>
        /// Obtiene la direccion IP del cliente, considerando proxies
        /// </summary>
        private string? GetClientIpAddress()
        {
            // Verificar X-Forwarded-For primero (para proxies/load balancers)
            var forwardedFor = HttpContext.Request.Headers["X-Forwarded-For"].FirstOrDefault();
            if (!string.IsNullOrEmpty(forwardedFor))
            {
                // Tomar la primera IP (la del cliente original)
                return forwardedFor.Split(',')[0].Trim();
            }

            // Fallback a la conexion directa
            return HttpContext.Connection.RemoteIpAddress?.ToString();
        }
    }
}
