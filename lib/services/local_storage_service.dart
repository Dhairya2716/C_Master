import 'package:c_master/models/progress_model.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageService {
  static const _subtopicsKey = 'completed_subtopics';
  static const _attemptsKey = 'quiz_attempts';
  static const _streakKey = 'streak';
  static const _lastActiveKey = 'last_active';

  final _box = GetStorage();

  // ── Subtopics ─────────────────────────────────────────────────────────────

  List<String> getCompletedSubtopics() {
    final raw = _box.read<List>(_subtopicsKey);
    return raw == null ? [] : List<String>.from(raw);
  }

  Future<void> saveCompletedSubtopics(List<String> subtopics) async {
    await _box.write(_subtopicsKey, subtopics);
  }

  Future<void> addCompletedSubtopic(String title) async {
    final current = getCompletedSubtopics();
    if (!current.contains(title)) {
      current.add(title);
      await saveCompletedSubtopics(current);
    }
  }

  // ── Quiz Attempts ─────────────────────────────────────────────────────────

  List<QuizAttempt> getQuizAttempts() {
    final raw = _box.read<List>(_attemptsKey);
    if (raw == null) return [];
    return raw
        .map((e) => QuizAttempt.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> addQuizAttempt(QuizAttempt attempt) async {
    final current = getQuizAttempts();
    current.add(attempt);
    await _box.write(
      _attemptsKey,
      current.map((e) => e.toMap()).toList(),
    );
  }

  // ── Streak ────────────────────────────────────────────────────────────────

  int getStreak() => _box.read<int>(_streakKey) ?? 0;

  DateTime? getLastActive() {
    final raw = _box.read<String>(_lastActiveKey);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  Future<int> updateStreak() async {
    final now = DateTime.now();
    final lastActive = getLastActive();
    int streak = getStreak();

    if (lastActive == null) {
      streak = 1;
    } else {
      final diff = now.difference(lastActive).inDays;
      if (diff == 1) {
        streak += 1;
      } else if (diff > 1) {
        streak = 1;
      }
      // diff == 0 → same day, no change
    }

    await _box.write(_streakKey, streak);
    await _box.write(_lastActiveKey, now.toIso8601String());
    return streak;
  }
}
