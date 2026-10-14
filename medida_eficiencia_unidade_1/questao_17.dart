// Questão 17
// Faça um algoritmo utilizando procedimento ou funções que leia dois vetores, gere e imprima um terceiro vetor que seja a soma dos dois vetores lidos e imprima também a soma de todos os elementos deste 3º vetor.

import 'dart:io';

void preencherVetor(List<int> vetor, String nome) {
  for (int i = 0; i < vetor.length; i++) {
    stdout.write('$nome[$i]: ');
    vetor[i] = int.parse(stdin.readLineSync()!);
  }
}

List<int> somarVetores(List<int> a, List<int> b) =>
    List.generate(a.length, (i) => a[i] + b[i]);

int totalDosElementos(List<int> v) => v.fold(0, (acc, x) => acc + x);

void imprimirResultado(List<int> v) {
  print('Terceiro vetor: $v');
  print('Soma de todos os elementos: ${totalDosElementos(v)}');
}

void main() {
  stdout.write('Tamanho dos vetores: ');
  int n = int.parse(stdin.readLineSync()!);

  final primeiro = List<int>.filled(n, 0);
  final segundo = List<int>.filled(n, 0);
  preencherVetor(primeiro, 'A');
  preencherVetor(segundo, 'B');

  imprimirResultado(somarVetores(primeiro, segundo));
}
