import '../../core/utils/import_export.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/progress_controller.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final controller = Get.put(DashboardController());
  final settingsCtrl = Get.put(SettingsController());
  final progressCtrl = Get.put(ProgressController());

  static const _cards = [
    _CardData(icon: Icons.menu_book_rounded, title: 'Learn C', subtitle: 'Topics & lessons', route: '/topics', gradientIndex: 0),
    _CardData(icon: Icons.quiz_rounded, title: 'Quiz', subtitle: 'Test yourself', route: '/quiz', gradientIndex: 1),
    _CardData(icon: Icons.terminal_rounded, title: 'Practice Code', subtitle: 'Write & run C', route: '/code_editor', gradientIndex: 2),
    _CardData(icon: Icons.bookmark_rounded, title: 'Bookmarks', subtitle: 'Saved topics', route: '/bookmarks', gradientIndex: 3),
    _CardData(icon: Icons.bar_chart_rounded, title: 'Progress', subtitle: 'Your journey', route: '/progress', gradientIndex: 4),
    _CardData(icon: Icons.auto_awesome_rounded, title: 'AI Assistant', subtitle: 'Ask anything', route: '/ai_chat', gradientIndex: 5),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.texts;
    final dark = context.isDark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [

          // ── Gradient Header SliverAppBar ─────────────────────────────
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            stretch: true,
            backgroundColor: dark ? AppColors.darkBg : AppColors.lightPrimary,
            surfaceTintColor: Colors.transparent,
            actions: [
              Obx(() => IconButton(
                    tooltip: settingsCtrl.isDarkMode.value ? 'Light Mode' : 'Dark Mode',
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, anim) =>
                          RotationTransition(turns: anim, child: FadeTransition(opacity: anim, child: child)),
                      child: Icon(
                        settingsCtrl.isDarkMode.value ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                        key: ValueKey(settingsCtrl.isDarkMode.value),
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => settingsCtrl.toggleTheme(!settingsCtrl.isDarkMode.value),
                  )),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () => Get.toNamed('/settings'),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: dark
                        ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                        : [AppColors.lightPrimary, AppColors.lightSecondary],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // User row
                            Row(
                              children: [
                                Container(
                                  width: 52, height: 52,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      (controller.username.value.isNotEmpty
                                              ? controller.username.value[0]
                                              : 'U')
                                          .toUpperCase(),
                                      style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Welcome back 👋',
                                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.white.withValues(alpha: 0.8)),
                                      ),
                                      Text(
                                        controller.username.value,
                                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // ── Live Stats Strip ──────────────────────────
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _StatPill(
                                    icon: Icons.menu_book_rounded,
                                    label: '${progressCtrl.completedCount}/${progressCtrl.totalSubtopics}',
                                    sublabel: 'Topics',
                                  ),
                                  Container(width: 1, height: 28, color: Colors.white.withValues(alpha: 0.25)),
                                  _StatPill(
                                    icon: Icons.quiz_rounded,
                                    label: '${(progressCtrl.averageQuizScore * 100).round()}%',
                                    sublabel: 'Quiz Avg',
                                  ),
                                  Container(width: 1, height: 28, color: Colors.white.withValues(alpha: 0.25)),
                                  _StatPill(
                                    icon: Icons.local_fire_department_rounded,
                                    label: '${progressCtrl.streak.value}d',
                                    sublabel: 'Streak 🔥',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            ),
          ),

          // ── Section Title ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
              child: Row(
                children: [
                  Text('Quick Access', style: tt.headlineSmall),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '6 modules',
                      style: tt.labelSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Grid ──────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _DashCard(data: _cards[index], index: index),
                childCount: _cards.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.95,
              ),
            ),
          ),
        ],
      ),

      // ── FAB ──────────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/ai_chat'),
        backgroundColor: cs.primary,
        foregroundColor: dark ? AppColors.darkOnPrimary : Colors.white,
        icon: const Icon(Icons.auto_awesome_rounded),
        label: Text('Ask AI', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.5),
    );
  }
}

// ── Stats Pill ────────────────────────────────────────────────────────────────

class _StatPill extends StatelessWidget {
  const _StatPill({required this.icon, required this.label, required this.sublabel});
  final IconData icon;
  final String label;
  final String sublabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
            ),
          ],
        ),
        Text(
          sublabel,
          style: GoogleFonts.poppins(fontSize: 10, color: Colors.white.withValues(alpha: 0.75)),
        ),
      ],
    );
  }
}

// ── Dashboard Card ────────────────────────────────────────────────────────────

class _DashCard extends StatefulWidget {
  const _DashCard({required this.data, required this.index});
  final _CardData data;
  final int index;

  @override
  State<_DashCard> createState() => _DashCardState();
}

class _DashCardState extends State<_DashCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final gradients = AppColors.tileGradients;
    final g = gradients[widget.data.gradientIndex % gradients.length];
    final delay = Duration(milliseconds: 100 + widget.index * 80);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        Get.toNamed(widget.data.route);
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: g),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(color: g.first.withValues(alpha: 0.35), blurRadius: 18, offset: const Offset(0, 8)),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(widget.data.icon, color: Colors.white, size: 26),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.data.title,
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(widget.data.subtitle,
                      style: GoogleFonts.poppins(color: Colors.white.withValues(alpha: 0.75), fontSize: 11)),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: delay, duration: 400.ms).slideY(begin: 0.25),
      ),
    );
  }
}

class _CardData {
  const _CardData({required this.icon, required this.title, required this.subtitle, required this.route, required this.gradientIndex});
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final int gradientIndex;
}
