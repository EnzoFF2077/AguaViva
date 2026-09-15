# ÁguaViva

Aplicativo em planejamento para a disciplina de Programação para Dispositivos Móveis, voltado ao registro colaborativo de suspeitas de contaminação da água e à comunicação com a Vigilância Sanitária municipal.

O projeto atende moradores de áreas rurais e comunidades com saneamento precário, agentes de saúde e órgãos responsáveis pelo atendimento. A proposta inclui registros com foto e localização, armazenamento local para envio quando houver internet, acompanhamento das notificações e orientações preventivas com linguagem acessível.

## Informações da turma

- **Curso:** Ciência da Computação (CC) - Noite
- **Dia:** Terça-feira
- **Sala:** A22

## Integrantes e responsabilidades

### Atividade 01 — Estudo de caso

| Integrante | Responsabilidade |
| --- | --- |
| Enzo Figueiredo | Criação do repositório e elaboração da análise do estudo de caso. |
| Guilherme Silva (GuiRodriSil) | Elaboração da análise do estudo de caso. |
| Gabriel Almeida (Gabriel-Almeida0) | Elaboração da análise do estudo de caso. |
| Guilherme Oliveira (guilherme-Oliveira3) | Estruturação da documentação no repositório e do README.md. |
| Guilherme Eugenio | Elaboração da análise do estudo de caso. |

### Atividade 02 — Pesquisa, benchmark e personas

Responsabilidades informadas pelo grupo para esta atividade:

| Integrante | Responsabilidade |
| --- | --- |
| Enzo Figueiredo | Elaboração das personas. |
| Guilherme Silva (GuiRodriSil) | Responsabilidade na Atividade 02 a confirmar. |
| Gabriel Almeida (Gabriel-Almeida0) | Pesquisa sobre o problema, com dados e fontes. |
| Guilherme Oliveira (guilherme-Oliveira3) | Benchmark de soluções similares. |
| Guilherme Eugênio | Liderança do grupo. |

Os responsáveis pela apresentação e pela atualização da documentação ainda estão a confirmar.

### Atividade 03 — Requisitos e Funcionalidades

| Integrante | Responsabilidade |
| --- | --- |
| Enzo Figueiredo | Elaboração das funcionalidades |
| Guilherme Silva (GuiRodriSil) | Elaboração dos RFs e RNFs |
| Gabriel Almeida (Gabriel-Almeida0) | Elaboração da apresentação. |
| Guilherme Oliveira (guilherme-Oliveira3) | Priorização das funcionalidades (MVP) |
| Guilherme Eugênio | Elaboração do CRUD e atualização do README e do changelog. |

## Documentação e andamento

| Documento | Conteúdo e situação atual |
| --- | --- |
| [Estudo de caso](docs/estudo-de-caso.md) | Análise do problema, público, contexto de uso e funcionalidades propostas. Ainda contém campos de iluminação e nível de atenção a preencher. |
| [Pesquisa](docs/pesquisa.md) | Informações sobre o problema, necessidades e dificuldades dos usuários, tabela de indicadores, três descobertas com suas implicações para o projeto e 11 referências. |
| [Benchmark](docs/benchmark.md) | Análise de Colab, Water Reporter e aplicativos municipais de atendimento / 156 Cidadão, com funcionalidades, pontos positivos e negativos, interface, oportunidades de melhoria e diferenciais do ÁguaViva. |
| [Personas](docs/personas.md) | Dona Marlene, moradora rural e persona prioritária, e Josimar, agente comunitário de saúde. Inclui perfis, objetivos, necessidades, dores, comportamentos, relação com o aplicativo e justificativa da prioridade. |
| [Apresentação da Atividade 02](docs/apresentacao.pdf) | Versão final em PDF, concluída e confirmada pelo grupo. |
| [Requisitos e funcionalidades](docs/requisitos.md) | 10 funcionalidades (F01–F10), 12 requisitos funcionais (RF01–RF12), 9 requisitos não funcionais (RNF01–RNF09), priorização do MVP e seção CRUD com operações por informação, justificativas e decisões pendentes. |
| [Changelog](CHANGELOG.md) | Histórico das alterações do projeto. |

## Atividade 03 — Andamento dos requisitos

O documento de [requisitos e funcionalidades](docs/requisitos.md) reúne 10 funcionalidades, 12 requisitos funcionais e 9 requisitos não funcionais, além da priorização em essenciais, importantes e secundárias. A captura e a confirmação da localização estão detalhadas em RF03 e RF04; o armazenamento local e a sincronização automática, em RF05 e RF06.

A seção [CRUD](docs/requisitos.md#crud) relaciona as operações de criação, consulta, atualização e exclusão às notificações, fotos, localização, situação de sincronização, guia de tratamento e alertas educativos. Também justifica as operações não previstas no escopo.

Permanecem a definir as regras de edição e exclusão de notificações após o registro e de limpeza dos dados locais após a sincronização. O mapeamento mantém o envio anônimo, o funcionamento sem internet e a priorização já estabelecida para o MVP.

## Apresentação da Atividade 02

A [apresentação em PDF](docs/apresentacao.pdf) está concluída e corresponde à versão final confirmada pelo grupo.

## Atividade 02 — Entregas previstas

Conforme o enunciado da atividade, a documentação deve contemplar:

- **Pesquisa:** informações sobre o problema e o público, necessidades e dificuldades dos usuários, dados que influenciem o aplicativo e pelo menos três fontes confiáveis. Ao final, destacar três descobertas e explicar seu impacto no projeto.
- **Benchmark:** analisar três soluções quanto a funcionalidades, pontos positivos e negativos, interface e experiência, além do que pode ser aproveitado ou melhorado. Apresentar os diferenciais propostos para o ÁguaViva.
- **Personas:** criar duas personas com nome fictício, perfil/contexto, objetivos, necessidades, dores, comportamentos e relação com o aplicativo. Indicar a persona prioritária e justificar a escolha.
- **Apresentação:** reunir uma descoberta da pesquisa, uma solução do benchmark, a persona prioritária e uma necessidade que o aplicativo deverá atender, em `docs/apresentacao.pdf`.
- **Organização e participação:** manter responsabilidades e changelog atualizados, realizar contribuições pelas contas individuais com commits descritivos e informar o link do repositório na entrega do Teams.

## Diretrizes propostas para o aplicativo

- Registro de suspeitas com foto e localização, inclusive sem conexão, com envio posterior.
- Interface com linguagem simples, imagens, ícones e fluxos curtos.
- Notificações anônimas e acompanhamento do atendimento.
- Mapa comunitário das ocorrências e encaminhamento à Vigilância Sanitária.
- Orientações preventivas acessíveis durante a espera pelo atendimento.

Essas funcionalidades estão documentadas como propostas. O repositório contém, nesta etapa, os documentos de pesquisa e planejamento do projeto.
