// Questão 16
// Construa um algoritmo para ler o tamanho e os elementos de 4 vetores e responda: a) Gere um quinto vetor com os valores dos outros vetores de forma ordenada. b) Gere um vetor só com os elementos que tenham interseção com os 4 vetores.

import 'dart:io';

List<int> lerVetor(int indice) {
  stdout.write('Tamanho do vetor $indice: ');
  int tamanho = int.parse(stdin.readLineSync()!);
  return List.generate(tamanho, (i) {
    stdout.write('V$indice[$i]: ');
    return int.parse(stdin.readLineSync()!);
  });
}

// Ordenação por inserção
List<int> ordenar(List<int> origem) {
  final v = List<int>.from(origem);
  for (int i = 1; i < v.length; i++) {
    int chave = v[i];
    int j = i - 1;
    while (j >= 0 && v[j] > chave) {
      v[j + 1] = v[j];
      j--;
    }
    v[j + 1] = chave;
  }
  return v;
}

List<int> intersecao(List<List<int>> vetores) {
  Set<int> comum = vetores.first.toSet();
  for (var v in vetores.skip(1)) {
    comum = comum.intersection(v.toSet());
  }
  return ordenar(comum.toList());
}

void main() {
  final vetores = [for (int k = 1; k <= 4; k++) lerVetor(k)];

  final juntos = vetores.expand((v) => v).toList();
  print('a) Quinto vetor ordenado: ${ordenar(juntos)}');
  print('b) Interseção dos 4 vetores: ${intersecao(vetores)}');
}
