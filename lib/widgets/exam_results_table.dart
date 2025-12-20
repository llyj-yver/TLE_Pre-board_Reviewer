import 'package:flutter/material.dart';
import '../database/exam_db.dart';

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
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text("No records for ${widget.examType}"),
          );
        }

        final results = snapshot.data!;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20,
            columns: const [
              DataColumn(label: Text("Date")),
              DataColumn(label: Text("Score")),
              DataColumn(label: Text("Total")),
              DataColumn(label: Text("Time")),
            ],
            rows: results.map((result) {
              return DataRow(cells: [
                DataCell(Text(_formatDate(result.timestamp))),
                DataCell(Text(result.score.toString())),
                DataCell(Text(result.totalQuestions.toString())),
                DataCell(Text(result.timeTaken)),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }

  String _formatDate(String iso) {
    final date = DateTime.parse(iso);
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}