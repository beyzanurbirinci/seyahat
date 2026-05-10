import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/place_model.dart';
import '../models/region_model.dart'; 
import '../models/city_model.dart';   

class ApiService {
  static const String baseUrl = "http://10.0.2.2:5041/api";

  // 1. TÜM BÖLGELERİ GETİREN METOD 
  Future<List<Region>> getRegions() async {
    final response = await http.get(Uri.parse('$baseUrl/Places/regions'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Region.fromJson(data)).toList();
    } else {
      throw Exception('Bölgeler yüklenemedi! Kod: ${response.statusCode}');
    }
  }

  // 2. SEÇİLEN BÖLGEYE GÖRE ŞEHİRLERİ GETİREN METOD
  // C# tarafındaki [HttpGet("cities/{regionId}")] ile tam uyumlu hale getirildi
  Future<List<City>> getCitiesByRegion(int regionId) async {
    final response = await http.get(Uri.parse('$baseUrl/Places/cities/$regionId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => City.fromJson(data)).toList();
    } else {
      throw Exception('Şehirler yüklenemedi! Kod: ${response.statusCode}');
    }
  }

  // 3. SEÇİLEN ŞEHRE GÖRE MEKANLARI (PLACES) GETİREN METOD
  // C# tarafındaki [HttpGet("places/{cityId}")] ile uyumlu
  Future<List<Place>> getPlacesByCity(int cityId) async {
    final response = await http.get(Uri.parse('$baseUrl/Places/places/$cityId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Place.fromJson(data)).toList();
    } else {
      throw Exception('Mekanlar yüklenemedi! Kod: ${response.statusCode}');
    }
  }

  // 4. TÜM MEKANLARI GETİREN METOD (Genel listeleme)
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