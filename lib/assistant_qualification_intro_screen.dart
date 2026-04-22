import 'package:flutter/material.dart';

import 'assistant_question_screen.dart';
import 'university_list.dart';

class AssistantQualificationIntroScreen extends StatelessWidget {
  const AssistantQualificationIntroScreen({super.key});

  static const List<AssistantChoiceData> _choices = [
    AssistantChoiceData(
      label: 'SSC / O Level',
      trailing: '10',
    ),
    AssistantChoiceData(
      label: 'HSC / A Level',
      trailing: '12',
    ),
    AssistantChoiceData(
      label: 'Diploma',
      trailing: 'Dip',
    ),
    AssistantChoiceData(
      label: "Bachelor's",
      trailing: 'UG',
    ),
    AssistantChoiceData(
      label: "Master's",
      trailing: 'PG',
    ),
  ];

  static Future<void> _goToUniversityList(
    BuildContext context,
    String? answer,
  ) async {
    FocusScope.of(context).unfocus();
    await Navigator.of(context).push(
      buildAssistantFlowRoute(
        const UniversityListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AssistantQuestionScreen(
      questionText:
          "\n\n       What is your current\n             qualification?",
      choices: _choices,
      stepIndex: 2,
      totalSteps: 3,
      onNext: _goToUniversityList,
      onSkip: _goToUniversityList,
    );
  }
}
