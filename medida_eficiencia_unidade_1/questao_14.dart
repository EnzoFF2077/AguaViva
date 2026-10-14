// Questão 14
// Faça um algoritmo que leia o tamanho e os elementos de dois vetores ordenados e, em seguida, gere um terceiro vetor também ordenado. Obs: o usuário deverá digitar os dois vetores obrigatoriamente.

import 'dart:io';

List<int> lerVetorOrdenado(String nome) {
  stdout.write('Tamanho do vetor $nome: ');
  int tamanho = int.parse(stdin.readLineSync()!);
  final vetor = <int>[];
  while (vetor.length < tamanho) {
    stdout.write('$nome[${vetor.length}]: ');
    int valor = int.parse(stdin.readLineSync()!);
    if (vetor.isNotEmpty && valor < vetor.last) {
      print('O vetor deve estar em ordem crescente. Digite novamente.');
      continue;
    }
    vetor.add(valor);
  }
  return vetor;
}

// Intercala dois vetores já ordenados (etapa "merge" do merge sort)
List<int> intercalar(List<int> x, List<int> y) {
  final resultado = <int>[];
  int i = 0, j = 0;
  while (i < x.length || j < y.length) {
    bool pegaDoX = j >= y.length || (i < x.length && x[i] <= y[j]);
    resultado.add(pegaDoX ? x[i++] : y[j++]);
  }
  return resultado;
}

void main() {
  final a = lerVetorOrdenado('A');
  final b = lerVetorOrdenado('B');
  print('Vetor resultante: ${intercalar(a, b)}');
}
