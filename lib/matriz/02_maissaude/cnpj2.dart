import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';
import 'package:guarda_corpo_2024/components/carregamento/barradecarregamento.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> _consultarCNPJ() async {
    FocusScope.of(context).unfocus();

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
          _cnpjController.clear();
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

  void _copiarTodosOsDados() {
    if (_cnpjData == null) return;
    final buffer = StringBuffer();
    buffer.writeln('Razão Social: ${_cnpjData!['razao_social'] ?? 'N/A'}');
    buffer.writeln('Nome Fantasia: ${_cnpjData!['nome_fantasia'] ?? 'N/A'}');
    buffer.writeln('CNPJ: ${_cnpjData!['cnpj'] ?? 'N/A'}');
    buffer.writeln(
        'Situação Cadastral: ${_cnpjData!['descricao_situacao_cadastral'] ?? 'N/A'}');
    buffer.writeln(
        'Data de Início: ${_cnpjData!['data_inicio_atividade'] ?? 'N/A'}');
    buffer.writeln(
        'Endereço: ${_cnpjData!['descricao_tipo_de_logradouro'] ?? ''} ${_cnpjData!['logradouro'] ?? ''}, ${_cnpjData!['numero'] ?? ''}, ${_cnpjData!['bairro'] ?? ''}, ${_cnpjData!['municipio'] ?? ''} - ${_cnpjData!['uf'] ?? ''}, CEP: ${_cnpjData!['cep'] ?? ''}');
    buffer.writeln(
        'CNAE Principal: ${_cnpjData!['cnae_fiscal_descricao'] ?? 'N/A'}');
    buffer.writeln(
        'Natureza Jurídica: ${_cnpjData!['natureza_juridica'] ?? 'N/A'}');
    buffer.writeln('Telefone: ${_cnpjData!['ddd_telefone_1'] ?? 'N/A'}');
    if (_cnpjData!['qsa'] != null && (_cnpjData!['qsa'] as List).isNotEmpty) {
      buffer.writeln(
          'Sócio Principal: ${(_cnpjData!['qsa'] as List).first['nome_socio'] ?? 'N/A'}');
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
    _cnpjController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF006837);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'CONSULTA DE CNPJ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: primary,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _cnpjController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(18),
                      CnpjInputFormatter(),
                    ],
                    onSubmitted: (_) => _consultarCNPJ(),
                    decoration: InputDecoration(
                      labelText: 'Digite o CNPJ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _consultarCNPJ,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'CONSULTAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
                        fontSize: 14,
                      ),
                    )
                  else if (_cnpjData != null)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow('Razão Social',
                                    _cnpjData!['razao_social'] ?? 'N/A'),
                                _buildInfoRow('Nome Fantasia',
                                    _cnpjData!['nome_fantasia'] ?? 'N/A'),
                                _buildInfoRow(
                                    'CNPJ', _cnpjData!['cnpj'] ?? 'N/A'),
                                _buildInfoRow(
                                  'Situação Cadastral',
                                  _cnpjData!['descricao_situacao_cadastral'] ??
                                      'N/A',
                                ),
                                _buildInfoRow(
                                  'Data de Início',
                                  _cnpjData!['data_inicio_atividade'] ?? 'N/A',
                                ),
                                _buildInfoRow(
                                  'Endereço',
                                  '${_cnpjData!['descricao_tipo_de_logradouro'] ?? ''} ${_cnpjData!['logradouro'] ?? ''}, ${_cnpjData!['numero'] ?? ''}, ${_cnpjData!['bairro'] ?? ''}, ${_cnpjData!['municipio'] ?? ''} - ${_cnpjData!['uf'] ?? ''}, CEP: ${_cnpjData!['cep'] ?? ''}',
                                ),
                                _buildInfoRow(
                                  'CNAE Principal',
                                  _cnpjData!['cnae_fiscal_descricao'] ?? 'N/A',
                                ),
                                _buildInfoRow(
                                  'Natureza Jurídica',
                                  _cnpjData!['natureza_juridica'] ?? 'N/A',
                                ),
                                _buildInfoRow(
                                  'Telefone',
                                  _cnpjData!['ddd_telefone_1'] ?? 'N/A',
                                ),
                                if (_cnpjData!['qsa'] != null &&
                                    (_cnpjData!['qsa'] as List).isNotEmpty)
                                  _buildInfoRow(
                                    'Sócio Principal',
                                    (_cnpjData!['qsa'] as List)
                                            .first['nome_socio'] ??
                                        'N/A',
                                  ),
                                const SizedBox(height: 16),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: _copiarTodosOsDados,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primary,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: const Text(
                                      'COPIAR TUDO',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const ConditionalBannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF006837),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          SelectableText(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
