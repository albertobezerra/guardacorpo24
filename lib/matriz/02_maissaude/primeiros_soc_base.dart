import 'package:flutter/material.dart';

import '../../admob/banner_ad_widget.dart';

class PrimeirosSocBase extends StatefulWidget {
  final String title;
  final String content;
  const PrimeirosSocBase({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<PrimeirosSocBase> createState() => _PrimeirosSocBaseState();
}

class _PrimeirosSocBaseState extends State<PrimeirosSocBase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            widget.title.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Segoe',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          flexibleSpace: const Image(
            image: AssetImage('assets/images/treinamentos.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Text(
                  widget.content, // Use o conteúdo passado
                  style: const TextStyle(
                    fontFamily: 'Segoe',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const BannerAdWidget(), // Mantém o BannerAdWidget fixo na parte inferior
        ],
      ),
    );
  }
}