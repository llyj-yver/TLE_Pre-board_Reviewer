import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ExamResult {
  final int? id;
  final String examType;
  final int score;
  final int totalQuestions;
  final String timeTaken;
  final String timestamp;

  ExamResult({
    this.id,
    required this.examType,
    required this.score,
    required this.totalQuestions,
    required this.timeTaken,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'examType': examType,
      'score': score,
      'totalQuestions': totalQuestions,
      'timeTaken': timeTaken,
      'timestamp': timestamp,
    };
  }

  factory ExamResult.fromMap(Map<String, dynamic> map) {
    return ExamResult(
      id: map['id'],
      examType: map['examType'],
      score: map['score'],
      totalQuestions: map['totalQuestions'],
      timeTaken: map['timeTaken'],
      timestamp: map['timestamp'],
    );
  }
}

class ExamDatabase {
  
  static final ExamDatabase instance = ExamDatabase._init();
  static Database? _database;

  ExamDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('exam_results.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE exam_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        examType TEXT NOT NULL,
        score INTEGER NOT NULL,
        totalQuestions INTEGER NOT NULL,
        timeTaken TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  // ✅ INSERT RESULT
  Future<int> insertResult(ExamResult result) async {
    final db = await instance.database;
    return await db.insert('exam_results', result.toMap());
  }

  // ✅ GET RESULTS BY TYPE
  Future<List<ExamResult>> getResultsByType(String type) async {
    final db = await instance.database;
    final maps = await db.query(
      'exam_results',
      where: 'examType = ?',
      whereArgs: [type],
      orderBy: 'timestamp DESC',
    );
    return maps.map((e) => ExamResult.fromMap(e)).toList();
  }

  Future<List<ExamResult>> getAllResults() async {
    final db = await instance.database;
    final maps = await db.query('exam_results');
    return maps.map((e) => ExamResult.fromMap(e)).toList();
  }
}
