// Questão 12
// Escreva um algoritmo que leia um número e o imprima de trás para frente. Exemplo: 6042 (impressão: 2406).

import 'dart:io';

int inverter(int numero) {
  int resultado = 0;
  while (numero > 0) {
    resultado = resultado * 10 + numero % 10;
    numero ~/= 10;
  }
  return resultado;
}

void main() {
  stdout.write('Informe um número: ');
  String entrada = stdin.readLineSync()!.trim();

  // Usa os dígitos como texto para manter zeros finais (ex.: 6040 -> 0406)
  String invertido = entrada.split('').reversed.join();
  print('Impressão: $invertido');

  // Versão numérica, usando só operações aritméticas
  print('Valor invertido: ${inverter(int.parse(entrada))}');
}
