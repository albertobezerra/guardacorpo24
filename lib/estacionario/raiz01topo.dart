import 'package:flutter/material.dart';

class Raiz01topo extends StatelessWidget {
  const Raiz01topo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/menu.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )),
      child: Center(
        child: Column(
          children: [
            const Row(),
            const SizedBox(height: 40),
            Image(
              height: 100,
              width: MediaQuery.of(context).size.width,
              image: const AssetImage('assets/images/logo.png'),
            ),
            const Text(
              'Guarda Corpo',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Segoe Black',
                fontSize: 40,
              ),
            ),
            const Text(
              'Um app sobre saúde e segurança do trabalho',
              style: TextStyle(color: Colors.white, fontFamily: 'Segoe Light'),
            ),
          ],
        ),
      ),
    );
  }
}
