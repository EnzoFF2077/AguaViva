// Questão 13
// Faça um algoritmo para ler um conjunto N de números inteiros e imprimir cada elemento do conjunto e quantas vezes ele se repete. Ex.: vetor lido 3 8 5 3 8 7 3 7 3 7 → resultado 3–4, 8–2, 5–1, 7–3. OBS.: O valor de N será lido.

import 'dart:io';

List<int> lerConjunto() {
  stdout.write('Valor de N: ');
  int n = int.parse(stdin.readLineSync()!);
  return List.generate(n, (i) {
    stdout.write('Elemento ${i + 1}: ');
    return int.parse(stdin.readLineSync()!);
  });
}

Map<int, int> contarOcorrencias(List<int> valores) {
  final frequencia = <int, int>{}; // mantém a ordem da primeira aparição
  for (var v in valores) {
    frequencia.update(v, (qtd) => qtd + 1, ifAbsent: () => 1);
  }
  return frequencia;
}

void main() {
  final conjunto = lerConjunto();
  contarOcorrencias(conjunto).forEach((valor, vezes) {
    print('$valor – $vezes');
  });
}
