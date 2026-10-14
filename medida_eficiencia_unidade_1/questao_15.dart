// Questão 15
// Faça um algoritmo para ler o número e o peso de N bois de uma fazenda, armazene estes dados em um vetor e, em seguida, possibilite que sejam feitas várias pesquisas, onde o fazendeiro digitará um intervalo para os pesos e, então, o algoritmo deve fornecer uma impressão de todos os bois com peso dentro desse intervalo.

import 'dart:io';

class Boi {
  final int numero;
  final double peso;
  Boi(this.numero, this.peso);
}

String ler(String rotulo) {
  stdout.write('$rotulo: ');
  return stdin.readLineSync()!.trim();
}

List<Boi> cadastrarRebanho() {
  int n = int.parse(ler('Quantidade de bois'));
  return [
    for (int i = 1; i <= n; i++)
      Boi(
        int.parse(ler('Número do boi $i')),
        double.parse(ler('Peso do boi $i (kg)')),
      )
  ];
}

List<Boi> buscarPorFaixa(List<Boi> rebanho, double minimo, double maximo) =>
    rebanho.where((b) => b.peso >= minimo && b.peso <= maximo).toList();

void main() {
  final rebanho = cadastrarRebanho();

  do {
    double minimo = double.parse(ler('Peso inicial da faixa'));
    double maximo = double.parse(ler('Peso final da faixa'));

    final achados = buscarPorFaixa(rebanho, minimo, maximo);
    if (achados.isEmpty) {
      print('Nenhum boi nessa faixa de peso.');
    } else {
      for (var b in achados) {
        print('Boi nº ${b.numero}: ${b.peso} kg');
      }
    }
  } while (ler('Nova pesquisa? (S/N)').toUpperCase() == 'S');
}
