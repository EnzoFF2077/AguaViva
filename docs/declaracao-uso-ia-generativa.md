# Declaração de uso de ferramentas de Inteligência Artificial generativa

**Referência:** Portaria CNPq nº 2.664/2026  
**Trabalho:** ÁguaViva — aplicativo para registro de alertas sobre a qualidade da água  
**Data da declaração:** 24/11/2026  
**Responsável pela declaração:** [nome completo do(a) autor(a)/responsável — preencher]

## 1. Declaração

Declaro que **foi utilizada ferramenta de Inteligência Artificial generativa** no desenvolvimento deste trabalho. A ferramenta foi empregada como apoio à análise de código, à implementação de ajustes no aplicativo, à elaboração de documentação e à verificação automatizada, sempre sob revisão e decisão da autoria, conforme detalhado abaixo.

Esta seção não foi omitida.

## 2. (i) Identificação da ferramenta

| Campo | Informação |
| --- | --- |
| Nome da ferramenta | OpenCode (agente de desenvolvimento de software, executado em ambiente local) |
| Versão da ferramenta | OpenCode v2.4.1 |
| Modelo utilizado | Big Pickle (identificador `opencode/big-pickle`) |
| Versão/modelo adicional | Não foi informada uma versão específica do modelo pelo ambiente; o identificador acima é a referência disponível |
| Período de uso | 24/11/2026 |
| Outros recursos generativos | Não foi utilizada geração de imagens nem qualquer outra ferramenta de IA generativa neste trabalho |

## 3. (ii) e (iii) Etapas do trabalho e finalidades específicas

| Etapa do trabalho | Finalidade específica do uso da IA generativa |
| --- | --- |
| Análise do repositório e do histórico Git | Localizar gargalos de inicialização do aplicativo e identificar, no histórico da branch `main`, quais opções do formulário de relatório foram removidas pelo commit de alta fidelidade (`6b3b888`). A IA examinou o código e os diffs e apresentou os trechos relevantes para decisão da autoria. |
| Definição da inicialização fluida | Implementar um orçamento de tempo de **3 segundos** para o Firebase, com tela de carregamento, modo básico fora de rede, nova tentativa e promoção automática para o aplicativo completo quando o serviço responde depois. Também ajustou a ativação da sessão para ocorrer em segundo plano e evitou a recriação da stream de alertas a cada rebuild. |
| Recuperação das opções de relatório | Restaurar, no formulário atual e mantendo o visual de alta fidelidade, o seletor de tipo de fonte, o campo de nome/referência do local e o campo de descrição, incluindo a validação e o envio desses dados no rascunho do alerta. |
| Recuperação da tela “Tratar água” | Recuperar o modelo anterior do guia de tratamento com as descrições dos passos, tabelas de dose e ícones, preservando os textos exigidos pelos testes já existentes. |
| Documentação da apresentação final | Elaborar o roteiro de slides em Markdown (`docs/roteiro-apresentacao-final.md`), com 16 slides distribuídos em 5 sessões, incluindo falas e sugestões visuais. |
| Verificação e correção | Executar `flutter analyze` e `flutter test`, interpretar falhas e ajustar os testes de inicialização e de fidelidade do formulário até que a suíte passasse integralmente (29 testes). |
| Versionamento | A pedido explícito da autoria, preparar o commit com as alterações e enviá-lo para `origin/main` (commit `a5bb79c`). A escolha do que versionar e a decisão de publicar foram tomadas pela autoria. |
| Elaboração desta declaração | Redigir este arquivo Markdown a partir das instruções da Portaria CNPq nº 2.664/2026 e do registro real das etapas acima. |

## 4. Escopo, supervisão e limites

- Todas as decisões de produto foram tomadas pela autoria, incluindo o limite de 3 segundos, a recuperação apenas das opções de relatório, a manutenção das mudanças pendentes, a recuperação da tela “Tratar água” e a publicação em `origin/main`.
- O código e os documentos produzidos pela IA foram revisados antes de serem aceitos; nenhuma alteração foi incorporada sem essa revisão.
- A IA generativa não foi utilizada para coletar dados, realizar experimentos, produzir resultados científicos ou elaborar referências bibliográficas.
- Não houve uso de IA generativa para geração de imagens, áudio ou vídeo neste trabalho.

## 5. Assinatura

Declaro que as informações acima são verdadeiras e referem-se ao uso efetivo de IA generativa no desenvolvimento deste trabalho.

______________________________________  
Nome: ________________________________  
Data: ___/___/______
