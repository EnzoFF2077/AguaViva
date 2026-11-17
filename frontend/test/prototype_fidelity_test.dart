import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/app/theme/app_theme.dart';
import 'package:frontend/features/auth/domain/entities/app_user.dart';
import 'package:frontend/features/auth/presentation/pages/profile_page.dart';
import 'package:frontend/features/reports/domain/entities/report_draft.dart';
import 'package:frontend/features/reports/domain/entities/water_report.dart';
import 'package:frontend/features/reports/domain/repositories/report_repository.dart';
import 'package:frontend/features/reports/presentation/controllers/report_controller.dart';
import 'package:frontend/features/reports/presentation/pages/home_page.dart';
import 'package:frontend/features/reports/presentation/pages/my_reports_page.dart';
import 'package:frontend/features/reports/presentation/pages/report_form_page.dart';
import 'package:frontend/features/reports/presentation/pages/report_success_page.dart';

class FakeReportRepository implements ReportRepository {
  final _reports = StreamController<List<WaterReport>>.broadcast();

  @override
  Future<void> initialize() async {}

  @override
  Stream<List<WaterReport>> watchOwnReports() => _reports.stream;

  @override
  Future<WaterReport> submit(ReportDraft draft) =>
      throw UnimplementedError('submit nao usado nos testes de tela');

  @override
  Future<void> retryPendingUploads() async {}

  void emit(List<WaterReport> reports) => _reports.add(reports);

  void dispose() => _reports.close();
}

Widget _wrap(Widget child) => MaterialApp(theme: AppTheme.light, home: child);

/// Rola o ListView ate o texto existir e depois o valida.
Future<void> _expectText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  await tester.scrollUntilVisible(finder, 150);
  expect(finder, findsOneWidget);
}

