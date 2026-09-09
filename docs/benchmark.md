# 3. Benchmark

Para o desenvolvimento do ÁguaViva, foi necessário analisar como outras soluções lidam com denúncias comunitárias, monitoramento hídrico e comunicação com órgãos públicos. Como o foco do projeto é atender moradores de áreas rurais e agentes de saúde em locais sem acesso à internet, avaliamos três plataformas para identificar suas funcionalidades, pontos positivos, limitações e o que pode servir de base para o nosso sistema.

## Solução 1: Colab (Colab.re)

Plataforma utilizada por prefeituras para que os cidadãos relatem problemas urbanos em seus bairros, como vazamentos ou falta de saneamento básico.

### Principais funcionalidades

- Abertura de chamados com envio de foto, breve descrição e localização automática via GPS.
- Mapa público interativo para visualização dos problemas relatados por outros moradores.
- Painel de acompanhamento para verificar o andamento e a resolução das solicitações.

### Pontos positivos

- Facilidade de uso e retorno transparente sobre o status do problema (ex: "em análise" ou "resolvido").
- Fomento ao engajamento comunitário, pois o mapa público permite acompanhar as ocorrências da região.

### Pontos negativos

- Dependência total de conexão ativa com a internet: em locais sem sinal, o aplicativo não envia nem permite o salvamento off-line do relato para sincronização futura.
- Exigência de cadastro com dados pessoais, inviabilizando o envio de denúncias de forma totalmente anônima.

### Aspectos de interface/experiência

O visual assemelha-se ao de uma rede social, utilizando um feed de fotos e mapas dinâmicos. A navegação é intuitiva e direta, otimizada para smartphones atuais.

### O que pode ser aproveitado ou melhorado no projeto

- **Aproveitar:** A clareza do mapa público interativo e o feedback visual simples sobre o status da denúncia.
- **Melhorar:** Adaptar a funcionalidade central para que os relatos possam ser criados de forma anônima e armazenados localmente no dispositivo para envio posterior, contornando a falta de internet.

## Solução 2: Water Reporter

Aplicativo voltado para organizações não governamentais (ONGs) e grupos de voluntários focados no monitoramento da qualidade de rios, lagos e nascentes.

### Principais funcionalidades

- Registro de dados quantitativos e fotos de pontos de água diretamente em campo, com georreferenciamento.
- Geração de mapas e gráficos analíticos sobre a situação das bacias hidrográficas.
- Rede de compartilhamento de informações entre pesquisadores e ambientalistas.

### Pontos positivos

- Foco exclusivo no contexto ambiental e na gestão de recursos hídricos.
- Capacidade de mapeamento e acompanhamento contínuo e histórico de pontos de água.

### Pontos negativos

- Uso frequente de jargões técnicos, o que cria uma barreira de compreensão para moradores com menor grau de escolaridade.
- Ausência de notificação direta à Vigilância Sanitária e falta de orientações preventivas ao morador.

### Aspectos de interface/experiência

A interface possui alta densidade de informações, apresentando diversas tabelas e mapas complexos. O preenchimento dos formulários exige tempo e foco, dificultando o uso ágil durante atividades de campo, especialmente sob luz solar direta.

### O que pode ser aproveitado ou melhorado no projeto

- **Aproveitar:** O conceito de registro de pontos de água específicos e acompanhamento contínuo do contexto ambiental.
- **Melhorar:** Simplificar drasticamente a linguagem (removendo termos técnicos) e adicionar um módulo de alertas emergenciais e dicas de tratamento de água para o morador.

## Solução 3: Aplicativos Municipais de Atendimento / 156 Cidadão

Sistemas institucionais adotados por prefeituras para centralizar solicitações diretas dos moradores sobre saneamento e zeladoria urbana.

### Principais funcionalidades

- Abertura de chamados específicos para problemas de infraestrutura e vazamentos, exigindo foto e endereço.
- Geração automática de protocolo oficial de atendimento municipal.
- Consulta de andamento da solicitação pelo cidadão.

### Pontos positivos

- Encaminhamento direto e oficial da demanda para as secretarias e órgãos competentes do município.
- Interface mais simplificada quando comparada aos portais unificados de governos maiores.

### Pontos negativos

- Impossibilidade de uso sem internet no momento do envio e ausência de recurso de salvamento em cache (off-line).
- Falta de transparência comunitária, pois não há um mapa aberto para que a vizinhança identifique focos de risco.
- Omissão de guias de emergência para o cidadão aguardando solução (ex: tutoriais sobre cloração ou fervura).

### Aspectos de interface/experiência

O design é centrado em formulários textuais e sequenciais (passo a passo) para o cadastro do endereço e descrição do problema, exigindo maior esforço de leitura e digitação.

### O que pode ser aproveitado ou melhorado no projeto

- **Aproveitar:** A formalização e direcionamento da denúncia para o poder público competente.
- **Melhorar:** Reduzir a carga de texto e leitura na interface, focando em ícones e cliques rápidos, além de criar um espaço comunitário aberto onde a vizinhança tenha ciência dos problemas relatados.

## O que nosso aplicativo poderá fazer de diferente ou melhor?

Diferente das plataformas analisadas, o ÁguaViva será projetado primariamente para a realidade das zonas rurais isoladas. Seus principais diferenciais serão:

- **Funcionamento 100% Off-line (Sincronização Assíncrona):** O aplicativo permitirá o registro completo da denúncia ou da análise da água sem sinal de internet, guardando os dados no dispositivo para envio automático assim que uma conexão for detectada.
- **Acessibilidade e Linguagem Inclusiva:** A interface será baseada em imagens, ícones e fluxos curtos, abandonando jargões técnicos e formulários densos, garantindo que usuários de diferentes níveis de letramento consigam utilizá-lo.
- **Educação e Prevenção Imediata:** Enquanto o poder público não atua, o ÁguaViva não deixará o cidadão sem amparo. O sistema fornecerá pílulas informativas e guias emergenciais simplificados (como métodos de cloração e fervura) para mitigar riscos imediatos de contaminação.
- **Denúncias Desburocratizadas e Anônimas:** O envio de dados será simplificado para não expor moradores de comunidades pequenas e vulneráveis, focando na utilidade pública da informação acima do cadastro civil.
