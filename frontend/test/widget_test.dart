import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/app/theme/app_theme.dart';
import 'package:frontend/features/guide/presentation/pages/treatment_guide_page.dart';

void main() {
  testWidgets('guia de tratamento funciona sem Firebase', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const TreatmentGuidePage()),
    );

    expect(find.text('Como tratar a água'), findsOneWidget);
    expect(find.text('Fervura'), findsOneWidget);
    expect(find.text('Prepare e filtre'), findsOneWidget);

    await tester.tap(find.text('Cloração'));
    await tester.pumpAndSettle();

    expect(find.text('Confira o produto'), findsOneWidget);
    expect(find.text('Siga a dose do rótulo'), findsOneWidget);
  });
}
