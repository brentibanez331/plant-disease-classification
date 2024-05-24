import 'package:flutter/material.dart';
import 'package:plant_disease_classifier/screens/authenticate/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 1.0, end: 0.8)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    _loadSplash();
  }

  _loadSplash() async {
    // Simulate a delay of 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Navigate to the main screen or any other screen
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
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
          // Background Image
          // Image.asset(
          //   'images/bg-splash.png', // Replace with your image path
          //   fit: BoxFit.cover,
          // ),
          // Animated Logo in the Center
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: child,
                );
              },
              child: Image.asset(
                'images/greenery-logo.png', // Replace with your logo image path
                width: 150, // Adjust the width as needed
                height: 150, // Adjust the height as needed
              ),
            ),
          ),
          const Text("This is login", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
