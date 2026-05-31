import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// Sadece senin projenin kendi servis ve modelleri çağrılıyor
import 'package:seyahat_mobile/services/api_service.dart'; 
import 'package:seyahat_mobile/models/city_model.dart';    
import 'package:seyahat_mobile/models/place_model.dart';   

class RoutePlannerPage extends StatefulWidget {
  const RoutePlannerPage({Key? key}) : super(key: key);

  @override
  State<RoutePlannerPage> createState() => _RoutePlannerPageState();
}

class _RoutePlannerPageState extends State<RoutePlannerPage> {
  final ApiService _apiService = ApiService(); // Tek ve ortak servisimiz
  GoogleMapController? _mapController;

  List<City> _allCities = [];          // Veritabanındaki tüm birleştirilmiş şehirler
  List<Place> _currentPlaces = [];     // Seçilen şehre ait mekanlar
  List<Place> _selectedPlaces = [];    // Kullanıcının rotaya eklemek için seçtiği mekanlar
  
  City? _selectedCity;
  bool _isLoading = true;              // Veriler ilk yüklenirken dönecek kontrol
  bool _isPlacesLoading = false;       // Mekanlar yüklenirken dönecek kontrol

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  CameraPosition _currentCameraPosition = const CameraPosition(
    target: LatLng(38.9637, 35.2433),  // Türkiye merkezi başlangıç pozisyonu
    zoom: 6,
  );

  @override
  void initState() {
    super.initState();
    _loadAllCitiesSequentially(); // Sayfa açılınca hiyerarşik olarak şehirleri topluyoruz
  }

  // Bölgeleri dönüp tüm şehirleri tek bir dropdown listesinde birleştiren fonksiyon
  Future<void> _loadAllCitiesSequentially() async {
    try {
      final regions = await _apiService.getRegions();
      List<City> temporaryCityList = [];

      // Her bölgenin şehirlerini sırayla çekip listeye ekliyoruz
      for (var region in regions) {
        final cities = await _apiService.getCitiesByRegion(region.id);
        temporaryCityList.addAll(cities);
      }

      setState(() {
        _allCities = temporaryCityList;
        _isLoading = false;
      });
    } catch (e) {
      print("Harita sayfasında şehirler yüklenirken hata: $e");
      setState(() => _isLoading = false);
    }
  }

  // Dropdown'dan şehir değiştirildiğinde tetiklenen fonksiyon
  Future<void> _onCityChanged(City? newCity) async {
    if (newCity == null) return;
    
    setState(() {
      _selectedCity = newCity;
      _isPlacesLoading = true;
      _selectedPlaces.clear();
      _markers.clear();
      _polylines.clear();
    });

    try {
      // ApiService içindeki metodu tetikleyerek mekanları çekiyoruz
      final places = await _apiService.getPlacesByCity(newCity.id);
      
      setState(() {
        _currentPlaces = places;
        _isPlacesLoading = false;

        if (_currentPlaces.isNotEmpty) {
          // Kamerayı seçilen şehrin ilk mekanına yumuşak geçişle odaklar
          _currentCameraPosition = CameraPosition(
            target: LatLng(_currentPlaces.first.enlem, _currentPlaces.first.boylam),
            zoom: 12,
          );
          _mapController?.animateCamera(CameraUpdate.newCameraPosition(_currentCameraPosition));
        }
      });
    } catch (e) {
      print("Şehre ait mekanlar çekilirken hata: $e");
      setState(() => _isPlacesLoading = false);
    }
  }

