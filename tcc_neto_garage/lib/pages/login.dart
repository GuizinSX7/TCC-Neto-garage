import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/components/sendPassword.dart';
import 'package:tcc_neto_garage/components/loginComp.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _componente = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: MyColors.gradienteLoginECadastro,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 120),
                  Image.asset(
                    'assets/images/Logo.png',
                    height: 100,
                    width: 200,
                  ),
                  if (_componente == 0)
                    LoginComp(
                      onRedefinirSenha: () {
                        setState(() {
                          _componente = 1;
                        });
                      },
                    )
                  else
                    Resetpassword(
                      onBackToLogin: () {
                        setState(() {
                          _componente = 0;
                        });
                      },
                      emailEnviado: () {
                        setState(() {
                          _componente = 0;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
