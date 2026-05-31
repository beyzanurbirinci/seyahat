// seyahat_mobile/lib/screens/travel_history_screen.dart
import 'package:flutter/material.dart';
import '../models/visited_place_model.dart';
import '../services/travel_service.dart';
import '../widgets/visited_place_card.dart';

class TravelHistoryScreen extends StatefulWidget {
  final String userToken; 

  const TravelHistoryScreen({super.key, this.userToken = "SeyahatApp_Secure_Token_User_1"});

  @override
  State<TravelHistoryScreen> createState() => _TravelHistoryScreenState();
}

class _TravelHistoryScreenState extends State<TravelHistoryScreen> {
  final TravelService _travelService = TravelService();
  List<VisitedPlace> _visitedPlaces = [];
  List<Map<String, dynamic>> _dbMekanlar = []; 
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() => _isLoading = true);
    final historyData = await _travelService.getVisitedPlaces(widget.userToken);
    final placesData = await _travelService.getAllPlaces();

    setState(() {
      _visitedPlaces = historyData;
      _dbMekanlar = placesData;
      _isLoading = false;
    });
  }

  void _openAddPlaceModal(BuildContext context) {
    int? selectedMekanId = _dbMekanlar.isNotEmpty ? _dbMekanlar.first['id'] as int : null;
    String enteredYorum = '';
    DateTime selectedDate = DateTime.now();
    double selectedPuan = 3.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E3C72),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Yeni Gezi Notu Ekle", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  
                  const Text("Nereyi Gezdiniz?", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 5),
                  
                  _dbMekanlar.isEmpty
                      ? const Text("Mekanlar yükleniyor...", style: TextStyle(color: Colors.amber, fontSize: 13))
                      : DropdownButtonFormField<int>(
                          dropdownColor: const Color(0xFF1E3C72),
                          value: selectedMekanId ?? _dbMekanlar.first['id'] as int,
                          items: _dbMekanlar.map((mekan) {
                            return DropdownMenuItem<int>(
                              value: mekan['id'] as int,
                              child: Text(mekan['ad'].toString(), style: const TextStyle(color: Colors.white)),
                            );
                          }).toList(),
                          onChanged: (value) => setModalState(() => selectedMekanId = value),
                        ),
                  const SizedBox(height: 10),
                  
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Deneyimleriniz...', 
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                    ),
                    onChanged: (value) => enteredYorum = value,
                  ),
                  const SizedBox(height: 15),
                  
                  Row(
                    children: [
                      const Text("Tarih: ", style: TextStyle(color: Colors.white, fontSize: 16)),
                      TextButton.icon(
                        icon: const Icon(Icons.calendar_month, color: Colors.amber),
                        label: Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) setModalState(() => selectedDate = picked);
                        },
                      )
                    ],
                  ),
                  
                  Row(
                    children: [
                      const Text("Puanınız: ", style: TextStyle(color: Colors.white, fontSize: 16)),
                      Row(
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < selectedPuan ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 28,
                            ),
                            onPressed: () => setModalState(() => selectedPuan = index + 1.0),
                          );
                        }),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                      onPressed: () async {
                        print("👉 [EKRAN LOGU] KAYDET BUTONUNA BASILDI!"); 

                        int finalMekanId = selectedMekanId ?? (_dbMekanlar.isNotEmpty ? _dbMekanlar.first['id'] as int : 1);
                        String finalYorum = enteredYorum.trim().isEmpty ? "Harika bir deneyimdi!" : enteredYorum;

                        int aktuelKullaniciId = 1; 
                        try {
                          if (widget.userToken.contains('_User_')) {
                            aktuelKullaniciId = int.parse(widget.userToken.split('_User_').last);
                          }
                        } catch (e) {
                          print("Token çözme hatası: $e");
                        }

                        final seyahatNotu = VisitedPlace(
                          id: DateTime.now().millisecondsSinceEpoch % 100000, 
                          kullaniciId: aktuelKullaniciId, 
                          mekanId: finalMekanId,
                          puan: selectedPuan, 
                          yorum: finalYorum,
                          tarih: selectedDate,
                          mekanAdi: "Geçici Konum", 
                        );
                        
                        print("👉 [EKRAN LOGU] Servise addVisitedPlace isteği gönderiliyor...");
                        await _travelService.addVisitedPlace(seyahatNotu, widget.userToken);
                        
                        if (mounted) {
                          Navigator.of(context).pop();
                          _loadData(); 
                        }
                      },
                      child: const Text("Kaydet", style: TextStyle(color: Color(0xFF1E3C72), fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
                    const Text("Gezi Geçmişim", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                    : _visitedPlaces.isEmpty
                        ? const Center(child: Text("Henüz gezi eklenmemiş.", style: TextStyle(color: Colors.white60)))
                        : ListView.builder(
                            itemCount: _visitedPlaces.length,
                            itemBuilder: (ctx, idx) => VisitedPlaceCard(
                              place: _visitedPlaces[idx],
                              onDelete: () async {
                                await _travelService.deleteVisitedPlace(_visitedPlaces[idx].id!, widget.userToken);
                                _loadData();
                              },
                            ),
                          ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () => _openAddPlaceModal(context),
        child: const Icon(Icons.add, color: Color(0xFF1E3C72)),
      ),
    );
  }
}