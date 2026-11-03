import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
}
