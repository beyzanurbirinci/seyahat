using Microsoft.AspNetCore.Mvc;
using SeyahatBackend.Models;
using SeyahatBackend.Data; 
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Cors;
using System.Text.RegularExpressions; 
using BCryptNet = BCrypt.Net.BCrypt; 

namespace SeyahatBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [EnableCors("AllowAll")]
    public class AuthController : ControllerBase
    {
        private readonly AppDbContext _context;

        public AuthController(AppDbContext context)
        {
            _context = context;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterRequest request)
        {
            try 
            {
                // 1. Temel Boşluk Kontrolü
                if (string.IsNullOrWhiteSpace(request.Sifre))
                    return BadRequest(new { message = "Şifre alanı boş bırakılamaz." });

                // 2. En az 6 karakter kontrolü
                if (request.Sifre.Length < 6)
                    return BadRequest(new { message = "Şifre en az 6 karakter olmalıdır." });

                // 3. En az bir büyük harf kontrolü
                if (!Regex.IsMatch(request.Sifre, @"[A-Z]"))
                    return BadRequest(new { message = "Şifre en az bir büyük harf içermelidir." });

                // 4. En az bir rakam kontrolü
                if (!Regex.IsMatch(request.Sifre, @"[0-9]"))
                    return BadRequest(new { message = "Şifre en az bir rakam içermelidir." });

                // 5. E-posta mükerrerlik kontrolü
                if (await _context.Users.AnyAsync(u => u.Email == request.Email))
                    return BadRequest(new { message = "Bu e-posta adresi zaten kullanımda." });

                // Eğer tüm kontrolleri geçerse yeni kullanıcıyı oluştur ve şifreyi hashle
                var user = new User
                {
                    AdSoyad = request.AdSoyad,
                    Email = request.Email,
                    Sifre = BCryptNet.HashPassword(request.Sifre) 
                };

                _context.Users.Add(user);
                await _context.SaveChangesAsync();

                return Ok(new { message = "Kayıt başarılı." });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "Sunucu hatası: " + ex.Message });
            }
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == request.Email);
            
            if (user == null || !BCryptNet.Verify(request.Sifre, user.Sifre))
                return Unauthorized(new { message = "Geçersiz e-posta veya şifre." });

            return Ok(new { Token = "SeyahatApp_Secure_Token_" + user?.Id, AdSoyad = user?.AdSoyad, Email = user?.Email });
        }
    }
}