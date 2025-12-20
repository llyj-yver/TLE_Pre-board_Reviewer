import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class QuestionCard extends StatefulWidget {
  final List<String> row;
  final int questionNumber;
  final Function(bool) onAnswered;

  const QuestionCard({
    super.key,
    required this.row,
    required this.questionNumber,
    required this.onAnswered,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  // Apple Calculator inspired color palette
  // Variables using the AppColors class for values
  final Color bgDark = AppColors.bgDark;
  final Color cardDark = AppColors.cardDark;
  final Color accentOrange = AppColors.accentOrange;
  final Color accentGray = AppColors.accentGray;
  final Color textWhite = AppColors.textWhite;
  final Color textGray = AppColors.textGray;
  final Color correctGreen = AppColors.correctGreen;
  final Color incorrectRed = AppColors.incorrectRed;

  String? selectedAnswer;
  bool isFirstAttempt = true;
  Set<String> tappedAnswers = {};

  @override
  Widget build(BuildContext context) {
    final question = widget.row[0];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Question ${widget.questionNumber}",
            style: TextStyle(
              color: textGray,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question,
            style: TextStyle(
              color: textWhite,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          _choiceButton(context, "a"),
          _choiceButton(context, "b"),
          _choiceButton(context, "c"),
          _choiceButton(context, "d"),
        ],
      ),
    );
  }

  Widget _choiceButton(BuildContext context, String letter) {
    final choiceText = widget.row[_choiceIndex(letter)];
    final description = widget.row[_descriptionIndex(letter)];
    final correctAnswer = widget.row[9];

    final isFirstSelection = selectedAnswer == letter;
    final isTapped = tappedAnswers.contains(letter);
    final isCorrect = letter == correctAnswer;

    Color backgroundColor;
    Color borderColor;
    Color textColor;

    if (isFirstSelection) {
      // Show color for first selected answer
      if (isCorrect) {
        backgroundColor = correctGreen.withOpacity(0.15);
        borderColor = correctGreen;
        textColor = correctGreen;
      } else {
        backgroundColor = incorrectRed.withOpacity(0.15);
        borderColor = incorrectRed;
        textColor = incorrectRed;
      }
    } else if (isTapped) {
      // Show subtle highlight for other tapped answers
      backgroundColor = accentGray.withOpacity(0.5);
      borderColor = accentGray;
      textColor = textWhite;
    } else {
      backgroundColor = accentGray.withOpacity(0.3);
      borderColor = Colors.transparent;
      textColor = textGray;
    }

    return GestureDetector(
      onTap: () {
        final isCorrectAnswer = letter == correctAnswer;

        // Show snackbar for any tap
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isCorrectAnswer
                          ? correctGreen.withOpacity(0.2)
                          : incorrectRed.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isCorrectAnswer ? Icons.check_circle : Icons.info_outline,
                      color: isCorrectAnswer ? correctGreen : incorrectRed,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isCorrectAnswer ? "Correct!" : "Incorrect",
                          style: TextStyle(
                            color: isCorrectAnswer
                                ? correctGreen
                                : incorrectRed,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            color: textWhite.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            letterSpacing: -0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: const Color(0xFF2C2C2E),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isCorrectAnswer
                    ? correctGreen.withOpacity(0.3)
                    : incorrectRed.withOpacity(0.3),
                width: 1,
              ),
            ),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            duration: const Duration(seconds: 4),
            elevation: 8,
          ),
        );

        setState(() {
          // Track this answer as tapped
          tappedAnswers.add(letter);

          // Only update score on first tap
          if (isFirstAttempt) {
            selectedAnswer = letter;
            isFirstAttempt = false;
            widget.onAnswered(isCorrectAnswer);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFirstSelection
                    ? (isCorrect ? correctGreen : incorrectRed)
                    : (isTapped ? accentGray : Colors.transparent),
                border: Border.all(
                  color: isFirstSelection
                      ? (isCorrect ? correctGreen : incorrectRed)
                      : (isTapped ? accentGray : textGray),
                  width: 2,
                ),
              ),
              child: isFirstSelection
                  ? Icon(
                      isCorrect ? Icons.check : Icons.close,
                      color: textWhite,
                      size: 16,
                    )
                  : (isTapped
                        ? Icon(Icons.visibility, color: textWhite, size: 14)
                        : null),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "${letter.toUpperCase()}. $choiceText",
                style: TextStyle(
                  color: isFirstSelection || isTapped ? textWhite : textColor,
                  fontSize: 15,
                  fontWeight: isFirstSelection
                      ? FontWeight.w600
                      : FontWeight.w400,
                  letterSpacing: -0.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _choiceIndex(String letter) {
    switch (letter) {
      case 'a':
        return 1;
      case 'b':
        return 2;
      case 'c':
        return 3;
      case 'd':
        return 4;
      default:
        return 1;
    }
  }

  int _descriptionIndex(String letter) {
    switch (letter) {
      case 'a':
        return 5;
      case 'b':
        return 6;
      case 'c':
        return 7;
      case 'd':
        return 8;
      default:
        return 5;
    }
  }
}
