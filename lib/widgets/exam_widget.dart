import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../database/exam_db.dart';
import '../utils/app_colors.dart';

class ExamWidget extends StatefulWidget {
  final List<List<String>> questions;
  final String examType;

  const ExamWidget({
    super.key,
    required this.questions,
    required this.examType,
  });

  @override
  State<ExamWidget> createState() => _ExamWidgetState();
}

class _ExamWidgetState extends State<ExamWidget> {
  // ==================== CONFIGURABLE TIMER ====================
  // Set exam duration in minutes (default: 30 minutes)
  final int examDurationMinutes = 30;
  
  // Apple Calculator inspired color palette
  final Color bgDark = AppColors.bgDark;
  final Color cardDark = AppColors.cardDark;
  final Color accentOrange = AppColors.accentOrange;
  final Color accentGray = AppColors.accentGray;
  final Color textWhite = AppColors.textWhite;
  final Color textGray = AppColors.textGray;
  final Color correctGreen = AppColors.correctGreen;
  final Color incorrectRed = AppColors.incorrectRed;

  late List<List<String>> examData;
  final Map<int, String> selectedAnswers = {};

  bool submitted = false;
  int score = 0;

  late DateTime startTime;
  Duration timeTaken = Duration.zero;
  
  Timer? countdownTimer;
  Duration remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Remove header and shuffle questions
    examData = widget.questions.sublist(1);
    examData.shuffle(Random());

    startTime = DateTime.now();
    remainingTime = Duration(minutes: examDurationMinutes);
    
    // Start countdown timer
    startCountdownTimer();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  // ==================== COUNTDOWN TIMER ====================
  void startCountdownTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime.inSeconds > 0) {
          remainingTime = remainingTime - const Duration(seconds: 1);
        } else {
          timer.cancel();
          if (!submitted) {
            submitExam();
          }
        }
      });
    });
  }

  // ==================== SUBMIT EXAM ====================
  Future<void> submitExam() async {
    countdownTimer?.cancel();
    
    DateTime endTime = DateTime.now();
    timeTaken = endTime.difference(startTime);

    int tempScore = 0;

    for (int i = 0; i < examData.length; i++) {
      if (selectedAnswers[i] == examData[i][5]) {
        tempScore++;
      }
    }

    final result = ExamResult(
      examType: widget.examType,
      score: tempScore,
      totalQuestions: examData.length,
      timeTaken: "${timeTaken.inMinutes} min ${timeTaken.inSeconds % 60} sec",
      timestamp: endTime.toIso8601String(),
    );

    await ExamDatabase.instance.insertResult(result);

    setState(() {
      score = tempScore;
      submitted = true;
    });
  }

  // ==================== RESTART ====================
  void restartExam() {
    setState(() {
      selectedAnswers.clear();
      submitted = false;
      score = 0;
      startTime = DateTime.now();
      remainingTime = Duration(minutes: examDurationMinutes);
      examData.shuffle(Random());
    });
    startCountdownTimer();
  }

  // ==================== FORMAT TIME ====================
  String formatRemainingTime() {
    int minutes = remainingTime.inMinutes;
    int seconds = remainingTime.inSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
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
          widget.examType.toUpperCase(),
          style: TextStyle(
            color: textWhite,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!submitted)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: remainingTime.inMinutes < 5
                        ? incorrectRed.withOpacity(0.2)
                        : accentGray.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: remainingTime.inMinutes < 5
                            ? incorrectRed
                            : textGray,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        formatRemainingTime(),
                        style: TextStyle(
                          color: remainingTime.inMinutes < 5
                              ? incorrectRed
                              : textWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: submitted ? resultScreen() : examScreen(),
      ),
    );
  }

  // ==================== EXAM UI ====================
  Widget examScreen() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: examData.length,
            itemBuilder: (context, index) {
              final q = examData[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Question ${index + 1}",
                      style: TextStyle(
                        color: textGray,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      q[0],
                      style: TextStyle(
                        color: textWhite,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildOption(index, "a", q[1]),
                    buildOption(index, "b", q[2]),
                    buildOption(index, "c", q[3]),
                    buildOption(index, "d", q[4]),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
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
              onTap: submitExam,
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: Text(
                  "Submit Exam",
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
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildOption(int qIndex, String value, String text) {
    final isSelected = selectedAnswers[qIndex] == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnswers[qIndex] = value;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? accentOrange.withOpacity(0.15)
              : accentGray.withOpacity(0.3),
          border: Border.all(
            color: isSelected ? accentOrange : Colors.transparent,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? accentOrange : Colors.transparent,
                border: Border.all(
                  color: isSelected ? accentOrange : textGray,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, color: textWhite, size: 16)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isSelected ? textWhite : textGray,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  letterSpacing: -0.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== RESULT UI ====================
  Widget resultScreen() {
    final formattedTime =
        "${timeTaken.inMinutes} min ${timeTaken.inSeconds % 60} sec";
    final percentage = ((score / examData.length) * 100).round();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: cardDark,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
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
                    color: percentage >= 70 ? correctGreen : incorrectRed,
                    fontSize: 56,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "$score / ${examData.length}",
                  style: TextStyle(
                    color: textWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: accentGray.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer_outlined, color: textGray, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        formattedTime,
                        style: TextStyle(
                          color: textGray,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
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
                onTap: restartExam,
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: Text(
                    "Restart Exam",
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
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: cardDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: Text(
                    "Back to Home",
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
    );
  }
}