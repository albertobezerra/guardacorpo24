import 'package:flutter/material.dart';
import 'package:guarda_corpo_2024/components/customizacao/outlined_text_field_inspecoes.dart';
import 'package:intl/intl.dart';

class CalculadoraAcidente extends StatefulWidget {
  const CalculadoraAcidente({super.key});

  @override
  CalculadoraAcidenteState createState() => CalculadoraAcidenteState();
}

class CalculadoraAcidenteState extends State<CalculadoraAcidente> {
  // Controladores para os inputs
  final TextEditingController _salarioController = TextEditingController();
  final TextEditingController _horasPorDiaController = TextEditingController();
  final TextEditingController _diasTrabalhadosController =
      TextEditingController();
  final TextEditingController _gastosAdicionaisController =
      TextEditingController();

  double totalPrejuizo = 0;
  int diasAfastamento = 15; // Valor inicial do slider

  void calcularPrejuizo() {
    try {
      double salario = double.tryParse(_salarioController.text
              .replaceAll('.', '')
              .replaceAll(',', '.')) ??
          0;
      int horasPorDia = int.tryParse(_horasPorDiaController.text) ?? 0;
      int diasTrabalhados = int.tryParse(_diasTrabalhadosController.text) ?? 0;
      double gastosAdicionais = double.tryParse(_gastosAdicionaisController.text
              .replaceAll('.', '')
              .replaceAll(',', '.')) ??
          0;

      if (salario == 0 || horasPorDia == 0 || diasTrabalhados == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Preencha todos os campos corretamente.')),
        );
        return;
      }

      // Cálculo dos encargos sociais
      double fgts = salario * 0.08; // FGTS (8%)
      double inss = salario * 0.09; // INSS (9%)
      double ferias = salario / 12; // Férias (1/12 do salário anual)

      // Valor da hora trabalhada
      int horasTotaisMes = horasPorDia * diasTrabalhados;
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
                    obscureText: false,
                    textCapitalization: TextCapitalization.none,
                    onChanged: (value) {},
                    maxLines: 1,
                  ),
                  const SizedBox(height: 16),

                  // Horas Trabalhadas por Dia
                  OutlinedTextField3(
                    controller: _horasPorDiaController,
                    labelText: 'Horas Trabalhadas por Dia',
                    obscureText: false,
                    textCapitalization: TextCapitalization.none,
                    onChanged: (value) {},
                    maxLines: 1,
                  ),
                  const SizedBox(height: 16),

                  // Dias Trabalhados no Mês
                  OutlinedTextField3(
                    controller: _diasTrabalhadosController,
                    labelText: 'Dias Trabalhados no Mês',
                    obscureText: false,
                    textCapitalization: TextCapitalization.none,
                    onChanged: (value) {},
                    maxLines: 1,
                  ),
                  const SizedBox(height: 16),

                  // Gastos Adicionais
                  OutlinedTextField3(
                    controller: _gastosAdicionaisController,
                    labelText: 'Gastos Adicionais',
                    obscureText: false,
                    textCapitalization: TextCapitalization.none,
                    onChanged: (value) {},
                    maxLines: 1,
                  ),
                  const SizedBox(height: 16),

                  // Slider para Dias de Afastamento
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: diasAfastamento.toDouble(),
                          min: 0,
                          max: 15,
                          divisions: 15,
                          label: '$diasAfastamento dias',
                          activeColor: buttonColor,
                          inactiveColor: Colors.grey,
                          onChanged: (value) {
                            setState(() {
                              diasAfastamento = value.toInt();
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

                  // Botão de Cálculo
                  ElevatedButton(
                    onPressed: calcularPrejuizo,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 24.0,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Segoe Bold',
                      ),
                    ),
                    child: Text('Calcular Prejuízo'.toUpperCase()),
                  ),
                  const SizedBox(height: 24),

                  // Resultado do Cálculo
                  if (totalPrejuizo > 0)
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
