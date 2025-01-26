import 'package:flutter/material.dart';

class OutlinedTextField2 extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final Function(String)? onSubmitted;
  final TextCapitalization textCapitalization;

  const OutlinedTextField2({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.onSubmitted,
    required this.textCapitalization,
  });

  @override
  OutlinedTextField2State createState() => OutlinedTextField2State();
}

class OutlinedTextField2State extends State<OutlinedTextField2> {
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
      cursorColor: const Color.fromARGB(255, 0, 104, 55),
      textCapitalization: widget.textCapitalization,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 104, 55)),
        hintStyle: const TextStyle(color: Colors.white),
        filled: false,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 104, 55)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 104, 55)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 104, 55)),
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: const Color.fromARGB(255, 0, 104, 55),
                ),
                onPressed: _togglePasswordVisibility,
              )
            : null,
      ),
      style: const TextStyle(color: Color.fromARGB(255, 0, 104, 55)),
      onSubmitted: widget.onSubmitted,
    );
  }
}
