# ÁguaViva — Roteiro da apresentação final

**Disciplina:** Programação para Dispositivos Móveis · Ciência da Computação (Noite) · Terça-feira · Sala A22  
**Público:** banca avaliadora e colegas de turma  
**Duração estimada:** 16 a 18 minutos (16 slides)  
**Versão do projeto apresentada:** `1.0.0+1` — piloto Flutter implementado, com build web publicado na Vercel  
**Data:** novembro de 2026

> **Como usar este roteiro:** cada slide traz o **texto pronto para a tela**, a **fala sugerida** (notas do apresentador) e uma **sugestão visual**. O texto do slide foi escrito para ser lido em poucos segundos; os detalhes e números ficam na fala. Os dados abaixo foram extraídos de todo o repositório: `README.md`, `CHANGELOG.md`, `docs/*.md`, `frontend/lib/**`, `frontend/test/**`, configurações Firebase e deploy.

---

## Visão geral das sessões

| Sessão | Slides | Foco | Tempo |
| --- | --- | --- | --- |
| **1. Contexto e problema** | 1–4 | O que motiva o ÁguaViva e onde ele atua | ~4 min |
| **2. Pessoas e decisões de produto** | 5–7 | Personas, benchmark, requisitos e MVP | ~3 min |
| **3. Solução e arquitetura** | 8–11 | Fluxo, interface, camadas e funcionamento offline | ~5 min |
| **4. Entrega e qualidade** | 12–14 | Privacidade, implementação e validação | ~3 min |
| **5. Impacto e encerramento** | 15–16 | Limites atuais, próximos passos e mensagem final | ~2 min |

### Divisão sugerida de falas

| Integrante | Slides |
| --- | --- |
| Gabriel Almeida | 1–3 |
| Enzo Figueiredo Feitosa | 4–6 |
| Guilherme Oliveira | 7–9 |
| Guilherme Rodrigues Silva | 10–12 |
| Guilherme Eugênio Sacramento Barreto | 13–16 |

---

# SESSÃO 1 — Contexto e problema

### Slide 1 — Capa

**Texto do slide**

> ## ÁguaViva
>
> **O olho da comunidade que enxerga a sujeira invisível na água**
>
> Notificação colaborativa de suspeitas de contaminação da água  
> Programação para Dispositivos Móveis — Ciência da Computação, turma da noite
>
> Guilherme Eugênio · Enzo Figueiredo · Guilherme Rodrigues · Gabriel Almeida · Guilherme Oliveira  
> Novembro de 2026

**Fala sugerida**

"Boa noite. Apresentamos o ÁguaViva, um aplicativo que permite a qualquer morador registrar uma suspeita de contaminação da água com foto e localização, mesmo sem internet, e acompanhar o retorno da Vigilância Sanitária. Esta é a apresentação final: consolidamos a pesquisa, os requisitos, a prototipação e o piloto implementado."

**Visual sugerido**

Fundo azul-água e branco, ícone de gota-d'água, título central. Sem texto adicional.

---

### Slide 2 — O problema: a água limpa também adoece

**Texto do slide**

> ## A aparência engana
>
> - **60%** dos poços rasos de Jaru (RO) tinham *E. coli* com turbidez dentro do padrão
> - **91,5%** das soluções alternativas individuais em Itabuna (BA) tinham amostras insatisfatórias
> - **33 milhões** de brasileiros sem água potável · **90 milhões** sem coleta de esgoto
> - **64,2%** das moradias sem rede de água estão na zona rural; só **8,9%** dos domicílios rurais têm esgoto geral
>
> *Fontes: SINISA 2024, IBGE/PNADC, ABAS/Sisagua, FIMCA Jaru*

**Fala sugerida**

"O dado que orientou todo o projeto vem de Jaru: 60% dos poços analisados tinham contaminação por *E. coli* mesmo com a água visualmente limpa. Ou seja, a percepção do morador não é suficiente — e é exatamente ela que hoje decide se a família bebe ou não. Nas soluções individuais, como poços e cisternas, o índice de amostras reprovadas chega a 91,5%. E esse problema é rural: 64,2% das moradias sem água tratada ficam no campo, onde apenas 8,9% dos domicílios têm esgoto. O ÁguaViva nasce para dar voz a essa população e transformar um sinal suspeito em uma notificação útil."

