import 'package:flutter/material.dart';
import '../../database/exam_db.dart';

class ExamResultsTable extends StatefulWidget {
  final String examType;

  const ExamResultsTable({
    super.key,
    required this.examType,
  });

  @override
  State<ExamResultsTable> createState() => _ExamResultsTableState();
}

class _ExamResultsTableState extends State<ExamResultsTable> {
  late Future<List<ExamResult>> resultsFuture;

  @override
  void initState() {
    super.initState();
    resultsFuture = ExamDatabase.instance.getResultsByType(widget.examType);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExamResult>>(
      future: resultsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF9F0A)),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              "No records for ${widget.examType}",
              style: const TextStyle(
                color: Color(0xFF8E8E93),
                fontSize: 16,
              ),
            ),
          );
        }

        final results = snapshot.data!;

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                  const Color(0xFF2C2C2E),
                ),
                dataRowColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return const Color(0xFF3A3A3C);
                    }
                    return const Color(0xFF1C1C1E);
                  },
                ),
                columnSpacing: 30,
                headingTextStyle: const TextStyle(
                  color: Color(0xFFFF9F0A),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
                dataTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                dividerThickness: 0.5,
                columns: const [
                  DataColumn(label: Text("DATE")),
                  DataColumn(label: Text("SCORE")),
                  DataColumn(label: Text("TOTAL")),
                  DataColumn(label: Text("TIME")),
                ],
                rows: results.asMap().entries.map((entry) {
                  final result = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text(_formatDate(result.timestamp))),
                      DataCell(
                        Text(
                          result.score.toString(),
                          style: TextStyle(
                            color: _getScoreColor(
                              result.score,
                              result.totalQuestions,
                            ),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DataCell(Text(result.totalQuestions.toString())),
                      DataCell(
                        Text(
                          result.timeTaken,
                          style: const TextStyle(
                            color: Color(0xFF8E8E93),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(String iso) {
    final date = DateTime.parse(iso);
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Color _getScoreColor(int score, int total) {
    final percentage = (score / total) * 100;
    if (percentage >= 80) {
      return const Color(0xFF34C759); // Green
    } else if (percentage >= 60) {
      return const Color(0xFFFF9F0A); // Orange
    } else {
      return const Color(0xFFFF453A); // Red
    }
  }
}