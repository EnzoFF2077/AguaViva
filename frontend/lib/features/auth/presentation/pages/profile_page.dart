import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../domain/entities/app_user.dart';

/// Tela "Meu Perfil" do prototipo.
///
/// Os dados da area de atuacao sao informacoes institucionais do agente;
/// nome e e-mail vem da conta autenticada quando disponiveis.
class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.user,
    required this.onBack,
    required this.onSignOut,
    required this.onChangePassword,
  });

  final AppUser user;
  final VoidCallback onBack;

  /// Ausentes no acesso anonimo, que nao tem conta para alterar ou encerrar.
  final VoidCallback? onSignOut;
  final VoidCallback? onChangePassword;

  @override
  Widget build(BuildContext context) {
    final name = user.displayName?.trim().isNotEmpty == true
        ? user.displayName!.trim()
        : 'Josimar Alfredo Lima';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          tooltip: 'Voltar',
          onPressed: onBack,
        ),
        titleSpacing: 0,
        title: const Text('Meu Perfil'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundColor: AppColors.surfaceSoft,
                  child: Icon(Icons.person, size: 58, color: AppColors.primary),
                ),
                const SizedBox(height: 14),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Agente Comunitário de Saúde',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.muted),
                ),
                if (user.email case final email?) ...[
                  const SizedBox(height: 4),
                  Text(
                    email,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => _showMessage(
                    context,
                    'A foto de perfil será disponibilizada em breve.',
                  ),
                  child: const Text(
                    'Editar Foto De Perfil',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Minha Área De Atuação',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const _InfoRow(
              label: 'Unidade De Saúde Responsável',
              value: 'UBS Alyrio Freitas',
            ),
            const SizedBox(height: 10),
            const _InfoRow(label: 'Microárea', value: '03 - Zona Rural'),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: () => _showMessage(
                context,
                'O painel da sua área será disponibilizado em breve.',
              ),
              child: const Text('Ver painel da minha área'),
            ),
            const SizedBox(height: 28),
            Text('Minha Conta', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              color: AppColors.surfaceSoft,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  if (onChangePassword != null)
                    ListTile(
                      leading: const Icon(
                        Icons.lock_outline,
                        color: AppColors.primary,
                      ),
                      title: const Text('Alterar Minha Senha'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: onChangePassword,
                    ),
                  if (onChangePassword != null && onSignOut != null)
                    const Divider(height: 1),
                  if (onSignOut != null)
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: AppColors.danger,
                      ),
                      title: const Text(
                        'Sair Da Conta',
                        style: TextStyle(color: AppColors.danger),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppColors.danger,
                      ),
                      onTap: onSignOut,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD9E5EE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