**Visual sugerido**

Grid com quatro números grandes em azul/vermelho; ao lado, duas fotos contrastantes: "parece limpa" × "contaminada".

---

### Slide 3 — O custo de não prevenir

**Texto do slide**

> ## Prevenir custa menos do que tratar
>
> - **344,4 mil** internações por doenças relacionadas ao saneamento inadequado em 2024
> - **R$ 174,309 milhões** de gasto do SUS · **R$ 506,07** por internação
> - Doenças feco-orais: **44,0%** do total — **R$ 76,706 milhões**
> - Universalização evitaria **86.760 internações/ano** e **R$ 1,255 bilhão** em perpetuidade
> - **14,982 milhões** de afastamentos por diarreia ou vômito em um ano
>
> *Fonte: Instituto Trata Brasil, com dados do SUS/Datasus*

**Fala sugerida**

"Esse é o argumento que sustenta o projeto junto a prefeituras e órgãos de saúde. As doenças de transmissão feco-oral — diarreia, hepatite A, febre tifoide — respondem por 44% das internações por saneamento inadequado, mais de 76 milhões de reais por ano. A universalização evitaria quase 87 mil internações anuais. O ÁguaViva não substitui o saneamento, mas reduz o intervalo entre a suspeita e a ação, que é onde a prevenção acontece."

**Visual sugerido**

Barra horizontal comparando "gasto atual" × "economia estimada"; rodapé com a fonte.

---

### Slide 4 — Onde e quando o aplicativo é usado

**Texto do slide**

> ## Três públicos, um mesmo fluxo
>
> | Público | Relação com o app | Necessidade central |
> | --- | --- | --- |
> | **Morador rural** | Esporádica e reativa | Avisar sem se expor e saber o que fazer hoje |
> | **Agente comunitário** | Frequente e proativa | Registrar em campo e mostrar orientação à família |
> | **Vigilância Sanitária** | Destinatária dos dados | Localizar a fonte e devolver o status do caso |
>
> **Contexto real:** quintal, poço ou nascente · sol forte · uma mão ocupada · sinal fraco · Android básico

**Fala sugerida**

"O uso acontece no momento em que o morador percebe algo estranho, em pé, ao lado do poço, muitas vezes com uma mão ocupada e sem sinal. O agente usa o app durante a visita, quatro dias por semana, e a Vigilância recebe as informações na sede. Projetamos para o caso mais restritivo: se funciona para a Dona Marlene, funciona para o agente. O contrário não seria verdade."

**Visual sugerido**

Três ícones alinhados (casa, agente, prédio público) sobre um mapa rural simplificado.

---

# SESSÃO 2 — Pessoas e decisões de produto

### Slide 5 — Personas: quem guia as decisões

**Texto do slide**

> ## Dona Marlene é a persona prioritária
>
> **Marlene, 52 anos** — 12 km da sede, poço no quintal, quinta série, Android básico, sinal fraco. Leitora visual, usa o app de forma esporádica e precisa reaprender a cada acesso. Medo de ser vista como "barraqueira" na comunidade.
>
> **Josimar, 34 anos** — agente comunitário, 150 famílias, 4 dias/semana em campo. Precisa de registro repetível, fila offline, histórico da microárea e material para orientar moradores.
>
> **Decisão:** onde houver conflito, a escolha pende para Marlene.

**Fala sugerida**

"Marlene é a razão de existir do aplicativo: sem o morador notificando, não existe dado colaborativo. Ela também é o caso mais restritivo — baixa familiaridade digital, uso espaçado, leitura visual e receio de exposição. Isso explica o fluxo curto, a linguagem cotidiana, o anonimato por padrão e o guia visual offline. Josimar é o multiplicador: apresenta o app à comunidade e cobra historicidade e economia de bateria. As necessidades dele em grande parte coincidem com as dela."

**Visual sugerido**

Dois cartões lado a lado com retratos ilustrados e 3 palavras-chave cada. Destaque "prioritária" no cartão de Marlene.

