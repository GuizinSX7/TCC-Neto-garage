import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/pages/Home.dart';
import 'package:tcc_neto_garage/pages/login.dart';
import 'package:tcc_neto_garage/pages/redefinirsenha.dart';
import 'package:tcc_neto_garage/shared/style.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        fontFamily: MyFonts.fontPrimary,
        brightness: Brightness.dark,
        useMaterial3: true,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: MyColors.branco1,
          selectionHandleColor: MyColors.azul1,
        )
      ),
      initialRoute: '/Login',
      routes: {
        '/Login' : (context) => Login(),
        '/Home' : (context) => Home(),
        '/Redefinirsenha' : (context) => Redefinirsenha()
      }, 
    );
  }
}