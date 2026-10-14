// Questão 10
// Uma empresa decidiu fazer um levantamento sobre o perfil de candidatos que se apresentarem para o preenchimento de vagas. Para cada candidato serão solicitados o nome, o sexo, a idade e se tem ou não experiência no serviço. O Flag é o nome FIM. Calcular e imprimir: a) O número de candidatos do sexo feminino e masculino. b) A idade média dos homens que já têm experiência no serviço. c) A porcentagem dos homens com mais de 45 anos com relação ao total de homens. d) O número de mulheres com idade inferior a 30 anos e com experiência no serviço. e) O nome da candidata com a menor idade que já tem experiência no serviço.

import 'dart:io';

String ler(String rotulo) {
  stdout.write('$rotulo: ');
  return stdin.readLineSync()!.trim();
}

void main() {
  int qtdHomens = 0, qtdMulheres = 0;
  int homensExperientes = 0, somaIdadesHomensExp = 0;
  int homensAcima45 = 0, mulheresJovensExp = 0;
  String? maisNovaExp;
  int idadeMaisNovaExp = 0;

  for (String nome = ler('Nome (FIM encerra)');
      nome.toUpperCase() != 'FIM';
      nome = ler('Nome (FIM encerra)')) {
    String sexo = ler('Sexo (M/F)').toUpperCase();
    int idade = int.parse(ler('Idade'));
    bool experiente = ler('Tem experiência? (S/N)').toUpperCase() == 'S';

    if (sexo == 'M') {
      qtdHomens++;
      if (idade > 45) homensAcima45++;
      if (experiente) {
        homensExperientes++;
        somaIdadesHomensExp += idade;
      }
    } else {
      qtdMulheres++;
      if (experiente) {
        if (idade < 30) mulheresJovensExp++;
        if (maisNovaExp == null || idade < idadeMaisNovaExp) {
          maisNovaExp = nome;
          idadeMaisNovaExp = idade;
        }
      }
    }
  }

  String idadeMedia = homensExperientes == 0
      ? '-'
      : (somaIdadesHomensExp / homensExperientes).toStringAsFixed(1);
  String percAcima45 = qtdHomens == 0
      ? '-'
      : '${(homensAcima45 * 100 / qtdHomens).toStringAsFixed(1)}%';

  print('a) Mulheres: $qtdMulheres | Homens: $qtdHomens');
  print('b) Idade média dos homens experientes: $idadeMedia');
  print('c) Homens com mais de 45 anos: $percAcima45');
  print('d) Mulheres < 30 anos com experiência: $mulheresJovensExp');
  print('e) Mais nova com experiência: ${maisNovaExp ?? 'nenhuma'}');
}
