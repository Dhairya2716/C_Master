import 'package:c_master/controllers/progress_controller.dart';
import 'package:c_master/controllers/quiz_controller.dart';
import 'package:c_master/core/constants/app_theme.dart';
import 'package:c_master/views/quiz/quiz_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class QuizPage extends StatelessWidget {
  QuizPage({super.key});

  final QuizController quizCtrl = Get.put(QuizController());

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: Obx(() {
        // ── Topic Picker (no quiz started yet) ───────────────────────────
        if (quizCtrl.questions.isEmpty) {
          return _TopicPicker(quizCtrl: quizCtrl);
        }

        // ── Quiz Finished ─────────────────────────────────────────────
        if (quizCtrl.isFinished.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final q = quizCtrl.currentQuestion!;
        final answered = quizCtrl.hasAnswered;

        return Column(
          children: [
            // ── Progress bar ──────────────────────────────────────────
            LinearProgressIndicator(
              value: quizCtrl.progressPercent,
              backgroundColor: cs.primary.withValues(alpha: 0.15),
              color: cs.primary,
              minHeight: 5,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Topic + counter
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            quizCtrl.currentTopic.value,
                            style: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.w600, color: cs.primary,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${quizCtrl.currentIndex.value + 1} / ${quizCtrl.questions.length}',
                          style: GoogleFonts.poppins(fontSize: 13, color: cs.onSurface.withValues(alpha: 0.5)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Question card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: cs.primary.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Text(
                        q.question,
                        style: GoogleFonts.poppins(
                          fontSize: 17, fontWeight: FontWeight.w600,
                          color: cs.onSurface, height: 1.5,
                        ),
                      ),
                    ).animate(key: ValueKey(quizCtrl.currentIndex.value))
                     .fadeIn(duration: 300.ms)
                     .slideX(begin: 0.1),

                    const SizedBox(height: 20),

                    // Options
                    ...q.options.asMap().entries.map((entry) {
                      final i = entry.key;
                      final opt = entry.value;
                      return _OptionTile(
                        option: opt,
                        index: i,
                        answered: answered,
                        selectedIndex: quizCtrl.selectedAnswerForCurrent,
                        correctIndex: q.correctIndex,
                        delayMs: i * 60,
                        onTap: () => quizCtrl.selectAnswer(i),
                      );
                    }),

                    // Explanation (shown after answering)
                    if (answered) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline_rounded, color: Colors.blue, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                q.explanation,
                                style: GoogleFonts.poppins(
                                  fontSize: 13, color: Colors.blue.shade700, height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Next / Submit button ───────────────────────────────────
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: GestureDetector(
                  onTap: answered ? quizCtrl.nextQuestion : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: answered
                          ? LinearGradient(colors: [cs.primary, cs.secondary])
                          : null,
                      color: answered ? null : cs.onSurface.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        quizCtrl.isLastQuestion ? 'Submit Quiz' : 'Next Question',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: answered ? Colors.white : cs.onSurface.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ── Topic Picker ─────────────────────────────────────────────────────────────

class _TopicPicker extends StatelessWidget {
  const _TopicPicker({required this.quizCtrl});
  final QuizController quizCtrl;

  static const _colors = [
    Color(0xFF4F46E5), Color(0xFF0EA5E9), Color(0xFF10B981),
    Color(0xFFF59E0B), Color(0xFFEC4899), Color(0xFF06B6D4),
    Color(0xFF8B5CF6), Color(0xFFEF4444),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.texts;
    final topics = quizTopics;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Choose a Topic', style: tt.headlineMedium).animate().fadeIn(),
        const SizedBox(height: 6),
        Text('Select a chapter to start your quiz', style: tt.bodySmall).animate().fadeIn(delay: 100.ms),
        const SizedBox(height: 24),

        // All topics card
        GestureDetector(
          onTap: quizCtrl.startAllTopicsQuiz,
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: const Color(0xFF4F46E5).withValues(alpha: 0.35), blurRadius: 18, offset: const Offset(0, 8))],
            ),
            child: Row(
              children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.shuffle_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mixed Quiz', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                      Text('20 random questions from all topics', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
        ),

        const SizedBox(height: 8),
        Text('Or by chapter:', style: tt.labelSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w700, letterSpacing: 1)),
        const SizedBox(height: 12),

        ...topics.asMap().entries.map((entry) {
          final i = entry.key;
          final topic = entry.value;
          final color = _colors[i % _colors.length];
          final count = questionsForTopic(topic).length;
          return GestureDetector(
            onTap: () => quizCtrl.startQuiz(topic),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border(left: BorderSide(color: color, width: 4)),
                boxShadow: [BoxShadow(color: color.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                    child: Center(child: Text('${i + 1}', style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w800, fontSize: 15))),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(topic, style: tt.titleMedium),
                        Text('$count questions', style: tt.bodySmall),
                      ],
                    ),
                  ),
                  Icon(Icons.play_arrow_rounded, color: color, size: 26),
                ],
              ),
            ).animate().fadeIn(delay: Duration(milliseconds: 80 * i + 300), duration: 350.ms).slideX(begin: 0.08),
          );
        }),
      ],
    );
  }
}

// ── Option Tile ───────────────────────────────────────────────────────────────

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.option,
    required this.index,
    required this.answered,
    required this.selectedIndex,
    required this.correctIndex,
    required this.delayMs,
    required this.onTap,
  });

  final String option;
  final int index;
  final bool answered;
  final int? selectedIndex;
  final int correctIndex;
  final int delayMs;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;

    Color bgColor = cs.surface;
    Color borderColor = cs.onSurface.withValues(alpha: 0.12);
    Color textColor = cs.onSurface;
    Widget? trailing;

    if (answered) {
      if (index == correctIndex) {
        bgColor = Colors.green.withValues(alpha: 0.12);
        borderColor = Colors.green;
        textColor = Colors.green.shade700;
        trailing = const Icon(Icons.check_circle_rounded, color: Colors.green, size: 22);
      } else if (index == selectedIndex && index != correctIndex) {
        bgColor = Colors.red.withValues(alpha: 0.10);
        borderColor = Colors.red;
        textColor = Colors.red.shade700;
        trailing = const Icon(Icons.cancel_rounded, color: Colors.red, size: 22);
      }
    }

    return GestureDetector(
      onTap: answered ? null : onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                color: answered && index == correctIndex
                    ? Colors.green.withValues(alpha: 0.15)
                    : cs.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A B C D
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: textColor),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(option, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: textColor)),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: delayMs), duration: 300.ms),
    );
  }
}
