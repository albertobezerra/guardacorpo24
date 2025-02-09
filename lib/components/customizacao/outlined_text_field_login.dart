import 'package:flutter/material.dart';

class OutlinedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final Function(String)? onSubmitted;
  final TextCapitalization textCapitalization;
  final TextInputType keyboardType;

  const OutlinedTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.onSubmitted,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType = TextInputType.text,
  });

  @override
  OutlinedTextFieldState createState() => OutlinedTextFieldState();
}

class OutlinedTextFieldState extends State<OutlinedTextField> {
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText ? _obscurePassword : false,
      textCapitalization:
          widget.textCapitalization, // Use o valor passado pelo construtor
      keyboardType: widget.keyboardType,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: Colors.white),
        hintStyle: const TextStyle(color: Colors.white),
        filled: false,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: _togglePasswordVisibility,
              )
            : null,
      ),
      style: const TextStyle(color: Colors.white),
      onSubmitted: widget.onSubmitted,
    );
  }
}
