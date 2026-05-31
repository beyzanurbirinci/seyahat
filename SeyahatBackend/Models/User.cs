namespace SeyahatBackend.Models
{
    // Veritabanı tablonu temsil eden ana model
    public class User
    {
        public int Id { get; set; }
        public string AdSoyad { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Sifre { get; set; } = string.Empty;
    }

    // Kayıt olurken Flutter'dan gelecek verileri karşılayan sınıf
    public class RegisterRequest
    {
        public string AdSoyad { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Sifre { get; set; } = string.Empty;
    }

    // Giriş yaparken Flutter'dan gelecek verileri karşılayan sınıf
    public class LoginRequest
    {
        public string Email { get; set; } = string.Empty;
        public string Sifre { get; set; } = string.Empty;
    }
}