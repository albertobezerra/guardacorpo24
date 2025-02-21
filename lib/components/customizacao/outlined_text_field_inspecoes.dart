import 'package:flutter/material.dart';

class OutlinedTextField3 extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? prefixText; // Campo para prefixo (ex.: R$)
  final bool obscureText;
  final bool enabled; // Novo parâmetro para habilitar/desabilitar o campo
  final Function(String)? onChanged; // Parâmetro onChanged
  final Function(String)? onSubmitted;
  final TextCapitalization textCapitalization;
  final int? maxLines; // Novo parâmetro maxLines

  const OutlinedTextField3({
    super.key,
    required this.controller,
    required this.labelText,
    this.prefixText, // Adicionado o parâmetro prefixText
    this.obscureText = false,
    this.enabled = true, // Valor padrão é true (habilitado)
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
      cursorColor: widget.enabled
          ? const Color.fromARGB(255, 0, 104, 55)
          : Colors.grey, // Cursor cinza quando desativado
      enabled: widget.enabled, // Define se o campo está habilitado
      textCapitalization: widget.textCapitalization,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: widget.enabled
              ? const Color.fromARGB(255, 0, 104, 55)
              : Colors.grey, // Cor do rótulo cinza quando desativado
        ),
        hintStyle: const TextStyle(color: Colors.white),
        filled: false,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: widget.enabled
                ? const Color.fromARGB(255, 0, 104, 55)
                : Colors.grey, // Borda cinza quando desativado
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: widget.enabled
                ? const Color.fromARGB(255, 0, 104, 55)
                : Colors.grey, // Borda cinza quando desativado
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: widget.enabled
                ? const Color.fromARGB(255, 0, 104, 55)
                : Colors.grey, // Borda cinza quando desativado
            width: 2,
          ),
        ),
        prefixText: widget.prefixText, // Adicionado o prefixText aqui
        prefixStyle: TextStyle(
          color: widget.enabled
              ? const Color.fromARGB(255, 0, 104, 55)
              : Colors.grey, // Prefixo cinza quando desativado
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: widget.enabled
                      ? const Color.fromARGB(255, 0, 104, 55)
                      : Colors.grey, // Ícone cinza quando desativado
                ),
                onPressed: widget.enabled
                    ? _togglePasswordVisibility
                    : null, // Desativa o ícone quando desativado
              )
            : null,
      ),
      style: TextStyle(
        color: widget.enabled
            ? const Color.fromARGB(255, 0, 104, 55)
            : Colors.grey, // Cor do texto cinza quando desativado
      ),
      onChanged: widget.enabled ? widget.onChanged : null, // Desativa onChanged
      onSubmitted: widget.onSubmitted,
      maxLines: widget.maxLines, // Aplica o parâmetro maxLines
    );
  }
}
