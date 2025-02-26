import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/components/cadastroComp.dart';
import 'package:tcc_neto_garage/components/cadastroCompCont.dart';
import 'package:tcc_neto_garage/shared/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  var continuar = 0;

  final TextEditingController _cepControllerCadastroCont = TextEditingController();
  final TextEditingController _bairroControllerCadastroCont = TextEditingController();
  final TextEditingController _logradouroControllerCadastroCont = TextEditingController();
  final TextEditingController _cidadeControllerCadastroCont = TextEditingController();
  final TextEditingController _numeroControllerCadastroCont = TextEditingController();
  final TextEditingController _controllerEmailCadastro = TextEditingController();
  final TextEditingController _controllerPassworCadastro = TextEditingController();
  final TextEditingController _controllerCPFCadastro = TextEditingController();
  final TextEditingController _controllerNomeCompletoCadastro = TextEditingController();


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
              const SizedBox(
                height: 100,
              ),
              Image.asset('assets/images/Logo.png', height: 100, width: 200),
              if (continuar == 0)
                Cadastrocomp(
                    controllerCPF: _controllerCPFCadastro,
                    controllerPassword: _controllerPassworCadastro,
                    controllerEmail: _controllerEmailCadastro,
                    controllerNomeCompleto: _controllerNomeCompletoCadastro,
                    continuarCadastro: () {
                      setState(() {
                        continuar = 1;
                      });
                    })
              else
                Continuar(
                  cepController: _cepControllerCadastroCont,
                  cidadeController: _cidadeControllerCadastroCont,
                  bairroController: _bairroControllerCadastroCont,
                  numeroController: _numeroControllerCadastroCont,
                  logradouroController: _logradouroControllerCadastroCont,
                  Cadastrar: () {
                    print(_cepControllerCadastroCont);
                  },
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
