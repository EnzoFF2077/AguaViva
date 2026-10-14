// Questão 06
// Levando em consideração que a função Random(N) gera um número aleatório entre 1 e N, faça um algoritmo que gere um número aleatório entre 1 e 100. E, então, permita que o usuário digite números, neste intervalo, até que acerte o número gerado. A cada número digitado, o novo intervalo deverá ser impresso, limitando os valores a serem chutados. Ex: se o número for 23 e o usuário digitar 40, deverá ser impresso “O número está entre 0 e 40”.

import 'dart:io';
import 'dart:math';

// Equivalente à função Random(N): sorteia de 1 até N
int sortear(int n) => Random().nextInt(n) + 1;

void main() {
  final secreto = sortear(100);
  int inferior = 0, superior = 100, tentativas = 0;

  while (true) {
    stdout.write('Seu palpite ($inferior a $superior): ');
    int palpite = int.parse(stdin.readLineSync()!);
    tentativas++;

    if (palpite == secreto) break;

    if (palpite < secreto) {
      inferior = max(inferior, palpite);
    } else {
      superior = min(superior, palpite);
    }
    print('O número está entre $inferior e $superior');
  }

  print('Parabéns! Você acertou o $secreto em $tentativas tentativa(s).');
}
