namespace SeyahatBackend.Models
{
    public class Place
    {
        public int Id { get; set; }
        public string Isim { get; set; } = string.Empty;
        public string Aciklama { get; set; } = string.Empty;
        
        // Yeni hiyerarşiye göre Şehir bağlantısı
        public int CityId { get; set; } 
        
        // Veritabanındaki Enlem/Boylam sütunları için (Opsiyonel)
        public double? Enlem { get; set; }
        public double? Boylam { get; set; }
    }
}