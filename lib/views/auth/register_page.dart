import '../../core/utils/import_export.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController controller = Get.find();
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
              height: 260,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.person_add_rounded, color: Colors.white, size: 38),
                    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.7, 0.7)),
                    const SizedBox(height: 14),
                    Text(
                      'Create Account',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideY(begin: 0.3),
                    const SizedBox(height: 6),
                    Text(
                      'Start your C learning journey',
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.white.withOpacity(0.85)),
                    ).animate().fadeIn(delay: 300.ms),
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
                      color: Colors.green.withOpacity(dark ? 0.0 : 0.1),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Join C Master 🚀', style: tt.headlineMedium),
                    const SizedBox(height: 4),
                    Text('Fill in your details to get started', style: tt.bodySmall),
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

                    // Register button
                    _GradientButton(
                      label: 'Create Account',
                      onTap: () => controller.register(emailController.text, passwordController.text),
                      colors: const [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                    const SizedBox(height: 16),

                    // Already have account
                    Center(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: RichText(
                          text: TextSpan(
                            style: tt.bodySmall,
                            children: [
                              const TextSpan(text: 'Already have an account? '),
                              TextSpan(
                                text: 'Sign in',
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