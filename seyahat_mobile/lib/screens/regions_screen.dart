import 'package:flutter/material.dart';
import '../models/region_model.dart';
import '../services/api_service.dart';
import '../widgets/travel_card.dart';
import 'cities_screen.dart'; // Bu importu eklemeyi unutma!

class RegionsScreen extends StatefulWidget {
  const RegionsScreen({super.key});

  @override
  State<RegionsScreen> createState() => _RegionsScreenState();
}

class _RegionsScreenState extends State<RegionsScreen> {
  late Future<List<Region>> futureRegions;

  @override
  void initState() {
    super.initState();
    // Backend'den bölgeleri çekiyoruz
    futureRegions = ApiService().getRegions();
  }

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
              _buildTopBar(context),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Text(
                  "Gezmek istediğiniz bölgeyi seçin",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Region>>(
                  future: futureRegions,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(color: Colors.white));
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text("Hata: ${snapshot.error}",
                              style: const TextStyle(color: Colors.white70)));
                    } else if (snapshot.hasData) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(20),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final region = snapshot.data![index];
                          return TravelCard(
                            title: region.name,
                            imageUrl: region.imageUrl,
                            subtitle: "Keşfet",
                            onTap: () {
                              // Tıklanınca Şehirler Ekranına Geçiş
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CitiesScreen(
                                    regionId: region.id,
                                    regionName: region.name,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                    return const Center(
                        child: Text("Bölge bulunamadı.",
                            style: TextStyle(color: Colors.white)));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 20, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Bölgeler",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
    );
  }
}