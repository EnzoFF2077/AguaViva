import 'package:flutter/material.dart';

import '../../features/auth/data/repositories/firebase_auth_repository.dart';
import '../../features/auth/domain/entities/app_user.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/reports/data/repositories/firebase_report_repository.dart';
import '../../features/reports/presentation/controllers/report_controller.dart';
import '../../features/reports/presentation/pages/app_shell.dart';
import 'theme/app_theme.dart';

class AguaVivaApp extends StatelessWidget {
  const AguaVivaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ÁguaViva',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AuthGate(),
    );
  }
}

/// Decide a primeira tela do app conforme o estado de autenticacao:
/// sem sessao mostra o login; autenticado (conta ou acesso anonimo)
/// mostra a area principal com os alertas de agua.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key, FirebaseAuthRepository? repository})
    : _repositoryOverride = repository;

  final FirebaseAuthRepository? _repositoryOverride;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final FirebaseAuthRepository _repository =
      widget._repositoryOverride ?? FirebaseAuthRepository();
  late final AuthController _authController = AuthController(_repository);

  @override
  void dispose() {
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: _repository.authStateChanges,
      initialData: _repository.currentUser,
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user == null) {
          return LoginScreen(controller: _authController);
        }
        return _AuthenticatedArea(
          user: user,
          onSignOut: _authController.signOut,
        );
      },
    );
  }
}

/// Area principal do app, montada apenas enquanto ha usuario autenticado.
///
/// O [ReportController] e criado aqui, garantindo que o repositorio de
/// alertas use o usuario da sessao atual e nao crie um acesso anonimo
/// antes do login.
class _AuthenticatedArea extends StatefulWidget {
  const _AuthenticatedArea({required this.user, required this.onSignOut});

  final AppUser user;
  final Future<void> Function() onSignOut;

  @override
  State<_AuthenticatedArea> createState() => _AuthenticatedAreaState();
}

class _AuthenticatedAreaState extends State<_AuthenticatedArea>
    with WidgetsBindingObserver {
  late final FirebaseReportRepository _repository;
  late final ReportController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _repository = FirebaseReportRepository();
    _controller = ReportController(_repository)..initialize();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller.retryPendingUploads();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _repository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSignOut = !widget.user.isAnonymous;
    return AppShell(
      controller: _controller,
      onSignOut: canSignOut ? widget.onSignOut : null,
    );
  }
}
