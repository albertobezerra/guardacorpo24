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
  final TextEditingController _salarioController =
      TextEditingController(text: '1518,00');
  final TextEditingController _horasPorDiaController =
      TextEditingController(text: '8');
  final TextEditingController _inssPercentualController =
      TextEditingController(text: '9');
  final TextEditingController _fgtsPercentualController =
      TextEditingController(text: '8');
  final TextEditingController _gastosAdicionaisController =
      TextEditingController();

  double totalPrejuizo = 0;
  int diasAfastamento = 1; // Inicia com 1 dia
  double fgtsValor = 0;
  double inssValor = 0;
  double feriasValor = 0;

  void calcularPrejuizo() {
    try {
      NumberFormat numberFormat =
          NumberFormat.currency(locale: 'pt_BR', symbol: '');
      double salario = double.tryParse(numberFormat
              .parse(_salarioController.text.replaceAll('R\$ ', ''))
              .toString()) ??
          0;
      int horasPorDia = int.tryParse(_horasPorDiaController.text) ?? 0;
      double inssPercentual =
          double.tryParse(_inssPercentualController.text) ?? 9;
      double fgtsPercentual =
          double.tryParse(_fgtsPercentualController.text) ?? 8;
      double gastosAdicionais = double.tryParse(_gastosAdicionaisController.text
              .replaceAll('R\$ ', '')
              .replaceAll('.', '')
              .replaceAll(',', '.')) ??
          0;

      if (salario == 0 || horasPorDia == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Preencha todos os campos corretamente.')),
        );
        return;
      }

      // Cálculo dos encargos sociais
      fgtsValor = (salario * fgtsPercentual / 100); // FGTS (%)
      inssValor = (salario * inssPercentual / 100); // INSS (%)
      feriasValor = salario / 12; // Férias (1/12 do salário)

      // Valor da hora trabalhada
      int horasTotaisMes = horasPorDia * 30; // Considerando 30 dias no mês
      double valorHora = salario / horasTotaisMes;

      // Cálculo do custo por dias de afastamento selecionados
      int horasPerdidas = horasPorDia * diasAfastamento; // Horas perdidas
      double custoAfastamento = horasPerdidas * valorHora;

      // Total de prejuízo
      double total = custoAfastamento +
          fgtsValor +
          inssValor +
          feriasValor +
          gastosAdicionais;

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
  void initState() {
    super.initState();
    calcularPrejuizo(); // Realiza o cálculo inicial ao carregar a tela
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
                          onChanged: (value) => calcularPrejuizo(),
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Padrão: 9% (${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(inssValor)})',
                          style: const TextStyle(fontSize: 14),
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
                          onChanged: (value) => calcularPrejuizo(),
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Padrão: 8% (${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(fgtsValor)})',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Férias (Fração)
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: OutlinedTextField3(
                          controller: TextEditingController(
                              text: '1/12'), // Fixo como fração
                          labelText: 'Férias (1/12)',
                          obscureText: false,
                          textCapitalization: TextCapitalization.none,
                          enabled: false, // Desabilita edição
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Valor: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(feriasValor)}',
                          style: const TextStyle(fontSize: 14),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total de Prejuízo: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(totalPrejuizo)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'FGTS: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(fgtsValor)}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            'INSS: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(inssValor)}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            'Férias: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(feriasValor)}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        ],
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
