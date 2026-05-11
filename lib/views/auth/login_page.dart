import '../../core/utils/import_export.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController controller = Get.put(AuthController());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.texts;
    final dark = context.isDark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Gradient Header ──────────────────────────────────────────
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.lightPrimary,
                    AppColors.lightSecondary,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.code_rounded, color: Colors.white, size: 44),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .scale(begin: const Offset(0.7, 0.7)),
                    const SizedBox(height: 16),
                    Text(
                      'C Master',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideY(begin: 0.3),
                    const SizedBox(height: 6),
                    Text(
                      'Master C Programming',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
                  ],
                ),
              ),
            ),

            // ── Form Card ────────────────────────────────────────────────
            Transform.translate(
              offset: const Offset(0, -28),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightPrimary.withOpacity(dark ? 0.0 : 0.1),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back 👋', style: tt.headlineMedium),
                    const SizedBox(height: 4),
                    Text('Sign in to continue learning', style: tt.bodySmall),
                    const SizedBox(height: 28),

                    // Email
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextField(
                      controller: passwordController,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Login button
                    _GradientButton(
                      label: 'Login',
                      onTap: () => controller.login(emailController.text, passwordController.text),
                      colors: [AppColors.lightPrimary, AppColors.lightSecondary],
                    ),
                    const SizedBox(height: 14),

                    // Google
                    OutlinedButton.icon(
                      onPressed: () => controller.googleLogin(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        side: BorderSide(color: cs.primary.withOpacity(0.3)),
                      ),
                      icon: const Icon(Icons.g_mobiledata_rounded, size: 26),
                      label: Text(
                        'Sign in with Google',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Register link
                    Center(
                      child: TextButton(
                        onPressed: () => Get.toNamed('/register'),
                        child: RichText(
                          text: TextSpan(
                            style: tt.bodySmall,
                            children: [
                              const TextSpan(text: "Don't have an account? "),
                              TextSpan(
                                text: 'Create one',
                                style: TextStyle(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideY(begin: 0.2),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared gradient button ───────────────────────────────────────────────────

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.onTap,
    required this.colors,
  });

  final String label;
  final VoidCallback onTap;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
