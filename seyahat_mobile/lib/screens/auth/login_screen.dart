import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import '../../services/api_service.dart'; 
import '../home_modules_screen.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; 

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const SizedBox(height: 40), 
                
            
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/images/logo.jpg', 
                      height: 150, 
                      width: 150,
                      fit: BoxFit.cover, 
                    ),
                  ),
                ),
                // --------------------------------------------------------
                
                const SizedBox(height: 28), 
                
                const Text(
                  'Hoşgeldiniz',
                  style: TextStyle(
                    fontSize: 32, 
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
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
                const SizedBox(height: 30),

                // Giriş Yap Butonu 
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1E3C72), 
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), 
                    ),
                    elevation: 4,
                  ),
                  onPressed: _isLoading ? null : () async { 
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
                      bool loginSuccess = await apiService.login(
                        _emailController.text.trim(), 
                        _passwordController.text.trim(),
                      );
                      
                      if (loginSuccess) {
                        if (mounted) {
                          Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(builder: (context) => const HomeModulesScreen())
                          );
                        }
                      } else {
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
                          width: 24, 
                          height: 24, 
                          child: CircularProgressIndicator(color: Color(0xFF1E3C72), strokeWidth: 2.5),
                        )
                      : const Text(
                          'Giriş Yap', 
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1),
                        ),
                ),
                
                const SizedBox(height: 24),
                
                // Şifremi Unuttum Bağlantısı
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen())
                    );
                  },
                  child: const Text(
                    'Şifremi Unuttum', 
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ),
                
                // Hesap Oluştur Bağlantısı
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const RegisterScreen())
                    );
                  },
                  child: const Text(
                    'Hesap Oluştur', 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}