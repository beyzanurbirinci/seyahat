using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SeyahatBackend.Migrations
{
    /// <inheritdoc />
    public partial class SyncDatabaseState : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
           
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Places_Cities_CityId",
                table: "Places");

            migrationBuilder.DropTable(
                name: "Cities");

            migrationBuilder.DropTable(
                name: "Regions");

            migrationBuilder.DropIndex(
                name: "IX_Places_CityId",
                table: "Places");

            migrationBuilder.DropColumn(
                name: "Boylam",
                table: "Places");

            migrationBuilder.DropColumn(
                name: "CityId",
                table: "Places");

            migrationBuilder.DropColumn(
                name: "Enlem",
                table: "Places");

            migrationBuilder.RenameColumn(
                name: "ImageUrl",
                table: "Places",
                newName: "Sehir");

            migrationBuilder.AddColumn<string>(
                name: "Bolge",
                table: "Places",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }
    }
}
