import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: 'assets/img/GifNetoGarage.gif',
        splashIconSize: 500.0, // Ajustado para um tamanho mais razoável
        nextScreen: const Home(),
        backgroundColor: Colors.black,
        duration: 3100,
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/LogoN.png',
              width: 80.0,
            ),
            const SizedBox(height: 20), // Adicionando um espaçamento
            const Text(
              'Carregando...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0, // Reduzi para melhor adaptação
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
