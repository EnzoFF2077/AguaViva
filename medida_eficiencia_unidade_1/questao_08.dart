// Questão 08
// A Universidade Tiradentes estará realizando o Concurso Vestibular para os cursos de Ciência da Computação e Sistemas de Informação. Para cada candidato são lidos: a) Código (FLAG ’0000’) b) Curso (CC ou SI) c) Nome d) Sexo e) Pontuação (0-5000). Informações desejadas: a) O código, nome e pontuação dos candidatos, independente do sexo, do curso de Ciência da Computação que fizeram mais de 2500 pontos. b) O nome do candidato do sexo masculino que teve a menor pontuação geral. c) O código do candidato do sexo masculino que teve a maior pontuação para o curso de Sistemas de Informação. d) O percentual geral de candidatos do sexo Masculino e Feminino inscritos no vestibular.

import 'dart:io';

class Candidato {
  final String codigo, curso, nome, sexo;
  final int pontos;
  Candidato(this.codigo, this.curso, this.nome, this.sexo, this.pontos);
}

String ler(String rotulo) {
  stdout.write('$rotulo: ');
  return stdin.readLineSync()!.trim();
}

List<Candidato> lerCandidatos() {
  final lista = <Candidato>[];
  while (true) {
    String codigo = ler('Código (0000 encerra)');
    if (codigo == '0000') break;
    lista.add(Candidato(
      codigo,
      ler('Curso (CC/SI)').toUpperCase(),
      ler('Nome'),
      ler('Sexo (M/F)').toUpperCase(),
      int.parse(ler('Pontuação (0-5000)')),
    ));
  }
  return lista;
}

String percentual(int parte, int total) =>
    '${(parte * 100 / total).toStringAsFixed(1)}%';

void main() {
  final candidatos = lerCandidatos();
  if (candidatos.isEmpty) return;

  final homens = candidatos.where((c) => c.sexo == 'M').toList();
  final mulheres = candidatos.length - homens.length;

  print('a) Candidatos de CC com mais de 2500 pontos:');
  for (var c in candidatos.where((c) => c.curso == 'CC' && c.pontos > 2500)) {
    print('   ${c.codigo} | ${c.nome} | ${c.pontos}');
  }

  if (homens.isNotEmpty) {
    homens.sort((a, b) => a.pontos.compareTo(b.pontos));
    print('b) Homem com menor pontuação geral: ${homens.first.nome}');

    final homensSI = homens.where((c) => c.curso == 'SI').toList();
    if (homensSI.isNotEmpty) {
      print('c) Maior pontuação masculina em SI: ${homensSI.last.codigo}');
    }
  }

  print('d) Masculino: ${percentual(homens.length, candidatos.length)}'
      ' | Feminino: ${percentual(mulheres, candidatos.length)}');
}
