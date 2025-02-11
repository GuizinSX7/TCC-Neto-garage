import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      ),
      initialRoute: '/',
      routes: {
        // '/' : (context) => 
      }, 
    );
  }
}