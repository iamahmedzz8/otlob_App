import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const coral = Color(0xFFFF654F);
  static const navy = Color(0xFF191B24);
  static const cream = Color(0xFFFFF8F4);

  late final AnimationController controller;
  late final Animation<double> fade;
  late final Animation<double> scale;
  late final Animation<Offset> slide;
  late final Animation<double> progress;
  Timer? navigationTimer;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    fade = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );

    scale = Tween<double>(
      begin: 0.88,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ),
    );

    slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ),
    );

    progress = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );

    controller.forward();

    navigationTimer = Timer(
      const Duration(seconds: 10),
          () {
        if (!mounted) return;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    navigationTimer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F4),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;

          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                top: -height * 0.01,
                left: -65,
                child: _circle(140, const Color(0xFFFFE1D7)),
              ),
              Positioned(
                top: height * 0.13,
                right: -75,
                child: _circle(155, const Color(0xFFFFE9E2)),
              ),
              Positioned(
                top: height * 0.37,
                left: -60,
                child: _circle(130, const Color(0xFFFFD9CE)),
              ),
              Positioned(
                bottom: -height * 0.03,
                left: -35,
                child: _circle(210, coral),
              ),
              Positioned(
                bottom: -height * 0.04,
                right: -65,
                child: Transform.rotate(
                  angle: -0.45,
                  child: Container(
                    width: 170,
                    height: 260,
                    decoration: BoxDecoration(
                      color: coral,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: height * 0.055),
                  FadeTransition(
                    opacity: fade,
                    child: ScaleTransition(
                      scale: scale,
                      child: Column(
                        children: [
                          const Icon(
                            Icons.room_service_rounded,
                            color: coral,
                            size: 100,
                          ),
                          const SizedBox(height: 2),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 76,
                                height: 1,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -2.5,
                              ),
                              children: [
                                TextSpan(
                                  text: 'o',
                                  style: TextStyle(color: coral),
                                ),
                                TextSpan(
                                  text: 'tlob',
                                  style: TextStyle(color: navy),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Your Cafe & Restaurant',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: navy,
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'A l l   i n   O n e   P l a c e',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF85818A),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.025),
                  Expanded(
                    child: SlideTransition(
                      position: slide,
                      child: FadeTransition(
                        opacity: fade,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: Image.asset(
                            'assets/images/Splash.png',
                            fit: BoxFit.contain,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 45,
                                  color: coral,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedBuilder(
                    animation: progress,
                    builder: (context, child) {
                      return SizedBox(
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: progress.value,
                            minHeight: 7,
                            backgroundColor: const Color(0xFFFFDED5),
                            valueColor:
                            const AlwaysStoppedAnimation<Color>(coral),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Delicious Food\nHappier Moments',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: navy,
                      fontSize: 19,
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: height * 0.085),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
