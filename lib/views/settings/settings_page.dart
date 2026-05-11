import 'package:c_master/controllers/settings_controller.dart';
import 'package:c_master/controllers/theme_controller.dart';
import 'package:c_master/core/constants/theme_palette.dart';
import '../../core/utils/import_export.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.texts;
    final dark = context.isDark;

    final email = controller.user?.email ?? 'No email';
    final initial = email.isNotEmpty ? email[0].toUpperCase() : 'U';
    final themeCtrl = Get.put(ThemeController());

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Obx(() => ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            children: [
              // ── User Banner ─────────────────────────────────────────────
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: dark
                        ? [const Color(0xFF1E293B), const Color(0xFF334155)]
                        : [AppColors.lightPrimary, AppColors.lightSecondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          initial,
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            email,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Active member',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),

              // ── Preferences ─────────────────────────────────────────────
              _SectionLabel(label: 'Preferences', cs: cs, tt: tt),
              _SettingsCard(
                children: [
                  _ToggleTile(
                    icon: controller.isDarkMode.value
                        ? Icons.nightlight_round
                        : Icons.wb_sunny_rounded,
                    iconColor: controller.isDarkMode.value
                        ? const Color(0xFF60A5FA)
                        : const Color(0xFFF59E0B),
                    title: 'Dark Mode',
                    value: controller.isDarkMode.value,
                    onChanged: controller.toggleTheme,
                  ),
                  _Separator(),
                  _ToggleTile(
                    icon: Icons.notifications_active_rounded,
                    iconColor: const Color(0xFF10B981),
                    title: 'Notifications',
                    value: controller.notificationsEnabled.value,
                    onChanged: controller.toggleNotifications,
                  ),
                ],
                cs: cs,
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

              const SizedBox(height: 16),

              // ── Theme Colors ────────────────────────────────────────────
              _SectionLabel(label: 'App Colors', cs: cs, tt: tt),
              Container(
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose a color theme',
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: themeCtrl.availablePalettes.map((palette) {
                        final isSelected = themeCtrl.currentThemeId.value == palette.id;
                        return GestureDetector(
                          onTap: () => themeCtrl.setTheme(palette.id),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [palette.lightPrimary, palette.lightSecondary],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: isSelected
                                      ? Border.all(color: cs.onSurface, width: 3)
                                      : Border.all(
                                          color: cs.outline.withOpacity(0.2),
                                          width: 1,
                                        ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: palette.lightPrimary.withOpacity(0.4),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: isSelected
                                    ? Icon(Icons.check_rounded, color: Colors.white, size: 28)
                                    : null,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                palette.name,
                                style: tt.labelSmall?.copyWith(
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected ? cs.onSurface : cs.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

              const SizedBox(height: 16),

              // ── Account ─────────────────────────────────────────────────
              _SectionLabel(label: 'Account', cs: cs, tt: tt),
              _SettingsCard(
                children: [
                  _ActionTile(
                    icon: Icons.edit_rounded,
                    iconColor: const Color(0xFF8B5CF6),
                    title: 'Edit Profile',
                    onTap: () => Get.snackbar(
                      'Coming Soon',
                      'Edit profile feature is in development',
                      snackPosition: SnackPosition.BOTTOM,
                    ),
                  ),
                  _Separator(),
                  _ActionTile(
                    icon: Icons.star_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'Rate App',
                    onTap: () => Get.snackbar(
                      'Rate Us ⭐',
                      'Redirect to Play Store',
                      snackPosition: SnackPosition.BOTTOM,
                    ),
                  ),
                  _Separator(),
                  _ActionTile(
                    icon: Icons.delete_sweep_rounded,
                    iconColor: const Color(0xFFEF4444),
                    title: 'Clear Bookmarks',
                    onTap: () => Get.snackbar(
                      'Done',
                      'Bookmarks cleared',
                      snackPosition: SnackPosition.BOTTOM,
                    ),
                  ),
                ],
                cs: cs,
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

              const SizedBox(height: 16),

              // ── Danger Zone ─────────────────────────────────────────────
              _SectionLabel(label: 'Danger Zone', cs: cs, tt: tt),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red.withOpacity(0.15)),
                ),
                child: _ActionTile(
                  icon: Icons.logout_rounded,
                  iconColor: Colors.red,
                  title: 'Logout',
                  titleColor: Colors.red,
                  onTap: controller.logout,
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

              const SizedBox(height: 32),

              // ── Version ─────────────────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.code_rounded, color: cs.primary, size: 22),
                    ),
                    const SizedBox(height: 8),
                    Text('C Master', style: tt.labelLarge),
                    const SizedBox(height: 2),
                    Text('Version 1.0.0', style: tt.bodySmall),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms),
            ],
          )),
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.cs, required this.tt});
  final String label;
  final ColorScheme cs;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 0, 10),
        child: Text(
          label.toUpperCase(),
          style: tt.labelSmall?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      );
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children, required this.cs});
  final List<Widget> children;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(children: children),
      );
}

class _Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Divider(
        height: 1,
        indent: 56,
        color: context.colors.onSurface.withOpacity(0.06),
      );
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tt = context.texts;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          _IconBox(icon: icon, color: iconColor),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: tt.titleMedium)),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.titleColor,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final tt = context.texts;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            _IconBox(icon: icon, color: iconColor),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: tt.titleMedium?.copyWith(color: titleColor),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: context.colors.onSurface.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon, required this.color});
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(icon, color: color, size: 20),
      );
}
