import 'package:c_master/controllers/quiz_controller.dart';
import 'package:c_master/core/constants/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final quizCtrl = Get.find<QuizController>();
    final cs = context.colors;
    final tt = context.texts;

    final score = quizCtrl.score.value;
    final total = quizCtrl.questions.length;
    final percent = total == 0 ? 0.0 : score / total;
    final topic = quizCtrl.currentTopic.value;

    final (grade, gradeColor, emoji) = _gradeData(percent);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // ── Score Ring ─────────────────────────────────────────────
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        startDegreeOffset: -90,
                        sectionsSpace: 0,
                        centerSpaceRadius: 70,
                        sections: [
                          PieChartSectionData(
                            value: percent,
                            color: gradeColor,
                            showTitle: false,
                            radius: 22,
                          ),
                          PieChartSectionData(
                            value: 1 - percent,
                            color: gradeColor.withValues(alpha: 0.12),
                            showTitle: false,
                            radius: 22,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          emoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                        Text(
                          '$score/$total',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface,
                          ),
                        ),
                        Text(
                          '${(percent * 100).round()}%',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: gradeColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.7, 0.7)),

              const SizedBox(height: 16),

              // ── Grade badge ────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: gradeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: gradeColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  grade,
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: gradeColor),
                ),
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 6),
              Text(topic, style: tt.bodySmall).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 28),

              // ── Review breakdown ───────────────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Review Answers', style: tt.headlineSmall),
              ),
              const SizedBox(height: 14),

              ...quizCtrl.questions.asMap().entries.map((entry) {
                final i = entry.key;
                final q = entry.value;
                final chosen = quizCtrl.selectedAnswers[i];
                final isCorrect = chosen == q.correctIndex;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isCorrect
                        ? Colors.green.withValues(alpha: 0.06)
                        : Colors.red.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isCorrect
                          ? Colors.green.withValues(alpha: 0.25)
                          : Colors.red.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                            color: isCorrect ? Colors.green : Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Q${i + 1}',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(q.question, style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      if (chosen != null && !isCorrect)
                        Text(
                          'Your answer: ${q.options[chosen]}',
                          style: tt.bodySmall?.copyWith(color: Colors.red.shade600),
                        ),
                      Text(
                        'Correct: ${q.options[q.correctIndex]}',
                        style: tt.bodySmall?.copyWith(color: Colors.green.shade700, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '💡 ${q.explanation}',
                        style: tt.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.65), height: 1.5),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: Duration(milliseconds: 600 + i * 60), duration: 300.ms);
              }),

              const SizedBox(height: 24),

              // ── Actions ────────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        quizCtrl.startQuiz(topic == 'All Topics'
                            ? quizCtrl.currentTopic.value
                            : topic);
                        Get.back();
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retake'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Get.offNamed('/dashboard'),
                      icon: const Icon(Icons.home_rounded),
                      label: const Text('Dashboard'),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 800.ms),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  (String grade, Color color, String emoji) _gradeData(double percent) {
    if (percent >= 0.9) return ('Excellent! 🏆', Colors.amber, '🌟');
    if (percent >= 0.75) return ('Great Job! 🎉', Colors.green, '😄');
    if (percent >= 0.5) return ('Good Effort 👍', Colors.blue, '🙂');
    if (percent >= 0.3) return ('Keep Practicing 📚', Colors.orange, '😅');
    return ('Need More Study 💪', Colors.red, '📖');
  }
}
