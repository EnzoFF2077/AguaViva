// Questão 11
// Faça um algoritmo para ler o código, nome, sexo e número de horas de aula dadas no mês dos professores de uma Universidade, sabendo que por cada hora de aula um professor ganha R$ 12,30. Emita uma listagem contendo o código, nome, salário bruto e salário líquido de todos os professores lidos e no final imprima a média dos salários líquidos de cada sexo. Observações: o desconto para os homens é 10% e para as mulheres é 5%; o FLAG é o código ’9999’.

import 'dart:io';

const double valorHoraAula = 12.30;

double descontoPorSexo(String sexo) => sexo == 'M' ? 0.10 : 0.05;

String ler(String rotulo) {
  stdout.write('$rotulo: ');
  return stdin.readLineSync()!.trim();
}

String reais(double valor) => 'R\$ ${valor.toStringAsFixed(2)}';

void main() {
  final listagem = StringBuffer();
  final somaLiquido = {'M': 0.0, 'F': 0.0};
  final quantidade = {'M': 0, 'F': 0};

  String codigo = ler('Código (9999 encerra)');
  while (codigo != '9999') {
    String nome = ler('Nome');
    String sexo = ler('Sexo (M/F)').toUpperCase() == 'M' ? 'M' : 'F';
    double horas = double.parse(ler('Horas-aula no mês'));

    double bruto = horas * valorHoraAula;
    double liquido = bruto * (1 - descontoPorSexo(sexo));

    listagem.writeln('$codigo | $nome | '
        'Bruto: ${reais(bruto)} | Líquido: ${reais(liquido)}');
    somaLiquido[sexo] = somaLiquido[sexo]! + liquido;
    quantidade[sexo] = quantidade[sexo]! + 1;

    codigo = ler('Código (9999 encerra)');
  }

  print('\n--- Listagem de professores ---');
  stdout.write(listagem);

  for (var s in ['M', 'F']) {
    if (quantidade[s]! > 0) {
      double media = somaLiquido[s]! / quantidade[s]!;
      print('Média do salário líquido ($s): ${reais(media)}');
    }
  }
}
