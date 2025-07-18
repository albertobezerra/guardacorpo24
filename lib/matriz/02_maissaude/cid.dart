import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' show parse;

class Cid extends StatefulWidget {
  const Cid({super.key});

  @override
  State<Cid> createState() => _CidState();
}

class _CidState extends State<Cid> {
  final TextEditingController _cidController = TextEditingController();
  List<dynamic>? _cidData;
  bool _isLoading = false;
  String? _errorMessage;

  // Configurações da API com as credenciais fornecidas
  final String clientId =
      'bd04e655-6da8-4bc4-b7a2-bdebe811ffb4_2a32db4b-37bc-41e0-9a2a-23eefff6ad8f';
  final String clientSecret = 'j7iPll4QHDT1NvNU/7uiTPgbDIkSS6k0eF84JgtaF70=';
  final String tokenEndpoint =
      'https://icdaccessmanagement.who.int/connect/token';
  final String scope = 'icdapi_access';
  final String searchEndpoint =
      'https://id.who.int/icd/release/11/2025-01/mms/search';

  // Função para limpar HTML do texto
  String _stripHtml(String htmlText) {
    final document = parse(htmlText);
    return document.body?.text ?? htmlText;
  }

  // Função para normalizar termo de busca (remove acentos e espaços extras)
  String _normalizeQuery(String query) {
    // Mapa de caracteres com acentos para equivalentes sem acentos
    const Map<String, String> accentMap = {
      'á': 'a',
      'à': 'a',
      'ã': 'a',
      'â': 'a',
      'ä': 'a',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'í': 'i',
      'ì': 'i',
      'î': 'i',
      'ï': 'i',
      'ó': 'o',
      'ò': 'o',
      'õ': 'o',
      'ô': 'o',
      'ö': 'o',
      'ú': 'u',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'ç': 'c',
      'ñ': 'n',
      'Á': 'A',
      'À': 'A',
      'Ã': 'A',
      'Â': 'A',
      'Ä': 'A',
      'É': 'E',
      'È': 'E',
      'Ê': 'E',
      'Ë': 'E',
      'Í': 'I',
      'Ì': 'I',
      'Î': 'I',
      'Ï': 'I',
      'Ó': 'O',
      'Ò': 'O',
      'Õ': 'O',
      'Ô': 'O',
      'Ö': 'O',
      'Ú': 'U',
      'Ù': 'U',
      'Û': 'U',
      'Ü': 'U',
      'Ç': 'C',
      'Ñ': 'N',
    };

    String normalized = query;
    accentMap.forEach((key, value) {
      normalized = normalized.replaceAll(key, value);
    });

    // Remove caracteres especiais, espaços extras e converte para minúsculas
    normalized =
        normalized.replaceAll(RegExp(r'[^\w\s]'), '').trim().toLowerCase();
    return normalized;
  }

