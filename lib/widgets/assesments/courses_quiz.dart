import 'package:flutter/material.dart';
import '../../models/quiz_question.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel? question;
  final int questionNumber;
  final Function(int) onAnswered;

  const QuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.onAnswered,
  });

  @override
  Widget build(BuildContext context) {
    if (question == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            '⚠ Question data is missing',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (question!.choices.length < 4) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            '⚠ Invalid question format',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question $questionNumber',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(question!.question),
            const SizedBox(height: 20),
            ...List.generate(4, (index) {
              return ElevatedButton(
                onPressed: () {
                  try {
                    onAnswered(index);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Answer error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text(question!.choices[index]),
              );
            }),
          ],
        ),
      ),
    );
  }
}
