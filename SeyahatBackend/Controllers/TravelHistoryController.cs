using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SeyahatBackend.Data;
using SeyahatBackend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SeyahatBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TravelHistoryController : ControllerBase
    {
        private readonly AppDbContext _context;

        public TravelHistoryController(AppDbContext context)
        {
            _context = context;
        }

        // 1. GET: api/TravelHistory/user/5
        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetUserTravelHistory(int userId)
        {
            var history = await (from th in _context.TravelHistories
                                 join p in _context.Places on th.MekanID equals p.Id into joinedPlace
                                 from p in joinedPlace.DefaultIfEmpty()
                                 where th.KullaniciID == userId
                                 select new
                                 {
                                     id = th.ID, 
                                     kullaniciId = th.KullaniciID,
                                     mekanId = th.MekanID,
                                     puan = th.Puan,
                                     yorum = th.Yorum,
                                     tarih = th.Tarih,
                                     mekanAdi = p != null ? p.Isim : "Bilinmeyen Mekan"
                                 }).ToListAsync();

            return Ok(history);
        }

        // 2. POST: api/TravelHistory
        [HttpPost]
        public async Task<ActionResult<TravelHistory>> PostTravelHistory([FromBody] TravelHistory travelHistory)
        {
            if (travelHistory == null)
            {
                return BadRequest(new { message = "Gönderilen gezi verisi boş olamaz." });
            }

            if (travelHistory.Tarih == DateTime.MinValue)
            {
                travelHistory.Tarih = DateTime.Now;
            }

            _context.TravelHistories.Add(travelHistory);
            await _context.SaveChangesAsync();

            return Ok(travelHistory);
        }

        // 3. DELETE: api/TravelHistory/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTravelHistory(int id)
        {
            var travelHistory = await _context.TravelHistories.FindAsync(id);
            if (travelHistory == null)
            {
                return NotFound(new { message = "Silinmek istenen gezi notu bulunamadı." });
            }

            _context.TravelHistories.Remove(travelHistory);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}