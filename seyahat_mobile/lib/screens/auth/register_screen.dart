import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import 'login_screen.dart';
import '../../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Veritabanı modelimiz (AdSoyad, Email, Sifre) ile birebir uyumlu controller'lar
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // İşlem esnasında butonda yükleniyor göstermek için

  @override
  void dispose() {
    // Hafıza sızıntılarını önlemek için tüm controller'ları temizliyoruz
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  // --- ŞİFRE KONTROL FONKSİYONU (REGEX) ---
  String? _validatePassword(String password) {
    if (password.length < 6) {
      return 'Şifre en az 6 karakter olmalıdır.';
    }
    // En az bir büyük harf kontrolü
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Şifre en az bir büyük harf içermelidir.';
    }
    // En az bir rakam kontrolü
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Şifre en az bir rakam içermelidir.';
    }
    return null; // Şifre tüm kurallara uyuyorsa null döner
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Klavye açıldığında nesnelerin taşmasını engellemek için emniyet
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            // Sağdan soldan boşlukları biraz daha genişleterek hizalamayı düzelttik
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'Hesap Oluştur',
                  style: TextStyle(
                    fontSize: 32, 
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 40),
                
                // Ad Soyad Giriş Alanı (Yeni ekledik - Veritabanı uyumu için ŞART)
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Ad Soyad',
                  icon: Icons.person,
                ),
                const SizedBox(height: 20),
                
                // E-posta Giriş Alanı
                CustomTextField(
                  controller: _emailController,
                  hintText: 'E-posta Adresi',
                  icon: Icons.email,
                ),
                const SizedBox(height: 20),
                
                // Şifre Giriş Alanı
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Şifre',
                  icon: Icons.lock,
                  isPassword: true,
                ),
                const SizedBox(height: 30),
                
                // Kayıt Ol Butonu
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),
                    elevation: 5,
                  ),
                  onPressed: _isLoading ? null : () async {
                    // 1. Boşluk Kontrolü (Ad Soyad dahil edildi)
                    if (_nameController.text.trim().isEmpty || 
                        _emailController.text.trim().isEmpty || 
                        _passwordController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Lütfen tüm alanları doldurun!'),
                          backgroundColor: Colors.orangeAccent,
                        ),
                      );
                      return;
                    }
                    
                    // 🛠️ DÜZELTİLDİ: != yerine = yapıldı
                    final passwordError = _validatePassword(_passwordController.text.trim());
                    if (passwordError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(passwordError),
                          backgroundColor: Colors.orangeAccent,
                        ),
                      );
                      return;
                    }

                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      final apiService = ApiService();
                      
                      // 2. Yenilenen parametrelerle (AdSoyad, Email, Sifre) Kayıt İsteği
                      final success = await apiService.register(
                        _nameController.text.trim(),
                        _emailController.text.trim(), 
                        _passwordController.text.trim()
                      );

                      if (success) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Kayıt başarılı! Giriş sayfasına yönlendiriliyorsunuz...'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }

                        // Kullanıcının mesajı görmesi için kısa bir gecikme
                        await Future.delayed(const Duration(seconds: 2));

                        if (mounted) {
                          Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(builder: (context) => const LoginScreen())
                          );
                        }
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Kayıt başarısız! Bu e-posta adresi zaten kullanımda olabilir.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sunucu hatası: Lütfen API bağlantınızı veya IP adresinizi kontrol edin!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  child: _isLoading 
                      ? const SizedBox(
                          width: 20, 
                          height: 20, 
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                        )
                      : const Text('Hesap Oluştur', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                
                const SizedBox(height: 20),
                
                // Giriş Sayfasına Geri Dönüş
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (context) => const LoginScreen())
                    );
                  },
                  child: const Text(
                    'Zaten hesabınız var mı? Giriş Yap', 
                    style: TextStyle(color: Colors.white70, fontSize: 15)
                  ),
                ),
              ],
            ),
          ), // 🛠️ DÜZELTİLDİ: SingleChildScrollView kapatıldı
        ), // 🛠️ DÜZELTİLDİ: SafeArea kapatıldı
      ),
    );
  }
}