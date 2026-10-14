// Questão 05
// Faça um algoritmo para ler o Nome, Sexo (M ou F) e o peso dos recém-nascidos de uma maternidade e de acordo com a tabela abaixo imprima: a) Para cada recém-nascido: o nome, o sexo e a classificação quanto ao peso. b) O nome do recém-nascido do sexo feminino com o maior peso. c) O percentual de recém-nascidos em cada classificação de peso. (0 <= Peso <= 2 kg: Baixo Peso; 2 < Peso <= 4 kg: Normal; Acima de 4 kg: Alto Peso)

import 'dart:io';

String classificarPeso(double peso) {
  if (peso <= 2) return 'Baixo Peso';
  if (peso <= 4) return 'Normal';
  return 'Alto Peso';
}

String ler(String rotulo) {
  stdout.write('$rotulo: ');
  return stdin.readLineSync()!.trim();
}

void main() {
  Map<String, int> contagem = {'Baixo Peso': 0, 'Normal': 0, 'Alto Peso': 0};
  String meninaMaisPesada = '';
  double pesoMaximoF = -1;

  String nome = ler('Nome do recém-nascido (FIM encerra)');
  while (nome.toUpperCase() != 'FIM') {
    String sexo = ler('Sexo (M/F)').toUpperCase();
    double peso = double.parse(ler('Peso (kg)'));

    String classe = classificarPeso(peso);
    contagem[classe] = contagem[classe]! + 1;
    print('-> $nome | $sexo | $classe');

    if (sexo == 'F' && peso > pesoMaximoF) {
      pesoMaximoF = peso;
      meninaMaisPesada = nome;
    }
    nome = ler('Nome do recém-nascido (FIM encerra)');
  }

  int total = contagem.values.fold(0, (a, b) => a + b);
  if (total == 0) return;

  print('b) Menina com maior peso: $meninaMaisPesada');
  print('c) Percentual por classificação:');
  contagem.forEach((classe, qtd) {
    print('   $classe: ${(qtd * 100 / total).toStringAsFixed(1)}%');
  });
}
