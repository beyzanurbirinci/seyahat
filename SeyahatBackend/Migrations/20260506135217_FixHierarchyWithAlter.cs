using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SeyahatBackend.Migrations
{
    public partial class FixHierarchyWithAlter : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Regions ve Cities zaten varsa hata vermemesi için SQL kontrolüyle ilerliyoruz
            migrationBuilder.Sql("IF OBJECT_ID(N'[Regions]', N'U') IS NULL BEGIN CREATE TABLE [Regions] ( [Id] int NOT NULL IDENTITY, [Name] nvarchar(max) NOT NULL, [ImageUrl] nvarchar(max) NULL, CONSTRAINT [PK_Regions] PRIMARY KEY ([Id]) ); END");
            
            migrationBuilder.Sql("IF OBJECT_ID(N'[Cities]', N'U') IS NULL BEGIN CREATE TABLE [Cities] ( [Id] int NOT NULL IDENTITY, [RegionId] int NOT NULL, [Name] nvarchar(max) NOT NULL, [ImageUrl] nvarchar(max) NULL, CONSTRAINT [PK_Cities] PRIMARY KEY ([Id]), CONSTRAINT [FK_Cities_Regions_RegionId] FOREIGN KEY ([RegionId]) REFERENCES [Regions] ([Id]) ON DELETE CASCADE ); END");

            // Places tablosundaki eski sütunları kaldır
            migrationBuilder.Sql("IF COL_LENGTH('Places', 'Bolge') IS NOT NULL ALTER TABLE Places DROP COLUMN Bolge");
            migrationBuilder.Sql("IF COL_LENGTH('Places', 'Sehir') IS NOT NULL ALTER TABLE Places DROP COLUMN Sehir");

            // CityId sütununu ekle
            migrationBuilder.Sql("IF COL_LENGTH('Places', 'CityId') IS NULL ALTER TABLE Places ADD CityId int NULL");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            // Geri alma işlemi: Eklenenleri sil, sildiklerimizi geri getir
            migrationBuilder.DropColumn(name: "CityId", table: "Places");
            
            migrationBuilder.AddColumn<string>(name: "Bolge", table: "Places", type: "nvarchar(max)", nullable: false, defaultValue: "");
            migrationBuilder.AddColumn<string>(name: "Sehir", table: "Places", type: "nvarchar(max)", nullable: false, defaultValue: "");

            migrationBuilder.DropTable(name: "Cities");
            migrationBuilder.DropTable(name: "Regions");
        }
    }
}