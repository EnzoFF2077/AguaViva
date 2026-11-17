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
    expect(
      find.text(
        'Enquanto a vigilância não responde, trate a água antes de beber ou cozinhar.',
      ),
      findsOneWidget,
    );
    expect(find.text('Fervura'), findsOneWidget);
    expect(find.text('Coe a água em um pano limpo.'), findsOneWidget);

    await tester.tap(find.text('Cloração'));
    await tester.pumpAndSettle();

    expect(
      find.text('Pingue 2 gotas de água sanitária para cada 1 litro.'),
      findsOneWidget,
    );
    expect(find.text('Misture bem e espere 30 minutos.'), findsOneWidget);
    expect(
      find.text('Só depois disso beba ou use para cozinhar.'),
      findsOneWidget,
    );
    expect(
      find.text('Orientações baseadas em materiais da OMS e da FUNASA.'),
      findsOneWidget,
    );
  });
}
