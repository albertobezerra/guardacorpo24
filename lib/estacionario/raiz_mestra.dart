import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/estacionario/raiz01topo.dart';
import 'package:guarda_corpo_2024/estacionario/raiz02_mbuscados.dart';

class Raiz extends StatelessWidget {
  const Raiz({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Flexible(
            flex: 6,
            child: Raiz01topo(),
          ),
          // SizedBox(height: 1),
          Flexible(
            flex: 4,
            child: Raiz02Mbuscados(),
          )
          // Flexible(
          //   flex: 1,
          //   child: Container(
          //     width: double.infinity,
          //     padding: EdgeInsets.only(left: 16, top: 8),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         RichText(
          //             text: TextSpan(
          //           text: 'Mais saúde e segurança'.toUpperCase(),
          //           style: TextStyle(
          //             fontFamily: 'Segoe Bold',
          //             color: Color(0xFF0C5422),
          //             fontSize: 19,
          //           ),
          //         )),
          //       ],
          //     ),
          //   ),
          // ),
          // Flexible(
          //   flex: 7,
          //   child: MediaQuery.removePadding(
          //     context: context,
          //     removeTop: true,
          //     child: ListView(
          //       children: [
          //         // _listadebtnssecundarios(),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (context) => MapadeRisco()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image: ExactAssetImage('assets/images/mapa.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'Mapa de Risco'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => Cipa()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image:
          //                     ExactAssetImage('assets/images/treinamentos.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'Cipa'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (context) =>
          //                         PrimeirosSocorrosEstacionario()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image: ExactAssetImage('assets/images/cid.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'Primeiros Socorros'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (context) => Sinalizacao()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image:
          //                     ExactAssetImage('assets/images/sinalizacao.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'Sinalização de Segurança'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => Datas()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image: ExactAssetImage('assets/images/datas.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'Datas Importantes'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => Tecnico()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image: ExactAssetImage('assets/images/tecnico.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'Técnico em tst'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => Historia()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image: ExactAssetImage('assets/images/historia.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'História da Segurança do Trabalho'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => NBRS()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image: ExactAssetImage('assets/images/nbr.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'NBrs Relevantes'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => NHO()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image: ExactAssetImage('assets/images/normas.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'nho'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => EPI()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image: ExactAssetImage('assets/images/epi.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'Tipos de EPi'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => OS()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image: ExactAssetImage('assets/images/menu.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'O.s'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => PPP()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image: ExactAssetImage('assets/images/ppp.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'P.P.P'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => Incendio()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image: ExactAssetImage('assets/images/incendio.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'Incêndio'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => Acidente()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image: ExactAssetImage('assets/images/acidente.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'Acidentes de Trabalho'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (context) => RiscosAmbientais()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image: ExactAssetImage('assets/images/riscos.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'Riscos Ambientais'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => Esocial()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image: ExactAssetImage('assets/images/esocial.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'E-Social'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => CLT()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image: ExactAssetImage('assets/images/clt.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'C.L.T'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => Cid()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image: ExactAssetImage('assets/images/cid.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'C.I.D'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => ASO()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image: ExactAssetImage('assets/images/aso.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'A.S.O'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => CNAE()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image: ExactAssetImage('assets/images/cnae.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'Consulta de Cnae'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         MaterialButton(
          //           padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
          //           onPressed: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) => CNPJ()));
          //           },
          //           child: Container(
          //             width: MediaQuery.of(context).size.width,
          //             height: 80,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(18),
          //               ),
          //               image: DecorationImage(
          //                 image: ExactAssetImage('assets/images/menu.jpg'),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //             child: Container(
          //               alignment: AlignmentDirectional.bottomStart,
          //               margin: EdgeInsets.only(left: 12, bottom: 8),
          //               child: Text(
          //                 'Consulta de CNPJ'.toUpperCase(),
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontFamily: 'Segoe Bold',
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Flexible(
          //   flex: 3,
          //   child: Container(
          //     width: double.infinity,
          //     margin: EdgeInsets.only(top: 9),
          //     padding: EdgeInsets.symmetric(horizontal: 16),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         RichText(
          //             text: TextSpan(
          //           text: 'emergência'.toUpperCase(),
          //           style: TextStyle(
          //             fontFamily: 'Segoe Bold',
          //             color: Color(0xFF0C5422),
          //             fontSize: 19,
          //           ),
          //         )),
          //         SizedBox(height: 10),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             MaterialButton(
          //               padding: EdgeInsets.all(0),
          //               onPressed: () => launch("tel://192"),
          //               child: Container(
          //                 width: MediaQuery.of(context).size.width * 0.3,
          //                 height: MediaQuery.of(context).size.height * 0.07,
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.all(
          //                     Radius.circular(9),
          //                   ),
          //                   image: DecorationImage(
          //                     image: ExactAssetImage('assets/images/menu.jpg'),
          //                     fit: BoxFit.cover,
          //                   ),
          //                 ),
          //                 child: Center(
          //                   child: Text(
          //                     'samu'.toUpperCase(),
          //                     style: TextStyle(
          //                       color: Colors.white,
          //                       fontFamily: 'Segoe Bold',
          //                       fontSize: 16,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             MaterialButton(
          //               padding: EdgeInsets.all(0),
          //               onPressed: () => launch("tel://193"),
          //               child: Container(
          //                 width: MediaQuery.of(context).size.width * 0.3,
          //                 height: MediaQuery.of(context).size.height * 0.07,
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.all(
          //                     Radius.circular(9),
          //                   ),
          //                   image: DecorationImage(
          //                     image: ExactAssetImage('assets/images/menu.jpg'),
          //                     fit: BoxFit.cover,
          //                   ),
          //                 ),
          //                 child: Center(
          //                   child: Text(
          //                     'Bombeiros'.toUpperCase(),
          //                     style: TextStyle(
          //                       color: Colors.white,
          //                       fontFamily: 'Segoe Bold',
          //                       fontSize: 16,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             MaterialButton(
          //               padding: EdgeInsets.all(0),
          //               onPressed: () => launch("tel://190"),
          //               child: Container(
          //                 width: MediaQuery.of(context).size.width * 0.3,
          //                 height: MediaQuery.of(context).size.height * 0.07,
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.all(
          //                     Radius.circular(9),
          //                   ),
          //                   image: DecorationImage(
          //                     image: ExactAssetImage('assets/images/menu.jpg'),
          //                     fit: BoxFit.cover,
          //                   ),
          //                 ),
          //                 child: Center(
          //                   child: Text(
          //                     'Polícia'.toUpperCase(),
          //                     style: TextStyle(
          //                       color: Colors.white,
          //                       fontFamily: 'Segoe Bold',
          //                       fontSize: 16,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
