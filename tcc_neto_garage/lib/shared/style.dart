import 'package:flutter/material.dart';

class MyColors{
  static const Color branco1 = Colors.white;
  static const Color branco2 = Color(0xFFF8F9FA);
  static const Color branco3 = Color(0xFFE9ECEF);
  static const Color branco4 = Color(0xFFDEE2E6);
  static const Color cinza1 = Color(0xFFCED4DA);
  static const Color cinza2 = Color(0xFFADB5BD);
  static const Color cinza3 = Color(0xFF6C757D);
  static const Color cinzaEscuro1 = Color(0xFF495057);
  static const Color cinzaEscuro2 = Color(0xFF343A40);
  static const Color cinzaEscuro3 = Color(0xFF212529);
  static const Color preto1 = Colors.black;
  static const Color preto2 = Color(0xFF000814);
  static const Color azul1 = Color(0xFF0396FE);
  static const Color azul2 = Color(0xFF313995);
  static const Color azul3 = Color(0xFF1D225D);
  static const Color azul4 = Color(0xFF0E1538);
  static const Color vermelho1 = Colors.red;
  static const Color verde = Color(0xFF269B28);
  static const LinearGradient gradienteLoginECadastro = LinearGradient(
    colors: [MyColors.preto2, MyColors.azul3],
    stops: [0.73, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient gradienteGeral = LinearGradient(
    colors: [MyColors.preto2, MyColors.azul3],
    stops: [0.50, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
} 

class MyFonts{
  static const String fontPrimary =  "ABeeZee";
  static const String fontSecundary = "Montserrat";
  static const String fontTerc = "OpenSans";
}