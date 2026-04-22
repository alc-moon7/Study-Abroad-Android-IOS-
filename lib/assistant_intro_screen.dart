import 'package:flutter/material.dart';

import 'assistant_budget_intro_screen.dart';
import 'assistant_question_screen.dart';

class AssistantIntroScreen extends StatefulWidget {
  const AssistantIntroScreen({super.key});

  @override
  State<AssistantIntroScreen> createState() => _AssistantIntroScreenState();
}

class _AssistantIntroScreenState extends State<AssistantIntroScreen> {
  static const List<AssistantChoiceData> _choices = [
    AssistantChoiceData(
      label: 'USA',
      trailing: '\u{1F1FA}\u{1F1F8}',
    ),
    AssistantChoiceData(
      label: 'UK',
      trailing: '\u{1F1EC}\u{1F1E7}',
    ),
    AssistantChoiceData(
      label: 'Canada',
      trailing: '\u{1F1E8}\u{1F1E6}',
    ),
    AssistantChoiceData(
      label: 'Australia',
      trailing: '\u{1F1E6}\u{1F1FA}',
    ),
    AssistantChoiceData(
      label: 'Europe',
      trailing: '\u{1F1EA}\u{1F1FA}',
    ),
  ];

  static Future<void> _goToBudget(BuildContext context, String? answer) async {
    await Navigator.of(context).push(
      buildAssistantFlowRoute(
        const AssistantBudgetIntroScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AssistantQuestionScreen(
      questionText:
          "\n                  Hi...!\n   Which Country would\n     you like to study in?",
      choices: _choices,
      stepIndex: 0,
      totalSteps: 3,
      onNext: _goToBudget,
      onSkip: _goToBudget,
    );
  }
}
