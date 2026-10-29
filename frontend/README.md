# ÁguaViva

Piloto Flutter para registro anônimo de suspeitas sobre a qualidade da água.

## Escopo do piloto

- autenticação anônima com Firebase Authentication;
- relatos persistidos no Cloud Firestore, incluindo cache offline nativo;
- foto comprimida e sem metadados EXIF enviada ao Firebase Storage;
- repetição do upload ao abrir o app, voltar ao primeiro plano ou recuperar a conexão;
- acompanhamento das próprias notificações;
- guia de tratamento disponível offline.

Não há SQLite, Hive, Drift ou outro banco de dados local.

## Preparação do Firebase

No projeto `aguaviva-26-2`:

1. habilite o provedor de autenticação anônima;
2. crie o banco Cloud Firestore;
3. habilite o Cloud Storage;
4. publique as regras com `firebase deploy --only firestore:rules,storage`.

O primeiro acesso exige internet para criar a conta anônima. Depois da ativação,
os documentos podem ser gravados offline pelo cache do Firestore. A fotografia
permanece temporariamente no diretório privado do aplicativo até o Storage
confirmar o upload.

## Executar

```sh
flutter pub get
flutter run
```

No Windows, plugins Flutter exigem suporte a links simbólicos. Ative o Modo de
Desenvolvedor do Windows antes de compilar o aplicativo.
