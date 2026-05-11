import 'package:c_master/controllers/progress_controller.dart';
import 'package:c_master/core/constants/app_theme.dart';
import 'package:c_master/views/tutorial/c_topics.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class ProgressPage extends StatelessWidget {
  ProgressPage({super.key});

  final ProgressController ctrl = Get.put(ProgressController());

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.texts;

    return Scaffold(
      appBar: AppBar(title: const Text('My Progress')),
      body: Obx(() {
        final perTopic = ctrl.perTopicPercent;
        final attempts = ctrl.quizAttempts;
        final recent = ctrl.recentAttempts;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: [

            // ── Overview Cards ─────────────────────────────────────────
            _SectionTitle(title: 'Overview', cs: cs, tt: tt),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.menu_book_rounded,
                    iconColor: AppColors.lightPrimary,
                    label: 'Topics Read',
                    value: '${ctrl.completedCount}',
                    sub: 'of ${ctrl.totalSubtopics}',
                    progress: ctrl.overallPercent,
                  ).animate().fadeIn(duration: 400.ms),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.quiz_rounded,
                    iconColor: const Color(0xFF0EA5E9),
                    label: 'Quiz Avg',
                    value: '${(ctrl.averageQuizScore * 100).round()}%',
                    sub: '${attempts.length} attempt${attempts.length == 1 ? '' : 's'}',
                    progress: ctrl.averageQuizScore,
                  ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.local_fire_department_rounded,
                    iconColor: Colors.orange,
                    label: 'Streak',
                    value: '${ctrl.streak.value}',
                    sub: 'days 🔥',
                    progress: null,
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ── Chapter Mastery Bars ───────────────────────────────────
            _SectionTitle(title: 'Chapter Mastery', cs: cs, tt: tt),
            const SizedBox(height: 16),

            ...cTopics.asMap().entries.map((entry) {
              final i = entry.key;
              final topic = entry.value;
              final percent = perTopic[topic.title] ?? 0.0;
              final color = _barColor(percent);

              return _ChapterBar(
                index: i,
                title: topic.title,
                percent: percent,
                totalSubtopics: topic.subtopics.length,
                completedCount: topic.subtopics
                    .where((s) => ctrl.completedSubtopics.contains(s.title))
                    .length,
                color: color,
              ).animate().fadeIn(
                delay: Duration(milliseconds: 60 * i + 300),
                duration: 350.ms,
              ).slideX(begin: 0.06);
            }),

            const SizedBox(height: 28),

            // ── Quiz Score History (Line Chart) ────────────────────────
            if (attempts.length >= 2) ...[
              _SectionTitle(title: 'Quiz Score Trend', cs: cs, tt: tt),
              const SizedBox(height: 16),
              Container(
                height: 200,
                padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 16, offset: const Offset(0, 4))],
                ),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (v) => FlLine(
                        color: cs.onSurface.withValues(alpha: 0.07),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 25,
                          reservedSize: 36,
                          getTitlesWidget: (v, _) => Text(
                            '${v.round()}%',
                            style: GoogleFonts.poppins(fontSize: 10, color: cs.onSurface.withValues(alpha: 0.5)),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (v, _) {
                            final idx = v.round();
                            if (idx < 0 || idx >= attempts.length) return const SizedBox();
                            return Text(
                              DateFormat('d/M').format(attempts[idx].date),
                              style: GoogleFonts.poppins(fontSize: 10, color: cs.onSurface.withValues(alpha: 0.5)),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    minY: 0,
                    maxY: 100,
                    lineBarsData: [
                      LineChartBarData(
                        spots: attempts.asMap().entries.map((e) =>
                          FlSpot(e.key.toDouble(), (e.value.percent * 100).roundToDouble()),
                        ).toList(),
                        isCurved: true,
                        gradient: LinearGradient(colors: [cs.primary, cs.secondary]),
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                            radius: 4,
                            color: cs.primary,
                            strokeWidth: 2,
                            strokeColor: cs.surface,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [cs.primary.withValues(alpha: 0.18), cs.primary.withValues(alpha: 0.0)],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
              const SizedBox(height: 28),
            ],

            // ── Recent Quiz Attempts ───────────────────────────────────
            if (recent.isNotEmpty) ...[
              _SectionTitle(title: 'Recent Quizzes', cs: cs, tt: tt),
              const SizedBox(height: 12),
              ...recent.asMap().entries.map((entry) {
                final i = entry.key;
                final attempt = entry.value;
                final pct = attempt.percent;
                final color = _barColor(pct);

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(13)),
                        child: Icon(Icons.quiz_rounded, color: color, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(attempt.topic, style: tt.titleMedium),
                            Text(
                              DateFormat('MMM d, yyyy').format(attempt.date),
                              style: tt.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${attempt.score}/${attempt.total}',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 16, color: color),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              '${(pct * 100).round()}%',
                              style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: color),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: Duration(milliseconds: 60 * i + 500), duration: 300.ms);
              }),
            ],

            // ── Empty State ────────────────────────────────────────────
            if (ctrl.completedCount == 0 && attempts.isEmpty)
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Icon(Icons.bar_chart_rounded, size: 72, color: cs.primary.withValues(alpha: 0.25)),
                    const SizedBox(height: 16),
                    Text('No progress yet!', style: tt.titleMedium),
                    const SizedBox(height: 6),
                    Text(
                      'Start reading topics and taking quizzes\nto see your analytics here.',
                      style: tt.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms),
          ],
        );
      }),
    );
  }

  Color _barColor(double percent) {
    if (percent >= 0.75) return Colors.green;
    if (percent >= 0.4) return Colors.amber.shade600;
    if (percent > 0) return Colors.blue;
    return Colors.grey.shade400;
  }
}

// ── Section Title ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.cs, required this.tt});
  final String title;
  final ColorScheme cs;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) => Text(
        title.toUpperCase(),
        style: tt.labelSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w700, letterSpacing: 1.2),
      );
}

// ── Stat Card ─────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.sub,
    required this.progress,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String sub;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.texts;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 10),
          Text(value, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w800, color: cs.onSurface)),
          Text(sub, style: tt.bodySmall),
          const SizedBox(height: 4),
          Text(label, style: tt.labelSmall),
          if (progress != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress!.clamp(0.0, 1.0),
                backgroundColor: iconColor.withValues(alpha: 0.12),
                color: iconColor,
                minHeight: 4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Chapter Bar ───────────────────────────────────────────────────────────────

class _ChapterBar extends StatelessWidget {
  const _ChapterBar({
    required this.index,
    required this.title,
    required this.percent,
    required this.totalSubtopics,
    required this.completedCount,
    required this.color,
  });

  final int index;
  final String title;
  final double percent;
  final int totalSubtopics;
  final int completedCount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.texts;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: tt.titleMedium)),
              Text(
                '$completedCount/$totalSubtopics',
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: color),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: percent.clamp(0.0, 1.0)),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              builder: (_, value, __) => LinearProgressIndicator(
                value: value,
                backgroundColor: color.withValues(alpha: 0.1),
                color: color,
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(percent * 100).round()}% completed',
            style: tt.bodySmall,
          ),
        ],
      ),
    );
  }
}
