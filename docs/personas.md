# Persona 1: Dona Marlene
**Nome**: *Marlene Santos de Jesus, 52 anos*

## Perfil e contexto

- Mora na zona rural, a cerca de 12 km da sede do município. A casa de dona Marlene é abastecida por um poço artesiano no quintal e, quando o poço fica turvo, ela busca água na nascente que fica a uns 400 metros. Mora com o marido e dois netos, de 6 e 9 anos. Estudou até a quinta série. Usa um Android básico que o filho passou para ela, principalmente para WhatsApp e para ver fotos dos netos. O sinal na casa é fraco: pega em um canto específico do quintal e cai o tempo todo.

## Objetivos

- Saber se pode dar aquela água para os netos beberem hoje.
- Avisar alguém que possa resolver o problema do poço.
- Fazer isso sem que a vizinhança saiba que foi ela quem reclamou.

## Necessidades

- Perguntas em linguagem do dia a dia, sem termo técnico.
- Envio que funcione mesmo quando o sinal cai, sem ela precisar entender o que é sincronização.
- Instrução clara de fervura e cloração, disponível sem internet e com apoio de imagem.
- Anonimato garantido por padrão, sem ela ter que configurar nada.
- Tela legível sob sol forte no quintal.

## Dores

- Já percebeu a água estranha outras vezes e não fez nada, pois não sabia a quem recorrer.
- Tem receio de ser vista como barraqueira na comunidade se reclamar da água que todos usam.
- Não confia na própria capacidade de usar aplicativos, e desiste quando aparece algo que não entende ou fora de seu dia a dia.
- Fica insegura sobre a quantidade certa de água sanitária, com medo de errar e piorar.
- Já ouviu falar de gente que reclamou e nunca teve resposta (seja dos Agentes ou da Secretaria).

## Comportamentos

- Usa o celular com uma mão só, muitas vezes, quando segurando um balde ou de mãos molhadas.
- Abre o app apenas quando nota algo de errado na água, podendo ter dias, até meses, entre uma denúncia e a próxima
- Se o app pedir cadastro ou senha, provavelmente abandona.
- Prefere ver do que ler: reconhece figura mais rápido que texto (ou seja, uma leitora visual)
- Se uma tela demora muito ou trava, ela assume que o erro foi dela.

## **Relação com o aplicativo**

- Usuária geradora do dado, com uso esporádico e reativo. Nunca vai se tornar experiente de maneira eficiente, porque o intervalo entre usos é longo demais para criar memória de fluxo / muscular. Consequentemente, o app precisa ser reaprendível a cada vez, não memorizável.

## Implicações diretas para o projeto

- Justifica o fluxo em até 3 interações, o mínimo de campos obrigatórios, a substituição de "Turbidez" por "A água está esbranquiçada?", o modo claro com alto contraste, o guia visual offline, o anonimato por padrão e o retorno de status como condição para ela voltar a usar.

#
# Persona 2: Josimar

**Nome**: *Josimar Andrade Lima, 34 anos*

## Perfil e contexto

- Agente comunitário de saúde há sete anos, responsável por uma microárea com cerca de 150 famílias, boa parte em zona rural. Faz visitas domiciliares quatro dias por semana, a pé e de moto. Tem ensino médio completo e formação técnica pelo programa. Usa smartphone próprio no trabalho, porque a unidade não fornece aparelho. Já preenche formulários em papel e no e-SUS, e reclama de retrabalho.

## Objetivos

- Registrar rapidamente todos os pontos de água comprometidos que encontra na jornada.
- Orientar a família na hora, com material que ele possa mostrar na tela.
- Levar para a unidade um panorama da microárea que sustente pedido de ação.

## Necessidades

- Registro rápido e repetível, memória muscular para inputs.
- Fila offline confiável, porque quase toda a rota dele é sem sinal.
- Visão da região com histórico e status, não só o alerta isolado.
- Guia de tratamento que funcione como material de orientação para terceiros.
- Economia de bateria e de dados, já que o aparelho é dele e precisa durar a jornada de trabalho inteira.

## Dores

- Registra ocorrência em papel e depois digita de novo em outro sistema.
- Percebe problemas recorrentes na mesma localidade, mas não consegue demonstrar o padrão com dado.
- Explica fervura e cloração de memória, e nem sempre a família entende ou lembra do quê foi dito.
- Fica sem bateria no meio da rota quando usa o celular para trabalho.
- Frustra-se quando encaminha um problema e não fica sabendo se algo foi feito, visto que isso afeta os moradores da região.

## Comportamentos

- Usa o app várias vezes por semana e decora o fluxo rapidamente.
- Trabalha em modo offline quase o tempo todo, sincronizando quando volta à unidade ou pega sinal na estrada.
- Mostra a tela do celular para o morador durante a orientação.
- Toca rápido e sem ler, porque já sabe onde ficam as coisas.
- Confere depois se as notificações que enviou foram recebidas.

## Relação com o aplicativo

- Usuário operacional, frequente e proativo. Acaba ficando experiente com o sistema em pouco tempo devido a isso. Também pode ser considerado um multiplicador, uma vez que, apresenta o app aos moradores de uma dada área e ensina-os como usar, o quê o faz um canal de repasse e adoção.

## Implicações diretas para o projeto

- Justifica o armazenamento local com envio em lote, o mapa com histórico da região, o guia de tratamento pensado também como material de apresentação a terceiros, a leveza do app em aparelho básico e a preocupação com bateria e consumo de dados.

#
# Persona prioritária
Marlene é a persona prioritária. Três razões, em ordem de força:

- Ela é a razão de o app existir. O estudo de caso define a missão como permitir que cidadãos monitorem e notifiquem. Sem morador notificando, não existe dado, e o app vira só mais uma ferramenta interna de agente de saúde, algo que o e-SUS já tenta fazer (Colab.AI também...). O diferencial da proposta é a notificação colaborativa vinda da comunidade.
- Ela é o caso mais restritivo. Um app que a Marlene consegue usar, o Josimar também consegue. O contrário não vale: uma interface otimizada para o usuário experiente, com atalhos e densidade de informação, exclui a Marlene. Projetar para a persona de menor familiaridade cobre as duas, e é o que justifica as restrições de 3 interações, 1 minuto e linguagem sem jargão.
- A frase-síntese do projeto aponta para ela. "O olho da comunidade que enxerga a sujeira invisível na água" posiciona o protagonismo no morador, não no profissional de saúde.

Vale acrescentar que priorizar Marlene *não* significa ignorar Josimar. Ele continua sendo determinante para a adoção, porque é ele quem apresenta o app à comunidade, e as necessidades dele (offline robusto, histórico da região) coincidem em boa parte com as dela. Porém, onde houver conflito entre os dois, a decisão pende para Marlene.
