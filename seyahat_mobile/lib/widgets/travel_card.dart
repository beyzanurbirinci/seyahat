import 'package:flutter/material.dart';

class TravelCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String subtitle;
  final VoidCallback onTap;

  const TravelCard({
    super.key,
    required this.title,
    this.imageUrl,
    this.subtitle = 'Keşfetmek için tıklayın',
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 1. KATMAN: Resim (Boyut ve hata kontrolü iyileştirildi)
          Image.asset(
            imageUrl ?? 'assets/images/placeholder.jpg',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,//Görselin en-boy oranını bozmadan, alanı tamamen dolduracak şekilde resmi ölçeklendirir.
            errorBuilder: (context, error, stackTrace) => Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
            ),
          ),
          // 2. KATMAN: Yarı saydam karartma (Okunabilirliği artırır)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.85),
                  ],
                ),
              ),
            ),
          ),
          // 3. KATMAN: Metinler (Taşma korumalı)
          Positioned(//Stack içerisinde kullanılır ve alt öğelerin (children) tam olarak nerede duracağını koordinat bazlı belirlemenize olanak tanır.
            bottom: 20,
            left: 20,
            right: 20, // Sağdan da sınır ekledik ki yazı sağa taşmasın
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title.toUpperCase(),
                  maxLines: 1, // Uzun isimleri tek satıra zorlar
                  overflow: TextOverflow.ellipsis, // Sığmazsa "..." koyar
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15, // Boyutu biraz küçülterek sığma şansını artırdık
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // 4. KATMAN: Tıklanabilirlik
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                splashColor: Colors.white10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}