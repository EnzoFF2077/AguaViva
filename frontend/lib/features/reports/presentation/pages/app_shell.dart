import 'package:flutter/material.dart';

import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/pages/profile_page.dart';
import '../../../guide/presentation/pages/treatment_guide_page.dart';
import '../controllers/report_controller.dart';
import 'home_page.dart';
import 'my_reports_page.dart';
import 'report_form_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.controller,
    required this.user,
    this.onSignOut,
    this.onChangePassword,
  });

  final ReportController controller;
  final AppUser user;

  /// Sair da conta e voltar para o login. `null` quando o acesso é
  /// anônimo, para não perder os alertas do aparelho.
  final Future<void> Function()? onSignOut;

  /// Envia o link de redefinição de senha para o e-mail da conta.
  final Future<void> Function()? onChangePassword;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  bool _showProfile = false;

  Future<void> _openReportForm() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ReportFormPage(controller: widget.controller),
      ),
    );
    if (created == true && mounted) setState(() => _index = 2);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        // A ativação da sessão acontece em segundo plano: as três abas ficam
        // navegáveis desde o primeiro frame, inclusive sem conexão.
        final initializing = widget.controller.isInitializing;
        final activationError = widget.controller.initializationError;

        final pages = <Widget>[
          HomePage(
            controller: widget.controller,
            onCreateReport: _openReportForm,
            onSignOut: widget.onSignOut == null
                ? null
                : () => widget.onSignOut!(),
          ),
          TreatmentGuidePage(onBack: () => setState(() => _index = 0)),
          if (_showProfile)
            ProfilePage(
              user: widget.user,
              onBack: () => setState(() => _showProfile = false),
              onSignOut: widget.onSignOut == null
                  ? null
                  : () => widget.onSignOut!(),
              onChangePassword: widget.onChangePassword,
            )
          else
            MyReportsPage(
              controller: widget.controller,
              onOpenProfile: () => setState(() => _showProfile = true),
            ),
        ];

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                if (initializing)
                  const LinearProgressIndicator(minHeight: 3),
                if (activationError case final error?)
                  MaterialBanner(
                    leading: const Icon(Icons.cloud_off),
                    content: Text(error),
                    actions: [
                      TextButton(
                        onPressed: widget.controller.initialize,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                Expanded(child: IndexedStack(index: _index, children: pages)),
              ],
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (value) => setState(() {
              _index = value;
              _showProfile = false;
            }),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.warning_amber_rounded),
                selectedIcon: Icon(Icons.warning_rounded),
                label: 'Alertas',
              ),
              NavigationDestination(
                icon: Icon(Icons.water_drop_outlined),
                selectedIcon: Icon(Icons.water_drop),
                label: 'Tratar água',
              ),
              NavigationDestination(
                icon: Icon(Icons.list_alt_outlined),
                selectedIcon: Icon(Icons.list_alt),
                label: 'Minhas',
              ),
            ],
          ),
        );
      },
    );
  }
}
