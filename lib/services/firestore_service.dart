import 'package:c_master/models/progress_model.dart';
import 'package:c_master/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── User ──────────────────────────────────────────────────────────────────

  Future<void> saveUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) return UserModel.fromMap(doc.data()!);
    return null;
  }

  // ── Progress ──────────────────────────────────────────────────────────────

  Future<void> saveProgress(String uid, UserProgress progress) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc('data')
        .set(progress.toMap(), SetOptions(merge: true));
  }

  Future<UserProgress?> loadProgress(String uid) async {
    try {
      final doc = await _db
          .collection('users')
          .doc(uid)
          .collection('progress')
          .doc('data')
          .get();
      if (doc.exists && doc.data() != null) {
        return UserProgress.fromMap(doc.data()!);
      }
    } catch (_) {}
    return null;
  }

  Future<void> recordSubtopicRead(String uid, String subtopicTitle) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc('data')
        .set({
      'completedSubtopics': FieldValue.arrayUnion([subtopicTitle]),
      'lastActive': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  Future<void> recordQuizAttempt(String uid, QuizAttempt attempt) async {
    final doc = _db
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc('data');

    final snap = await doc.get();
    final existing = (snap.data()?['quizAttempts'] as List? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    existing.add(attempt.toMap());

    await doc.set({
      'quizAttempts': existing,
    }, SetOptions(merge: true));
  }
}