---

### Slide 6 — Benchmark: o que já existe e o que falta

**Texto do slide**

> ## O gap que o ÁguaViva preenche
>
> | Solução | Ponto forte | Limitação para o nosso público |
> | --- | --- | --- |
> | **Colab** | Mapa e acompanhamento | Exige internet e cadastro com dados pessoais |
> | **Water Reporter** | Histórico ambiental | Linguagem técnica e alta densidade de informação |
> | **Apps municipais / 156** | Protocolo oficial | Sem offline, sem mapa aberto e sem guia de tratamento |
>
> **Diferenciais:** funcionamento offline · linguagem inclusiva · educação imediata · denúncia anônima

**Fala sugerida**

"Analisamos três categorias. O Colab tem bom mapa, mas depende de conexão e cadastro. O Water Reporter é denso e técnico. Os aplicativos municipais têm o protocolo oficial, mas não funcionam sem rede e não orientam a família enquanto a resposta não chega. Os quatro diferenciais que extraímos dessa análise — offline, linguagem simples, educação imediata e anonimato — se tornaram requisitos do produto."

**Visual sugerido**

Tabela em três colunas; na última linha, quatro chips com os diferenciais.

---

### Slide 7 — Requisitos e priorização do MVP

**Texto do slide**

> ## De 10 funcionalidades a 6 prioridades
>
> **10 funcionalidades (F01–F10) · 12 requisitos funcionais · 9 não funcionais · 6 informações no CRUD**
>
> **Essenciais (MVP):** F01 notificação rápida · F02 foto · F03 GPS · F04 armazenamento e sincronização · F06 guia de tratamento · F08 anonimato e remoção de metadados  
> **Importantes:** F05 mapa de focos · F07 acompanhamento das notificações  
> **Secundárias:** F09 alertas educativos · F10 painel do agente
>
> Critério: impacto direto na notificação colaborativa, no uso rural e na prevenção imediata.

**Fala sugerida**

"Documentamos dez funcionalidades, doze requisitos funcionais e nove não funcionais. Para o MVP priorizamos seis: registrar rápido, tirar foto, capturar o GPS, guardar e sincronizar, orientar o tratamento e proteger o notificante. Mapa e acompanhamento vieram em seguida, porque dão visibilidade coletiva e fecham o ciclo de confiança. Alertas periódicos e o painel do agente ficaram para uma etapa posterior. Essa priorização aparece hoje no código: as seis essenciais e as duas importantes estão implementadas; F09 e F10 são os limites que vamos apresentar no final."

**Visual sugerido**

Pirâmide de prioridades ou três faixas coloridas (essencial / importante / secundária) com os códigos F01–F10.

---

# SESSÃO 3 — Solução e arquitetura

### Slide 8 — A solução em uma tela

**Texto do slide**

> ## Da suspeita à ação em poucos toques
>
> **Ver região** → **“A água está estranha”** → **foto** → **cor e cheiro** → **GPS** → **enviar**
>
> Depois: **“Alerta enviado”** → acompanhar em **Minhas** → tratar em **Tratar água**
>
> **Navegação fixa:** Alertas · Tratar água · Minhas

**Fala sugerida**

"A tela inicial mostra o mapa da região, o estado dos pontos e o botão que inicia a ação principal. O formulário pede só o essencial: uma foto, a cor da água, se há cheiro forte e a localização. Não há cadastro obrigatório — é possível entrar como anônimo. Ao enviar, o aplicativo confirma na hora, mesmo sem rede, porque o registro já está salvo no aparelho. O usuário acompanha o status na aba Minhas e encontra o passo a passo de fervura e cloração na aba Tratar água."

**Visual sugerido**

Fluxo horizontal com setas e miniaturas das telas reais do aplicativo.

---

### Slide 9 — Interface e acessibilidade

**Texto do slide**

> ## Simples de usar, fácil de reaprender
>
> - Azul-água e branco; alto contraste; texto escuro sobre fundo claro
> - Perguntas cotidianas: **“A água está esbranquiçada?”** em vez de “turbidez”
> - Cores **sempre acompanhadas** de rótulo, ícone ou texto
> - Botões de ação com **54 px** e alvos de toque amplos
> - `Semantics` nos marcadores e no seletor de tratamento; mensagens com o próximo passo
> - Três destinos constantes na barra inferior

