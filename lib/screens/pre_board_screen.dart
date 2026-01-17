import 'package:flutter/material.dart';
import '../widgets/exam_widget.dart';

class PreBoardScreen extends StatelessWidget {
  const PreBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamWidget(
      csvPath: 'assets/exam/PRE_BOARD.csv', // ✅ your CSV file
      examType: 'pre-board',
      numberOfQuestions: 15, // Control how many questions to display
      examDurationMinutes: 20, // Control time limit in minutes
    );
  }
}
