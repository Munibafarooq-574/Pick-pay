import 'package:flutter/material.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // longer for pause
    );

    // Slide animation: Left → Center → Right
    _slideAnimation = TweenSequence<Offset>([
      // Step 1: Left → Center
      TweenSequenceItem(
        tween: Tween(begin: const Offset(-1.5, 0), end: const Offset(0, 0))
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      // Step 2: Pause in Center (no movement)
      TweenSequenceItem(
        tween: ConstantTween(const Offset(0, 0)),
        weight: 20,
      ),
      // Step 3: Center → Right
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, 0), end: const Offset(1.5, 0))
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 40,
      ),
    ]).animate(_controller);

    // Scale animation: Small → Big → Hold → Small
    _scaleAnimation = TweenSequence<double>([
      // Step 1: Grow while coming to center
      TweenSequenceItem(
        tween: Tween(begin: 0.2, end: 1.5)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 40,
      ),
      // Step 2: Hold size in center
      TweenSequenceItem(
        tween: ConstantTween(1.5),
        weight: 20,
      ),
      // Step 3: Shrink while moving out
      TweenSequenceItem(
        tween: Tween(begin: 1.5, end: 0.8)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 40,
      ),
    ]).animate(_controller);

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacementNamed(context, "/getStarted");
      }
    });
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Image.asset(
            "assets/shopping_background.png",
            fit: BoxFit.cover,
          ),

          // Logo animation
          Center(
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  "assets/logo.png",
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
