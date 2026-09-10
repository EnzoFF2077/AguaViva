## Funcionalidades

### F01 - Notificação rápida de água suspeita

- **Descrição**: Fluxo curto em que o usuário registra uma suspeita de contaminação respondendo poucas perguntas em linguagem cotidiana, anexando foto e confirmando o local.

- **Necessidade atendida:** Marlene precisa avisar alguém sem gastar tempo e sem entender muitos termos técnicos.

- **Justificativa:** É a razão de existir do app. Sem tal funcionalidade, não há dado gerado pela comunidade, e o projeto perde o diferencial de notificação colaborativa que o separa dos sistemas institucionais analisados no benchmark.

### F02 - Captura de foto da água

- **Descrição:** Abertura da câmera dentro do app para registrar a evidência visual, com a imagem vinculada à notificação.

- **Necessidade atendida:** A vigilância precisa de evidência objetiva que compense a descrição subjetiva feita por um leigo.

- **Justificativa:** A nossa pesquisa mostra que a percepção visual do morador é limitada, já que mais da metade dos poços de Jaru tinham *E. coli* com turbidez normal. A foto permite que quem tem competência técnica avalie o caso em vez de depender só do relato.

### F03 - Georreferenciamento com confirmação do local

- **Descrição:** Captura automática das coordenadas pelo GPS, apresentadas ao usuário para confirmação ou ajuste antes do envio.

- **Necessidade atendida:** A vigilância precisa localizar a fonte, e o usuário precisa marcar a água, não o lugar onde ele está.

- **Justificativa:** O GPS erra em área rural e sob mata. Além disso, Marlene pode notificar em casa uma água trazida da nascente. A confirmação também protege a identidade dela, permitindo marcar a fonte comunitária em vez do próprio quintal.

### F04 - Armazenamento local e sincronização automática

- **Descrição:** A notificação é gravada no dispositivo assim que concluída e enviada ao servidor quando houver conexão, sem ação do usuário.

- **Necessidade atendida:** Marlene e Josimar operam em áreas sem sinal e não podem perder o registro.

- **Justificativa:** É a restrição mais determinante do projeto. A pesquisa mostra que o déficit de saneamento é concentrado no meio rural, exatamente onde a conectividade é pior. Consequentemente, foi também a principal falha identificada nas três soluções do nosso benchmark, *todas* dependentes de conexão ativa.

### F05 - Mapa de focos notificados

- **Descrição:** Visualização dos pontos de contaminação notificados na região, com indicação de gravidade por cor e do status de cada foco.

- **Necessidade atendida:** Marlene quer saber quais fontes evitar; Josimar precisa enxergar o padrão da microárea que acompanha.

- **Justificativa:** Transforma notificações isoladas em informação coletiva. Josimar hoje percebe recorrência mas não consegue demonstrar com dado, e o mapa resolve isso. Foi o ponto positivo do Colab que vale aproveitar.

### F06 - Guia de tratamento caseiro da água

- **Descrição:** Instruções visuais de fervura e de cloração com hipoclorito de sódio, com dosagem por volume de água, disponíveis sem conexão.

- **Necessidade atendida:** Marlene precisa saber o que fazer hoje; Josimar precisa de material para mostrar na visita.

- **Justificativa:** A pesquisa mostra que 91,5% das amostras de Soluções Alternativas Individuais são insatisfatórias, ou seja, o tratamento recai sobre a própria família. Entre a notificação e a resposta oficial podem se passar dias, e o guia é o que ampara o usuário nesse intervalo. Nenhuma das três soluções do benchmark oferece isso.

### F07 - Acompanhamento das próprias notificações

- **Descrição:** Lista das notificações enviadas pelo dispositivo, com o status atribuído pela vigilância ("Em análise", "Resolvido pela vigilância") e as pendentes de envio.

- **Necessidade atendida:** Marlene e Josimar precisam saber que a notificação chegou e teve consequência.

- **Justificativa:** É o que sustenta a confiança e o reuso. Uma das dores registradas é ter ouvido falar de gente que reclamou e nunca teve retorno. Sem o ciclo fechado, o engajamento se extingue, o que é crítico num público de uso esporádico.

### F08 - Envio anônimo com remoção de metadados

- **Descrição:** Notificação enviada sem identificação pessoal por padrão, com os metadados de localização da foto removidos no dispositivo antes do upload.

- **Necessidade atendida:** Marlene teme ser vista como encrenqueira por reclamar da água que a comunidade toda usa.

- **Justificativa:** É uma condição de viabilidade. Se houver risco percebido de identificação, o app pode não ser usado. O Colab exige cadastro com dados pessoais, e essa é a barreira que o ÁguaViva remove.

### F09 - Alertas educativos de prevenção

- **Descrição:** Mensagens curtas e periódicas reforçando que água transparente também pode estar contaminada e que o tratamento deve ser contínuo.

- **Necessidade atendida:** Corrigir a falsa sensação de segurança diante de água visualmente limpa.

- **Justificativa:** Decorre diretamente da primeira descoberta da nossa pesquisa. Resolve a tensão central do projeto: o app aciona por sinal visual, mas o risco nem sempre é visível e, consequentemente, o guia não pode ser condicional à suspeita.

### F10 - Painel da região para agente de saúde

- **Descrição:** Visão consolidada das notificações da microárea, com histórico e filtro por status.

- **Necessidade atendida:** Josimar precisa levar um panorama à unidade que sustente pedido de ação.

- **Justificativa:** Aproveita o conceito de acompanhamento contínuo do Water Reporter, sem a densidade de informação que inviabilizaria o uso em campo.
