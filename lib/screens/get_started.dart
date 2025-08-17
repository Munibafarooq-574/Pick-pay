import 'package:flutter/material.dart';
import 'package:pick_pay/screens/signup_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                "assets/logo.png",
                width: 220,
                height: 220,
              ),
              const SizedBox(height: 40),

              // Headline
              const Text(
                "Welcome!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Subheading
              const Text(
                "Everything you love, just a tap away.",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),

              // Custom Animated Button
              GestureDetector(
                onTapDown: (_) => setState(() => _pressed = true),
                onTapUp: (_) => setState(() => _pressed = false),
                onTapCancel: () => setState(() => _pressed = false),
                onTap: () {
                  Navigator.push (context, MaterialPageRoute(builder: (context) => const SignUpScreen())
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  decoration: BoxDecoration(
                    color: const Color(0XFF2e4cb6),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: _pressed
                        ? [
                      BoxShadow(
                        color: const Color(0xFFF7C803),
                        blurRadius: 12,
                        spreadRadius: 2,
                      )
                    ]
                        : [],
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