  // Haversine Formülü
  double _calculateDistance(LatLng p1, LatLng p2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((p2.latitude - p1.latitude) * p)/2 + 
          c(p1.latitude * p) * c(p2.latitude * p) * (1 - c((p2.longitude - p1.longitude) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  // Listeden mekan seçildiğinde veya kaldırıldığında marker günceller
  void _onPlaceSelected(bool? checked, Place place) {
    setState(() {
      if (checked == true) {
        _selectedPlaces.add(place);
      } else {
        _selectedPlaces.remove(place);
      }

      _markers.clear();
      for (var p in _selectedPlaces) {
        _markers.add(
          Marker(
            markerId: MarkerId(p.id.toString()),
            position: LatLng(p.enlem, p.boylam),
            infoWindow: InfoWindow(title: p.isim, snippet: p.aciklama),
          ),
        );
      }
    });
  }

  // Genetik Algoritma Motoru
  List<Place> _runGeneticAlgorithm(List<Place> points) {
    if (points.length <= 2) return points;
    final random = Random();

    double evaluateRoute(List<Place> route) {
      double total = 0;
      for (int i = 0; i < route.length - 1; i++) {
        total += _calculateDistance(
          LatLng(route[i].enlem, route[i].boylam),
          LatLng(route[i+1].enlem, route[i+1].boylam),
        );
      }
      return total;
    }

    List<List<Place>> population = List.generate(20, (_) {
      return List<Place>.from(points)..shuffle(random);
    });

    for (int gen = 0; gen < 50; gen++) {
      population.sort((a, b) => evaluateRoute(a).compareTo(evaluateRoute(b)));
      List<List<Place>> nextGen = population.take(5).toList();

      while (nextGen.length < 20) {
        var parent = population[random.nextInt(5)];
        var child = List<Place>.from(parent);

        int idx1 = random.nextInt(child.length);
        int idx2 = random.nextInt(child.length);
        var temp = child[idx1];
        child[idx1] = child[idx2];
        child[idx2] = temp;

        nextGen.add(child);
      }
      population = nextGen;
    }

    population.sort((a, b) => evaluateRoute(a).compareTo(evaluateRoute(b)));
    return population.first;
  }

  // Rota optimizasyonunu çalıştırıp haritaya çizen fonksiyon
  Future<void> _optimizeAndDrawRoute() async {
    if (_selectedPlaces.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen en az 2 yer seçiniz!")),
      );
      return;
    }

    List<Place> optimizedPlaces = _runGeneticAlgorithm(_selectedPlaces);

    double totalKm = 0;
    for (int i = 0; i < optimizedPlaces.length - 1; i++) {
      totalKm += _calculateDistance(
        LatLng(optimizedPlaces[i].enlem, optimizedPlaces[i].boylam),
        LatLng(optimizedPlaces[i+1].enlem, optimizedPlaces[i+1].boylam),
      );
    }

    String routeText = optimizedPlaces.map((p) => p.isim).join(" --> ");

    List<List<double>> optimizedCoordinates = optimizedPlaces
        .map((p) => [p.enlem, p.boylam])
        .toList();

    // DEĞİŞİKLİK: Rota çizgisini artık kendi ApiService dosyan üzerinden çekiyoruz
    final encodedPolyline = await _apiService.getRoutePolyline(optimizedCoordinates);

    if (encodedPolyline != null) {
      PolylinePoints polylinePoints = PolylinePoints();
      List<PointLatLng> result = polylinePoints.decodePolyline(encodedPolyline);
      List<LatLng> polylineCoordinates = result.map((point) => LatLng(point.latitude, point.longitude)).toList();

      setState(() {
        _polylines.clear();
        _markers.clear();

        for (int i = 0; i < optimizedPlaces.length; i++) {
          var place = optimizedPlaces[i];
          
          final BitmapDescriptor markerIcon = i == 0
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
              : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);

          _markers.add(
            Marker(
              markerId: MarkerId(place.id.toString()),
              position: LatLng(place.enlem, place.boylam),
              icon: markerIcon,
              infoWindow: InfoWindow(
                title: "${i + 1}. Durak (${i == 0 ? 'BAŞLANGIÇ' : 'Devam'})",
                snippet: place.isim,
              ),
            ),
          );
        }

        _polylines.add(
          Polyline(
            polylineId: const PolylineId("genetic_route"),
            color: const Color(0xFF1E3C72),
            width: 6,
            points: polylineCoordinates,
            geodesic: true,
            patterns: [
              PatternItem.dash(20),
              PatternItem.gap(10),
            ],
          ),
        );
      });

      ScaffoldMessenger.of(context).clearSnackBars(); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.psychology, color: Colors.amber, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    "En Kısa Rota Hesaplandı (${totalKm.toStringAsFixed(2)} km)",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
              const Divider(color: Colors.white24, height: 12),
              Text(
                routeText,
                style: const TextStyle(fontSize: 13, color: Colors.amberAccent, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1E3C72),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 8),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryNavy = Color(0xFF1E3C72);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Akıllı Rota Planlayıcı", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: primaryNavy,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(primaryNavy)))
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
                  ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // VERİTABANINDAN ALINAN TÜM ŞEHİRLERİN LİSTELENDİĞİ DROPDOWN
                      DropdownButton<City>(
                        isExpanded: true,
                        hint: const Text("Bir Şehir Seçiniz", style: TextStyle(color: primaryNavy)),
                        value: _selectedCity,
                        style: const TextStyle(color: primaryNavy, fontSize: 16, fontWeight: FontWeight.w500),
                        underline: Container(height: 2, color: primaryNavy),
                        items: _allCities.map((City city) {
                          return DropdownMenuItem<City>(value: city, child: Text(city.name));
                        }).toList(),
                        onChanged: _onCityChanged,
                      ),
                      
                      if (_isPlacesLoading)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(primaryNavy)),
                        ),

                      if (!_isPlacesLoading && _currentPlaces.isNotEmpty)
                        SizedBox(
                          height: 160, 
                          child: ListView.builder(
                            itemCount: _currentPlaces.length,
                            itemBuilder: (context, index) {
                              final place = _currentPlaces[index];
                              final isChecked = _selectedPlaces.contains(place);
                              return CheckboxListTile(
                                title: Text(place.isim, style: const TextStyle(fontWeight: FontWeight.w500)),
                                value: isChecked,
                                dense: true,
                                activeColor: primaryNavy,
                                controlAffinity: ListTileControlAffinity.leading,
                                onChanged: (val) => _onPlaceSelected(val, place),
                              );
                            },
                          ),
                        ),
                      
                      if (_selectedPlaces.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryNavy,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: _optimizeAndDrawRoute,
                              icon: const Icon(Icons.psychology_alt),
                              label: const Text("En Kısa Rotayı Çiz", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: _currentCameraPosition,
                    markers: _markers,
                    polylines: _polylines,
                    onMapCreated: (controller) => _mapController = controller,
                  ),
                ),
              ],
            ),
    );
  }
}