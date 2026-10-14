// Questão 09
// Existem números que têm a seguinte característica: 3025 = 30 + 25 = 55 * 55 = 3025. Faça um algoritmo para imprimir todos os números entre 1000 e 9999 que tenham tal característica.

bool temPropriedade(int numero) {
  int esquerda = numero ~/ 100;
  int direita = numero % 100;
  int soma = esquerda + direita;
  return soma * soma == numero;
}

void main() {
  final encontrados = [
    for (int n = 1000; n <= 9999; n++)
      if (temPropriedade(n)) n
  ];
  encontrados.forEach(print);
}
