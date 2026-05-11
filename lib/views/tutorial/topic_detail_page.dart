import 'package:flutter_html/flutter_html.dart';
import 'package:c_master/controllers/progress_controller.dart';
import '../../core/utils/import_export.dart';

class TopicDetailPage extends StatefulWidget {
  const TopicDetailPage({super.key});

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  final ScrollController _scroll = ScrollController();
  double _readProgress = 0;
  bool _markingRead = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.maxScrollExtent > 0) {
        setState(() {
          _readProgress = _scroll.offset / _scroll.position.maxScrollExtent;
        });
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SubTopic subtopic = Get.arguments;
    final cs = context.colors;
    final dark = context.isDark;

    final codeBg = dark ? const Color(0xFF1E293B) : const Color(0xFF1E1E2E);
    final codeText = dark ? const Color(0xFF94D468) : const Color(0xFF50FA7B);

    final progressCtrl = Get.find<ProgressController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(subtopic.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedFractionallySizedBox(
              widthFactor: _readProgress.clamp(0.0, 1.0),
              duration: const Duration(milliseconds: 150),
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [cs.primary, cs.secondary]),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(3),
                    bottomRight: Radius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scroll,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Topic badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.article_rounded, size: 14, color: cs.primary),
                  const SizedBox(width: 6),
                  Text(
                    'C Programming',
                    style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.w600, color: cs.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // HTML content
            Html(
              data: subtopic.content,
              style: {
                'body': Style(
                  fontFamily: 'Poppins',
                  color: cs.onSurface,
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
                'h1,h2,h3': Style(
                  color: cs.primary,
                  fontWeight: FontWeight.w700,
                ),
                'p': Style(
                  fontSize: FontSize(15.5),
                  lineHeight: LineHeight.em(1.7),
                  color: cs.onSurface.withValues(alpha: 0.9),
                ),
                'pre': Style(
                  backgroundColor: codeBg,
                  padding: HtmlPaddings.all(16),
                  border: Border.all(color: codeText.withValues(alpha: 0.15)),
                  margin: Margins.symmetric(vertical: 12),
                ),
                'code': Style(
                  fontFamily: 'Courier',
                  fontSize: FontSize(13.5),
                  color: codeText,
                  backgroundColor: codeBg,
                  padding: HtmlPaddings.symmetric(horizontal: 4, vertical: 2),
                ),
                'li': Style(
                  fontSize: FontSize(15.0),
                  lineHeight: LineHeight.em(1.7),
                  color: cs.onSurface.withValues(alpha: 0.85),
                  margin: Margins.only(bottom: 6),
                ),
                'strong': Style(color: cs.onSurface, fontWeight: FontWeight.w700),
                'a': Style(color: cs.primary, textDecoration: TextDecoration.none),
              },
            ),
          ],
        ),
      ),

      // ── Mark as Read FAB ────────────────────────────────────────────────
      floatingActionButton: Obx(() {
        final isRead = progressCtrl.isSubtopicCompleted(subtopic.title);
        return FloatingActionButton.extended(
          onPressed: isRead
              ? null
              : () async {
                  setState(() => _markingRead = true);
                  await progressCtrl.markSubtopicRead(subtopic.title);
                  setState(() => _markingRead = false);
                  Get.snackbar(
                    '✅ Marked as Read',
                    '"${subtopic.title}" added to your progress',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green.withValues(alpha: 0.9),
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(12),
                    borderRadius: 14,
                  );
                },
          backgroundColor: isRead ? Colors.green : cs.primary,
          foregroundColor: Colors.white,
          icon: _markingRead
              ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : Icon(isRead ? Icons.check_rounded : Icons.check_circle_outline_rounded),
          label: Text(
            isRead ? 'Completed ✓' : 'Mark as Read',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        );
      }).animate().fadeIn(delay: 500.ms).slideY(begin: 0.5),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
