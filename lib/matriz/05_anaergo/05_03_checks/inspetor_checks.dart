// No início do arquivo check_model.dart

import 'package:guarda_corpo_2024/matriz/05_anaergo/05_03_checks/check_model.dart';

class Inspection {
  String title;
  DateTime date;
  List<ChecklistItem> checklist;

  Inspection({
    required this.title,
    required this.date,
    required this.checklist,
  });
}
