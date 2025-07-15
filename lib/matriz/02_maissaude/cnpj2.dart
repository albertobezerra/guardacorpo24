import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';
import 'package:guarda_corpo_2024/components/carregamento/barradecarregamento.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Formatador personalizado para aplicar a máscara de CNPJ
class CnpjInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (newText.length > 14) {
      newText = newText.substring(0, 14);
    }

    String formattedText = '';
    for (int i = 0; i < newText.length; i++) {
      if (i == 2) formattedText += '.';
      if (i == 5) formattedText += '.';
      if (i == 8) formattedText += '/';
      if (i == 12) formattedText += '-';
      formattedText += newText[i];
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class Cnpj2 extends StatefulWidget {
  const Cnpj2({super.key});

  @override
  State<Cnpj2> createState() => _CnpjState2();
}

class _CnpjState2 extends State<Cnpj2> {
  final TextEditingController _cnpjController = TextEditingController();
  Map<String, dynamic>? _cnpjData;
  bool _isLoading = false;
  String? _errorMessage;

  // Função para consultar o CNPJ na BrasilAPI
  Future<void> _consultarCNPJ() async {
    final cnpj = _cnpjController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cnpj.length != 14) {
      setState(() {
        _errorMessage = 'Por favor, insira um CNPJ válido (14 dígitos).';
        _cnpjData = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://brasilapi.com.br/api/cnpj/v1/$cnpj'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _cnpjData = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'CNPJ não encontrado ou erro na consulta.';
          _cnpjData = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao consultar CNPJ: $e';
        _cnpjData = null;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _cnpjController.dispose();
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
            'Consulta de CNPJ'.toUpperCase(),
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
                    controller: _cnpjController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(
                          18), // Máximo com máscara
                      CnpjInputFormatter(), // Aplica a máscara
                    ],
                    decoration: InputDecoration(
                      labelText: 'Digite o CNPJ',
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
                    onPressed: _isLoading ? null : _consultarCNPJ,
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
                    const Center(child: CustomLoadingIndicator())
                  else if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'Segoe',
                        fontSize: 14,
                      ),
                    )
                  else if (_cnpjData != null)
                    Expanded(
                      child: ListView(
                        children: [
                          _buildInfoCard('Razão Social',
                              _cnpjData!['razao_social'] ?? 'N/A'),
                          _buildInfoCard('Nome Fantasia',
                              _cnpjData!['nome_fantasia'] ?? 'N/A'),
                          _buildInfoCard('CNPJ', _cnpjData!['cnpj'] ?? 'N/A'),
                          _buildInfoCard(
                              'Situação Cadastral',
                              _cnpjData!['descricao_situacao_cadastral'] ??
                                  'N/A'),
                          _buildInfoCard('Data de Início',
                              _cnpjData!['data_inicio_atividade'] ?? 'N/A'),
                          _buildInfoCard('Endereço',
                              '${_cnpjData!['descricao_tipo_de_logradouro'] ?? ''} ${_cnpjData!['logradouro'] ?? ''}, ${_cnpjData!['numero'] ?? ''}, ${_cnpjData!['bairro'] ?? ''}, ${_cnpjData!['municipio'] ?? ''} - ${_cnpjData!['uf'] ?? ''}, CEP: ${_cnpjData!['cep'] ?? ''}'),
                          _buildInfoCard('CNAE Principal',
                              _cnpjData!['cnae_fiscal_descricao'] ?? 'N/A'),
                          _buildInfoCard('Natureza Jurídica',
                              _cnpjData!['natureza_juridica'] ?? 'N/A'),
                          _buildInfoCard('Telefone',
                              _cnpjData!['ddd_telefone_1'] ?? 'N/A'),
                          if (_cnpjData!['qsa'] != null &&
                              (_cnpjData!['qsa'] as List).isNotEmpty)
                            _buildInfoCard(
                                'Sócio Principal',
                                (_cnpjData!['qsa'] as List)
                                        .first['nome_socio'] ??
                                    'N/A'),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const Flexible(
            flex: 1,
            child: ConditionalBannerAdWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Segoe',
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 104, 55),
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontFamily: 'Segoe', fontSize: 14),
        ),
      ),
    );
  }
}
