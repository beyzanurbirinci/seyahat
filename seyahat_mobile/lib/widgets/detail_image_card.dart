import 'package:flutter/material.dart';

class DetailImageCard extends StatelessWidget {
  final String? imageUrl;

  // Güncel Flutter standartlarına uygun const constructor
  const DetailImageCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      clipBehavior: Clip.antiAlias, // Parantez dışındaydı, Container içine taşındı
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            // withOpacity yerine güncel olan withAlpha kullanıldı (0.3 katsayısı için ~76 değeri)
            color: Colors.black.withAlpha(76),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Image.asset( // Image.assets hatası Image.asset olarak düzeltildi
        imageUrl ?? 'assets/images/placeholder.jpg',
        height: 280, // Resmin yüksekliği Container formuna otursun diye eklendi
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 280,
            width: double.infinity,
            color: Colors.grey[300],
            child: Center(
              child: Icon(Icons.broken_image, size: 50, color: Colors.grey[700]),
            ),
          );
        },
      ),
    );  
  }
}