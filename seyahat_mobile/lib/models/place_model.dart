class Place {
  final int id;
  final String isim;
  final String aciklama;
  final String imageUrl;
  final double enlem;
  final double boylam;
  final int cityId;

  Place({
    required this.id,
    required this.isim,
    required this.aciklama,
    required this.imageUrl,
    required this.enlem,
    required this.boylam,
    required this.cityId,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] ?? 0,
      isim: json['isim'] ?? '',
      // Hata veren kısım buradaki yazım yanlışıydı, düzeltildi:
      aciklama: json['aciklama'] ?? '', 
      imageUrl: json['imageUrl'] ?? '',
      // Sayısal değerleri güvenli bir şekilde double'a çeviriyoruz
      enlem: (json['enlem'] as num?)?.toDouble() ?? 0.0,
      boylam: (json['boylam'] as num?)?.toDouble() ?? 0.0,
      cityId: json['cityId'] ?? 0,
    );
  }
}