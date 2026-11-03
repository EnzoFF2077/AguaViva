# ÁguaViva

Piloto Flutter para registro anônimo de suspeitas sobre a qualidade da água.

## Escopo do piloto

- autenticação anônima com Firebase Authentication;
- relatos persistidos no Cloud Firestore, incluindo cache offline nativo;
- no Chrome, prévia JPEG sem EXIF de até 200 KiB em `reports/{id}`, no campo `photo.previewBytes`;
- nos aplicativos nativos, envio da foto ao Firebase Storage;
- repetição do upload ao abrir o app, voltar ao primeiro plano ou recuperar a conexão;
- acompanhamento das próprias notificações;
- guia de tratamento disponível offline.

Não há SQLite, Hive, Drift ou outro banco de dados local.

## Preparação do Firebase

No projeto `aguaviva-26-2`:

1. habilite o provedor de autenticação anônima;
2. crie o banco Cloud Firestore;
3. para o Chrome, publique as regras com `firebase deploy --only firestore:rules`;
4. para o piloto nativo com fotos, habilite o Cloud Storage e publique também as regras de Storage.

O primeiro acesso exige internet para criar a conta anônima. Depois da ativação,
os documentos podem ser gravados offline pelo cache do Firestore. No piloto nativo, a fotografia
permanece temporariamente no diretório privado do aplicativo até o Storage
confirmar o upload.

## Executar

```sh
flutter pub get
flutter run
```

No Windows, plugins Flutter exigem suporte a links simbólicos. Ative o Modo de
Desenvolvedor do Windows antes de compilar o aplicativo.
