import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/app/startup_limits.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets(
    'mostra a primeira tela enquanto aguarda o Firebase e permite repetir',
    (tester) async {
      var initialization = Completer<void>();
      await tester.pumpWidget(
        FirebaseStartup(initialize: () => initialization.future),
      );
      expect(find.text('ÁguaViva'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      initialization.completeError(StateError('falha de teste'));
      await tester.pump();
      await tester.pump();
      expect(find.textContaining('falha de teste'), findsOneWidget);

      initialization = Completer<void>();
      await tester.tap(find.text('Tentar novamente'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.textContaining('falha de teste'), findsNothing);
    },
  );

  testWidgets(
    'abre o modo básico quando a inicialização passa do limite de 3 s',
    (tester) async {
      final initialization = Completer<void>();
      await tester.pumpWidget(
        FirebaseStartup(
          initialize: () => initialization.future,
          limits: const StartupLimits(
            total: Duration(milliseconds: 50),
            slowHint: Duration(milliseconds: 10),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 15));
      expect(find.textContaining('conexão está lenta'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 50));
      expect(find.textContaining('modo básico'), findsOneWidget);
      expect(find.text('Como tratar a água'), findsOneWidget);
      expect(find.text('Tentar novamente'), findsOneWidget);
    },
  );
}
