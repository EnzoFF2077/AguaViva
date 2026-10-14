// Questão 07
// Leia o número de termos e calcule o valor da seguinte série: S = X²/1! + X³/2! + X⁴/3! + X⁵/4! + X⁶/3! + X⁷/2! + X⁸/1! + X⁹/2! + X¹⁰/3! + X¹¹/4! ...

import 'dart:io';
import 'dart:math';

int fatorial(int n) {
  int resultado = 1;
  for (int i = 2; i <= n; i++) resultado *= i;
  return resultado;
}

// Denominadores seguem o ciclo 1, 2, 3, 4, 3, 2, 1, 2, 3, 4, ...
// Fora o primeiro termo, o padrão 2, 3, 4, 3, 2, 1 se repete a cada 6
int baseDoFatorial(int k) {
  if (k == 1) return 1;
  const ciclo = [2, 3, 4, 3, 2, 1];
  return ciclo[(k - 2) % 6];
}

double serie(double x, int termos) {
  double s = 0;
  for (int k = 1; k <= termos; k++) {
    s += pow(x, k + 1) / fatorial(baseDoFatorial(k));
  }
  return s;
}

void main() {
  stdout.write('Valor de X: ');
  double x = double.parse(stdin.readLineSync()!);
  stdout.write('Quantidade de termos: ');
  int n = int.parse(stdin.readLineSync()!);

  print('S = ${serie(x, n)}');
}
