class Question {
  final String question;
  final List<String> options;
  final List<String> correctAnswers;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswers,
  });

  factory Question.fromApi(Map<String, dynamic> json) {
    final incorrect = (json['incorrect_answers'] as List)
        .map((e) => e.toString())
        .toList();

    final correct = json['correct_answer'].toString();

    final options = [...incorrect, correct]..shuffle();

    return Question(
      question: json['question'].toString(),
      options: options,
      correctAnswers: [correct],
    );
  }
}
