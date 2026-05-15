import 'package:flutter/material.dart';

class DetailDescriptionBox extends StatelessWidget{
  final String? aciklama;
  final double enlem;
   final double  boylam;

   const DetailDescriptionBox({
    super.key,
    required this.aciklama,
    required this.enlem,
    required this.boylam,
   });

   @override
   Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95), // Kutunun arka planını hafif saydam yaparak görselin önünde daha iyi görünmesini sağlıyoruz
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(76), // withOpacity yerine withAlpha kullanıldı
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.description_rounded, color:Color(0xFF1E3C72)),
            SizedBox(width: 10),
            Text(
              "Açıklama",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:Color(0xFF1E3C72),
              ),
            ),
          ],),
          const Divider(height: 20, thickness: 1),
          Text(
            aciklama != null && aciklama!.isNotEmpty 
              ? aciklama! 
              : "Bu mekan için henüz detaylı bir açıklama metni girilmemiş.",
            style: const TextStyle(
              
              fontSize: 16,
              height: 1.6,
              color:Colors.black87,
            ),
          )
          ,
        ],
      ),
    );
   }
}