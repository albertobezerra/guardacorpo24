import 'package:flutter/material.dart';

class CustomPlanCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final VoidCallback onPressed;

  const CustomPlanCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Bordas arredondadas
        side: const BorderSide(
          color: Color.fromARGB(255, 0, 104, 55), // Borda verde
          width: 2,
        ),
      ),
      color: Colors.transparent, // Fundo transparente
      elevation: 0, // Sem sombra
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 0, 104, 55), // Borda verde
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 104, 55),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 104, 55),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 104, 55),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: onPressed,
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.transparent,
                  //     elevation: 0,
                  //     foregroundColor: const Color.fromARGB(255, 0, 104, 55),
                  //     padding: const EdgeInsets.symmetric(
                  //       vertical: 10,
                  //       horizontal: 16,
                  //     ),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //       side: const BorderSide(
                  //         color: Color.fromARGB(255, 0, 104, 55),
                  //         width: 2,
                  //       ),
                  //     ),
                  //   ),
                  //   child: const Text('ASSINAR'),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
