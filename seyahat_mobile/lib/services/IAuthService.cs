using SeyahatBackend.Models;

namespace SeyahatBackend.Services
{
    public interface IAuthService
    {
        string HashPassword(string password);
        bool VerifyPassword(string password, string hashedPassword);
        string GenerateToken(User user);
    }
}