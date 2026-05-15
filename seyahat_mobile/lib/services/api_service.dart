import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place_model.dart';
import '../models/region_model.dart'; 
import '../models/city_model.dart';   

class ApiService {
  static const String baseUrl = "http://10.0.2.2:5041/api";

  // ==================== KIMLIK DOGRULAMA (AUTH) METODLARI ====================

  // 1. KAYIT OLMA METODU (Veritabanı kolonları ve C# RegisterRequest ile birebir uyumlu)
  Future<bool> register(String adSoyad, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Auth/register'), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // Backend tarafındaki büyük harfle başlayan alan isimleriyle (AdSoyad, Email, Sifre) eşleşmeli
      body: jsonEncode(<String, String>{
        'AdSoyad': adSoyad,
        'Email': email, 
        'Sifre': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true; 
    } else {
      print("Kayıt Hatası: ${response.body}");
      return false;
    }
  }

  // 2. GİRİŞ YAPMA METODU (C# LoginRequest ile birebir uyumlu)
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Auth/login'), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Email': email, 
        'Sifre': password,
      }),
    );

    if (response.statusCode == 200) {
      // İleride backend'den dönen Token bilgisini burada yakalayıp 
      // SharedPreferences gibi lokal bir hafızada saklayabilirsin.
      print("Giriş Başarılı: ${response.body}");
      return true; 
    } else {
      print("Giriş Hatası: ${response.body}");
      return false;
    }
  }

  // ==================== SEYAHAT İÇERİK METODLARI ====================

  // 3. TÜM BÖLGELERİ GETİREN METOD 
  Future<List<Region>> getRegions() async {
    final response = await http.get(Uri.parse('$baseUrl/Places/regions'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Region.fromJson(data)).toList();
    } else {
      throw Exception('Bölgeler yüklenemedi! Kod: ${response.statusCode}');
    }
  }

  // 4. SEÇİLEN BÖLGEYE GÖRE ŞEHİRLERİ GETİREN METOD
  Future<List<City>> getCitiesByRegion(int regionId) async {
    final response = await http.get(Uri.parse('$baseUrl/Places/cities/$regionId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => City.fromJson(data)).toList();
    } else {
      throw Exception('Şehirler yüklenemedi! Kod: ${response.statusCode}');
    }
  }

  // 5. SEÇİLEN ŞEHRE GÖRE MEKANLARI (PLACES) GETİREN METOD
  Future<List<Place>> getPlacesByCity(int cityId) async {
    final response = await http.get(Uri.parse('$baseUrl/Places/places/$cityId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Place.fromJson(data)).toList();
    } else {
      throw Exception('Mekanlar yüklenemedi! Kod: ${response.statusCode}');
    }
  }

  // 6. TÜM MEKANLARI GETİREN METOD (Genel listeleme)
  Future<List<Place>> fetchAllPlaces() async {
    final response = await http.get(Uri.parse('$baseUrl/Places'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Place.fromJson(data)).toList();
    } else {
      throw Exception('Veriler yüklenemedi! Kod: ${response.statusCode}');
    }
  }
}