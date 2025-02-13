import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();

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
              const SizedBox(height: 180,),
              Image.asset('assets/images/Logo.png'), 
              const SizedBox(height: 63,),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 300,
                      height: 45,
                      child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(30, 233, 236, 239),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: MyColors.branco1, width: 3),
                          ),
                          hintText: "Email ou CPF",
                          hintStyle: TextStyle(color: MyColors.branco4,),
                          contentPadding: const EdgeInsets.symmetric(vertical:10, horizontal: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48,),
                    SizedBox(
                      width: 300,
                      height: 45,
                      child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(30, 233, 236, 239),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: MyColors.branco1, width: 3),
                          ),
                          hintText: "Senha",
                          hintStyle: TextStyle(color: MyColors.branco4,),
                          contentPadding: const EdgeInsets.symmetric(vertical:10, horizontal: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
