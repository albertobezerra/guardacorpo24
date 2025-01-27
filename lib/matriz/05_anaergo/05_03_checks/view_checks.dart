import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_03_checks/edit_checks.dart';
import 'package:guarda_corpo_2024/matriz/05_anaergo/05_03_checks/inspector_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ViewInspections extends StatelessWidget {
  const ViewInspections({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Inspeções de Segurança'.toUpperCase(),
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
      body: Consumer<InspectionProvider>(
        builder: (context, inspectionProvider, child) {
          if (inspectionProvider.inspections.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Nenhuma inspeção encontrada.\nVamos criar sua primeira inspeção?',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'SUAS INSPEÇÕES',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: inspectionProvider.inspections.length,
                    itemBuilder: (context, index) {
                      final inspection = inspectionProvider.inspections[index];
                      return ListTile(
                        title: Text(inspection.title),
                        subtitle: Text(
                            'Data: ${DateFormat('dd/MM/yyyy').format(inspection.date)}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditInspectionScreen(
                                index: index,
                                initialData: inspection,
                                onSave: (updatedInspection) {
                                  final inspectionProvider =
                                      Provider.of<InspectionProvider>(context,
                                          listen: false);
                                  inspectionProvider.updateInspection(
                                      index, updatedInspection);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditInspectionScreen(
                onSave: (newInspection) {
                  final inspectionProvider =
                      Provider.of<InspectionProvider>(context, listen: false);
                  inspectionProvider.addInspection(newInspection);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
