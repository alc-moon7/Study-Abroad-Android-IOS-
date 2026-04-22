import 'package:flutter/material.dart';

import 'assistant_qualification_intro_screen.dart';
import 'assistant_question_screen.dart';

class AssistantBudgetIntroScreen extends StatelessWidget {
  const AssistantBudgetIntroScreen({super.key});

  static const List<AssistantChoiceData> _choices = [
    AssistantChoiceData(
      label: 'Under \$10K',
      trailing: 'USD',
    ),
    AssistantChoiceData(
      label: '\$10K-\$20K',
      trailing: 'USD',
    ),
    AssistantChoiceData(
      label: '\$20K-\$35K',
      trailing: 'USD',
    ),
    AssistantChoiceData(
      label: '\$35K+',
      trailing: 'USD',
    ),
    AssistantChoiceData(
      label: 'Need Advice',
      trailing: 'AI',
    ),
  ];

  static Future<void> _goToQualification(
    BuildContext context,
    String? answer,
  ) async {
    await Navigator.of(context).push(
      buildAssistantFlowRoute(
        const AssistantQualificationIntroScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AssistantQuestionScreen(
      questionText:
          "\n \n      What is your budget\n      for studying abroad?",
      choices: _choices,
      stepIndex: 1,
      totalSteps: 3,
      onNext: _goToQualification,
      onSkip: _goToQualification,
    );
  }
}
