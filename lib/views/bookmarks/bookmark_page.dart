import 'package:c_master/controllers/bookmark_controller.dart';
import '../../core/utils/import_export.dart';

class BookmarkPage extends StatelessWidget {
  BookmarkPage({super.key});

  final controller = Get.put(BookmarkController());

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.texts;
    final dark = context.isDark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        elevation: 0,
        actions: [
          Obx(() {
            if (controller.totalBookmarks == 0) return SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Center(
                child: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'clear_all') {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Clear All Bookmarks?'),
                          content: const Text('This action cannot be undone.'),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                controller.clearAllBookmarks();
                                Get.back();
                              },
                              child: const Text('Clear', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: 'clear_all',
                      child: Row(
                        children: [
                          Icon(Icons.delete_sweep, size: 18),
                          SizedBox(width: 8),
                          Text('Clear All'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.totalBookmarks == 0) {
          return _EmptyState(cs: cs, tt: tt);
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          children: [
            // ── Header ─────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cs.primary.withValues(alpha: 0.1), cs.secondary.withValues(alpha: 0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.bookmark_rounded, color: cs.primary, size: 28),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Bookmarks',
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${controller.totalBookmarks} saved topic${controller.totalBookmarks > 1 ? 's' : ''}',
                        style: tt.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Bookmarks List ─────────────────────────────────────────────
            ...controller.bookmarks.map((bookmark) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _BookmarkCard(
                  bookmark: bookmark,
                  onDelete: () {
                    controller.removeBookmark(bookmark.topicTitle, bookmark.subtopicTitle);
                  },
                  cs: cs,
                  tt: tt,
                  dark: dark,
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  final dynamic bookmark;
  final VoidCallback onDelete;
  final ColorScheme cs;
  final TextTheme tt;
  final bool dark;

  const _BookmarkCard({
    required this.bookmark,
    required this.onDelete,
    required this.cs,
    required this.tt,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to topic detail with this subtopic
        Get.toNamed('/topic_detail', arguments: null); // You might want to pass the subtopic
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: cs.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: dark ? cs.surface : Colors.white,
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Icon ────────────────────────────────────────────────────
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cs.primary.withValues(alpha: 0.2), cs.secondary.withValues(alpha: 0.2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.bookmark_rounded, color: cs.primary, size: 24),
            ),
            const SizedBox(width: 16),

            // ── Content ─────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Topic tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      bookmark.topicTitle,
                      style: tt.labelSmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtopic title
                  Text(
                    bookmark.subtopicTitle,
                    style: tt.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Saved date
                  Text(
                    'Saved ${_formatDate(bookmark.savedAt)}',
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),

            // ── Delete Button ───────────────────────────────────────────
            IconButton(
              onPressed: onDelete,
              icon: Icon(Icons.close_rounded, color: cs.error, size: 20),
              tooltip: 'Remove bookmark',
              splashRadius: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    }
  }
}

class _EmptyState extends StatelessWidget {
  final ColorScheme cs;
  final TextTheme tt;

  const _EmptyState({required this.cs, required this.tt});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.bookmark_outline_rounded,
                size: 50,
                color: cs.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Bookmarks Yet',
              style: tt.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Save your favorite topics to access them quickly later',
                textAlign: TextAlign.center,
                style: tt.bodyMedium?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Get.toNamed('/topics'),
              icon: const Icon(Icons.menu_book_rounded),
              label: const Text('Browse Topics'),
            ),
          ],
        ),
      ),
    );
  }
}
