import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/components/cadastroComp.dart';
import 'package:tcc_neto_garage/shared/style.dart';
import 'package:tcc_neto_garage/components/cadastroCompCont.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: MyColors.gradienteLoginECadastro,
        ),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 110,),
              Image.asset('assets/images/Logo.png'),
              Continuar(),
            ],
          ),
        ),
      ),
    );
  
  }
}