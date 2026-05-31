using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SeyahatBackend.Migrations
{
    /// <inheritdoc />
    public partial class AddImageUrlToPlaces : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Veritabanında zaten var olan Enlem, Boylam ve CityId sütunlarına dokunmuyoruz.
            // Sadece eksik olan ImageUrl sütununu ekliyoruz.
            migrationBuilder.AddColumn<string>(
                name: "ImageUrl",
                table: "Places",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            // Geri alma işlemi yapılırsa ImageUrl sütununu siler.
            migrationBuilder.DropColumn(
                name: "ImageUrl",
                table: "Places");
        }
    }
}