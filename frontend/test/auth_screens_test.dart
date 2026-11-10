import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/app/theme/app_theme.dart';
import 'package:frontend/features/auth/domain/entities/app_user.dart';
import 'package:frontend/features/auth/domain/errors/auth_failure.dart';
import 'package:frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frontend/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frontend/features/auth/presentation/pages/login_screen.dart';
import 'package:frontend/features/auth/presentation/pages/register_screen.dart';

/// Repositorio em memoria para exercitar as telas sem Firebase.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.signInFailure, this.registerFailure});

  String? signInFailure;
  String? registerFailure;

  String? lastSignInEmail;
  String? lastSignInPassword;
  String? lastRegisterName;
  String? lastRegisterEmail;
  String? lastRegisterPassword;
  bool anonymousSignIn = false;
  final List<String> resetEmails = [];

  AppUser? user;

  final _states = StreamController<AppUser?>.broadcast();

  void emit(AppUser? value) {
    user = value;
    _states.add(value);
  }

  @override
  Stream<AppUser?> get authStateChanges => _states.stream;

  @override
  AppUser? get currentUser => user;

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    lastSignInEmail = email;
    lastSignInPassword = password;
    if (signInFailure != null) throw AuthFailure(signInFailure!);
    final signed = AppUser(uid: 'user-1', email: email, isAnonymous: false);
    emit(signed);
    return signed;
  }

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    lastRegisterName = name;
    lastRegisterEmail = email;
    lastRegisterPassword = password;
    if (registerFailure != null) throw AuthFailure(registerFailure!);
    final created = AppUser(
      uid: 'user-2',
      email: email,
      displayName: name.isEmpty ? null : name,
      isAnonymous: false,
    );
    emit(created);
    return created;
  }

  @override
  Future<AppUser> signInAnonymously() async {
    anonymousSignIn = true;
    final anonymous = AppUser(uid: 'anon-1', isAnonymous: true);
    emit(anonymous);
    return anonymous;
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    resetEmails.add(email);
  }

  @override
  Future<void> signOut() async {
    emit(null);
  }

  void dispose() => _states.close();
}

Widget _wrap(Widget child) => MaterialApp(theme: AppTheme.light, home: child);

/// Garante que o alvo esta visivel dentro do scroll antes do toque.
Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Finder get _entrarButton => find.widgetWithText(ElevatedButton, 'Entrar');
Finder get _emailFieldLogin =>
    find.widgetWithText(TextFormField, 'Digite seu e-mail');
Finder get _senhaFieldLogin =>
    find.widgetWithText(TextFormField, 'Digite sua senha');
Finder get _nomeField =>
    find.widgetWithText(TextFormField, 'Como podemos chamar você?');
Finder get _emailFieldCadastro =>
    find.widgetWithText(TextFormField, 'Digite seu e-mail');
Finder get _senhaFieldCadastro =>
    find.widgetWithText(TextFormField, 'Crie uma senha');
Finder get _criarContaButtonLogin =>
    find.widgetWithText(OutlinedButton, 'Criar conta');
Finder get _criarContaButtonCadastro =>
    find.widgetWithText(ElevatedButton, 'Criar conta');

Future<void> _abrirCadastro(
  WidgetTester tester,
  AuthController controller,
) async {
  await tester.pumpWidget(_wrap(LoginScreen(controller: controller)));
  await _tap(tester, _criarContaButtonLogin);
}

