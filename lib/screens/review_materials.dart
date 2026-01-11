import 'package:flutter/material.dart';
import '../data/course_config.dart';
import '../widgets/assesments/course_quiz_screen.dart'; // Your existing QuizScreen

class TestSelectionScreen extends StatelessWidget {
  const TestSelectionScreen({super.key});

  void openQuiz(BuildContext context, CourseItem course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          csvPath: course.csvPath,
          courseName: course.title, // ✅ Pass only the base course title
        ),
      ),
    );
  }

  Widget buildCourseButtons(BuildContext context, List<CourseItem> courses) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: courses.map((course) {
        return ElevatedButton(
          onPressed: () => openQuiz(context, course),
          child: Text(course.title),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Courses')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Major Courses
            const Text('Major Courses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            buildCourseButtons(context, majorCourses),

            const SizedBox(height: 20),
            // Exploratory Courses
            const Text('Exploratory Courses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            buildCourseButtons(context, exploratoryCourses),
          ],
        ),
      ),
    );
  }
}
