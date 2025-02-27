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

  final TextEditingController _cepControllerCadastroCont =
      TextEditingController();
  final TextEditingController _bairroControllerCadastroCont =
      TextEditingController();
  final TextEditingController _logradouroControllerCadastroCont =
      TextEditingController();
  final TextEditingController _cidadeControllerCadastroCont =
      TextEditingController();
  final TextEditingController _numeroControllerCadastroCont =
      TextEditingController();
  final TextEditingController _controllerEmailCadastro =
      TextEditingController();
  final TextEditingController _controllerPassworCadastro =
      TextEditingController();
  final TextEditingController _controllerCPFCadastro = TextEditingController();
  final TextEditingController _controllerNomeCompletoCadastro =
      TextEditingController();

  Future<String?> registerUser(
      String email,
      String logradouro,
      String nome,
      int numero,
      int cpf,
      int cep,
      String cidade,
      String bairro,
      String tipoUsuario) async {
    try {
      // Criando usuário no Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _controllerEmailCadastro.text,
        password: _controllerPassworCadastro.text,
      );

      // Obtendo o UID do usuário

      // Criando o usuário no Firestore
      await FirebaseFirestore.instance.collection('usuarios').doc(_controllerCPFCadastro.text).set({
        'nome completo': nome,
        'email': email,
        'logradouro': logradouro,
        'numero': numero,
        'CPF': cpf,
        'CEP': cep,
        'cidade': cidade,
        'bairro': bairro,
        'tipo_usuario': tipoUsuario
      });

      _showSnackBar("Login realizado com sucesso", MyColors.azul1);
      Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, "/");
      });
    } catch (e) {
      print("Erro inesperado: $e");
      _showSnackBar('Erro inesperado: $e', MyColors.vermelho1); // Retorna erro caso ocorra
    }
  }

  void _showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: MyColors.gradienteLoginECadastro,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 80,
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
                      }
                  )
                else
                  Continuar(
                    cepController: _cepControllerCadastroCont,
                    cidadeController: _cidadeControllerCadastroCont,
                    bairroController: _bairroControllerCadastroCont,
                    numeroController: _numeroControllerCadastroCont,
                    logradouroController: _logradouroControllerCadastroCont,
                    cadastrar: () {
                      registerUser(
                        _controllerEmailCadastro.text, 
                        _logradouroControllerCadastroCont.text, 
                        _controllerNomeCompletoCadastro.text, 
                        int.tryParse(_numeroControllerCadastroCont.text) ?? 0,
                        int.tryParse(_controllerCPFCadastro.text) ?? 0, 
                        int.tryParse(_cepControllerCadastroCont.text) ?? 0, 
                        _cidadeControllerCadastroCont.text,
                        _bairroControllerCadastroCont.text, 
                        "normal"
                      );
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
      ),
    );
  }
}
