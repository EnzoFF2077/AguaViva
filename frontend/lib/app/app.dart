import 'package:flutter/material.dart';

import '../features/reports/data/repositories/firebase_report_repository.dart';
import '../features/reports/presentation/controllers/report_controller.dart';
import '../features/reports/presentation/pages/app_shell.dart';
import 'theme/app_theme.dart';

class AguaVivaApp extends StatefulWidget {
  const AguaVivaApp({super.key});

  @override
  State<AguaVivaApp> createState() => _AguaVivaAppState();
}

class _AguaVivaAppState extends State<AguaVivaApp> with WidgetsBindingObserver {
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
    return MaterialApp(
      title: 'ÁguaViva',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: AppShell(controller: _controller),
    );
  }
}
