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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 8),
            Text(price,
                style: const TextStyle(fontSize: 16, color: Colors.green)),
            if (infoText != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child:
                    Text(infoText!, style: const TextStyle(color: Colors.blue)),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isEnabled ? onPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnabled ? Colors.blue : Colors.grey,
              ),
              child: Text(isEnabled ? 'Assinar' : 'Já Ativo'),
            ),
          ],
        ),
      ),
    );
  }
}
