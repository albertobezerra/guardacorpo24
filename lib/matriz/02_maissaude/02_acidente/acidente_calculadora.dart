import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../components/customizacao/outlined_text_field_inspecoes.dart';

class CalculadoraAcidente extends StatefulWidget {
  const CalculadoraAcidente({super.key});

  @override
  CalculadoraAcidenteState createState() => CalculadoraAcidenteState();
}

class CalculadoraAcidenteState extends State<CalculadoraAcidente> {
  // Controladores para os inputs
  final MoneyTextController _salarioController =
      MoneyTextController(text: '1518');
  final TextEditingController _horasPorDiaController =
      TextEditingController(text: '8');
  final TextEditingController _inssPercentualController =
      TextEditingController(text: '9');
  final TextEditingController _fgtsPercentualController =
      TextEditingController(text: '8');
  final MoneyTextController _gastosAdicionaisController = MoneyTextController();

  double totalPrejuizo = 0;
  int diasAfastamento = 1; // Inicia com 1 dia

  @override
  void initState() {
    super.initState();
    calcularPrejuizo(); // Realiza o cálculo inicial ao carregar a tela
  }

  void calcularPrejuizo() {
    try {
      // Converte o salário para double, removendo formatação monetária
      String salarioRaw =
          _salarioController.text.replaceAll('.', '').replaceAll(',', '.');
      double salario = double.tryParse(salarioRaw) ?? 0;

      int horasPorDia = int.tryParse(_horasPorDiaController.text) ?? 0;
      double inssPercentual =
          double.tryParse(_inssPercentualController.text) ?? 9;
      double fgtsPercentual =
          double.tryParse(_fgtsPercentualController.text) ?? 8;
      double gastosAdicionais = _gastosAdicionaisController.getDoubleValue();

      if (salario == 0 || horasPorDia == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Preencha todos os campos corretamente.')),
        );
        return;
      }

      // Cálculo dos encargos sociais
      double fgts = (salario * fgtsPercentual / 100); // FGTS (%)
      double inss = (salario * inssPercentual / 100); // INSS (%)
      double ferias = salario / 12; // Férias (1/12 do salário)

      // Valor da hora trabalhada
      int horasTotaisMes = horasPorDia * 30; // Considerando 30 dias no mês
      double valorHora = salario / horasTotaisMes;

      // Cálculo do custo por dias de afastamento selecionados
      int horasPerdidas = horasPorDia * diasAfastamento; // Horas perdidas
      double custoAfastamento = horasPerdidas * valorHora;

      // Total de prejuízo
      double total = custoAfastamento + fgts + inss + ferias + gastosAdicionais;

      setState(() {
        totalPrejuizo = total;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao calcular prejuízo.')),
      );
    }
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
            'Cálculo de Prejuízo Acidente'.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Segoe Bold',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          flexibleSpace: const Image(
            image: AssetImage('assets/images/acidente.jpg'),
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
                  // Salário Mensal
                  OutlinedTextField3(
                    controller: _salarioController,
                    labelText: 'Salário Mensal',
                    prefixText: 'R\$ ',
                    obscureText: false,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.number, // Teclado numérico
                    onChanged: (value) => calcularPrejuizo(),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 16),

                  // Horas Trabalhadas por Dia
                  OutlinedTextField3(
                    controller: _horasPorDiaController,
                    labelText: 'Horas Trabalhadas por Dia',
                    obscureText: false,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.number, // Teclado numérico
                    onChanged: (value) => calcularPrejuizo(),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 16),

                  // Percentual INSS
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: OutlinedTextField3(
                          controller: _inssPercentualController,
                          labelText: 'INSS (%)',
                          obscureText: false,
                          textCapitalization: TextCapitalization.none,
                          keyboardType:
                              TextInputType.number, // Teclado numérico
                          onChanged: (value) => calcularPrejuizo(),
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        flex: 1,
                        child: Text(
                          'Padrão: 9%',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Percentual FGTS
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: OutlinedTextField3(
                          controller: _fgtsPercentualController,
                          labelText: 'FGTS (%)',
                          obscureText: false,
                          textCapitalization: TextCapitalization.none,
                          keyboardType:
                              TextInputType.number, // Teclado numérico
                          onChanged: (value) => calcularPrejuizo(),
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        flex: 1,
                        child: Text(
                          'Padrão: 8%',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Campo de Férias (somente leitura)
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: OutlinedTextField3(
                          controller: TextEditingController(
                              text: NumberFormat.currency(
                                      locale: 'pt_BR', symbol: 'R\$ ')
                                  .format(_salarioController.getDoubleValue() /
                                      12)), // Calcula 1/12 do salário
                          labelText: 'Férias (1/12)',
                          obscureText: false,
                          textCapitalization: TextCapitalization.none,
                          enabled: false, // Campo desativado (somente leitura)
                          keyboardType:
                              TextInputType.number, // Teclado numérico
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        flex: 1,
                        child: Text(
                          'Valor Fixo: 1/12 do Salário',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Gastos Adicionais
                  OutlinedTextField3(
                    controller: _gastosAdicionaisController,
                    labelText: 'Gastos Adicionais',
                    prefixText: 'R\$ ',
                    obscureText: false,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.number, // Teclado numérico
                    onChanged: (value) => calcularPrejuizo(),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 16),

                  // Slider para Dias de Afastamento
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: diasAfastamento.toDouble(),
                          min: 1, // Inicia com 1 dia
                          max: 15,
                          divisions: 14, // 14 divisões entre 1 e 15
                          label: '$diasAfastamento dias',
                          activeColor: buttonColor,
                          inactiveColor: Colors.grey,
                          onChanged: (value) {
                            setState(() {
                              diasAfastamento = value.toInt();
                              calcularPrejuizo(); // Atualiza o cálculo automaticamente
                            });
                          },
                        ),
                      ),
                      Text(
                        '$diasAfastamento dias',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Resultado do Cálculo
                  Card(
                    color: buttonColor,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Total de Prejuízo: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(totalPrejuizo)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Classe para controlador de texto monetário
class MoneyTextController extends TextEditingController {
  MoneyTextController({String text = ''})
      : super(text: formatCurrency(double.tryParse(text) ?? 0));

  static String formatCurrency(double value) {
    final formatter =
        NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2);
    return formatter.format(value);
  }

  double getDoubleValue() {
    final text = this.text.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(text) ?? 0;
  }

  @override
  set text(String newText) {
    double? value =
        double.tryParse(newText.replaceAll('.', '').replaceAll(',', '.'));
    super.text = formatCurrency(value ?? 0);
  }

  void setValue(String value) {
    double? newValue =
        double.tryParse(value.replaceAll('.', '').replaceAll(',', '.'));
    super.text = formatCurrency(newValue ?? 0);
  }

  void updateText(String? value) {
    if (value != null) {
      double? numericValue =
          double.tryParse(value.replaceAll('.', '').replaceAll(',', '.'));
      if (numericValue != null) {
        super.text = formatCurrency(numericValue);
        super.selection = TextSelection.collapsed(offset: super.text.length);
      }
    }
  }
}
