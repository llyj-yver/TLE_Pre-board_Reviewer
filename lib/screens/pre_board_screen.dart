import 'package:flutter/material.dart';
import '../widgets/exam_widget.dart';
import '../data/questions_data.dart';

class PreBoardScreen extends StatelessWidget {
  const PreBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamWidget(
      questions: tlePreBoardData,examType: "pre-board" // pass your 2D list here
    );
  }
}
