import 'package:flutter/material.dart';

class DetailAppBar extends StatelessWidget {
  final String title;

  // Başlığı dışarıdan dinamik alabilmek için title parametresi ekledik
  const DetailAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sol taraftaki Geri Butonu
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          
          // Ortadaki Başlık Metni
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}