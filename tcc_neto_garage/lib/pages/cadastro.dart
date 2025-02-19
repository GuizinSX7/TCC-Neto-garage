import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/components/cadastroComp.dart';
import 'package:tcc_neto_garage/components/cadastroCompCont.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  var continuar = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: MyColors.gradienteLoginECadastro, 
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100,),
              Image.asset(
                'assets/images/Logo.png',
                height: 100,
                width: 200
              ),
              if (continuar == 0)
                Cadastrocomp(
                  continuarCadastro: () {
                    setState(() {
                      continuar = 1;
                    });
                  }
                )
              else
                Continuar(
                  voltar: () {
                    setState(() {
                      continuar = 0;
                    });
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}