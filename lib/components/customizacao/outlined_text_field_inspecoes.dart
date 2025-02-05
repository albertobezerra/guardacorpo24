import 'package:flutter/material.dart';

class OutlinedTextField3 extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final Function(String)? onChanged; // Parâmetro onChanged
  final Function(String)? onSubmitted;
  final TextCapitalization textCapitalization;
  final int? maxLines; // Novo parâmetro maxLines

  const OutlinedTextField3({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.onChanged, // Parâmetro onChanged
    this.onSubmitted,
    required this.textCapitalization,
    this.maxLines = 1, // Valor padrão para maxLines é 1 (campo de linha única)
  });

  @override
  OutlinedTextField3State createState() => OutlinedTextField3State();
}

class OutlinedTextField3State extends State<OutlinedTextField3> {
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
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 0, 104, 55), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 0, 104, 55), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 0, 104, 55), width: 2),
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
      onChanged: widget.onChanged, // Adiciona o onChanged
      onSubmitted: widget.onSubmitted,
      maxLines: widget.maxLines, // Aplica o parâmetro maxLines
    );
  }
}
