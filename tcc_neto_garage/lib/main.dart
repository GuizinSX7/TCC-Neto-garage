import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/pages/Agendamento.dart';
import 'package:tcc_neto_garage/pages/ajuda.dart';
import 'package:tcc_neto_garage/pages/ajustes.dart';
import 'package:tcc_neto_garage/pages/cadastro.dart';
import 'package:tcc_neto_garage/pages/camera.dart';
import 'package:tcc_neto_garage/pages/clientesCadastrados.dart';
import 'package:tcc_neto_garage/pages/enderecoNovo.dart';
import 'package:tcc_neto_garage/pages/funcionarios.dart';
import 'package:tcc_neto_garage/pages/home.dart';
import 'package:tcc_neto_garage/pages/linha_do_tempo.dart';
import 'package:tcc_neto_garage/pages/login.dart';
import 'package:tcc_neto_garage/pages/perfil.dart';
import 'package:tcc_neto_garage/pages/reagendamento.dart';
import 'package:tcc_neto_garage/pages/servicosAgendadosUsua.dart';
import 'package:tcc_neto_garage/shared/style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tcc_neto_garage/pages/cadastroveiculo.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  await initializeDateFormatting('pt_BR', null);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        ),
      ),
      initialRoute: '/',
      routes: {
        '/' : (context) => Login(),
        '/Cadastro': (context) => Cadastro(),
        '/Home': (context) => Home(),
        '/CadastroVeiculo' : (context) => Cadastroveiculo(),
        '/Agendamento' : (context) => TelaDeAgendamento(),
        '/ClientesCadastrados' : (context) => Clientescadastrados(),
        '/Perfil' : (context) => Perfil(),
        '/EditEndereco' : (context) => editarAgendamento(),
        '/ServicosAgendadosUsua' : (context) => AgendamentosUsuario(),
        '/Reagendamento' : (context) => reagendamentoHorario(),
        '/Ajuda' : (context) => Ajuda(),
        '/Linhadotempo' : (context) => Timeline(),
      }, 
    ); 
  }
}
