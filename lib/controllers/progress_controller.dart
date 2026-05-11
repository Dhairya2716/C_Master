import 'package:c_master/models/progress_model.dart';
import 'package:c_master/models/topic_model.dart';
import 'package:c_master/services/firestore_service.dart';
import 'package:c_master/services/local_storage_service.dart';
import 'package:c_master/views/tutorial/c_topics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProgressController extends GetxController {
  final _localStorage = LocalStorageService();
  final _firestoreService = FirestoreService();

  final completedSubtopics = <String>[].obs;
  final quizAttempts = <QuizAttempt>[].obs;
  final streak = 0.obs;

  // ── Computed ───────────────────────────────────────────────────────────────

  int get totalSubtopics =>
      cTopics.fold(0, (sum, t) => sum + t.subtopics.length);

  int get completedCount => completedSubtopics.length;

  double get overallPercent =>
      totalSubtopics == 0 ? 0 : completedCount / totalSubtopics;

  /// Per-topic completion percentage map. Key = topic title.
  Map<String, double> get perTopicPercent {
    final map = <String, double>{};
    for (final topic in cTopics) {
      if (topic.subtopics.isEmpty) {
        map[topic.title] = 0;
        continue;
      }
      final done = topic.subtopics
          .where((s) => completedSubtopics.contains(s.title))
          .length;
      map[topic.title] = done / topic.subtopics.length;
    }
    return map;
  }

  double get averageQuizScore {
    if (quizAttempts.isEmpty) return 0;
    final sum = quizAttempts.fold(0.0, (s, a) => s + a.percent);
    return sum / quizAttempts.length;
  }

  int get bestQuizScore {
    if (quizAttempts.isEmpty) return 0;
    return quizAttempts
        .map((a) => a.score)
        .reduce((a, b) => a > b ? a : b);
  }

  List<QuizAttempt> get recentAttempts =>
      quizAttempts.reversed.take(5).toList();

  bool isSubtopicCompleted(String title) =>
      completedSubtopics.contains(title);

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _loadLocal();
    _syncFirestore();
    _updateStreak();
  }

  void _loadLocal() {
    completedSubtopics.value = _localStorage.getCompletedSubtopics();
    quizAttempts.value = _localStorage.getQuizAttempts();
    streak.value = _localStorage.getStreak();
  }

  Future<void> _syncFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      final remote = await _firestoreService.loadProgress(uid);
      if (remote == null) return;

      // Merge: union of local + remote subtopics
      final merged = {
        ...completedSubtopics,
        ...remote.completedSubtopics,
      }.toList();

      completedSubtopics.value = merged;
      await _localStorage.saveCompletedSubtopics(merged);

      // Merge quiz attempts (deduplicate by date+topic)
      final existing = {
        for (final a in quizAttempts) '${a.topic}_${a.date.toIso8601String()}': a
      };
      for (final a in remote.quizAttempts) {
        final key = '${a.topic}_${a.date.toIso8601String()}';
        existing.putIfAbsent(key, () => a);
      }
      quizAttempts.value = existing.values.toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    } catch (_) {
      // Silently ignore sync errors (offline)
    }
  }

  Future<void> _updateStreak() async {
    final newStreak = await _localStorage.updateStreak();
    streak.value = newStreak;
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> markSubtopicRead(String subtopicTitle) async {
    if (completedSubtopics.contains(subtopicTitle)) return;

    // Local
    completedSubtopics.add(subtopicTitle);
    await _localStorage.addCompletedSubtopic(subtopicTitle);

    // Firestore (background)
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _firestoreService.recordSubtopicRead(uid, subtopicTitle).catchError((_) {});
    }
  }

  Future<void> recordQuizAttempt(QuizAttempt attempt) async {
    quizAttempts.add(attempt);
    await _localStorage.addQuizAttempt(attempt);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _firestoreService.recordQuizAttempt(uid, attempt).catchError((_) {});
    }
  }
}
