import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/main.dart';
import 'package:guarda_corpo_2024/matriz/01_maisbuscados/01_nrs/01_nr_base.dart';

void handleNotificationNavigation(Map<String, dynamic> data) {
  final context = navigatorKey.currentContext;
  if (context == null) {
    debugPrint('NavigatorKey context is null, cannot navigate');
    return;
  }

  final type = data['type'];
  debugPrint('Handling notification navigation, type: $type');

  if (type == 'nr_update') {
    final pdfPath = data['nr_pdf'] as String?;
    final title = data['nr_title'] as String? ?? 'Norma Regulamentadora';

    if (pdfPath != null && pdfPath.isNotEmpty) {
      debugPrint('Navigating to NR: $title at $pdfPath');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => NrBase(
            title: title,
            pdfPath: pdfPath,
          ),
        ),
      );
    } else {
      debugPrint('nr_pdf is null or empty, cannot navigate');
    }
  }

  // Futuros tipos:
  // else if (type == 'dds') { ... }
  // else if (type == 'inspecao') { ... }
}