void main() {
  testWidgets('login exige e-mail e senha preenchidos', (tester) async {
    final repository = FakeAuthRepository();
    await tester.pumpWidget(
      _wrap(LoginScreen(controller: AuthController(repository))),
    );

    await _tap(tester, _entrarButton);

    expect(find.text('Por favor, digite seu e-mail'), findsOneWidget);
    expect(find.text('Por favor, digite sua senha'), findsOneWidget);
    expect(repository.lastSignInEmail, isNull);
  });

  testWidgets('login rejeita e-mail invalido', (tester) async {
    final repository = FakeAuthRepository();
    await tester.pumpWidget(
      _wrap(LoginScreen(controller: AuthController(repository))),
    );

    await tester.enterText(_emailFieldLogin, 'aguaviva');
    await tester.enterText(_senhaFieldLogin, 'senha12345');
    await _tap(tester, _entrarButton);

    expect(find.text('Digite um e-mail válido'), findsOneWidget);
    expect(repository.lastSignInEmail, isNull);
  });

  testWidgets('login com credenciais erradas mostra mensagem amigavel', (
    tester,
  ) async {
    final repository = FakeAuthRepository(
      signInFailure: 'E-mail ou senha incorretos.',
    );
    await tester.pumpWidget(
      _wrap(LoginScreen(controller: AuthController(repository))),
    );

    await tester.enterText(_emailFieldLogin, 'morador@exemplo.com');
    await tester.enterText(_senhaFieldLogin, 'senha-incorreta');
    await _tap(tester, _entrarButton);

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('E-mail ou senha incorretos.'), findsOneWidget);
    expect(repository.lastSignInEmail, 'morador@exemplo.com');
    expect(repository.lastSignInPassword, 'senha-incorreta');
  });

  testWidgets('login com sucesso envia as credenciais sem erro', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    await tester.pumpWidget(
      _wrap(LoginScreen(controller: AuthController(repository))),
    );

    await tester.enterText(_emailFieldLogin, 'morador@exemplo.com');
    await tester.enterText(_senhaFieldLogin, 'senha-forte');
    await _tap(tester, _entrarButton);

    expect(find.byType(SnackBar), findsNothing);
    expect(repository.lastSignInEmail, 'morador@exemplo.com');
    expect(repository.lastSignInPassword, 'senha-forte');
    expect(repository.user?.email, 'morador@exemplo.com');
  });

  testWidgets('continuar sem cadastro usa o acesso anonimo', (tester) async {
    final repository = FakeAuthRepository();
    await tester.pumpWidget(
      _wrap(LoginScreen(controller: AuthController(repository))),
    );

    await _tap(tester, find.text('Continuar sem cadastro'));

    expect(repository.anonymousSignIn, isTrue);
    expect(repository.user?.isAnonymous, isTrue);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('esqueci minha senha envia o e-mail de recuperacao', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    await tester.pumpWidget(
      _wrap(LoginScreen(controller: AuthController(repository))),
    );

    await tester.enterText(_emailFieldLogin, 'morador@exemplo.com');
    await tester.ensureVisible(find.text('Esqueci minha senha'));
    await tester.tap(find.text('Esqueci minha senha'));
    await tester.pumpAndSettle();

    expect(find.text('Recuperar senha'), findsOneWidget);
    // O dialog vem preenchido com o e-mail digitado na tela.
    await tester.tap(find.text('Enviar'));
    await tester.pumpAndSettle();

    expect(repository.resetEmails, ['morador@exemplo.com']);
    expect(find.textContaining('Enviamos um link'), findsOneWidget);
  });

  testWidgets('criar conta abre a tela de cadastro', (tester) async {
    final repository = FakeAuthRepository();
    await _abrirCadastro(tester, AuthController(repository));

    expect(find.byType(RegisterScreen), findsOneWidget);
    expect(find.text('Preencha os dados para começar.'), findsOneWidget);
  });

  testWidgets('cadastro exige senha com pelo menos 8 caracteres', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    await _abrirCadastro(tester, AuthController(repository));

    await tester.enterText(_nomeField, 'Maria');
    await tester.enterText(_emailFieldCadastro, 'maria@exemplo.com');
    await tester.enterText(_senhaFieldCadastro, 'curta');
    await _tap(tester, _criarContaButtonCadastro);

    expect(
      find.text('A senha deve ter pelo menos 8 caracteres'),
      findsOneWidget,
    );
    expect(repository.lastRegisterEmail, isNull);
  });

  testWidgets('cadastro com sucesso registra o usuario e volta ao inicio', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    await _abrirCadastro(tester, AuthController(repository));

    await tester.enterText(_nomeField, 'Maria');
    await tester.enterText(_emailFieldCadastro, 'maria@exemplo.com');
    await tester.enterText(_senhaFieldCadastro, 'senha-forte');
    await _tap(tester, _criarContaButtonCadastro);

    expect(repository.lastRegisterName, 'Maria');
    expect(repository.lastRegisterEmail, 'maria@exemplo.com');
    expect(repository.lastRegisterPassword, 'senha-forte');
    expect(repository.user?.uid, 'user-2');
    // O popUntil devolve para a primeira rota apos a autenticacao.
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(RegisterScreen), findsNothing);
  });

  testWidgets('cadastro com e-mail ja usado mostra mensagem amigavel', (
    tester,
  ) async {
    final repository = FakeAuthRepository(
      registerFailure: 'Já existe uma conta com este e-mail.',
    );
    await _abrirCadastro(tester, AuthController(repository));

    await tester.enterText(_emailFieldCadastro, 'maria@exemplo.com');
    await tester.enterText(_senhaFieldCadastro, 'senha-forte');
    await _tap(tester, _criarContaButtonCadastro);

    expect(find.text('Já existe uma conta com este e-mail.'), findsOneWidget);
    expect(find.byType(RegisterScreen), findsOneWidget);
  });

  testWidgets('voltar do cadastro para o login', (tester) async {
    final repository = FakeAuthRepository();
    await _abrirCadastro(tester, AuthController(repository));
    expect(find.byType(RegisterScreen), findsOneWidget);

    await _tap(tester, find.text('Entrar'));

    expect(find.byType(RegisterScreen), findsNothing);
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
