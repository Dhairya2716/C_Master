import '../../core/utils/import_export.dart';
import '../../controllers/topic_controller.dart';

class TopicListPage extends StatelessWidget {
  TopicListPage({super.key});

  final TopicController topicController = Get.put(TopicController());

  // Accent colors cycling through topics
  static const _accents = [
    Color(0xFF4F46E5),
    Color(0xFF0EA5E9),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEC4899),
    Color(0xFF06B6D4),
    Color(0xFF8B5CF6),
    Color(0xFFEF4444),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.texts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn C'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: cs.primary.withOpacity(0.1)),
        ),
      ),
      body: Obx(() {
        if (topicController.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: cs.primary),
                const SizedBox(height: 16),
                Text('Loading topics…', style: tt.bodyMedium),
              ],
            ),
          );
        }

        if (topicController.topicList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_rounded, size: 64, color: cs.primary.withOpacity(0.3)),
                const SizedBox(height: 16),
                Text('No topics available', style: tt.titleMedium),
                const SizedBox(height: 6),
                Text('Check back soon!', style: tt.bodySmall),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          itemCount: topicController.topicList.length,
          itemBuilder: (context, index) {
            final topic = topicController.topicList[index];
            final accent = _accents[index % _accents.length];

            return _TopicCard(
              topic: topic,
              index: index,
              accent: accent,
            )
                .animate()
                .fadeIn(delay: Duration(milliseconds: 60 * index), duration: 350.ms)
                .slideX(begin: 0.08);
          },
        );
      }),
    );
  }
}

// ─── Topic Card ───────────────────────────────────────────────────────────────

class _TopicCard extends StatelessWidget {
  const _TopicCard({
    required this.topic,
    required this.index,
    required this.accent,
  });

  final dynamic topic;
  final int index;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.texts;
    final dark = context.isDark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: accent, width: 4)),
        boxShadow: [
          BoxShadow(
            color: dark ? Colors.black.withOpacity(0.3) : accent.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Theme(
        // Override ExpansionTile splash to match theme
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(18, 4, 16, 4),
          childrenPadding: EdgeInsets.zero,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: GoogleFonts.poppins(
                  color: accent,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          title: Text(topic.title, style: tt.titleLarge),
          subtitle: Text(
            '${topic.subtopics.length} subtopics',
            style: tt.bodySmall,
          ),
          iconColor: accent,
          collapsedIconColor: cs.onSurface.withOpacity(0.4),
          children: [
            const Divider(height: 1, indent: 18, endIndent: 18),
            ...topic.subtopics.map<Widget>((subtopic) {
              return InkWell(
                onTap: () => Get.toNamed(Routes.TOPIC_DETAIL, arguments: subtopic),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(subtopic.title, style: tt.bodyMedium),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, size: 14, color: accent.withOpacity(0.7)),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
