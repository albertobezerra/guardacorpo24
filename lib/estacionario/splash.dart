import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/estacionario/raiz_mestra.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  void requeridoPermissao() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    double textoPrincipalResponsivo = screenHeight < 1000 ? 26 : 37;
    FontWeight fonteNegrito =
        screenHeight < 1000 ? FontWeight.bold : FontWeight.normal;
    EdgeInsets paddingBotaoComecar =
        screenHeight < 1000 ? EdgeInsets.zero : const EdgeInsets.all(20);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/index.jpg'),
          fit: BoxFit.cover,
        )),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomCenter, colors: [
            Colors.black.withOpacity(.9),
            Colors.black.withOpacity(.8),
            Colors.black.withOpacity(.2),
          ])),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: Text(
                    'Saúde e Segurança\ndo Trabalho na\npalma da mão.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: textoPrincipalResponsivo,
                        fontFamily: 'Segoe Black'),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Tudo a um clique de distância!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.4,
                      fontSize: 13,
                      fontWeight: fonteNegrito,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    onPressed: () {
                      //requeridoPermissao();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Raiz(),
                      ));
                    },
                    child: Padding(
                      padding: paddingBotaoComecar,
                      child: Text(
                        "Começar".toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF0C5422),
                          fontFamily: 'Segoe Black',
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
