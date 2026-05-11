using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SeyahatBackend.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Places");

            migrationBuilder.DropTable(
                name: "TravelHistories");

            migrationBuilder.DropTable(
                name: "Users");
        }
    }
}
