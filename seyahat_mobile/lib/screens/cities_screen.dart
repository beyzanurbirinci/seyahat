import 'package:flutter/material.dart';
import '../models/city_model.dart'; 
import '../services/api_service.dart';
import '../widgets/travel_card.dart';
import 'places_screen.dart'; // - Mekanlar sayfasını import ettik

class CitiesScreen extends StatefulWidget {
  final int regionId;
  final String regionName;

  const CitiesScreen({
    super.key,
    required this.regionId,
    required this.regionName,
  });

  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  late Future<List<City>> futureCities; 

  @override
  void initState() {
    super.initState();
    // - Seçilen bölgeye ait şehirleri API'den çekiyoruz
    futureCities = ApiService().getCitiesByRegion(widget.regionId);
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Text(
                  "${widget.regionName} Bölgesi Şehirleri",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<City>>(
                  future: futureCities,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Hata: ${snapshot.error}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      );
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
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
                          final city = snapshot.data![index];
                          return TravelCard(
                            title: city.name,
                            imageUrl: city.imageUrl,
                            subtitle: "Detayları Gör",
                            onTap: () {
                              // - Şehre tıklandığında ilgili PlacesScreen'e yönlendiriyoruz
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlacesScreen(
                                    cityId: city.id, // - Şehir ID'sini gönderiyoruz
                                    cityName: city.name, // - Şehir ismini başlık için gönderiyoruz
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                    return const Center(
                      child: Text(
                        "Bu bölgeye ait şehir bulunamadı.",
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
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
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            widget.regionName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}