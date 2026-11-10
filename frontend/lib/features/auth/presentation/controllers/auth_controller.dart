import 'package:flutter/foundation.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/errors/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';

/// Controla as acoes de autenticacao e expoe o estado de ocupado para as
/// telas mostrarem o progresso.
///
/// Os metodos retornam `null` quando dao certo ou a mensagem de erro pronta
/// para exibir ao usuario.
class AuthController extends ChangeNotifier {
  AuthController(this._repository);

  final AuthRepository _repository;

  bool _busy = false;
  bool get busy => _busy;

  Future<String?> signIn({required String email, required String password}) =>
      _run(() => _repository.signIn(email: email, password: password));

  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) => _run(
    () => _repository.register(name: name, email: email, password: password),
  );

  Future<String?> continueWithoutAccount() =>
      _run(_repository.signInAnonymously);

  Future<String?> sendPasswordReset({required String email}) async {
    if (_busy) return 'Aguarde a operação atual terminar.';
    _busy = true;
    notifyListeners();
    try {
      await _repository.sendPasswordReset(email: email);
      return null;
    } on AuthFailure catch (error) {
      return error.message;
    } catch (error, stack) {
      debugPrint('Falha ao enviar a recuperacao de senha: $error\n$stack');
      return 'Não foi possível enviar o e-mail. Tente novamente.';
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _repository.signOut();
    } catch (error, stack) {
      debugPrint('Falha ao sair da conta: $error\n$stack');
    }
  }

  Future<String?> _run(Future<AppUser> Function() action) async {
    if (_busy) return 'Aguarde a operação atual terminar.';
    _busy = true;
    notifyListeners();
    try {
      await action();
      return null;
    } on AuthFailure catch (error) {
      return error.message;
    } catch (error, stack) {
      debugPrint('Falha de autenticacao: $error\n$stack');
      return 'Não foi possível concluir agora. Tente novamente.';
    } finally {
      _busy = false;
      notifyListeners();
    }
  }
}
