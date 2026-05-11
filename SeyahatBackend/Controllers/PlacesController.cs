using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SeyahatBackend.Data;
using SeyahatBackend.Models;

namespace SeyahatBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PlacesController : ControllerBase
    {
        private readonly AppDbContext _context;

        public PlacesController(AppDbContext context)
        {
            _context = context;
        }

        // 1. Tüm Bölgeleri Getir
        // GET: api/Places/regions
        [HttpGet("regions")]
        public async Task<ActionResult<IEnumerable<Region>>> GetRegions()
        {
            var regions = await _context.Regions.ToListAsync();
            return Ok(regions); // 200 OK ile listeyi dön
        }

        // 2. Seçilen Bölgedeki Şehirleri Getir
        // GET: api/Places/cities/2
        [HttpGet("cities/{regionId}")]
        public async Task<ActionResult<IEnumerable<City>>> GetCities(int regionId)
        {
            var cities = await _context.Cities
                .Where(c => c.RegionId == regionId)
                .ToListAsync();

            return Ok(cities);
        }

        // 3. Seçilen Şehirdeki Mekanları Getir
        // GET: api/Places/places/10
        [HttpGet("places/{cityId}")]
        public async Task<ActionResult<IEnumerable<Place>>> GetPlacesByCity(int cityId)
        {
            var places = await _context.Places
                .Where(p => p.CityId == cityId)
                .ToListAsync();

            return Ok(places);
        }

        // 4. Tüm Mekanları Getir (Genel listeleme)
        // GET: api/Places
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Place>>> GetAllPlaces()
        {
            return await _context.Places.ToListAsync();
        }
    }
}