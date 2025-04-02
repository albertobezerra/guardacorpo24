import 'package:flutter/material.dart';

class CustomPlanCard extends StatelessWidget {
  final String title;
  final String? description; // Opcional
  final String? price; // Opcional
  final bool isEnabled;
  final String? infoText;
  final VoidCallback? onPressed; // Opcional
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const CustomPlanCard({
    super.key,
    required this.title,
    this.description,
    this.price,
    this.isEnabled = true,
    this.infoText,
    this.onPressed,
    this.backgroundColor = Colors.transparent,
    this.textColor = const Color.fromARGB(255, 0, 104, 55),
    this.borderColor = const Color.fromARGB(255, 0, 104, 55),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Card(
          elevation: 0,
          color: backgroundColor,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: borderColor,
              width: 2,
            ),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                if (description != null)
                  Text(
                    description!,
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),
                if (price != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    price!,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                  ),
                ],
                if (infoText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      infoText!,
                      style: TextStyle(
                        color: textColor,
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
