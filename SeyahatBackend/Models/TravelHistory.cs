namespace SeyahatBackend.Models
{
    public class TravelHistory
    {
        public int ID { get; set; }
        public int KullaniciID { get; set; }
        public int MekanID { get; set; }
        public int Puan { get; set; }
        public required string Yorum { get; set; }
        public DateTime Tarih { get; set; }
    }
}