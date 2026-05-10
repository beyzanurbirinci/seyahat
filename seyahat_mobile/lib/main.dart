import 'package:flutter/material.dart';
import 'screens/regions_screen.dart'; // Import yolu bu şekilde olmalı

void main() {
  runApp(const SeyahatUygulamasi());
}

class SeyahatUygulamasi extends StatelessWidget {
  const SeyahatUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seyahat Rehberi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3C72)),
        useMaterial3: true,
      ),
      home: const LoginEkrani(),
    );
  }
}

class LoginEkrani extends StatefulWidget {
  const LoginEkrani({super.key});

  @override
  State<LoginEkrani> createState() => _LoginEkraniState();
}

class _LoginEkraniState extends State<LoginEkrani> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();

  void _girisYap() {
    if (_emailController.text.trim().isNotEmpty && _sifreController.text.trim().isNotEmpty) {
      Navigator.pushReplacement(
        context,
        // BURAYA DİKKAT: RegionsScreen önünde 'const' OLMAYACAK
        MaterialPageRoute(builder: (context) => RegionsScreen()), 
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen bilgilerinizi giriniz"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.travel_explore, size: 100, color: Color(0xFF1E3C72)),
              const SizedBox(height: 20),
              const Text(
                "Seyahat Rehberi",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E3C72)),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "E-posta",
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _sifreController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Şifre",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _girisYap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3C72),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Giriş Yap", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}