import 'package:flutter/material.dart';
import 'question_card.dart';
import '../utils/app_colors.dart';

class ExamView extends StatefulWidget {
  final String title;
  final List<List<String>> data;

  const ExamView({super.key, required this.title, required this.data});

  @override
  State<ExamView> createState() => _ExamViewState();
}

class _ExamViewState extends State<ExamView> {
  // Apple Calculator inspired color palette
  final Color bgDark = AppColors.bgDark;
  final Color cardDark = AppColors.cardDark;
  final Color accentOrange = AppColors.accentOrange;
  final Color accentGray = AppColors.accentGray;
  final Color textWhite = AppColors.textWhite;
  final Color textGray = AppColors.textGray;
  final Color correctGreen = AppColors.correctGreen;

  int currentIndex = 1; // skip header
  int score = 0;

  void handleAnswer(bool isCorrect) {
    if (isCorrect) {
      score++;
    }
  }

  void nextQuestion() {
    if (currentIndex < widget.data.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      _showFinalScore();
    }
  }

  void _showFinalScore() {
    final totalQuestions = widget.data.length - 1;
    final percentage = ((score / totalQuestions) * 100).round();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: cardDark,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Exam Complete",
                style: TextStyle(
                  color: textGray,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "$percentage%",
                style: TextStyle(
                  color: percentage >= 70 ? correctGreen : accentOrange,
                  fontSize: 56,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "$score / $totalQuestions",
                style: TextStyle(
                  color: textWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: accentOrange,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Go back to previous screen
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Center(
                      child: Text(
                        "Done",
                        style: TextStyle(
                          color: textWhite,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalQuestions = widget.data.length - 1;
    final progress = currentIndex / totalQuestions;

    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: bgDark,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textWhite, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: textWhite,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress bar
          Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: accentGray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: accentOrange,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Question counter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Question $currentIndex of $totalQuestions",
                  style: TextStyle(
                    color: textGray,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: correctGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: correctGreen, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        "$score",
                        style: TextStyle(
                          color: correctGreen,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Question Card
          Expanded(
            child: QuestionCard(
              key: ValueKey(currentIndex), // IMPORTANT - forces rebuild
              row: widget.data[currentIndex],
              questionNumber: currentIndex,
              onAnswered: handleAnswer,
            ),
          ),

          // Next button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: accentOrange,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: nextQuestion,
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentIndex < totalQuestions
                              ? "Next Question"
                              : "Finish Exam",
                          style: TextStyle(
                            color: textWhite,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(width: 8),
                          Icon(
                          Icons.arrow_forward,
                          color: textWhite,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
