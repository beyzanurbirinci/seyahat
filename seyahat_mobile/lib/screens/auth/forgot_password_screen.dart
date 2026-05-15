import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Form kontrolü ve validasyon için formKey ekledik
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sayfa kaydığında klavyenin tasarımı bozmaması için emniyet
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
        child: Form(
          key: _formKey, // Boş geçilememe kontrolü için formu sarmaladık
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Şifremi Unuttum',
                style: TextStyle(
                  fontSize: 32, 
                  color: Colors.white, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'E-posta adresinizi girerek şifre sıfırlama talebinde bulunabilirsiniz.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 40),
              
              // E-posta Giriş Alanı
              CustomTextField(
                controller: _emailController, 
                hintText: 'E-posta Adresi', 
                icon: Icons.email,
              ),
              
              const SizedBox(height: 30),
              
              // Şifre Sıfırlama Butonu
              ElevatedButton(
                onPressed: () {
                  if (_emailController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lütfen geçerli bir e-posta adresi girin.'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  } else {
                    // TODO: İleride backend'e şifre sıfırlama isteği buraya bağlanacak
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sıfırlama kodu gönderildi: ${_emailController.text.trim()}'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Şifre Sıfırla',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              
              // Giriş Sayfasına Dönüş Butonu
              TextButton(
                onPressed: () {
                  // Üst üste sayfa yığmamak için pop kullanarak önceki ekrana dönüyoruz
                  Navigator.pop(context);
                },
                child: const Text(
                  'Giriş Sayfasına Dön', 
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}