using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using comara.Data;
using comara.Models;
using comara.Models.ViewModels;
using comara.Services;
using System.Security.Claims;

namespace comara.Controllers
{
    [Authorize(Policy = "AdminOnly")]
    public class UsuariosController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly IPasswordService _passwordService;
        private readonly ILogger<UsuariosController> _logger;

        public UsuariosController(
            ApplicationDbContext context,
            IPasswordService passwordService,
            ILogger<UsuariosController> logger)
        {
            _context = context;
            _passwordService = passwordService;
            _logger = logger;
        }

        // GET: Usuarios
        public async Task<IActionResult> Index()
        {
            var usuarios = await _context.Usuarios
                .OrderByDescending(u => u.UsuFechaCreacion)
                .ToListAsync();
            return View(usuarios);
        }

        // GET: Usuarios/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var usuario = await _context.Usuarios
                .Include(u => u.CreadoPor)
                .FirstOrDefaultAsync(m => m.Id == id);

            if (usuario == null)
            {
                return NotFound();
            }

            return View(usuario);
        }

        // GET: Usuarios/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: Usuarios/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(CreateUsuarioViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            // Verificar si el username ya existe
            if (await _context.Usuarios.AnyAsync(u => u.UsuUsername == model.UsuUsername))
            {
                ModelState.AddModelError("UsuUsername", "Este nombre de usuario ya existe");
                return View(model);
            }

            var currentUserId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

            var usuario = new Usuario
            {
                UsuUsername = model.UsuUsername,
                UsuNombreCompleto = model.UsuNombreCompleto,
                UsuEmail = model.UsuEmail,
                UsuRole = model.UsuRole,
                UsuActivo = model.UsuActivo,
                UsuPasswordHash = _passwordService.HashPassword(model.Password),
                UsuFechaCreacion = DateTime.UtcNow,
                UsuCreadoPor = currentUserId
            };

            _context.Usuarios.Add(usuario);
            await _context.SaveChangesAsync();

            TempData["SuccessMessage"] = $"Usuario '{usuario.UsuUsername}' creado exitosamente";
            _logger.LogInformation("User '{Username}' created by {CreatorUsername}",
                usuario.UsuUsername, User.Identity?.Name);

            return RedirectToAction(nameof(Index));
        }

        // GET: Usuarios/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var usuario = await _context.Usuarios.FindAsync(id);
            if (usuario == null)
            {
                return NotFound();
            }

            var model = new EditUsuarioViewModel
            {
                Id = usuario.Id,
                UsuUsername = usuario.UsuUsername,
                UsuNombreCompleto = usuario.UsuNombreCompleto,
                UsuEmail = usuario.UsuEmail,
                UsuRole = usuario.UsuRole,
                UsuActivo = usuario.UsuActivo
            };

            return View(model);
        }

        // POST: Usuarios/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, EditUsuarioViewModel model)
        {
            if (id != model.Id)
            {
                return NotFound();
            }

            if (!ModelState.IsValid)
            {
                return View(model);
            }

            // Verificar si el username ya existe (excepto para este usuario)
            if (await _context.Usuarios.AnyAsync(u => u.UsuUsername == model.UsuUsername && u.Id != id))
            {
                ModelState.AddModelError("UsuUsername", "Este nombre de usuario ya existe");
                return View(model);
            }

            try
            {
                var usuario = await _context.Usuarios.FindAsync(id);
                if (usuario == null)
                {
                    return NotFound();
                }

                var currentUserId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

                usuario.UsuUsername = model.UsuUsername;
                usuario.UsuNombreCompleto = model.UsuNombreCompleto;
                usuario.UsuEmail = model.UsuEmail;
                usuario.UsuRole = model.UsuRole;
                usuario.UsuActivo = model.UsuActivo;
                usuario.UsuModificadoPor = currentUserId;
                usuario.UsuFechaModificacion = DateTime.UtcNow;

                await _context.SaveChangesAsync();

                TempData["SuccessMessage"] = $"Usuario '{usuario.UsuUsername}' actualizado exitosamente";
                _logger.LogInformation("User '{Username}' updated by {EditorUsername}",
                    usuario.UsuUsername, User.Identity?.Name);

                return RedirectToAction(nameof(Index));
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UsuarioExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }
        }

        // GET: Usuarios/ResetPassword/5
        public async Task<IActionResult> ResetPassword(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var usuario = await _context.Usuarios.FindAsync(id);
            if (usuario == null)
            {
                return NotFound();
            }

            var model = new ResetPasswordViewModel
            {
                UsuarioId = usuario.Id,
                Username = usuario.UsuUsername
            };

            return View(model);
        }

        // POST: Usuarios/ResetPassword/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ResetPassword(ResetPasswordViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var usuario = await _context.Usuarios.FindAsync(model.UsuarioId);
            if (usuario == null)
            {
                return NotFound();
            }

            var currentUserId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

            usuario.UsuPasswordHash = _passwordService.HashPassword(model.NewPassword);
            usuario.UsuModificadoPor = currentUserId;
            usuario.UsuFechaModificacion = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            TempData["SuccessMessage"] = $"Contraseña del usuario '{usuario.UsuUsername}' restablecida exitosamente";
            _logger.LogInformation("Password reset for user '{Username}' by {AdminUsername}",
                usuario.UsuUsername, User.Identity?.Name);

            return RedirectToAction(nameof(Index));
        }

        // GET: Usuarios/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var usuario = await _context.Usuarios
                .FirstOrDefaultAsync(m => m.Id == id);

            if (usuario == null)
            {
                return NotFound();
            }

            // Prevent deleting yourself
            var currentUserId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
            if (usuario.Id == currentUserId)
            {
                TempData["ErrorMessage"] = "No puedes eliminar tu propio usuario";
                return RedirectToAction(nameof(Index));
            }

            return View(usuario);
        }

        // POST: Usuarios/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var currentUserId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

            // Prevent deleting yourself
            if (id == currentUserId)
            {
                TempData["ErrorMessage"] = "No puedes eliminar tu propio usuario";
                return RedirectToAction(nameof(Index));
            }

            var usuario = await _context.Usuarios.FindAsync(id);
            if (usuario != null)
            {
                // Soft delete: just deactivate instead of removing
                usuario.UsuActivo = false;
                usuario.UsuModificadoPor = currentUserId;
                usuario.UsuFechaModificacion = DateTime.UtcNow;

                await _context.SaveChangesAsync();

                TempData["SuccessMessage"] = $"Usuario '{usuario.UsuUsername}' desactivado exitosamente";
                _logger.LogInformation("User '{Username}' deactivated by {AdminUsername}",
                    usuario.UsuUsername, User.Identity?.Name);
            }

            return RedirectToAction(nameof(Index));
        }

        private bool UsuarioExists(int id)
        {
            return _context.Usuarios.Any(e => e.Id == id);
        }
    }
}
