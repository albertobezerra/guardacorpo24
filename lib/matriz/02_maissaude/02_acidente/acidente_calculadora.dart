import 'package:flutter/material.dart';

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

  // Função para calcular o prejuízo
  void calcularPrejuizo() {
    try {
      double salario = double.tryParse(_salarioController.text) ?? 0;
      int horasPorDia = int.tryParse(_horasPorDiaController.text) ?? 0;
      int diasTrabalhados = int.tryParse(_diasTrabalhadosController.text) ?? 0;
      double gastosAdicionais =
          double.tryParse(_gastosAdicionaisController.text) ?? 0;

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

      // Cálculo do custo por 15 dias de afastamento
      int horasPerdidas = horasPorDia * 15; // Horas perdidas em 15 dias
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Prejuízo Acidente de Trabalho'),
        backgroundColor: Colors.blue, // Cor de fundo da AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _salarioController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Salário Mensal',
                prefixText: 'R\$ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _horasPorDiaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Horas Trabalhadas por Dia',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _diasTrabalhadosController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Dias Trabalhados no Mês',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _gastosAdicionaisController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Gastos Adicionais (Médicos/Hospitalares)',
                prefixText: 'R\$ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: calcularPrejuizo,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Calcular Prejuízo',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 24),
            if (totalPrejuizo > 0)
              Card(
                color: Colors.red[100],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total de Prejuízo: R\$ ${totalPrejuizo.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
