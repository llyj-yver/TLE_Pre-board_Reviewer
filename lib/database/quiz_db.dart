import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class QuizDB {
  static Database? _db;

  // -------------------- DB INSTANCE --------------------
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  // -------------------- INIT DB --------------------
  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'quiz.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE results (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            course TEXT,
            score INTEGER
          )
        ''');
      },
    );
  }

  // -------------------- SAVE RESULT --------------------
  static Future<void> saveResult(String course, int score) async {
    final db = await database;
    await db.insert(
      'results',
      {
        'course': course,
        'score': score,
      },
    );
  }

  // -------------------- AVERAGE PER COURSE --------------------
  static Future<Map<String, double>> getAverageScoresByCourse(
    List<String> courseNames,
  ) async {
    final db = await database;
    final Map<String, double> averages = {};

    for (final course in courseNames) {
      debugPrint('🔍 QUERYING: "$course"');

      final result = await db.rawQuery(
        '''
        SELECT AVG(score) AS avgScore
        FROM results
        WHERE course = ?
        ''',
        [course],
      );

      debugPrint('📊 RESULT: $result');

      final avg = result.first['avgScore'];
      averages[course] = avg == null ? 0.0 : (avg as num).toDouble();
    }

    return averages;
  }

  // -------------------- DEBUG DB CONTENTS --------------------
  static Future<void> debugPrintAllResults() async {
    final db = await database;
    final rows = await db.query('results');

    if (rows.isEmpty) {
      debugPrint('❌ DB IS EMPTY');
      return;
    }

    debugPrint('📦 DB CONTENTS:');
    for (final row in rows) {
      debugPrint(
        '➡ COURSE: "${row['course']}" | SCORE: ${row['score']}',
      );
    }
  }
}
