import 'package:flutter/material.dart';
import '../models/place_model.dart';
import '../widgets/detail_image_card.dart';
import '../widgets/detail_description_box.dart';
import '../widgets/detail_app_bar.dart'; // Yeni eklediğimiz AppBar widget'ı

class PlaceDetailScreen extends StatelessWidget {
  final Place place;

  const PlaceDetailScreen({super.key, required this.place});

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
            children: [
              // Yeni ayırdığımız parçayı buraya çağırıyoruz
              const DetailAppBar(title: "MEKAN DETAYI"),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      
                      // Mekan İsmi
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          place.isim.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Resim Kartı Widget'ı
                      DetailImageCard(imageUrl: place.imageUrl),

                      const SizedBox(height: 30),

                      // Açıklama Kutusu Widget'ı
                      DetailDescriptionBox(
                        aciklama: place.aciklama,
                        enlem: place.enlem,
                        boylam: place.boylam,
                      ),
                      
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}