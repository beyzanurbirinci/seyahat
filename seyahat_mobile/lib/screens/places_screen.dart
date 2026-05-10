import 'package:flutter/material.dart';
import '../models/place_model.dart';
import '../services/api_service.dart';
import '../widgets/travel_card.dart';

class PlacesScreen extends StatefulWidget {
  final int cityId;
  final String cityName;

  const PlacesScreen({
    super.key,
    required this.cityId,
    required this.cityName,
  });

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  late Future<List<Place>> futurePlaces;

  @override
  void initState() {
    super.initState();
    // ApiService üzerinden mekana ait verileri çekiyoruz
    futurePlaces = ApiService().getPlacesByCity(widget.cityId);
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
                  "${widget.cityName} Gezilecek Yerler",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Place>>(
                  future: futurePlaces,
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
                          final place = snapshot.data![index];
                          return TravelCard(
                            // Modelindeki 'isim' değişkenini kullanıyoruz
                            title: place.isim, 
                            // Modele eklediğimiz 'imageUrl' değişkenini kullanıyoruz
                            imageUrl: place.imageUrl, 
                            subtitle: "Detayları Gör",
                            onTap: () {
                              debugPrint("${place.isim} tıklandı");
                            },
                          );
                        },
                      );
                    }
                    return const Center(
                      child: Text(
                        "Bu şehre ait mekan bulunamadı.",
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
            widget.cityName,
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