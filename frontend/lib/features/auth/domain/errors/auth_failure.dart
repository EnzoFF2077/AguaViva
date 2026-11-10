/// Falha de autenticacao com mensagem pronta para exibir ao usuario.
///
/// A camada de dados traduz os codigos do Firebase para mensagens em
/// portugues, mantendo o dominio livre de dependencias externas.
class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}