void main() {
  testWidgets('home exibe regiao, legenda, alertas e chamado do prototipo', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(HomePage(onCreateReport: () {})));

    expect(find.text('ÁguaViva'), findsOneWidget);
    expect(find.text('Sua região · 12 pontos monitorados'), findsOneWidget);
    expect(find.text('Limpa'), findsOneWidget);
    expect(find.text('Suspeita'), findsOneWidget);
    expect(find.text('Alertas perto de você'), findsOneWidget);
    expect(find.text('Poço do Sítio Boa Vista'), findsOneWidget);
    expect(find.text('Água esbranquiçada e com cheiro forte'), findsOneWidget);
    expect(find.text('Contaminada'), findsNWidgets(2));
    expect(find.text('há 2 h'), findsOneWidget);
    expect(find.text('Torneira comunitária — Rua 7'), findsOneWidget);
    expect(find.text('Água com cor de barro depois da chuva'), findsOneWidget);
    expect(find.text('Em análise'), findsOneWidget);
    expect(find.text('há 5 h'), findsOneWidget);
    await _expectText(tester, 'A água está estranha');
  });

  testWidgets('formulario segue as perguntas e botoes do prototipo', (
    tester,
  ) async {
    final repository = FakeReportRepository();
    addTearDown(repository.dispose);
    final controller = ReportController(repository);
    addTearDown(controller.dispose);

    await tester.pumpWidget(_wrap(ReportFormPage(controller: controller)));

    expect(find.text('A água está estranha'), findsOneWidget);
    await _expectText(tester, 'Toque para tirar a foto da água');
    await _expectText(tester, 'Funciona sem internet');
    await _expectText(tester, 'Como está a cor da água?');
    await _expectText(tester, 'Normal');
    await _expectText(tester, 'Leitosa');
    await _expectText(tester, 'Escura ou com barro');
    await _expectText(tester, 'A água tem cheiro forte?');
    await _expectText(tester, 'Sim');
    await _expectText(tester, 'Não');
    await _expectText(tester, 'Local encontrado pelo GPS');
    await _expectText(tester, 'Enviar alerta');
    await _expectText(
      tester,
      'Seu alerta é enviado sem o seu nome. Sem internet, ele fica guardado '
      'no aparelho e sai sozinho depois.',
    );

    // Campos que nao aparecem no prototipo foram removidos da tela.
    expect(find.text('De onde vem essa água?'), findsNothing);
    expect(
      find.text('Quer contar mais alguma coisa? (opcional)'),
      findsNothing,
    );
  });

  testWidgets('confirmacao mostra o numero do alerta e as duas acoes', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const ReportSuccessPage(reportId: 'alerta-2481')),
    );

    expect(find.text('Alerta enviado'), findsOneWidget);
    expect(
      find.text(
        'Seu alerta foi enviado sem o seu nome. A Vigilância Sanitária vai '
        'analisar e responder aqui no aplicativo.',
      ),
      findsOneWidget,
    );
    expect(find.text('Número do seu alerta'), findsOneWidget);
    expect(find.text('#2481'), findsOneWidget);
    expect(find.text('Ver minhas notificações'), findsOneWidget);
    expect(find.text('Voltar ao início'), findsOneWidget);
  });

  testWidgets('perfil exibe agente, area de atuacao e opcoes da conta', (
    tester,
  ) async {
    final user = AppUser(
      uid: 'u1',
      email: 'agente@exemplo.com',
      displayName: 'Josimar Alfredo Lima',
      isAnonymous: false,
    );
    await tester.pumpWidget(
      _wrap(
        ProfilePage(
          user: user,
          onBack: () {},
          onSignOut: () {},
          onChangePassword: () {},
        ),
      ),
    );

    expect(find.text('Meu Perfil'), findsOneWidget);
    await _expectText(tester, 'Josimar Alfredo Lima');
    await _expectText(tester, 'Agente Comunitário de Saúde');
    await _expectText(tester, 'Editar Foto De Perfil');
    await _expectText(tester, 'Minha Área De Atuação');
    await _expectText(tester, 'Unidade De Saúde Responsável');
    await _expectText(tester, 'UBS Alyrio Freitas');
    await _expectText(tester, 'Microárea');
    await _expectText(tester, '03 - Zona Rural');
    await _expectText(tester, 'Ver painel da minha área');
    await _expectText(tester, 'Minha Conta');
    await _expectText(tester, 'Alterar Minha Senha');
    await _expectText(tester, 'Sair Da Conta');
  });

  testWidgets('notificacoes mostram o aviso de pendencia do prototipo', (
    tester,
  ) async {
    final repository = FakeReportRepository();
    addTearDown(repository.dispose);
    final controller = ReportController(repository);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _wrap(MyReportsPage(controller: controller, onOpenProfile: () {})),
    );
    await tester.pump();

    // O stream e broadcast: emite depois que a pagina ja esta inscrita.
    repository.emit([
      WaterReport(
        id: 'r1',
        ownerId: 'u1',
        sourceType: WaterSourceType.well,
        sourceName: 'Poço do Sítio Boa Vista',
        waterColor: WaterColor.darkOrMuddy,
        hasStrongOdor: true,
        description: null,
        location: const ReportLocation(
          latitude: -9,
          longitude: -35,
          accuracy: 2,
          confirmed: true,
        ),
        photoStoragePath: null,
        photoStatus: PhotoUploadStatus.uploaded,
        status: ReportStatus.resolved,
        createdAt: DateTime(2026, 5, 12),
        updatedAt: DateTime(2026, 5, 12),
        responseMessage: 'Ponto tratado e liberado para consumo.',
      ),
    ]);
    await tester.pump();

    await _expectText(
      tester,
      '1 notificação guardada no aparelho. Ela será enviada quando houver '
      'internet.',
    );
    await _expectText(tester, 'Meu Perfil');
    await _expectText(tester, 'Poço do Sítio Boa Vista');
    await _expectText(tester, 'Vigilância Sanitária');
    await _expectText(tester, 'Ponto tratado e liberado para consumo.');
  });
}
