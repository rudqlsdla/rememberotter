import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rememberotter/app/app_routes.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/feature/onboarding/pages/notification_consent_page.dart';
import 'package:rememberotter/shared/log/logger.dart';
import 'package:rememberotter/shared/services/remote_config_service.dart';

import '../../../gen/assets.gen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _floatController;
  late final AnimationController _exitController;

  // Main sequence animations
  late final Animation<double> _bgFade;
  late final Animation<double> _otterScale;
  late final Animation<double> _otterFade;
  late final Animation<Offset> _otterSlide;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<Offset> _subtitleSlide;
  late final Animation<double> _shimmerFade;

  // Exit animation
  late final Animation<double> _exitFade;
  late final Animation<double> _exitScale;

  // Floating otter bob
  late final Animation<double> _floatOffset;

  bool _navigationStarted = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _mainController.forward();
    _startApp();
  }

  void _setupAnimations() {
    // ── Main entrance sequence (1.4s) ──
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _bgFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0, 0.3, curve: Curves.easeOut),
      ),
    );

    _otterScale = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _otterFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.45, curve: Curves.easeOut),
      ),
    );

    _otterSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.55, 0.85, curve: Curves.easeOut),
      ),
    );

    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.55, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _shimmerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    // ── Floating bob (continuous) ──
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _floatOffset = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOutSine,
      ),
    );

    // ── Exit animation ──
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _exitFade = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _exitController,
        curve: Curves.easeInCubic,
      ),
    );

    _exitScale = Tween<double>(begin: 1, end: 1.08).animate(
      CurvedAnimation(
        parent: _exitController,
        curve: Curves.easeInCubic,
      ),
    );
  }

  Future<void> _startApp() async {
    logger.i('스플래시 화면 시작');

    await Future.wait([
      Future.delayed(const Duration(milliseconds: 2200)),
      RemoteConfigService().checkAndStoreUpdateStatus(),
    ]);

    if (!mounted || _navigationStarted) return;
    _navigationStarted = true;

    final hasShownConsent = await NotificationConsentPage.hasShownConsent();

    // Play exit animation then navigate
    await _exitController.forward();
    if (!mounted) return;

    if (hasShownConsent) {
      Get.offAllNamed(AppRoutes.main);
    } else {
      Get.offAllNamed(AppRoutes.notificationConsent);
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAF8),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _mainController,
          _floatController,
          _exitController,
        ]),
        builder: (context, _) {
          return FadeTransition(
            opacity: _exitFade,
            child: ScaleTransition(
              scale: _exitScale,
              child: Stack(
                children: [
                  // ── Gradient background ──
                  Opacity(
                    opacity: _bgFade.value,
                    child: const _GradientBackground(),
                  ),

                  // ── Floating decorations ──
                  Opacity(
                    opacity: _shimmerFade.value,
                    child: const _FloatingDecorations(),
                  ),

                  // ── Main content ──
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Otter image
                        SlideTransition(
                          position: _otterSlide,
                          child: FadeTransition(
                            opacity: _otterFade,
                            child: ScaleTransition(
                              scale: _otterScale,
                              child: Transform.translate(
                                offset: Offset(0, _floatOffset.value),
                                child: _buildOtterImage(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 28.h),

                        // Title
                        SlideTransition(
                          position: _titleSlide,
                          child: FadeTransition(
                            opacity: _titleFade,
                            child: _buildTitle(),
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // Subtitle
                        SlideTransition(
                          position: _subtitleSlide,
                          child: FadeTransition(
                            opacity: _subtitleFade,
                            child: _buildSubtitle(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOtterImage() {
    return Container(
      width: 200.w,
      height: 260.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.op(AppColors.primary, 0.25),
            blurRadius: 40,
            offset: const Offset(0, 16),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Assets.images.splash.splashOtter.image(
        width: 200.w,
        height: 260.w,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Color(0xFF9681D3),
          Color(0xFFB8A3E6),
          Color(0xFFD4C5F0),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      blendMode: BlendMode.srcIn,
      child: Text(
        '기억해달',
        style: TextStyle(
          fontSize: 38.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 2.w,
          height: 1,
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      '해달이 소중한 돌을 간직하듯\n소중한 생일을 간직해드려요',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w300,
        color: AppColors.op(AppColors.primaryDark, 0.7),
        height: 1.6,
        letterSpacing: 0.3.w,
      ),
    );
  }
}

// ─── Gradient Background ─────────────────────────────────────────────────────

class _GradientBackground extends StatelessWidget {
  const _GradientBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.2, -1),
          end: Alignment(0.2, 1),
          colors: [
            Color(0xFFF5F0FF), // soft lavender top
            Color(0xFFF0EAF8), // warm lavender mid
            Color(0xFFFCF0F6), // hint of pink bottom
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: CustomPaint(
        size: Size.infinite,
        painter: _SoftOrbsPainter(),
      ),
    );
  }
}

class _SoftOrbsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Top-right lavender orb
    final orbPaint1 = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.op(AppColors.primaryLight, 0.3),
          AppColors.op(AppColors.primaryLight, 0),
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.85, size.height * 0.15),
          radius: size.width * 0.45,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.15),
      size.width * 0.45,
      orbPaint1,
    );

    // Bottom-left pink orb
    final orbPaint2 = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.op(AppColors.accent, 0.08),
          AppColors.op(AppColors.accent, 0),
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.15, size.height * 0.8),
          radius: size.width * 0.5,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.8),
      size.width * 0.5,
      orbPaint2,
    );

    // Center subtle warm orb
    final orbPaint3 = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.op(AppColors.primary, 0.06),
          AppColors.op(AppColors.primary, 0),
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.5, size.height * 0.45),
          radius: size.width * 0.6,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.45),
      size.width * 0.6,
      orbPaint3,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Floating Decorations ────────────────────────────────────────────────────

class _FloatingDecorations extends StatefulWidget {
  const _FloatingDecorations();

  @override
  State<_FloatingDecorations> createState() => _FloatingDecorationsState();
}

class _FloatingDecorationsState extends State<_FloatingDecorations>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    final rng = Random(42);
    _particles = List.generate(12, (i) {
      return _Particle(
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        size: 3 + rng.nextDouble() * 5,
        speed: 0.3 + rng.nextDouble() * 0.7,
        phase: rng.nextDouble() * 2 * pi,
        type: i % 3, // 0: dot, 1: star, 2: heart
        color: [
          AppColors.op(AppColors.primaryLight, 0.4),
          AppColors.op(AppColors.accent, 0.2),
          AppColors.op(AppColors.primary, 0.25),
        ][i % 3],
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlesPainter(
            particles: _particles,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _Particle {
  final double x, y, size, speed, phase;
  final int type;
  final Color color;

  const _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.phase,
    required this.type,
    required this.color,
  });
}

class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticlesPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (progress * p.speed + p.phase) % 1.0;
      final floatY = sin(t * 2 * pi) * 12;
      final floatX = cos(t * 2 * pi * 0.7) * 6;
      final opacity = 0.3 + 0.7 * ((sin(t * 2 * pi) + 1) / 2);

      final cx = p.x * size.width + floatX;
      final cy = p.y * size.height + floatY;

      final paint = Paint()..color = p.color.withValues(alpha: opacity * p.color.a);

      switch (p.type) {
        case 0: // soft dot
          canvas.drawCircle(Offset(cx, cy), p.size, paint);
          break;
        case 1: // 4-pointed star
          _drawStar(canvas, cx, cy, p.size * 1.2, paint);
          break;
        case 2: // small diamond
          _drawDiamond(canvas, cx, cy, p.size, paint);
          break;
      }
    }
  }

  void _drawStar(Canvas canvas, double cx, double cy, double r, Paint paint) {
    final path = Path();
    for (int i = 0; i < 4; i++) {
      final angle = (i * pi / 2) - pi / 2;
      final outerX = cx + cos(angle) * r;
      final outerY = cy + sin(angle) * r;
      final innerAngle = angle + pi / 4;
      final innerR = r * 0.35;
      final innerX = cx + cos(innerAngle) * innerR;
      final innerY = cy + sin(innerAngle) * innerR;

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawDiamond(
      Canvas canvas, double cx, double cy, double r, Paint paint) {
    final path = Path()
      ..moveTo(cx, cy - r)
      ..lineTo(cx + r * 0.6, cy)
      ..lineTo(cx, cy + r)
      ..lineTo(cx - r * 0.6, cy)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ParticlesPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
