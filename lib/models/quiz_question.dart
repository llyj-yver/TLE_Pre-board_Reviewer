class QuestionModel {
  final String question;
  final List<String> choices;
  final List<String> descriptions;
  final String correctAnswer;

  QuestionModel({
    required this.question,
    required this.choices,
    required this.descriptions,
    required this.correctAnswer,
  });

  factory QuestionModel.fromCsv(List<dynamic> row) {
    return QuestionModel(
      question: row[0],
      choices: [row[1], row[2], row[3], row[4]],
      descriptions: [row[5], row[6], row[7], row[8]],
      correctAnswer: row[9],
    );
  }
}
