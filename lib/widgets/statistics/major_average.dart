import 'package:flutter/material.dart';
import '../../database/quiz_db.dart';
import '../../data/course_config.dart';

class MajorCoursesAverageWidget extends StatefulWidget {
  const MajorCoursesAverageWidget({super.key});

  @override
  State<MajorCoursesAverageWidget> createState() =>
      _MajorCoursesAverageWidgetState();
}

class _MajorCoursesAverageWidgetState
    extends State<MajorCoursesAverageWidget> {
  late Future<Map<String, double>> _averageScores;

  @override
  void initState() {
    super.initState();
    _averageScores = QuizDB.getAverageScoresByCourse(
      majorCourses.map((c) => c.title).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Major Courses Average Scores',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            FutureBuilder<Map<String, double>>(
              future: _averageScores,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  );
                }

                final data = snapshot.data!;

                return Column(
                  children: data.entries.map((entry) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(entry.key),
                      trailing: Text(
                        entry.value.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
