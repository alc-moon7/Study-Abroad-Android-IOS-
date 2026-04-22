import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:study_abroad_app/assistant_intro_screen.dart';
import 'package:study_abroad_app/assistant_budget_intro_screen.dart';
import 'package:study_abroad_app/assistant_qualification_intro_screen.dart';
import 'package:study_abroad_app/main.dart';

void main() {
  testWidgets('Splash screen renders branded copy',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());

    expect(find.text('Study Abroad'), findsOneWidget);
    expect(find.text('Your AI Study Abroad Companion'), findsOneWidget);
    expect(find.textContaining('Visily'), findsNothing);
  });

  testWidgets('Assistant intro screen renders key elements',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: AssistantIntroScreen(),
      ),
    );

    await tester.pump(const Duration(milliseconds: 1200));

    expect(find.text('NEW ASSISTANT'), findsOneWidget);
    expect(find.text('POPULAR CHOICES'), findsOneWidget);
    expect(find.text('Type your answer....'), findsOneWidget);
  });

  testWidgets('Assistant flow routes through budget and qualification pages',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: AssistantIntroScreen(),
      ),
    );

    await tester.pump(const Duration(milliseconds: 1200));
    expect(find.text('USA'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.byType(AssistantBudgetIntroScreen), findsOneWidget);
    expect(find.text('Under \$10K'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.byType(AssistantQualificationIntroScreen), findsOneWidget);
    expect(find.text("Bachelor's"), findsOneWidget);
  });
}
