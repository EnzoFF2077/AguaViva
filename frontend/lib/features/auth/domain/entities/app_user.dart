/// Usuario autenticado no AguaViva.
///
/// [isAnonymous] identifica o acesso sem cadastro, que o app mantem para
/// nao exigir conta de quem so quer avisar sobre a agua.
class AppUser {
  const AppUser({
    required this.uid,
    required this.isAnonymous,
    this.email,
    this.displayName,
  });

  final String uid;
  final String? email;
  final String? displayName;
  final bool isAnonymous;
}
