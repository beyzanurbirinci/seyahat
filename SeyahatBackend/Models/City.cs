namespace SeyahatBackend.Models;

public class City
{
    public int Id { get; set; }
    public int RegionId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? ImageUrl { get; set; }

    // Navigasyon özellikleri
    public Region? Region { get; set; }
    public ICollection<Place> Places { get; set; } = new List<Place>();
}