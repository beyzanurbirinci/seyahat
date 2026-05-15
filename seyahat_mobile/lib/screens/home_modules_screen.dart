import 'package:flutter/material.dart';
import '../widgets/travel_card.dart';
import 'regions_screen.dart'; // Bölgeler ekranı içe aktarıldı

class HomeModulesScreen extends StatelessWidget {
  const HomeModulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. KISIM: Üst Karşılama Başlığı
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 30, 25, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "HOŞ GELDİNİZ ",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Nereye Gitmek İstersin?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. KISIM: Modül Kartları Listesi
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // 1. MODÜL: Harita
                    TravelCard(
                      title: "HARİTA",
                      subtitle: "Etrafındaki güzellikleri keşfet",
                      imageUrl: "assets/images/modules/harita.jpg",
                      onTap: () {
                        // TODO: İleride harita ekranı buraya bağlanacak
                      },
                    ),

                    // 2. MODÜL: Nereleri Gezebilirim (Bölgeler Ekranına Geçiş Yapar)
                    TravelCard(
                      title: "NERELERİ GEZEBİLİRİM?",
                      subtitle: "Şehirleri ve mekanları incele",
                      imageUrl: "assets/images/modules/nerelerigezebilirim.jpg",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegionsScreen(),
                          ),
                        );
                      },
                    ),

                    // 3. MODÜL: Gezi Geçmişim
                    TravelCard(
                      title: "GEZİ GEÇMİŞİM",
                      subtitle: "Daha önce uğradığın yerleri gör",
                      imageUrl: "assets/images/modules/gezigecmisi.jpg",
                      onTap: () {
                        // TODO: İleride gezi geçmişi ekranı buraya bağlanacak
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}