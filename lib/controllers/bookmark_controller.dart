import 'package:c_master/core/utils/import_export.dart';
import 'package:c_master/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Bookmark {
  final String topicTitle;
  final String subtopicTitle;
  final String content;
  final DateTime savedAt;

  Bookmark({
    required this.topicTitle,
    required this.subtopicTitle,
    required this.content,
    required this.savedAt,
  });

  Map<String, dynamic> toMap() => {
        'topicTitle': topicTitle,
        'subtopicTitle': subtopicTitle,
        'content': content,
        'savedAt': savedAt.toIso8601String(),
      };

  factory Bookmark.fromMap(Map<String, dynamic> map) => Bookmark(
        topicTitle: map['topicTitle'] ?? '',
        subtopicTitle: map['subtopicTitle'] ?? '',
        content: map['content'] ?? '',
        savedAt: DateTime.tryParse(map['savedAt'] ?? '') ?? DateTime.now(),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Bookmark &&
          runtimeType == other.runtimeType &&
          topicTitle == other.topicTitle &&
          subtopicTitle == other.subtopicTitle;

  @override
  int get hashCode => topicTitle.hashCode ^ subtopicTitle.hashCode;
}

class BookmarkController extends GetxController {
  final _localStorage = GetStorage();
  final _firestoreService = FirestoreService();

  static const _bookmarksKey = 'bookmarks';

  final bookmarks = <Bookmark>[].obs;
  final isLoading = false.obs;

  // ── Computed ───────────────────────────────────────────────────────────────

  int get totalBookmarks => bookmarks.length;

  bool isBookmarked(String topicTitle, String subtopicTitle) =>
      bookmarks.any((b) => b.topicTitle == topicTitle && b.subtopicTitle == subtopicTitle);

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _loadLocal();
    _syncFirestore();
  }

  void _loadLocal() {
    try {
      final raw = _localStorage.read<List>(_bookmarksKey);
      if (raw != null) {
        bookmarks.value = raw
            .map((e) => Bookmark.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    } catch (e) {
      print('Error loading bookmarks: $e');
    }
  }

  Future<void> _syncFirestore() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final remote = await _firestoreService.loadBookmarks(uid);
      if (remote != null && remote.isNotEmpty) {
        // Merge: keep local + add any remote that aren't local
        final localSet = bookmarks.map((b) => '${b.topicTitle}_${b.subtopicTitle}').toSet();
        for (final b in remote) {
          final key = '${b.topicTitle}_${b.subtopicTitle}';
          if (!localSet.contains(key)) {
            bookmarks.add(b);
          }
        }
        await _saveToStorage();
      }
    } catch (e) {
      print('Error syncing bookmarks from Firestore: $e');
    }
  }

  // ── Add Bookmark ───────────────────────────────────────────────────────────

  Future<void> addBookmark({
    required String topicTitle,
    required String subtopicTitle,
    required String content,
  }) async {
    if (isBookmarked(topicTitle, subtopicTitle)) {
      Get.snackbar('Already Bookmarked', 'This topic is already in your bookmarks');
      return;
    }

    final bookmark = Bookmark(
      topicTitle: topicTitle,
      subtopicTitle: subtopicTitle,
      content: content,
      savedAt: DateTime.now(),
    );

    bookmarks.add(bookmark);
    await _saveToStorage();
    await _saveToFirestore(bookmark, isAdd: true);

    Get.snackbar('Bookmarked', '$subtopicTitle added to bookmarks',
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  // ── Remove Bookmark ────────────────────────────────────────────────────────

  // Future<void> removeBookmark(String topicTitle, String subtopicTitle) async {
  //   final removed = bookmarks.removeWhere(
  //     (b) => b.topicTitle == topicTitle && b.subtopicTitle == subtopicTitle,
  //   );

    Future<void> removeBookmark(String topicTitle, String subtopicTitle) async{

        final exists = bookmarks.any(
          (b) => 
                b.topicTitle == topicTitle &&
                b.subtopicTitle == subtopicTitle, 
        );

        if(!exists) return;

        bookmarks.removeWhere(
          (b) => 
                b.topicTitle == topicTitle &&
                b.subtopicTitle == subtopicTitle,
        );

        await _saveToStorage();
        await _removeFromFirestore(topicTitle, subtopicTitle);

        Get.snackbar(
          'Removed',
          '$subtopicTitle removed from bookmarks',
          backgroundColor: Colors.orange,
          colorText: Colors.white
        );

    }


  // ── Remove All Bookmarks ───────────────────────────────────────────────────

  Future<void> clearAllBookmarks() async {
    bookmarks.clear();
    await _saveToStorage();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await _firestoreService.clearBookmarks(uid);
    }

    Get.snackbar('Cleared', 'All bookmarks removed',
        backgroundColor: Colors.orange, colorText: Colors.white);
  }

  // ── Get Bookmarks by Topic ─────────────────────────────────────────────────

  List<Bookmark> getBookmarksByTopic(String topicTitle) {
    return bookmarks.where((b) => b.topicTitle == topicTitle).toList();
  }

  // ── Storage & Sync ─────────────────────────────────────────────────────────

  Future<void> _saveToStorage() async {
    await _localStorage.write(
      _bookmarksKey,
      bookmarks.map((b) => b.toMap()).toList(),
    );
  }

  Future<void> _saveToFirestore(Bookmark bookmark, {required bool isAdd}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      if (isAdd) {
        await _firestoreService.addBookmark(uid, bookmark);
      }
    } catch (e) {
      print('Error saving to Firestore: $e');
    }
  }

  Future<void> _removeFromFirestore(String topicTitle, String subtopicTitle) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      await _firestoreService.removeBookmark(
        uid,
        topicTitle,
        subtopicTitle
      );
    } catch (e) {
      print('Error removing from Firestore: $e');
    }
  }
}
