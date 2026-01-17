import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../models/quiz_question.dart';
import '../../database/quiz_db.dart';

class QuizScreen extends StatefulWidget {
  final String csvPath;
  final String courseName;
  final int maxQuestions; // Configurable number of questions

  const QuizScreen({
    super.key,
    required this.csvPath,
    required this.courseName,
    this.maxQuestions = 30, // Default: 30 questions
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // ==================== BLUE & WHITE COLORS ====================
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

  List<QuestionModel> questions = [];
  int currentIndex = 0;
  int score = 0;
  bool answered = false;
  bool loading = true;
  String? error;
  String? selectedAnswer;

  final FlutterTts _tts = FlutterTts();
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _setupTts();
    loadCsv();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _setupTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);

    _tts.setCompletionHandler(() {
      if (mounted) {
        setState(() => isSpeaking = false);
      }
    });
  }

  Future<void> _speakQuestion() async {
    if (questions.isEmpty) return;

    setState(() => isSpeaking = true);
    await _tts.stop();
    await _tts.speak(questions[currentIndex].question);
  }

  Future<void> _stopSpeaking() async {
    await _tts.stop();
    setState(() => isSpeaking = false);
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

      // 🎯 Take only specified number of questions
      questions = allQuestions.take(widget.maxQuestions).toList();
    } catch (e) {
      error = e.toString();
      debugPrint('CSV LOAD ERROR: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  void answerQuestion(int index) {
    if (answered) return;

    setState(() {
      answered = true;
      selectedAnswer = ['A', 'B', 'C', 'D'][index];
    });

    final question = questions[currentIndex];
    final selected = ['A', 'B', 'C', 'D'][index];
    final isCorrect = selected == question.correctAnswer;
    final description = question.descriptions[index];

    if (isCorrect) score++;

    // Show feedback in a custom dialog
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: bgWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? correctGreen : incorrectRed,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                isCorrect ? 'Correct!' : 'Incorrect',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: textGray,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    nextQuestion();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    currentIndex == questions.length - 1
                        ? 'View Results'
                        : 'Next Question',
                    style: const TextStyle(
                      color: Colors.white,
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
    });
  }

  Future<void> nextQuestion() async {
    await _stopSpeaking(); // Stop speaking when moving to next question

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        answered = false;
        selectedAnswer = null;
      });
    } else {
      // Quiz finished - show results
      try {
        await QuizDB.saveResult(widget.courseName, score);
        await QuizDB.debugPrintAllResults();
        if (!mounted) return;

        showResultDialog();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Save failed: $e'),
            backgroundColor: incorrectRed,
          ),
        );
      }
    }
  }

  void showResultDialog() {
    final percentage = questions.isNotEmpty 
        ? ((score / questions.length) * 100).round()
        : 0;
    final passed = percentage >= 70;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: bgWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              passed ? Icons.celebration : Icons.refresh,
              size: 80,
              color: passed ? correctGreen : primaryBlue,
            ),
            const SizedBox(height: 24),
            Text(
              passed ? "Great Job!" : "Keep Learning!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              passed ? "You passed the quiz" : "You can do better",
              style: TextStyle(
                fontSize: 16,
                color: textGray,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "$percentage%",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$score out of ${questions.length} correct",
                    style: TextStyle(
                      fontSize: 16,
                      color: textGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Return to previous screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Back to Home",
                  style: TextStyle(
                    color: Colors.white,
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

    if (error != null) {
      return Scaffold(
        backgroundColor: bgWhite,
        appBar: AppBar(
          backgroundColor: bgWhite,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textDark),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: incorrectRed),
                const SizedBox(height: 16),
                Text(
                  'Error Loading Quiz',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textGray),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: bgWhite,
        appBar: AppBar(
          backgroundColor: bgWhite,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textDark),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Text(
            'No questions available',
            style: TextStyle(color: textGray, fontSize: 16),
          ),
        ),
      );
    }

    final question = questions[currentIndex];
    final progress = (currentIndex + 1) / questions.length;

    return Scaffold(
      backgroundColor: bgWhite,
      appBar: AppBar(
        backgroundColor: bgWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.courseName,
          style: TextStyle(
            color: textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.emoji_events, color: primaryBlue, size: 18),
                const SizedBox(width: 6),
                Text(
                  '$score pts',
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: bgWhite,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${currentIndex + 1} of ${questions.length}',
                      style: TextStyle(
                        color: textGray,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
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
              ],
            ),
          ),

          // Question content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question card
                  Container(
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Question ${currentIndex + 1}',
                                style: TextStyle(
                                  color: primaryBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Spacer(),
                            // TTS Button
                            IconButton(
                              icon: Icon(
                                isSpeaking ? Icons.stop_circle : Icons.volume_up,
                                color: primaryBlue,
                              ),
                              onPressed: isSpeaking ? _stopSpeaking : _speakQuestion,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          question.question,
                          style: TextStyle(
                            color: textDark,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Options
                  if (question.choices.length >= 4)
                    ...List.generate(4, (index) {
                      final letters = ['A', 'B', 'C', 'D'];
                      final isSelected = selectedAnswer == letters[index];
                      final isCorrect = answered &&
                          letters[index] == question.correctAnswer;
                      final isWrong = answered &&
                          isSelected &&
                          letters[index] != question.correctAnswer;

                      Color borderColor = borderGray;
                      Color bgColor = Colors.transparent;

                      if (answered) {
                        if (isCorrect) {
                          borderColor = correctGreen;
                          bgColor = correctGreen.withOpacity(0.1);
                        } else if (isWrong) {
                          borderColor = incorrectRed;
                          bgColor = incorrectRed.withOpacity(0.1);
                        }
                      } else if (isSelected) {
                        borderColor = primaryBlue;
                        bgColor = selectedBlue;
                      }

                      return GestureDetector(
                        onTap: () => answerQuestion(index),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: borderColor,
                              width: answered && (isCorrect || isWrong) ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: answered && isCorrect
                                      ? correctGreen
                                      : answered && isWrong
                                          ? incorrectRed
                                          : isSelected
                                              ? primaryBlue
                                              : Colors.transparent,
                                  border: Border.all(
                                    color: answered && isCorrect
                                        ? correctGreen
                                        : answered && isWrong
                                            ? incorrectRed
                                            : isSelected
                                                ? primaryBlue
                                                : borderGray,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: answered && (isCorrect || isWrong)
                                      ? Icon(
                                          isCorrect ? Icons.check : Icons.close,
                                          color: Colors.white,
                                          size: 18,
                                        )
                                      : Text(
                                          letters[index],
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : textGray,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  question.choices[index],
                                  style: TextStyle(
                                    color: textDark,
                                    fontSize: 15,
                                    fontWeight:
                                        isSelected || (answered && isCorrect)
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                  else
                    Text(
                      '⚠ Invalid question format',
                      style: TextStyle(color: incorrectRed),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}