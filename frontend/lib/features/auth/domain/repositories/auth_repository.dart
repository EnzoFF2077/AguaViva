import '../entities/app_user.dart';

abstract class AuthRepository {
  /// Emite sempre que o estado de autenticacao muda (login, cadastro,
  /// acesso anonimo ou saida).
  Stream<AppUser?> get authStateChanges;

  AppUser? get currentUser;

  /// Entra com e-mail e senha via Firebase Authentication.
  Future<AppUser> signIn({required String email, required String password});

  /// Cria a conta no Firebase Authentication e salva o perfil no Firestore.
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  });

  /// Mantem o acesso sem cadastro para avisar sobre a agua.
  Future<AppUser> signInAnonymously();

  /// Envia o link de redefinicao de senha para o [email].
  Future<void> sendPasswordReset({required String email});

  Future<void> signOut();
}
