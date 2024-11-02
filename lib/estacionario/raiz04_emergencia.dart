import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Raiz04Emergencia extends StatelessWidget {
  const Raiz04Emergencia({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 9),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'emergência'.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Segoe Bold',
                color: Color(0xFF0C5422),
                fontSize: 19,
              ),
            ),
          ),
          const SizedBox(height: 9),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MaterialButton(
                padding: const EdgeInsets.all(0),
                onPressed: () => _makePhoneCall('192'),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(9),
                    ),
                    image: DecorationImage(
                      image: ExactAssetImage('assets/images/menu.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'samu'.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Segoe Bold',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              MaterialButton(
                padding: const EdgeInsets.all(0),
                onPressed: () => _makePhoneCall('193'),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(9),
                    ),
                    image: DecorationImage(
                      image: ExactAssetImage('assets/images/menu.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Bombeiros'.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Segoe Bold',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              MaterialButton(
                padding: const EdgeInsets.all(0),
                onPressed: () => _makePhoneCall('190'),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(9),
                    ),
                    image: DecorationImage(
                      image: ExactAssetImage('assets/images/menu.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Polícia'.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Segoe Bold',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String number) async {
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      await Permission.phone.request();
    }
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    if (res != true) {}
  }
}
