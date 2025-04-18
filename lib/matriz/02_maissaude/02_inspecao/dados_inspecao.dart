import 'package:intl/intl.dart';

class Inspecao {
  String id;
  String tipoInspecao;
  DateTime data;
  String local;
  List<String> anexos;
  List<Map<String, dynamic>> pontos;

  Inspecao({
    required this.id,
    required this.tipoInspecao,
    required this.data,
    required this.local,
    this.anexos = const [],
    this.pontos = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipoInspecao': tipoInspecao,
      'data': DateFormat('dd/MM/yyyy').format(data),
      'local': local,
      'anexos': anexos,
      'pontos': pontos.map((ponto) => ponto).toList(),
    };
  }

  factory Inspecao.fromMap(Map<String, dynamic> map) {
    return Inspecao(
      id: map['id'],
      tipoInspecao: map['tipoInspecao'],
      data: DateFormat('dd/MM/yyyy').parse(map['data']),
      local: map['local'],
      anexos:
          List<String>.from(map['anexos'] ?? []), // Lidando com possíveis nulos
      pontos: List<Map<String, dynamic>>.from(
          map['pontos'] ?? []), // Lidando com possíveis nulos
    );
  }
}
