import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: MyColors.gradienteLoginECadastro,
          ),
        ),
    );
  }
}