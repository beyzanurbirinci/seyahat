// seyahat_mobile/lib/models/visited_place_model.dart

class VisitedPlace {
  final int? id;
  final int? kullaniciId;
  final int? mekanId;
  final double? puan; 
  final String? yorum;
  final DateTime? tarih;
  final String? mekanAdi;

  VisitedPlace({
    this.id,
    this.kullaniciId,
    this.mekanId,
    this.puan,
    this.yorum,
    this.tarih,
    this.mekanAdi,
  });

  factory VisitedPlace.fromJson(Map<String, dynamic> json) {
    return VisitedPlace(
      id: json['id'] ?? json['ID'],
      kullaniciId: json['kullaniciId'] ?? json['KullaniciID'],
      mekanId: json['mekanId'] ?? json['MekanID'],
      puan: (json['puan'] ?? json['Puan'])?.toDouble(),
      yorum: json['yorum'] ?? json['Yorum'],
      tarih: json['tarih'] != null ? DateTime.parse(json['tarih']) : null,
      mekanAdi: json['mekanAdi'] ?? json['MekanAdi'],
    );
  }

  // .NET API'nin 400 Bad Request (null ID uyuşmazlığı) vermemesi için güncellendi
  Map<String, dynamic> toJson() {
    return {
      // 'ID' alanını tamamen kaldırdık, yeni kayıt atarken SQL Server otomatik artan değer verecek
      'KullaniciID': kullaniciId,
      'MekanID': mekanId,
      'Puan': puan?.toInt() ?? 3, 
      'Yorum': yorum ?? "Harika bir deneyimdi!",
      'Tarih': tarih?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }
}