/// Orçamento de tempo para a inicialização do aplicativo.
///
/// O limite [total] garante que o usuário nunca fique preso a uma tela de
/// carregamento: ao atingi-lo, o app abre o modo básico (guia de tratamento,
/// sem Firebase) e continua tentando inicializar em segundo plano.
class StartupLimits {
  const StartupLimits({
    this.total = const Duration(seconds: 3),
    this.slowHint = const Duration(seconds: 1),
    this.activation = const Duration(seconds: 2),
  });

  /// Tempo máximo para o Firebase responder antes de abrir o modo básico.
  final Duration total;

  /// Quando avisar que a inicialização está demorando mais do que o usual.
  final Duration slowHint;

  /// Tempo máximo para a ativação da sessão (acesso anônimo/conectividade).
  final Duration activation;
}
