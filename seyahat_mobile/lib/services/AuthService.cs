using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using SeyahatBackend.Models;
using BCryptNet = BCrypt.Net.BCrypt;

namespace SeyahatBackend.Services
{
    public class AuthService : IAuthService
    {
        // Şifreyi güvenli bir şekilde hash'ler
        public string HashPassword(string password)
        {
            return BCryptNet.HashPassword(password);
        }

        // Girilen şifre ile veritabanındaki hash'i karşılaştırır
        public bool VerifyPassword(string password, string hashedPassword)
        {
            try
            {
                return BCryptNet.VerifyPassword(password, hashedPassword);
            }
            catch
            {
                return false;
            }
        }

        // Flutter tarafı için geçici/basit bir JWT Token üretir
        public string GenerateToken(User user)
        {
            // Şimdilik sorunsuz ilerlemek adına basit bir token string'i dönüyoruz
            // İleride burayı tam JWT standartlarına (SecretKey vb.) bağlayabilirsin
            return "SeyahatApp_Secure_Token_User_" + user.Id;
        }
    }
}