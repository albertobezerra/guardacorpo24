import 'package:flutter/material.dart';

import '../../../admob/banner_ad_widget.dart';

class ConsultaCa extends StatefulWidget {
  const ConsultaCa({super.key});

  @override
  State<ConsultaCa> createState() => _ConsultaCaState();
}

class _ConsultaCaState extends State<ConsultaCa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: const Text(
            'Consulta de C.A',
            style: TextStyle(
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
            image: AssetImage('assets/images/normas.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 12,
            child: Container(),
          ),
          const Flexible(
            flex: 1,
            child: BannerAdWidget(),
          ),
        ],
      ),
    );
  }
}
