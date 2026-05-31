// seyahat_mobile/lib/services/travel_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/visited_place_model.dart';

class TravelService {
  static const String _baseUrl = 'http://10.0.2.2:5041/api/TravelHistory';
  static const String _placesUrl = 'http://10.0.2.2:5041/api/Places'; 

  // 1. Giriş Yapan Kullanıcının Gezi Geçmişini Getir (GET)
  Future<List<VisitedPlace>> getVisitedPlaces(String userToken) async {
    int currentUserId = 1; // Çökme koruması için varsayılan 1
    try {
      if (userToken.contains('_User_')) {
        currentUserId = int.parse(userToken.split('_User_').last);
      }
    } catch (e) {
      print("Token ayrıştırma hatası: $e");
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/$currentUserId'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $userToken"
        },
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => VisitedPlace.fromJson(data)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Gezi geçmişi çekilirken bağlantı hatası: $e");
      return [];
    }
  }

  // 2. Tüm Mekanları Getir (GET)
  Future<List<Map<String, dynamic>>> getAllPlaces() async {
    try {
      final response = await http.get(Uri.parse(_placesUrl));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map<Map<String, dynamic>>((m) => {
          'id': m['id'] as int,
          'ad': m['isim'] as String,
        }).toList();
      } else {
        print("Mekanlar yüklenemedi. Kod: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Mekan listesi çekilirken bağlantı hatası: $e");
      return [];
    }
  }

  // 3. Yeni Gezi Ekle (POST)
  Future<bool> addVisitedPlace(VisitedPlace place, String userToken) async {
    int currentUserId = 1; // AuthService yapısına uyumlu varsayılan güvenli ID
    try {
      if (userToken.contains('_User_')) {
        currentUserId = int.parse(userToken.split('_User_').last);
      }
    } catch (e) {
      print("Token ayrıştırma hatası: $e");
    }

    final updatedPlace = VisitedPlace(
      kullaniciId: currentUserId, 
      mekanId: place.mekanId,
      puan: place.puan,
      yorum: place.yorum,
      tarih: place.tarih,
    );

    try {
      print("--- POST İSTEĞİ BAŞLATILDI ---");
      String jsonBody = json.encode(updatedPlace.toJson());
      print("Gönderilecek JSON Verisi: $jsonBody");

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $userToken"
        },
        body: jsonBody,
      );

      print("POST Status Code: ${response.statusCode}");
      print("POST Response Body: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ POST İSTEĞİ ATILIRKEN İÇ HATA OLUŞTU! ❌");
      print("Hata Detayı: $e");
      return false;
    }
  }

  // 4. Gezi Sil (DELETE)
  Future<bool> deleteVisitedPlace(int id, String userToken) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: {"Authorization": "Bearer $userToken"},
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("Silme hatası: $e");
      return false;
    }
  }
}