**Fala sugerida**

"A paleta azul-água e branco transmite limpeza e confiança. A linguagem evita termos técnicos — perguntamos se a água está esbranquiçada, não sobre turbidez. As cores de status nunca aparecem sozinhas: vêm com texto e ícone, o que atende à acessibilidade e ajuda quem lê sob sol forte. Os botões têm altura generosa para uso com uma mão, e as mensagens de erro sempre dizem o que fazer em seguida, sem exigir que a pessoa entenda sincronização."

**Visual sugerido**

Print do tema do app com anotações apontando contraste, botão grande e legenda do mapa.

---

### Slide 10 — Arquitetura do piloto

**Texto do slide**

> ## Clean Architecture, organizada por funcionalidade
>
> ```
> presentation  →  domain  ←  data
>   telas,         entidades,   Firebase Auth, Firestore,
>   controllers    contratos    Storage, câmera, GPS
> ```
>
> - `features/auth` e `features/reports` com contratos de repositório explícitos
> - Injeção por construtor permite testar sem Firebase
> - **Stack:** Flutter 3.47.4 · Dart ≥3.13.1 · Firebase · OpenStreetMap (`flutter_map`) · `geolocator` · `image_picker`
> - Navegação imperativa; `core/`, `di/` e `router/` reservados para evolução

**Fala sugerida**

"Organizamos o código em camadas: apresentação depende de domínio, dados implementam os contratos do domínio e o domínio não conhece Firebase ou Flutter. Isso aparece em duas features principais, autenticação e notificações, cada uma com seu repositório. A injeção de dependências é feita pelo construtor, o que permitiu escrever os testes com fakes em memória, sem emulador. A navegação ainda é imperativa — uma dívida consciente, registrada para a próxima etapa."

**Visual sugerido**

Diagrama de camadas com setas; ao lado, logos Firebase, Flutter e OpenStreetMap.

---

### Slide 11 — Offline-first na prática

**Texto do slide**

> ## O alerta nunca se perde
>
> 1. O documento é gravado **primeiro no cache persistente do Firestore** (`waitingInternet`)
> 2. No navegador, a foto vira **prévia JPEG ≤ 200 KiB sem EXIF**, embutida no relato
> 3. No nativo, a foto fica em `pending_photos/` e sobe para o Storage com timeout de **45 s**
> 4. Retentativa automática ao recuperar conexão, abrir o app ou voltar ao primeiro plano
> 5. O status avança para **submitted** quando a gravação é confirmada
>
> **Nota de evolução:** o SQLite previsto nos documentos iniciais foi substituído pelo cache offline do Firestore.

**Fala sugerida**

"O ponto mais importante da arquitetura é a ordem das operações: primeiro salvamos localmente e só depois enviamos. No Chrome, a imagem é processada para caber em 200 KiB e já viaja com o documento; no aplicativo nativo, a foto espera em um diretório privado até o Storage confirmar. Se o sinal cair, o relato fica marcado como 'aguardando internet' e volta a tentar quando a conexão retorna, quando o app é reaberto ou quando o usuário puxa a lista para atualizar. Essa foi a adaptação mais relevante em relação ao desenho original: trocamos o SQLite pelo cache nativo do Firestore para reduzir dependências e manter a sincronização integrada."

**Visual sugerido**

Diagrama de sequência: app → cache → fila → Firebase, com seta de retorno "conexão restabelecida".

---

# SESSÃO 4 — Entrega e qualidade

### Slide 12 — Privacidade e segurança por design

**Texto do slide**

> ## Anônimo por padrão, seguro por regra
>
> - Login opcional: **Firebase Authentication anônimo**
> - **EXIF removido** antes do upload; compressão para 1024 px (web) e 1280 px (nativo), qualidade 72
> - Regras **Firestore/Storage**: leitura e escrita restritas a `ownerId == auth.uid`; criação só nos estágios iniciais; atualização limitada a cinco campos; **exclusão negada**
> - Fotos em `reports/{uid}/{reportId}/water.jpg`, limite de 5 MB e tipo `image/*`
>
>_privacidade é condição de uso, não detalhe técnico._

