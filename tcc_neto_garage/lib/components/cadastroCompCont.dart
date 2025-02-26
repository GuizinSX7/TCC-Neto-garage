import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tcc_neto_garage/shared/style.dart';

class Continuar extends StatefulWidget {
  final VoidCallback voltar;
  final VoidCallback Cadastrar;

  final TextEditingController cepController;
  final TextEditingController bairroController;
  final TextEditingController logradouroController;
  final TextEditingController cidadeController;
  final TextEditingController numeroController;

  const Continuar({
    super.key, 
    required this.voltar,
    required this.Cadastrar,
    required this.cepController,
    required this.bairroController,
    required this.cidadeController,
    required this.logradouroController,
    required this.numeroController
  });

  @override
  _ContinuarState createState() => _ContinuarState();
}

class _ContinuarState extends State<Continuar> {

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
          widget.bairroController.text = data['bairro'] ?? '';
          widget.logradouroController.text = data['logradouro'] ?? '';
          widget.cidadeController.text = data['localidade'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar CEP')),
      );
    }
  }

  Widget buildTextField({
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onFieldSubmitted,
  }) {
    return SizedBox(
      width: 300,
      height: 45,
      child: TextFormField(
        controller: controller,
        cursorColor: MyColors.branco1,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          fillColor: const Color.fromARGB(30, 233, 236, 239),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyColors.branco1, width: 3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyColors.branco1, width: 1),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: MyColors.branco4,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        ),
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              "Falta pouco!",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: MyFonts.fontSecundary,
                  fontSize: 22,
                  color: MyColors.branco1),
            ),
            const SizedBox(height: 39),
            buildTextField(
              hintText: "CEP",
              controller: widget.cepController,
              keyboardType: TextInputType.number,
              onFieldSubmitted: (value) => buscarCep(value),
            ),
            SizedBox(height: 30),
            buildTextField(hintText: "Bairro", controller: widget.bairroController),
            SizedBox(height: 30),
            buildTextField(
                hintText: "Logradouro", controller: widget.logradouroController),
            SizedBox(height: 30),
            buildTextField(
                hintText: "Número",
                controller: widget.numeroController,
                keyboardType: TextInputType.number),
            SizedBox(height: 30),
            buildTextField(hintText: "Cidade", controller: widget.cidadeController),
            SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  widget.Cadastrar;
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(300, 49),
                  backgroundColor: MyColors.azul2,
                  foregroundColor: MyColors.branco1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Cadastrar",
                  style: TextStyle(
                    fontSize: 14, // Tamanho maior para melhor legibilidade
                    fontWeight: FontWeight.bold, // Negrito para destaque
                    fontFamily: MyFonts.fontTerc, // Mantendo a identidade visual
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: 245,
              height: 1,
              decoration: BoxDecoration(color: MyColors.branco1),
            ),
            SizedBox(height: 13),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: MyFonts.fontTerc,
                  fontSize: 14,
                  color: MyColors.branco1,
                ),
                children: [
                  TextSpan(text: "Voltar ao Cadastro? "),
                  TextSpan(
                    text: "Aqui",
                    style: TextStyle(
                      color: MyColors.azul1,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = widget.voltar,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
