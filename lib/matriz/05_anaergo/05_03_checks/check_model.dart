import 'dart:io';

class ChecklistItem {
  String description;
  bool isComplete;
  String? note;
  List<File> photos;

  ChecklistItem({
    required this.description,
    this.isComplete = false,
    this.note,
    this.photos = const [],
  });
}
