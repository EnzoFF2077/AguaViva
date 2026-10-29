import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../guide/presentation/pages/treatment_guide_page.dart';
import '../controllers/report_controller.dart';
import 'home_page.dart';
import 'my_reports_page.dart';
import 'report_form_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.controller});

  final ReportController controller;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

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
        if (widget.controller.isInitializing) {
          return const _StartupPage();
        }
        if (widget.controller.initializationError case final error?) {
          return _ActivationPage(
            message: error,
            onRetry: widget.controller.initialize,
          );
        }

        final pages = [
          HomePage(onCreateReport: _openReportForm),
          const TreatmentGuidePage(),
          MyReportsPage(controller: widget.controller),
        ];
        return Scaffold(
          body: IndexedStack(index: _index, children: pages),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (value) => setState(() => _index = value),
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

class _StartupPage extends StatelessWidget {
  const _StartupPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.water_drop, color: Colors.white, size: 64),
            SizedBox(height: 16),
            Text(
              'ÁguaViva',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _ActivationPage extends StatelessWidget {
  const _ActivationPage({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ativar ÁguaViva')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 72, color: AppColors.primary),
              const SizedBox(height: 24),
              Text(
                'Precisamos de internet no primeiro acesso',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: onRetry,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