**Fala sugerida**

"Marlene receia ser identificada pela comunidade. Por isso o anonimato é o padrão, e o cadastro com e-mail é uma opção, não uma exigência. Antes do envio, os metadados de localização da foto são removidos — a coordenada confirmada pelo usuário fica registrada separadamente no relato. As regras de segurança garantem que cada pessoa veja e altere apenas o que é seu, e a exclusão é negada. Privacidade aqui é o que permite que o aplicativo seja usado."

**Visual sugerido**

Cadeado sobre ícone de foto; ao lado, três linhas das regras em destaque.

---

### Slide 13 — O que foi entregue

**Texto do slide**

> ## Números do piloto implementado
>
> - **31 arquivos Dart** · **2 controllers** · **2 repositórios concretos + 2 contratos** · **1 serviço de processamento de imagem**
> - **10 telas**, incluindo login, cadastro, perfil, mapa, formulário, sucesso, acompanhamento e guia
> - **3 abas fixas** · **12 pontos ilustrativos** no mapa · **5 tipos de fonte de água** · **3 cores de água** · **5 status de relato**
> - Versão **1.0.0+1** · Flutter **3.47.4** · projeto Firebase **aguaviva-26-2**
> - Build web gerado e publicado na **Vercel**
>
> *Os 12 pontos do mapa são demonstrativos; alertas reais do usuário aparecem junto a eles.*

**Fala sugerida**

"O piloto saiu do papel: são 31 arquivos Dart, dez telas e dois controllers para autenticação e notificações. O mapa traz doze pontos ilustrativos para dar contexto e passa a mostrar também os alertas reais registrados pelo usuário. Temos cinco tipos de fonte, três opções de cor e cinco estados de relato, do aguardando internet ao resolvido. A versão entregue é a 1.0.0+1, compilada com Flutter 3.47.4 e publicada como aplicação web."

**Visual sugerido**

Collage com três capturas reais: mapa, formulário e tela "Alerta enviado".

---

### Slide 14 — Validação e deploy

**Texto do slide**

> ## 25 testes e publicação contínua na web
>
> | Arquivo de teste | Casos | O que valida |
> | --- | --- | --- |
> | `auth_screens_test.dart` | 11 | Validação, login, cadastro, recuperação e acesso anônimo |
> | `prototype_fidelity_test.dart` | 8 | Fidelidade ao protótipo, alertas reais, marcadores após zoom |
> | `report_dto_test.dart` | 2 | Contrato de dados e horários cliente/servidor |
> | `photo_preview_test.dart` | 2 | Prévia ≤ 200 KiB e remoção de EXIF |
> | `firebase_startup_test.dart` / `widget_test.dart` | 2 | Splash com retry e guia offline |
>
> **Deploy:** Vercel · Flutter instalado no build · buildCommand de 28 caracteres · rewrite SPA · cache imutável de 1 ano para assets

**Fala sugerida**

"Escrevemos 25 testes em seis arquivos, usando fakes em memória. Os oito testes de fidelidade verificam que os doze pontos do mapa continuam visíveis depois de zoom e enquadramento, além de validar o formulário, a tela de sucesso, o perfil e o aviso de pendência. O build web é publicado pela Vercel: o script instala o Flutter, gera o release e configura o rewrite para a aplicação funcionar como SPA. Isso permite que a banca abra o projeto direto no navegador."

**Visual sugerido**

Painel com "25 testes ✓" em destaque e log de build da Vercel ao lado.

---

# SESSÃO 5 — Impacto e encerramento

### Slide 15 — Limites atuais e próximos passos

**Texto do slide**

