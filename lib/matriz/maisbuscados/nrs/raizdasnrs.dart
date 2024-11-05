import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/maisbuscados/nrs/nr1.dart';

class NrsRaiz extends StatelessWidget {
  const NrsRaiz({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(70)),
                image: DecorationImage(
                  image: AssetImage('assets/images/normas.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(top: 50, left: 30, right: 30),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 26,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 120),
                        Text(
                          'normas regulamentadoras'.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'Segoe Bold',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 6,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Container(
                margin: const EdgeInsets.all(24),
                child: ListView(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      child: InkWell(
                        onTap: () async {
                          // if (!interstitialAd.isAvailable)
                          //   await interstitialAd.load();
                          // if (interstitialAd.isAvailable) {
                          //   await interstitialAd.show();
                          // }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Nr1()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            children: [
                              const Icon(Icons.library_books),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  'NR 1 - Disposições Gerais e gerenciamento de riscos Ocupacionais.'
                                      .toUpperCase(),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: const TextStyle(
                                    fontFamily: 'Segoe Bold',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
