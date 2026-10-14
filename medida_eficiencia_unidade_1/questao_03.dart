// Questão 03
// Faça um algoritmo que imprima a série abaixo, o número de termos será lido. S = 1 5 100 2 10 90 4 15 80 8 20 70 16 25 60 32 30 50 64 35 40 128 40 30 256 ...

import 'dart:io';
import 'dart:math';

// Cada grupo de 3 termos segue três sequências:
// potências de 2, múltiplos de 5 e 100 decrescendo de 10 em 10
int termoDaSerie(int posicao) {
  int grupo = (posicao - 1) ~/ 3;
  switch ((posicao - 1) % 3) {
    case 0:
      return pow(2, grupo).toInt();
    case 1:
      return 5 * (grupo + 1);
    default:
      return 100 - 10 * grupo;
  }
}

void main() {
  stdout.write('Quantidade de termos: ');
  int n = int.parse(stdin.readLineSync()!);

  final serie = List.generate(n, (i) => termoDaSerie(i + 1));
  print('S = ${serie.join(' ')}');
}
