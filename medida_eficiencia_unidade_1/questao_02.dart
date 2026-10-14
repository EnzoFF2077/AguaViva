// Questão 02
// Faça um algoritmo para ler o número de termos e calcular o valor da série abaixo: S = 3^4!/5 + 5^8!/10 + 7^12!/15 – 9^16!/20 + 11^20!/25 – 13^24!/30 + 15^28!/35 ...

import 'dart:io';
import 'dart:math';

int lerInteiro(String mensagem) {
  stdout.write(mensagem);
  return int.parse(stdin.readLineSync()!);
}

double fatorial(int n) => n <= 1 ? 1 : n * fatorial(n - 1);

// Termos 4, 6, 8, ... são subtraídos; os demais são somados
int sinalDoTermo(int k) => (k >= 4 && k.isEven) ? -1 : 1;

double calcularSerie(int qtdTermos) {
  double soma = 0;
  for (int k = 1; k <= qtdTermos; k++) {
    int base = 2 * k + 1;
    int expoente = 4 * k;
    int divisor = 5 * k;
    double termo = pow(base, fatorial(expoente)) / divisor;
    soma += sinalDoTermo(k) * termo;
  }
  return soma;
}

void main() {
  int termos = lerInteiro('Quantidade de termos: ');
  print('S = ${calcularSerie(termos)}');
}
