class Place {
  final int id;
  final String isim;
  final String aciklama;
  final String? imageUrl; // Resim yolu için ekledik

  Place({
    required this.id, 
    required this.isim, 
    required this.aciklama, 
    this.imageUrl
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] ?? 0,
      isim: json['name'] ?? json['isim'] ?? '', // Backend'den 'name' de gelse 'isim' de gelse çalışır
      aciklama: json['description'] ?? json['aciklama'] ?? '',
      imageUrl: json['imageUrl'], // Backend'deki isimlendirme ile aynı olmalı
    );
  }
}