> ## O que fica para a próxima etapa
>
> | Item | Situação hoje | Próximo passo |
> | --- | --- | --- |
> | RF04 — confirmar/ajustar o ponto no mapa | GPS aceito automaticamente | Seletor de ponto no formulário |
> | F09 — alertas educativos periódicos | Orientações fixas no guia e no formulário | Notificações leves e periódicas |
> | F10 — painel do agente | Perfil com UBS e microárea; painel “em breve” | Visão consolidada da microárea |
> | Retorno da Vigilância | Status já modelados no app | Backend de gestão e devolução de status |
> | Documentação e código | README e justificativas desatualizados; DTO SQLite legado | Alinhar docs e remover resíduos |
>
> **Fora do escopo atual:** edição/exclusão de relatos e limpeza de dados locais após sincronização.

**Fala sugerida**

"Transparência faz parte da entrega. As seis funcionalidades essenciais e o mapa e acompanhamento estão implementados; três pontos evoluem na próxima etapa: a confirmação do local no mapa, os alertas educativos periódicos e o painel do agente. Também falta a integração real com a Vigilância para devolver os status que o aplicativo já sabe exibir. Há ainda dívidas pequenas de documentação e um DTO do antigo modelo SQLite que pode ser removido. Nenhum desses pontos impede o uso do piloto; eles definem o roadmap."

**Visual sugerido**

Tabela com coluna "próximo passo" em azul; ícone de estrada/roadmap no canto.

---

### Slide 16 — Encerramento

**Texto do slide**

> ## ÁguaViva
>
> **Registrar é proteger.** Em uma comunidade sem saneamento, uma foto com localização pode antecipar uma visita da Vigilância e evitar que uma família beba água imprópria.
>
> - Notificação rápida, anônima e offline
> - Orientação imediata de fervura e cloração
> - Ciclo fechado com acompanhamento do status
>
> **Obrigado pela atenção.**
>
> Guilherme Eugênio · Enzo Figueiredo · Guilherme Rodrigues · Gabriel Almeida · Guilherme Oliveira

**Fala sugerida**

"Fechamos com a ideia central: registrar é proteger. O ÁguaViva transforma um sinal que hoje passaria despercebido em um dado com foto, local e responsável pelo atendimento. Ele funciona onde o sinal não chega, protege quem notifica e orienta a família enquanto a resposta oficial não vem. É um projeto modesto em escala, mas com impacto direto na prevenção de doenças de veiculação hídrica. Obrigado."

**Visual sugerido**

Mesma capa, com uma frase curta em destaque: **“Registrar é proteger.”**

---

## Apêndice — Fatos de apoio para perguntas da banca

- **Pesquisa:** 11 fontes oficiais e científicas em `docs/pesquisa.md` (SINISA, Trata Brasil, IBGE/PNADC, ABAS/Sisagua, FIMCA Jaru, Portaria GM/MS 888/2021, entre outras).
- **Documentação do projeto:** 6 arquivos Markdown e 8 PDFs em `docs/`, além de 13 entradas no `CHANGELOG.md` (01/09 a 17/11/2026).
- **Escopo documentado:** 10 funcionalidades, 12 RF, 9 RNF, matriz CRUD com 6 informações; MVP com 6 essenciais, 2 importantes e 2 secundárias.
- **Implementação:** `frontend/lib` com 31 arquivos Dart; `frontend/test` com 25 testes; build web em `frontend/build/web`; versão `1.0.0+1`.
- **Firebase:** projeto `aguaviva-26-2`; Auth (e-mail/senha, recuperação e anônimo), Firestore com persistência ilimitada, Storage com regras por proprietário.
- **Mapa:** `flutter_map` + tiles OpenStreetMap, 12 pontos demonstrativos, zoom de 10.0 a 12.5, botão “Minha localização” e “Ver todos os pontos”.
- **Processamento de imagem:** prévia web ≤ 200 KiB (1024 px, qualidade 72, EXIF removido); nativo até 1280 px, qualidade 72; upload com timeout de 45 s.
- **Deploy:** `vercel.json` + `scripts/vercel-build.sh`; framework `null`, output em `frontend/build/web`, rewrite SPA e cache de 1 ano para `/assets`.
- **Divergências conhecidas (evolução do piloto):** `README.md` da raiz ainda diz que a implementação não estava incluída; `docs/justificativas.md` descreve SQLite, mas o código usa cache do Firestore; `PendingReportDto` e seu teste são resíduos do modelo antigo.
