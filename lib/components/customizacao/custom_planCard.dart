import 'package:flutter/material.dart';

class CustomPlanCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final bool isEnabled;
  final String? infoText;
  final VoidCallback onPressed;

  const CustomPlanCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    this.isEnabled = true,
    this.infoText,
    required this.onPressed,
  });

  static const Color borderAndTextColor = Color.fromARGB(255, 0, 104, 55);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : null, // Card inteiro é clicável
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Card(
          elevation: 0, // Remove sombra para um visual mais limpo
          color: Colors.transparent, // Sem cor de fundo
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: borderAndTextColor, // Borda verde escura
              width: 2,
            ),
          ),
          child: Container(
            width: double.infinity, // Ocupa toda a largura da tela
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: borderAndTextColor, // Verde escuro
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  description,
                  style: const TextStyle(
                    color: borderAndTextColor, // Verde escuro
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    color: borderAndTextColor, // Verde escuro
                    fontSize: 16,
                  ),
                ),
                if (infoText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      infoText!,
                      style: const TextStyle(
                        color: borderAndTextColor, // Verde escuro
                      ),
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
