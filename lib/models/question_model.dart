class Question {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String topic;
  final String explanation;

  const Question({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.topic,
    required this.explanation,
  });
}
