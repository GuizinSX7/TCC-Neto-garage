import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tcc_neto_garage/shared/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class editarEndereco extends StatefulWidget {
  const editarEndereco({super.key});

  @override
  State<editarEndereco> createState() => _editarEnderecoState();
}

class _editarEnderecoState extends State<editarEndereco> {
  final _formKey = GlobalKey<FormState>();

  // 1. Declarar os TextEditingControllers
  final TextEditingController cepController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController logradouroController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // 2. Limpar os controllers
  @override
  void dispose() {
    cepController.dispose();
    bairroController.dispose();
    logradouroController.dispose();
    numeroController.dispose();
    cidadeController.dispose();
    super.dispose();
  }

  Future<void> buscarCep(String cep) async {
    if (cep.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CEP inválido! Digite um CEP com 8 dígitos.')),
      );
      return;
    }

    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('erro')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('CEP não encontrado')),
          );
          return;
        }

        setState(() {
          bairroController.text = data['bairro'] ?? '';
          logradouroController.text = data['logradouro'] ?? '';
          cidadeController.text = data['localidade'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar CEP')),
      );
    }
  }

  Future<String?> _buscarCPFUsuario() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

    if (userId.isEmpty) return null;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("usuarios")
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first;
      var cpf = doc["CPF"];

      if (cpf is int) {
        return cpf.toString();
      } else if (cpf is String) {
        return cpf;
      }
    }
    return null;
  }

  Widget buildTextField({
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onFieldSubmitted,
    String? Function(String?)? validator,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: MyColors.branco1,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          fillColor: const Color.fromARGB(30, 233, 236, 239),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white, width: 3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white, width: 1),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: MyColors.branco4),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        ),
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
      ),
    );
  }

  void atualizarEndereco() async {
    String? cpf = await _buscarCPFUsuario();

    if (cpf == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível encontrar o CPF do usuário.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('usuarios').doc(cpf).update({
        'CEP': cepController.text,
        'bairro': bairroController.text,
        'logradouro': logradouroController.text,
        'numero': int.tryParse(numeroController.text) ?? 0,
        'cidade': cidadeController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Endereço atualizado com sucesso!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar endereço: $e')),
      );
    }
  }

  void voltar() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double contentWidth = screenWidth > 600 ? 500 : screenWidth * 0.9;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: MyColors.gradienteLoginECadastro,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/Logo.png',
                    height: 100,
                    width: 200,
                  ),
                  const SizedBox(height: 39),
                  buildTextField(
                    hintText: "CEP",
                    controller: cepController,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: buscarCep,
                    validator: (cep) {
                      if (cep == null || cep.isEmpty) return 'CEP obrigatório';
                      if (cep.length != 8) return 'CEP inválido';
                      if (RegExp(r'[a-zA-Z]').hasMatch(cep))
                        return 'O CEP deve conter apenas números';
                      return null;
                    },
                    width: contentWidth,
                  ),
                  const SizedBox(height: 30),
                  buildTextField(
                    hintText: "Bairro",
                    controller: bairroController,
                    validator: (bairro) {
                      if (bairro == null || bairro.isEmpty)
                        return 'Bairro obrigatório';
                      if (bairro.length < 3) return 'Bairro muito curto';
                      return null;
                    },
                    width: contentWidth,
                  ),
                  const SizedBox(height: 30),
                  buildTextField(
                    hintText: "Logradouro",
                    controller: logradouroController,
                    validator: (logradouro) {
                      if (logradouro == null || logradouro.isEmpty)
                        return 'Logradouro obrigatório';
                      if (logradouro.length < 3)
                        return 'Logradouro muito curto';
                      return null;
                    },
                    width: contentWidth,
                  ),
                  const SizedBox(height: 30),
                  buildTextField(
                    hintText: "Número",
                    controller: numeroController,
                    keyboardType: TextInputType.number,
                    validator: (numero) {
                      if (numero == null || numero.isEmpty)
                        return 'Número obrigatório';
                      if (RegExp(r'[a-zA-Z]').hasMatch(numero))
                        return 'O campo deve conter apenas números';
                      return null;
                    },
                    width: contentWidth,
                  ),
                  const SizedBox(height: 30),
                  buildTextField(
                    hintText: "Cidade",
                    controller: cidadeController,
                    validator: (cidade) {
                      if (cidade == null || cidade.isEmpty)
                        return 'Cidade obrigatória';
                      if (cidade.length < 3) return 'Cidade muito curta';
                      return null;
                    },
                    width: contentWidth,
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        atualizarEndereco();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(contentWidth, 49),
                      backgroundColor: MyColors.azul2,
                      foregroundColor: MyColors.branco1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Atualizar",
                      style: TextStyle(
                        color: MyColors.branco1,
                        fontSize: 14,
                        fontFamily: MyFonts.fontTerc,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: voltar,
                    child: Text(
                      "Voltar ao perfil? Aqui",
                      style: TextStyle(
                        color: MyColors.branco1,
                        fontSize: 14,
                        fontFamily: MyFonts.fontTerc,
                      ),
                    ),
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
