# 2.4 Justificativas

As decisões do ÁguaViva foram orientadas principalmente por Dona Marlene, moradora rural com baixa familiaridade digital e uso esporádico do aplicativo, sem desconsiderar Josimar, agente comunitário que utiliza a solução com frequência durante as visitas. A interface, portanto, precisa ser simples o bastante para ser reaprendida a cada uso e, ao mesmo tempo, rápida e confiável para o trabalho em campo.

## Cores

A paleta utiliza azul-água e branco como cores principais, transmitindo limpeza, confiança, clareza e relação com o tema da água. O modo claro, os textos escuros e as áreas de fundo bem delimitadas favorecem o contraste e a leitura sob iluminação intensa. Amarelo, vermelho e verde comunicam estados como atenção, contaminação e resolução; essas cores aparecem acompanhadas de rótulos, ícones ou mensagens, para que a informação não dependa apenas da percepção cromática.

## Tipografia

Foi adotada uma tipografia sem serifa, de formas simples e legíveis em telas pequenas. Títulos maiores e em maior peso, subtítulos, textos de apoio e rótulos curtos estabelecem uma hierarquia clara. O conteúdo evita blocos longos, letras pequenas e termos técnicos: expressões como “turbidez” são substituídas por perguntas cotidianas, como “A água está esbranquiçada?”, atendendo pessoas com escolaridade e letramento digital variados.

## Organização das informações

As telas apresentam baixa densidade visual, espaçamento generoso e uma tarefa principal por vez. Na página inicial, o mapa e os alertas próximos oferecem consciência da situação regional, enquanto o botão “A água está estranha” recebe maior destaque por iniciar a ação central do sistema. O registro organiza foto, características visuais, odor e localização em uma sequência curta; após o envio ou salvamento, o sistema informa claramente o resultado e oferece acesso ao acompanhamento e ao guia de tratamento. Essa ordem reduz a carga cognitiva e conduz o usuário da suspeita à ação imediata.

## Navegação

A barra inferior mantém três destinos constantes — “Alertas”, “Tratar água” e “Minhas” —, facilitando a localização das funções principais. Botões largos, rótulos diretos e ações de retorno visíveis favorecem o uso com uma mão e diminuem erros de toque. O fluxo prioritário pode ser concluído em poucas interações, sem cadastro obrigatório. Telas específicas orientam a recuperação em casos de câmera desativada, GPS indisponível, envio interrompido ou ausência de internet, sem exigir que o usuário compreenda conceitos técnicos como sincronização.

## Componentes

Os principais elementos de interface são botões de ação destacados, cartões de ocorrências, seletores com texto e ícones, captura e pré-visualização de foto, mapa com marcadores, confirmação de localização, avisos de estado, lista de notificações, indicadores de status e guias ilustrados em etapas. Esses componentes atendem tanto ao relato rápido de Marlene quanto à necessidade de Josimar de consultar histórico, reconhecer padrões da região e mostrar orientações às famílias durante as visitas.

## Acessibilidade

O projeto segue os princípios de inclusão definidos no estudo de caso: linguagem simples, apoio visual, alto contraste, hierarquia previsível, alvos de toque amplos e fluxo curto. Ícones não substituem os textos, e estados não são identificados somente por cores. As mensagens explicam o que ocorreu e qual é o próximo passo, reduzindo a insegurança de usuários pouco experientes. O envio anônimo por padrão, sem exigir login, também funciona como acessibilidade social, pois protege moradores que temem exposição ou represálias na comunidade.

## Contexto de uso

O ÁguaViva foi pensado para quintais, poços, nascentes e visitas domiciliares, onde o usuário pode estar em pé, sob luz solar, com uma mão ocupada ou molhada e com atenção limitada. Por isso, a interface prioriza contraste, poucos campos, botões grandes, baixo consumo de dados e compatibilidade com celulares básicos. Como a conexão rural é instável ou inexistente, o relato e a foto ficam salvos no aparelho, o guia permanece disponível offline e o envio ocorre automaticamente quando a rede retorna. A compressão das imagens e a contenção do uso de armazenamento, memória e bateria também respondem às limitações dos aparelhos e à rotina prolongada dos agentes de saúde.

## Arquitetura do sistema

A solução adota uma arquitetura mobile **offline-first**, pois a coleta não pode depender da disponibilidade de internet. Seus principais componentes e funções são:

- **Aplicativo móvel:** apresenta os fluxos de registro, mapa, tratamento da água e acompanhamento das notificações.
- **Serviços de câmera e GPS:** capturam a evidência visual e as coordenadas; o ponto pode ser confirmado ou ajustado para representar a fonte de água, e não necessariamente a posição atual da pessoa.
- **Processamento local de imagens:** comprime a foto para redes fracas e remove metadados EXIF de localização antes da transmissão, preservando o anonimato.
- **Banco local SQLite e fila de pendências:** guardam o relato no dispositivo, exibem o estado “aguardando internet” e evitam a perda de dados em campo.
- **Monitoramento de conectividade e sincronização em segundo plano:** detecta o retorno da rede e envia automaticamente os registros pendentes, sem intervenção do usuário.
- **Servidor e integração com a Vigilância Sanitária:** recebem foto, localização confirmada e respostas do relato, disponibilizam as ocorrências para análise e devolvem estados como “Em análise” e “Resolvido”. A tecnologia específica do backend ainda não foi definida nos documentos do projeto.
- **Conteúdo offline:** mantém as orientações de fervura e cloração acessíveis antes da resposta oficial, oferecendo proteção imediata às famílias.

Essa separação permite que a experiência essencial continue funcionando no aparelho sem rede e que a comunicação com a Vigilância seja retomada quando houver conexão. A arquitetura sustenta, assim, os diferenciais do ÁguaViva: registro comunitário acessível, anonimato, prevenção imediata, baixa perda de dados e fechamento do ciclo com retorno ao usuário.
