import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController controller;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.icon,
    this.isPassword = false,
    required this.controller,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // Şifrenin görünürlüğünü kontrol eden state değişkeni
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    // Eğer şifre alanıysa ilk başta gizli (true) başlasın
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Opaklığı biraz azalttım, daha soft dursun diye
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        style: const TextStyle(color: Colors.black),
        // Klavye aksiyonu: Şifre alanında ise 'Bitti', değilse 'Sonraki Alana Geç' aksiyonu verir
        textInputAction: widget.isPassword ? TextInputAction.done : TextInputAction.next,
        decoration: InputDecoration(
          icon: widget.icon != null ? Icon(widget.icon, color: Colors.grey) : null,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey), 
          border: InputBorder.none,
          // Eğer bu bir şifre alanıysa sağ tarafa göz ikonu ekliyoruz
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // İkona tıklandığında şifrenin gizlilik durumunu tersine çeviriyoruz
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}