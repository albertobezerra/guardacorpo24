import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/01_maisbuscados/01_nrs/01_nr_base.dart';
import 'package:guarda_corpo_2024/matriz/01_maisbuscados/04_dds/01_dds_base.dart';
import 'package:guarda_corpo_2024/matriz/02_maissaude/02_inspecao/view_inspecoes.dart';
import 'package:guarda_corpo_2024/matriz/04_premium/subscription_service.dart';

void handleNotificationNavigation(Map<String, dynamic> data) {
  final context = navigatorKey.currentContext;
  if (context == null) {
    debugPrint('NavigatorKey context is null, cannot navigate');
    return;
  }

  final type = data['type'];
  debugPrint('Handling notification navigation, type: $type');

  // 1. Navegação para NR
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
  // 2. Navegação para DDS
  else if (type == 'dds') {
    final ddsTitle = data['dds_title'] as String?;
    final ddsContent = data['dds_content'] as String?;

    if (ddsTitle != null && ddsContent != null) {
      debugPrint('Navigating to DDS: $ddsTitle');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DdsBase(
            title: ddsTitle,
            content: ddsContent,
          ),
        ),
      );
    } else {
      debugPrint('dds_title or dds_content is null, cannot navigate');
    }
  }
  // 3. Navegação para Inspeção
  else if (type == 'inspecao') {
    debugPrint('Navigating to Inspeções');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ViewInspecoes(),
      ),
    );
  }
  // Tipo desconhecido
  else {
    debugPrint('Unknown notification type: $type');
  }
}
