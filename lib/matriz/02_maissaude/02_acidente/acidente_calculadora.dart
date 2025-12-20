import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guarda_corpo_2024/services/admob/components/banner.dart';
import 'package:intl/intl.dart';
import '../../../components/customizacao/outlined_text_field_inspecoes.dart';

class CalculadoraAcidente extends StatefulWidget {
  const CalculadoraAcidente({super.key});

  @override
  CalculadoraAcidenteState createState() => CalculadoraAcidenteState();
}

class CalculadoraAcidenteState extends State<CalculadoraAcidente> {
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
  int diasAfastamento = 1;
  final Color primaryColor = const Color(0xFF006837);

  @override
  void initState() {
    super.initState();
    calcularPrejuizo();
  }

  void calcularPrejuizo() {
    try {
      String salarioRaw =
          _salarioController.text.replaceAll('.', '').replaceAll(',', '.');
      double salario = double.tryParse(salarioRaw) ?? 0;
      int horasPorDia = int.tryParse(_horasPorDiaController.text) ?? 0;
      double inssPercentual =
          double.tryParse(_inssPercentualController.text) ?? 9;
      double fgtsPercentual =
          double.tryParse(_fgtsPercentualController.text) ?? 8;
      double gastosAdicionais = _gastosAdicionaisController.getDoubleValue();

      if (salario == 0 || horasPorDia == 0) return;

      double fgts = (salario * fgtsPercentual / 100);
      double inss = (salario * inssPercentual / 100);
      double ferias = salario / 12;
      int horasTotaisMes = horasPorDia * 30;
      double valorHora = salario / horasTotaisMes;
      int horasPerdidas = horasPorDia * diasAfastamento;
      double custoAfastamento = horasPerdidas * valorHora;

      setState(() {
        totalPrejuizo =
            custoAfastamento + fgts + inss + ferias + gastosAdicionais;
      });
    } catch (e) {
      debugPrint("Erro no cálculo");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'CALCULADORA DE CUSTO',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: primaryColor,
            fontSize: 16,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionHeader('Dados do Funcionário'),
                  const SizedBox(height: 16),

                  OutlinedTextField3(
                    controller: _salarioController,
                    labelText: 'Salário Mensal',
                    prefixText: 'R\$ ',
                    keyboardType: TextInputType.number,
                    onChanged: (value) => calcularPrejuizo(),
                    // Argumentos obrigatórios adicionados:
                    textCapitalization: TextCapitalization.none,
                    obscureText: false,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 16),

                  OutlinedTextField3(
                    controller: _horasPorDiaController,
                    labelText: 'Horas/Dia',
                    keyboardType: TextInputType.number,
                    onChanged: (value) => calcularPrejuizo(),
                    // Argumentos obrigatórios adicionados:
                    textCapitalization: TextCapitalization.none,
                    obscureText: false,
                    maxLines: 1,
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader('Encargos (%)'),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedTextField3(
                          controller: _inssPercentualController,
                          labelText: 'INSS (%)',
                          keyboardType: TextInputType.number,
                          onChanged: (value) => calcularPrejuizo(),
                          // Argumentos obrigatórios adicionados:
                          textCapitalization: TextCapitalization.none,
                          obscureText: false,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedTextField3(
                          controller: _fgtsPercentualController,
                          labelText: 'FGTS (%)',
                          keyboardType: TextInputType.number,
                          onChanged: (value) => calcularPrejuizo(),
                          // Argumentos obrigatórios adicionados:
                          textCapitalization: TextCapitalization.none,
                          obscureText: false,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader('Custos Extras'),
                  const SizedBox(height: 16),

                  OutlinedTextField3(
                    controller: _gastosAdicionaisController,
                    labelText: 'Gastos Adicionais',
                    prefixText: 'R\$ ',
                    keyboardType: TextInputType.number,
                    onChanged: (value) => calcularPrejuizo(),
                    // Argumentos obrigatórios adicionados:
                    textCapitalization: TextCapitalization.none,
                    obscureText: false,
                    maxLines: 1,
                  ),

                  const SizedBox(height: 32),

                  // Slider
                  Text(
                    'Dias de Afastamento: $diasAfastamento',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  Slider(
                    value: diasAfastamento.toDouble(),
                    min: 1,
                    max: 30,
                    divisions: 29,
                    activeColor: primaryColor,
                    inactiveColor: Colors.grey[200],
                    onChanged: (value) {
                      setState(() {
                        diasAfastamento = value.toInt();
                        calcularPrejuizo();
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Card Resultado
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(
                              alpha: 0.3), // Corrigido para .withValues
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'PREJUÍZO ESTIMADO',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 12,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                              .format(totalPrejuizo),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.grey[500],
        letterSpacing: 1.0,
      ),
    );
  }
}

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
}
