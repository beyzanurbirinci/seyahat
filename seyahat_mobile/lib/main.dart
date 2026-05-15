import 'dart:io';
import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart'; // Güncel login ekranı yolun

/// Yerel backend sunucusuyla (HTTP/HTTPS) emülatör üzerinden 
/// sertifika hatası yaşamadan güvenle haberleşmek için override sınıfı.
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  // HTTP sertifika muafiyetini küresel olarak aktif ediyoruz
  HttpOverrides.global = MyHttpOverrides();
  runApp(const SeyahatUygulamasi());
}

class SeyahatUygulamasi extends StatelessWidget {
  const SeyahatUygulamasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seyahat Rehberi',
      debugShowCheckedModeBanner: false,
      
      // Uygulamanın genel renk temasını seyahat laciverdine ayarlıyoruz
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3C72)),
        useMaterial3: true,
      ),
      
      // Uygulama ilk açıldığında doğrudan bizim hazırladığımız, 
      // backend bağlantılı LoginScreen karşılayacak.
      home: const LoginScreen(), 
    );
  }
}