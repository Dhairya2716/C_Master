class QuizAttempt {
  final String topic;
  final int score;
  final int total;
  final DateTime date;

  QuizAttempt({
    required this.topic,
    required this.score,
    required this.total,
    required this.date,
  });

  double get percent => total == 0 ? 0 : score / total;

  Map<String, dynamic> toMap() => {
        'topic': topic,
        'score': score,
        'total': total,
        'date': date.toIso8601String(),
      };

  factory QuizAttempt.fromMap(Map<String, dynamic> map) => QuizAttempt(
        topic: map['topic'] ?? '',
        score: map['score'] ?? 0,
        total: map['total'] ?? 0,
        date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      );
}

class UserProgress {
  final List<String> completedSubtopics;
  final List<QuizAttempt> quizAttempts;
  final int streak;
  final DateTime lastActive;

  UserProgress({
    required this.completedSubtopics,
    required this.quizAttempts,
    required this.streak,
    required this.lastActive,
  });

  factory UserProgress.empty() => UserProgress(
        completedSubtopics: [],
        quizAttempts: [],
        streak: 0,
        lastActive: DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'completedSubtopics': completedSubtopics,
        'quizAttempts': quizAttempts.map((e) => e.toMap()).toList(),
        'streak': streak,
        'lastActive': lastActive.toIso8601String(),
      };

  factory UserProgress.fromMap(Map<String, dynamic> map) => UserProgress(
        completedSubtopics: List<String>.from(map['completedSubtopics'] ?? []),
        quizAttempts: (map['quizAttempts'] as List? ?? [])
            .map((e) => QuizAttempt.fromMap(Map<String, dynamic>.from(e)))
            .toList(),
        streak: map['streak'] ?? 0,
        lastActive: DateTime.tryParse(map['lastActive'] ?? '') ?? DateTime.now(),
      );
}
