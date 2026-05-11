namespace SeyahatBackend.Models;

public class Region
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? ImageUrl { get; set; }
    
    // Navigasyon özelliği: Bir bölgenin birden fazla şehri olabilir
    public ICollection<City> Cities { get; set; } = new List<City>();
}