// seyahat_mobile/lib/widgets/visited_place_card.dart
import 'package:flutter/material.dart';
import '../models/visited_place_model.dart';

class VisitedPlaceCard extends StatelessWidget {
  final VisitedPlace place;
  final VoidCallback onDelete;

  const VisitedPlaceCard({
    super.key,
    required this.place,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Tarihi GG/AA/YYYY formatında düzgünce göstermek için Null Safety kontrolü yapıldı
    // Eğer veritabanından tarih null gelirse uygulamanın çökmemesi için bugünün tarihi atanır
    String day = (place.tarih?.day ?? DateTime.now().day).toString().padLeft(2, '0');
    String month = (place.tarih?.month ?? DateTime.now().month).toString().padLeft(2, '0');
    int year = place.tarih?.year ?? DateTime.now().year;
    String formattedDate = "$day/$month/$year";

    // Eğer backend'den mekan adı gelmişse onu yazar, yoksa geçici bir başlık koyar
    String displayTitle = place.mekanAdi ?? "Ziyaret Edilen Mekan #${place.mekanId}";

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.white.withOpacity(0.12), // Sayfa gradyanı üzerinde soft durması için
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sol/Orta Kısım: İçerik Bilgileri
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    place.yorum ?? "Harika bir deneyimdi!", // null gelirse varsayılan yorum
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Colors.amber, size: 15),
                      const SizedBox(width: 6),
                      Text(
                        formattedDate,
                        style: const TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                      const SizedBox(width: 15),
                      // Puanı Yıldız İkonuyla Gösterme
                      const Icon(Icons.star, color: Colors.amber, size: 15),
                      const SizedBox(width: 4),
                      Text(
                        "${place.puan?.toInt() ?? 0} / 5",
                        style: const TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Sağ Kısım: Silme Butonu
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}