namespace SeyahatBackend.Models
{
    public class Place
    {
        public int Id { get; set; }
        public string Isim { get; set; } = string.Empty;
        public string Aciklama { get; set; } = string.Empty;

        // Yerel resim yollarını (assets/images/...) tutacak yeni alan
        public string ImageUrl { get; set; } = string.Empty;

        // Veritabanındaki decimal(9, 6) yapısına daha uygun olması için decimal kullanıyoruz
        public decimal? Enlem { get; set; }
        public decimal? Boylam { get; set; }

        // Şehir bağlantısı
        public int CityId { get; set; } 
    }
}