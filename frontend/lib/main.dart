import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/offline_startup_page.dart';
import 'app/startup_limits.dart';
import 'app/startup_page.dart';
import 'app/theme/app_theme.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FirebaseStartup());
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
}

enum _StartupOutcome { pending, ready, timedOut, failed }

/// Porta de entrada que aplica um orçamento de tempo à inicialização.
///
/// O Firebase precisa ser inicializado antes de qualquer tela que use Auth ou
/// Firestore, mas uma conexão lenta não pode prender o usuário para sempre.
/// Após [StartupLimits.total] o app abre o modo básico; se a inicialização
/// terminar depois disso, a troca para o app completo acontece automaticamente.
class FirebaseStartup extends StatefulWidget {
  const FirebaseStartup({
    super.key,
    this.initialize = _initializeFirebase,
    this.limits = const StartupLimits(),
  });

  final Future<void> Function() initialize;
  final StartupLimits limits;

  @override
  State<FirebaseStartup> createState() => _FirebaseStartupState();
}

class _FirebaseStartupState extends State<FirebaseStartup> {
  _StartupOutcome _outcome = _StartupOutcome.pending;
  Object? _error;
  bool _showSlowHint = false;
  Timer? _budgetTimer;
  Timer? _hintTimer;

  @override
  void initState() {
    super.initState();
    _start(widget.initialize());
  }

  @override
  void dispose() {
    _budgetTimer?.cancel();
    _hintTimer?.cancel();
    super.dispose();
  }

  void _start(Future<void> initialization) {
    _budgetTimer?.cancel();
    _hintTimer?.cancel();
    setState(() {
      _outcome = _StartupOutcome.pending;
      _error = null;
      _showSlowHint = false;
    });

    _budgetTimer = Timer(widget.limits.total, () {
      if (_outcome == _StartupOutcome.pending) {
        setState(() => _outcome = _StartupOutcome.timedOut);
      }
    });
    _hintTimer = Timer(widget.limits.slowHint, () {
      if (mounted && _outcome == _StartupOutcome.pending) {
        setState(() => _showSlowHint = true);
      }
    });

    initialization.then(
      (_) => _complete(_StartupOutcome.ready),
      onError: (Object error) => _complete(_StartupOutcome.failed, error),
    );
  }

  void _complete(_StartupOutcome outcome, [Object? error]) {
    if (!mounted) return;
    // Uma inicialização lenta que termina depois do limite promove o modo
    // básico para o app completo. Falhas explícitas mantêm a tela de erro.
    if (_outcome == _StartupOutcome.ready ||
        _outcome == _StartupOutcome.failed ||
        _outcome == outcome) {
      return;
    }
    _budgetTimer?.cancel();
    _hintTimer?.cancel();
    setState(() {
      _outcome = outcome;
      _error = error;
      _showSlowHint = false;
    });
  }

  void _retry() => _start(widget.initialize());

  @override
  Widget build(BuildContext context) {
    switch (_outcome) {
      case _StartupOutcome.ready:
        return const AguaVivaApp();

      case _StartupOutcome.timedOut:
        return MaterialApp(
          theme: AppTheme.light,
          home: OfflineStartupPage(onRetry: _retry),
        );

      case _StartupOutcome.failed:
        return MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Não foi possível iniciar o ÁguaViva.'),
                  Text('$_error', textAlign: TextAlign.center),
                  FilledButton(
                    onPressed: _retry,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          ),
        );

      case _StartupOutcome.pending:
        return MaterialApp(
          theme: AppTheme.light,
          home: StartupPage(
            message: _showSlowHint
                ? 'A conexão está lenta. Estamos abrindo o aplicativo…'
                : 'Abrindo o aplicativo…',
          ),
        );
    }
  }
}