  // Função para obter o token de acesso
  Future<String?> _getAccessToken() async {
    try {
      final response = await http.post(
        Uri.parse(tokenEndpoint),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'client_credentials',
          'client_id': clientId,
          'client_secret': clientSecret,
          'scope': scope,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Token obtido: ${data['access_token']}');
        return data['access_token'];
      } else {
        print(
            'Falha ao obter token: Status ${response.statusCode}, Resposta: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Erro ao obter token: $e');
      return null;
    }
  }

  // Função para consultar o CID-11
  Future<void> _consultarCID() async {
    // Fecha o teclado
    FocusScope.of(context).unfocus();

    final query = _cidController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _errorMessage =
            'Por favor, insira um termo de busca (ex.: diabetes, cólica).';
        _cidData = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Obtém o token de acesso
      final token = await _getAccessToken();
      if (token == null) {
        setState(() {
          _errorMessage =
              'Erro ao obter token de autenticação. Verifique as credenciais.';
          _cidData = null;
          _isLoading = false;
        });
        return;
      }

      // Normaliza o termo de busca
      final normalizedQuery = _normalizeQuery(query);
      print('Termo normalizado: $normalizedQuery');

      // Faz a requisição à API de busca
      final response = await http.get(
        Uri.parse('$searchEndpoint?q=$normalizedQuery'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Accept-Language': 'pt', // Solicita resultados em português
          'API-Version': 'v2',
        },
      );

      print(
          'Resposta da API: Status ${response.statusCode}, Corpo: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final entities = data['destinationEntities'] ?? [];
        // Mapeia os dados para o formato esperado
        final mappedData = entities.map((item) {
          return {
            'title': _stripHtml(item['title'] ?? 'N/A'),
            'code': item['code'] ?? (item['stemId']?.split('/').last ?? 'N/A'),
            'definition': _stripHtml(
              item['definition'] ??
                  (item['matchingPVs']?.isNotEmpty == true
                      ? item['matchingPVs'][0]['label'] ?? 'N/A'
                      : 'N/A'),
            ),
          };
        }).toList();

        print('Dados mapeados: $mappedData');

        setState(() {
          _cidData = mappedData;
          _isLoading = false;
          _cidController.clear(); // Limpa o TextField após busca bem-sucedida
          if (_cidData!.isEmpty) {
            _errorMessage =
                'Nenhum resultado encontrado para "$query". Tente termos como "diabetes" ou "cólica".';
          }
        });
      } else {
        setState(() {
          _errorMessage =
              'Erro na consulta: Status ${response.statusCode}. Tente novamente.';
          _cidData = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erro ao consultar CID: $e');
      setState(() {
        _errorMessage = 'Erro ao consultar CID: $e';
        _cidData = null;
        _isLoading = false;
      });
    }
  }

  // Função para copiar todos os dados consultados
  void _copiarTodosOsDados() {
    if (_cidData == null || _cidData!.isEmpty) return;
    final buffer = StringBuffer();
    for (var item in _cidData!) {
      buffer.writeln('Título: ${item['title'] ?? 'N/A'}');
      buffer.writeln('Código: ${item['code'] ?? 'N/A'}');
      buffer.writeln('Descrição: ${item['definition'] ?? 'N/A'}');
      buffer.writeln('---');
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todos os dados foram copiados!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _cidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.09),
        child: AppBar(
          toolbarHeight: 200,
          title: Text(
            'Consulta de CID'.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Segoe Bold',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          flexibleSpace: const Image(
            image: AssetImage('assets/images/menu.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 12,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _cidController,
                    keyboardType: TextInputType.text,
                    onSubmitted: (value) =>
                        _consultarCID(), // Chama a consulta ao pressionar Enter
                    decoration: InputDecoration(
                      labelText:
                          'Digite o termo ou código CID (ex.: diabetes, cólica)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 0, 104, 55),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _consultarCID,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 104, 55),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: const Text(
                      'CONSULTAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Segoe',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'Segoe',
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    )
                  else if (_cidData != null && _cidData!.isNotEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: ElevatedButton(
                                    onPressed: _copiarTodosOsDados,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 0, 104, 55),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                    ),
                                    child: const Text(
                                      'COPIAR TUDO',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Segoe',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ..._cidData!.asMap().entries.map((entry) {
                                  final item = entry.value;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildInfoRow(
                                          'Título', item['title'] ?? 'N/A'),
                                      _buildInfoRow(
                                          'Código', item['code'] ?? 'N/A'),
                                      _buildInfoRow('Descrição',
                                          item['definition'] ?? 'N/A'),
                                      const Divider(),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    const Text(
                      'Nenhum resultado encontrado. Tente termos como "diabetes" ou "cólica".',
                      style: TextStyle(
                        fontFamily: 'Segoe',
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Segoe',
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 104, 55),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          SelectableText(
            value.isEmpty ? 'N/A' : value,
            style: const TextStyle(
              fontFamily: 'Segoe',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
