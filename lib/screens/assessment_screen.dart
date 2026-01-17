import 'package:flutter/material.dart';
import '../data/course_config.dart';
import '../widgets/assesments/course_quiz_screen.dart';
import '../widgets/exam_widget.dart';

class TestSelectionScreen extends StatelessWidget {
  const TestSelectionScreen({super.key});

  // ==================== BLUE & WHITE COLORS ====================
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color darkBlue = Color(0xFF1976D2);
  static const Color lightBlue = Color(0xFF64B5F6);
  static const Color bgWhite = Colors.white;
  static const Color cardWhite = Color(0xFFFAFAFA);
  static const Color textDark = Color(0xFF212121);
  static const Color textGray = Color(0xFF757575);
  static const Color borderGray = Color(0xFFE0E0E0);
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentPurple = Color(0xFF9C27B0);

  // =========================
  // Open quiz (per course)
  // =========================
  void openQuiz(BuildContext context, CourseItem course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          csvPath: course.csvPath,
          courseName: course.title,
          maxQuestions: 30,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhite,
      appBar: AppBar(
        backgroundColor: bgWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Assessments',
          style: TextStyle(
            color: textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryBlue, darkBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.assessment,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Test Your Knowledge',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose from main assessments or course quizzes',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // =========================
            // MAIN ASSESSMENT
            // =========================
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.star,
                    color: accentOrange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Main Assessment',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildMainAssessmentCard(
                    context,
                    title: 'Pre-Test',
                    subtitle: '15 questions • 20 min',
                    icon: Icons.play_circle_outline,
                    color: accentGreen,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ExamWidget(
                            csvPath: 'assets/exam/PRE_BOARD.csv',
                            examType: 'pre-test',
                            numberOfQuestions: 15,
                            examDurationMinutes: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMainAssessmentCard(
                    context,
                    title: 'Post-Test',
                    subtitle: '15 questions • 20 min',
                    icon: Icons.check_circle_outline,
                    color: accentOrange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ExamWidget(
                            csvPath: 'assets/exam/FINAL_EXAM.csv',
                            examType: 'post-test',
                            numberOfQuestions: 15,
                            examDurationMinutes: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // =========================
            // MAJOR COURSES
            // =========================
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.school,
                    color: primaryBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Major Courses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildCourseGrid(context, majorCourses, primaryBlue),

            const SizedBox(height: 32),

            // =========================
            // EXPLORATORY COURSES
            // =========================
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.explore,
                    color: accentPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Exploratory Courses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildCourseGrid(context, exploratoryCourses, accentPurple),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // =========================
  // Main Assessment Card
  // =========================
  Widget _buildMainAssessmentCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: textDark,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: textGray,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // Course Grid Builder
  // =========================
  Widget _buildCourseGrid(
    BuildContext context,
    List<CourseItem> courses,
    Color accentColor,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return _buildCourseCard(context, course, accentColor);
      },
    );
  }

  // =========================
  // Course Card
  // =========================
  Widget _buildCourseCard(
    BuildContext context,
    CourseItem course,
    Color accentColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderGray, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => openQuiz(context, course),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.quiz,
                        color: accentColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      course.title,
                      style: const TextStyle(
                        color: textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.play_arrow,
                      color: accentColor,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Start Quiz',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}