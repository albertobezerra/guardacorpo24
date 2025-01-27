import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_03_checks/check_model.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_03_checks/inspetor_checks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:guarda_corpo_2024/components/customizacao/outlined_text_field_aet.dart';

class EditInspectionScreen extends StatefulWidget {
  final int? index;
  final Inspection? initialData;
  final Function(Inspection) onSave;

  const EditInspectionScreen({
    super.key,
    this.index,
    this.initialData,
    required this.onSave,
  });

  @override
  EditInspectionScreenState createState() => EditInspectionScreenState();
}

class EditInspectionScreenState extends State<EditInspectionScreen> {
  late TextEditingController _titleController;
  late DateTime _date;
  late List<ChecklistItem> _checklist;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialData?.title ?? '');
    _date = widget.initialData?.date ?? DateTime.now();
    _checklist = widget.initialData?.checklist ?? [];
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  void _saveInspection() {
    final newInspection = Inspection(
      title: _titleController.text,
      date: _date,
      checklist: _checklist,
    );
    widget.onSave(newInspection);
    Navigator.pop(context);
  }

  Future<void> _addPhoto(ChecklistItem item) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        item.photos.add(File(pickedFile.path));
      });
    }
  }

  Future<String?> _editNoteDialog(
      BuildContext context, String? currentNote) async {
    TextEditingController controller = TextEditingController(text: currentNote);
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Nota'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Digite a nota"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color buttonColor = Color.fromARGB(255, 0, 104, 55);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Editar Inspeção'.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Segoe Bold',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          flexibleSpace: const Image(
            image: AssetImage('assets/images/cid.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedTextField2(
                    controller: _titleController,
                    labelText: 'Título',
                    obscureText: false,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _pickDate,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Segoe Bold',
                      ),
                    ),
                    child: Text(
                        DateFormat('dd/MM/yyyy').format(_date).toUpperCase()),
                  ),
                  const SizedBox(height: 16.0),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _checklist.length,
                    itemBuilder: (context, index) {
                      final item = _checklist[index];
                      return ListTile(
                        title: Text(item.description),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (item.note != null) Text('Nota: ${item.note}'),
                            Wrap(
                              children: item.photos.map((file) {
                                return Image.file(
                                  file,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.note),
                              onPressed: () async {
                                final note =
                                    await _editNoteDialog(context, item.note);
                                if (note != null) {
                                  setState(() {
                                    item.note = note;
                                  });
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.camera_alt),
                              onPressed: () => _addPhoto(item),
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            item.isComplete = !item.isComplete;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _checklist.add(ChecklistItem(description: 'Novo Item'));
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Segoe Bold',
                      ),
                    ),
                    child: Text('Adicionar Item'.toUpperCase()),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                label: Text('Salvar Inspeção'.toUpperCase()),
                onPressed: _saveInspection,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: buttonColor,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Segoe Bold',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
