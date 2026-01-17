import 'package:flutter/services.dart';
import '../models/exam_question_model.dart.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';

class CsvExamParser {
  /// Load exam questions from CSV with format:
  /// QUESTIONS,A,B,C,D,ANSWER
  static Future<List<ExamQuestion>> loadExamQuestions(String path) async {
    try {
      final rawData = await rootBundle.loadString(path);
      final rows = const CsvToListConverter().convert(rawData);

      if (rows.length <= 1) {
        throw Exception('CSV has no data rows');
      }

      // Remove header row
      rows.removeAt(0);

      return rows.map((row) {
        if (row.length < 6) {
          throw Exception('Invalid CSV row format: $row');
        }

        return ExamQuestion(
          question: row[0].toString(),
          optionA: row[1].toString(),
          optionB: row[2].toString(),
          optionC: row[3].toString(),
          optionD: row[4].toString(),
          answer: row[5].toString(),
        );
      }).toList();
    } catch (e) {
      debugPrint('CSV LOAD ERROR: $e');
      rethrow;
    }
  }
}
