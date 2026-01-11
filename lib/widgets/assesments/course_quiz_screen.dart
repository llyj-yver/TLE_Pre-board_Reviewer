import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import '../../models/quiz_question.dart';
import 'courses_quiz.dart';
import '../../database/quiz_db.dart';

class QuizScreen extends StatefulWidget {
  final String csvPath;
  final String courseName;

  const QuizScreen({
    super.key,
    required this.csvPath,
    required this.courseName,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static const int maxQuestions = 2;

  List<QuestionModel> questions = [];
  int currentIndex = 0;
  int score = 0;
  bool answered = false;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadCsv();
  }

  Future<void> loadCsv() async {
    try {
      final rawData = await rootBundle.loadString(widget.csvPath);
      final rows = const CsvToListConverter().convert(rawData);

      if (rows.length <= 1) throw Exception('CSV has no data');

      rows.removeAt(0); // remove header

      final allQuestions =
          rows.map((row) => QuestionModel.fromCsv(row)).toList();

      // 🔀 Shuffle questions randomly
      allQuestions.shuffle();

      // 🎯 Take only 30 questions (or less if CSV is smaller)
      questions = allQuestions.take(maxQuestions).toList();
    } catch (e) {
      error = e.toString();
      debugPrint('CSV LOAD ERROR: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  void answerQuestion(int index) {
    if (answered) return;
    answered = true;

    final question = questions[currentIndex];
    final selected = ['A', 'B', 'C', 'D'][index];
    final isCorrect = selected == question.correctAnswer;
    final description = question.descriptions[index];

    if (isCorrect) score++;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCorrect ? 'Correct! $description' : 'Wrong! $description',
        ),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> nextQuestion() async {
    answered = false;

    if (currentIndex < questions.length - 1) {
      setState(() => currentIndex++);
    } else {
      try {
        await QuizDB.saveResult(widget.courseName, score);
        await QuizDB.debugPrintAllResults();
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Quiz finished! Score: $score / ${questions.length}',
            ),
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(child: Text('Error: $error')),
      );
    }

    final question = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.courseName} (${currentIndex + 1}/${questions.length})'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            QuestionCard(
              question: question,
              questionNumber: currentIndex + 1,
              onAnswered: answerQuestion,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: nextQuestion,
              child: Text(
                currentIndex == questions.length - 1
                    ? 'Finish Quiz'
                    : 'Next Question',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
