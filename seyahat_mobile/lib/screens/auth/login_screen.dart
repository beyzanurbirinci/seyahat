import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import '../../services/api_service.dart'; // ApiService'i kullanmaya devam ediyoruz
import '../regions_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Kullanıcı butona bastığında yükleniyor efekti için

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Klavye açıldığında tasarımın yukarı kayıp bozulmaması için
      resizeToAvoidBottomInset: false, 
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hoşgeldiniz',
              style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            
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
            const SizedBox(height: 20),

            // Giriş Yap Butonu
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 5,
              ),
              onPressed: _isLoading ? null : () async { 
                // 1. Boşluk Kontrolü
                if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lütfen tüm alanları doldurun.'),
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
                  
                  // Backend'e Email ve Şifreyi gönderiyoruz
                  bool loginSuccess = await apiService.login(
                    _emailController.text.trim(), 
                    _passwordController.text.trim(),
                  );
                  
                  if (loginSuccess) {
                    // 2. Başarılı Giriş Sonrası Yönlendirme
                    if (mounted) {
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder: (context) => const RegionsScreen())
                      );
                    }
                  } else {
                    // 3. Başarısız Giriş
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Giriş başarısız. E-posta veya şifre hatalı.'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  }
                } catch (e) {
                  // Bağlantı veya Sunucu Hatası Durumunda
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sunucuya bağlanılamadı. API durumunu ve IP adresini kontrol edin.'),
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
                  : const Text('Giriş Yap', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            
            const SizedBox(height: 20),
            
            // Şifremi Unuttum Bağlantısı
            TextButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const ForgotPasswordScreen())
                );
              },
              child: const Text('Şifremi Unuttum', style: TextStyle(color: Colors.white70, fontSize: 15)),
            ),
            
            // Hesap Oluştur Bağlantısı
            TextButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const RegisterScreen())
                );
              },
              child: const Text('Hesap Oluştur', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}