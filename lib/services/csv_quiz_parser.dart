import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import '../models/quiz_question.dart';

class CsvLoader {
  static Future<List<QuestionModel>> loadQuestions(String path) async {
    try {
      final rawData = await rootBundle.loadString(path);
      final rows = const CsvToListConverter().convert(rawData);

      if (rows.length <= 1) {
        throw Exception('CSV has no data rows');
      }

      rows.removeAt(0); // remove header

      return rows.map((row) {
        if (row.length < 10) {
          throw Exception('Invalid CSV row format');
        }
        return QuestionModel.fromCsv(row);
      }).toList();
    } catch (e) {
      debugPrint('CSV LOAD ERROR: $e');
      rethrow;
    }
  }
}

