import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showFirstAnimation = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showFirstAnimation = false;
      });
    });
    Future.delayed(const Duration(seconds: 6), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: showFirstAnimation
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.5, end: 5.0),
                      duration: Duration(seconds: 3),
                      builder: (context, double scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: child,
                        );
                      },
                      onEnd: () {
                        Future.delayed(Duration(seconds: 2), () {
                          setState(() {
                            showFirstAnimation = false;
                          });
                        });
                      },
                      child: Image.asset(
                        'assets/img/LogoN-1.png',
                        width: 150.0,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // const Text(
                    //   'Carregando...',
                    //   style: TextStyle(
                    //     fontSize: 28.0,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.white,
                    //   ),
                    // ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Pulse(
                      infinite: true,
                      child: Image.asset(
                        'assets/img/Logo.gif',
                        width: 200.0,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // AnimatedTextKit(
                    //   animatedTexts: [
                    //     TyperAnimatedText(
                    //       'N',
                    //       textStyle: const TextStyle(
                    //         fontSize: 28.0,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.white,
                    //       ),
                    //       speed: const Duration(milliseconds: 300),
                    //     ),
                    //     TyperAnimatedText(
                    //       'NE',
                    //       textStyle: const TextStyle(
                    //         fontSize: 28.0,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.white,
                    //       ),
                    //       speed: const Duration(milliseconds: 300),
                    //     ),
                    //     TyperAnimatedText(
                    //       'NET',
                    //       textStyle: const TextStyle(
                    //         fontSize: 28.0,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.white,
                    //       ),
                    //       speed: const Duration(milliseconds: 300),
                    //     ),
                    //     TyperAnimatedText(
                    //       'NETO',
                    //       textStyle: const TextStyle(
                    //         fontSize: 28.0,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.white,
                    //       ),
                    //       speed: const Duration(milliseconds: 300),
                    //     ),
                    //     TyperAnimatedText(
                    //       'NETO G',
                    //       textStyle: const TextStyle(
                    //         fontSize: 28.0,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.white,
                    //       ),
                    //       speed: const Duration(milliseconds: 300),
                    //     ),
                    //     TyperAnimatedText(
                    //       'NETO GA',
                    //       textStyle: const TextStyle(
                    //         fontSize: 28.0,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.white,
                    //       ),
                    //       speed: const Duration(milliseconds: 300),
                    //     ),
                    //     TyperAnimatedText(
                    //       'NETO GAR',
                    //       textStyle: const TextStyle(
                    //         fontSize: 28.0,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.white,
                    //       ),
                    //       speed: const Duration(milliseconds: 300),
                    //     ),
                    //     TyperAnimatedText(
                    //       'NETO GARA',
                    //       textStyle: const TextStyle(
                    //         fontSize: 28.0,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.white,
                    //       ),
                    //       speed: const Duration(milliseconds: 300),
                    //     ),
                    //     TyperAnimatedText(
                    //       'NETO GARAG',
                    //       textStyle: const TextStyle(
                    //         fontSize: 28.0,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.white,
                    //       ),
                    //       speed: const Duration(milliseconds: 300),
                    //     ),
                    //     TyperAnimatedText(
                    //       'NETO GARAGE!',
                    //       textStyle: const TextStyle(
                    //         fontSize: 28.0,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.white,
                    //       ),
                    //       speed: const Duration(milliseconds: 300),
                    //     ),
                    //   ],
                    //   totalRepeatCount: 1,
                    // ),
                  ],
                ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const Center(
        child: Text(
          'Bem-vindo ao Neto Garage!',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
