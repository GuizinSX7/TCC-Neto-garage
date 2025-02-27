import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/components/Menubar.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeUsuarioState();
}

class _HomeUsuarioState extends State<Home> {

  var continuar = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: MyColors.gradienteGeral, 
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Menubar(),
            ],
          ),
        ),
      ),
    );
  }
}