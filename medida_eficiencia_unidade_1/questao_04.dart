// Questão 04
// Elabore um algoritmo para ler a matrícula, nome, sexo (“M” e “F”), três notas e o número de faltas dos alunos de uma escola, onde o FLAG é a matrícula = ’00000’. E imprima: a) A média da turma. b) O percentual de alunos aprovados. c) A matrícula do aluno do sexo masculino e feminino que possui a maior média e que foi aprovado. d) A média dos alunos do sexo feminino. Obs: Considere para aprovação a média 7,0 e o limite de faltas 18.

import 'dart:io';

class Aluno {
  String matricula, nome, sexo;
  double media;
  int faltas;

  Aluno(this.matricula, this.nome, this.sexo, this.media, this.faltas);

  bool get aprovado => media >= 7.0 && faltas <= 18;
}

String ler(String rotulo) {
  stdout.write('$rotulo: ');
  return stdin.readLineSync()!.trim();
}

Aluno? lerAluno() {
  String matricula = ler('Matrícula (00000 encerra)');
  if (matricula == '00000') return null;
  String nome = ler('Nome');
  String sexo = ler('Sexo (M/F)').toUpperCase();
  double soma = 0;
  for (int i = 1; i <= 3; i++) {
    soma += double.parse(ler('Nota $i'));
  }
  int faltas = int.parse(ler('Faltas'));
  return Aluno(matricula, nome, sexo, soma / 3, faltas);
}

double mediaDe(List<Aluno> lista) {
  if (lista.isEmpty) return 0;
  return lista.map((a) => a.media).reduce((x, y) => x + y) / lista.length;
}

String melhorAprovado(List<Aluno> alunos, String sexo) {
  Aluno? melhor;
  for (var a in alunos) {
    bool candidato = a.sexo == sexo && a.aprovado;
    if (candidato && (melhor == null || a.media > melhor.media)) {
      melhor = a;
    }
  }
  return melhor?.matricula ?? 'nenhum';
}

void main() {
  List<Aluno> turma = [];
  Aluno? atual;
  while ((atual = lerAluno()) != null) {
    turma.add(atual!);
  }

  if (turma.isEmpty) {
    print('Nenhum aluno cadastrado.');
    return;
  }

  int aprovados = turma.where((a) => a.aprovado).length;
  var meninas = turma.where((a) => a.sexo == 'F').toList();

  print('a) Média da turma: ${mediaDe(turma).toStringAsFixed(2)}');
  double percAprov = aprovados * 100 / turma.length;
  print('b) Aprovados: ${percAprov.toStringAsFixed(1)}%');
  print('c) Maior média aprovado (M): ${melhorAprovado(turma, 'M')}');
  print('   Maior média aprovada (F): ${melhorAprovado(turma, 'F')}');
  print('d) Média do sexo feminino: ${mediaDe(meninas).toStringAsFixed(2)}');
}
