import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../database/exam_db.dart';
import '../utils/app_colors.dart';
import '../models/exam_question_model.dart.dart';
import '../services/csv_exam_parser.dart';

class ExamWidget extends StatefulWidget {
  final String csvPath;
  final String examType;
  
  // ==================== CONFIGURABLE PARAMETERS ====================
  final int numberOfQuestions; // How many questions to display
  final int examDurationMinutes; // Time limit in minutes

  const ExamWidget({
    super.key,
    required this.csvPath,
    required this.examType,
    this.numberOfQuestions = 20, // Default: 20 questions
    this.examDurationMinutes = 30, // Default: 30 minutes
  });

  @override
  State<ExamWidget> createState() => _ExamWidgetState();
}

class _ExamWidgetState extends State<ExamWidget> {
  // ==================== BLUE & WHITE MODERN COLORS ====================
  final Color primaryBlue = const Color(0xFF2196F3);
  final Color darkBlue = const Color(0xFF1976D2);
  final Color lightBlue = const Color(0xFF64B5F6);
  final Color bgWhite = Colors.white;
  final Color cardWhite = const Color(0xFFFAFAFA);
  final Color textDark = const Color(0xFF212121);
  final Color textGray = const Color(0xFF757575);
  final Color borderGray = const Color(0xFFE0E0E0);
  final Color correctGreen = const Color(0xFF4CAF50);
  final Color incorrectRed = const Color(0xFFF44336);
  final Color selectedBlue = const Color(0xFFE3F2FD);
  final Color warningOrange = const Color(0xFFFF9800);

  List<ExamQuestion> examData = [];
  final Map<int, String> selectedAnswers = {};

  bool submitted = false;
  bool loading = true;
  int score = 0;

  late DateTime startTime;
  Duration timeTaken = Duration.zero;

  Timer? countdownTimer;
  Duration remainingTime = Duration.zero;

  // ==================== INIT ====================
  @override
  void initState() {
    super.initState();
    loadExam();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  // ==================== LOAD CSV ====================
  Future<void> loadExam() async {
    try {
      final allQuestions = await CsvExamParser.loadExamQuestions(widget.csvPath);
      allQuestions.shuffle(Random());
      
      // Take only the specified number of questions
      examData = allQuestions.take(widget.numberOfQuestions).toList();

      startTime = DateTime.now();
      remainingTime = Duration(minutes: widget.examDurationMinutes);

      startCountdownTimer();
    } catch (e) {
      debugPrint('EXAM LOAD ERROR: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  // ==================== TIMER ====================
  void startCountdownTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime -= const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
        if (!submitted) submitExam();
      }
    });
  }

  // ==================== SUBMIT ====================
  Future<void> submitExam() async {
    countdownTimer?.cancel();

    final endTime = DateTime.now();
    timeTaken = endTime.difference(startTime);

    int tempScore = 0;
    for (int i = 0; i < examData.length; i++) {
      if (selectedAnswers[i]?.toUpperCase() ==
          examData[i].answer.toUpperCase()) {
        tempScore++;
      }
    }

    final result = ExamResult(
      examType: widget.examType,
      score: tempScore,
      totalQuestions: examData.length,
      timeTaken:
          "${timeTaken.inMinutes} min ${timeTaken.inSeconds % 60} sec",
      timestamp: endTime.toIso8601String(),
    );

    await ExamDatabase.instance.insertResult(result);

    setState(() {
      score = tempScore;
      submitted = true;
    });
  }

  // ==================== RESTART ====================
  void restartExam() async {
    setState(() {
      selectedAnswers.clear();
      submitted = false;
      score = 0;
      loading = true;
    });
    
    await loadExam();
  }

  String formatRemainingTime() {
    final m = remainingTime.inMinutes;
    final s = remainingTime.inSeconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  Color getTimerColor() {
    if (remainingTime.inMinutes >= 5) return primaryBlue;
    if (remainingTime.inMinutes >= 2) return warningOrange;
    return incorrectRed;
  }

  // ==================== UI ====================
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        backgroundColor: bgWhite,
        body: Center(
          child: CircularProgressIndicator(color: primaryBlue),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgWhite,
      appBar: AppBar(
        backgroundColor: cardWhite,
        elevation: 0,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.examType,
          style: TextStyle(
            color: textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (!submitted)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: getTimerColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: getTimerColor(), width: 1.5),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: getTimerColor(), size: 18),
                  const SizedBox(width: 6),
                  Text(
                    formatRemainingTime(),
                    style: TextStyle(
                      color: getTimerColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: submitted ? resultScreen() : examScreen(),
      bottomNavigationBar: !submitted ? bottomProgressBar() : null,
    );
  }

  // ==================== BOTTOM PROGRESS BAR ====================
  Widget bottomProgressBar() {
    final answered = selectedAnswers.length;
    final total = examData.length;
    final progress = total > 0 ? answered / total : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: cardWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$answered of $total questions answered",
                  style: TextStyle(color: textGray, fontSize: 14),
                ),
                Text(
                  "${(progress * 100).round()}%",
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: borderGray,
                valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: answered == total ? submitExam : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  disabledBackgroundColor: borderGray,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  answered == total ? "Submit Exam" : "Answer all questions to submit",
                  style: TextStyle(
                    color: answered == total ? Colors.white : textGray,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== EXAM SCREEN ====================
  Widget examScreen() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: examData.length,
      itemBuilder: (context, index) {
        final q = examData[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderGray, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Question ${index + 1}",
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (selectedAnswers.containsKey(index))
                    Icon(Icons.check_circle, color: correctGreen, size: 20),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                q.question,
                style: TextStyle(
                  color: textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              buildOption(index, 'A', q.optionA),
              buildOption(index, 'B', q.optionB),
              buildOption(index, 'C', q.optionC),
              buildOption(index, 'D', q.optionD),
            ],
          ),
        );
      },
    );
  }

  Widget buildOption(int qIndex, String value, String text) {
    final isSelected = selectedAnswers[qIndex]?.toUpperCase() == value;

    return GestureDetector(
      onTap: () => setState(() => selectedAnswers[qIndex] = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? selectedBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? primaryBlue : borderGray,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? primaryBlue : Colors.transparent,
                border: Border.all(
                  color: isSelected ? primaryBlue : borderGray,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(
                    color: isSelected ? Colors.white : textGray,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isSelected ? textDark : textGray,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== RESULT SCREEN ====================
  Widget resultScreen() {
    final percentage = examData.length > 0 
        ? ((score / examData.length) * 100).round() 
        : 0;
    final passed = percentage >= 70;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderGray, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              passed ? Icons.celebration : Icons.refresh,
              size: 80,
              color: passed ? correctGreen : warningOrange,
            ),
            const SizedBox(height: 24),
            Text(
              passed ? "Congratulations!" : "Keep Practicing!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              passed ? "You passed the exam" : "You can do better",
              style: TextStyle(
                fontSize: 16,
                color: textGray,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "$percentage%",
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$score out of ${examData.length} correct",
                    style: TextStyle(
                      fontSize: 18,
                      color: textGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.timer_outlined, color: textGray, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Time taken: ${timeTaken.inMinutes} min ${timeTaken.inSeconds % 60} sec",
                  style: TextStyle(color: textGray, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: restartExam,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Retake Exam",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryBlue, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Back to Home",
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}