using Microsoft.EntityFrameworkCore;
using SeyahatBackend.Data;
using SeyahatBackend.Models;

var builder = WebApplication.CreateBuilder(args);

// DB Bağlantısı
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(); // En sade hali, çakışma ihtimali yok.

var app = builder.Build();

// Swagger'ı aktif et
app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "Seyahat API V1");
    c.RoutePrefix = string.Empty;
});

app.UseAuthorization();
app.MapControllers();

app.Run();