import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_01_relatorios/incident_report.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_01_relatorios/view_reports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Relatórios de Incidentes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(), // Define a tela inicial como o MainScreen
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Principal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const IncidentReport()),
                );
              },
              child: const Text('Registrar Incidente'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewReports()),
                );
              },
              child: const Text('Ver Relatórios'),
            ),
          ],
        ),
      ),
    );
  }
}
