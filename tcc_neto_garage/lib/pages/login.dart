import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/components/ResetPassword.dart';
import 'package:tcc_neto_garage/components/loginComp.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  var componente = 0;

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
              if (componente == 0)
                LoginComp(
                  onRedefinirSenha: () {
                    setState(() {
                      componente = 1;
                    });
                  }
                )
              else
                Resetpassword(
                  onBackToLogin: () {
                    setState(() {
                      componente = 0;
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
