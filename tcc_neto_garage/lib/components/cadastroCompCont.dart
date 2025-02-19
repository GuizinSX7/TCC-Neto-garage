import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tcc_neto_garage/shared/style.dart';

class Continuar extends StatefulWidget {
  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<Continuar> {
  final TextEditingController cepController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController logradouroController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();

  Future<void> buscarCep(String cep) async {
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

  Widget buildTextField({
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool autoFocus = false,
    Function(String)? onSubmitted,
  }) {
    return SizedBox(
      width: 300,
      height: 45,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        autofocus: autoFocus,
        maxLines: null, // Permite múltiplas linhas se necessário
        expands: true,  // Faz com que o input cresça sem cortar o texto
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center, // Centraliza verticalmente
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: MyColors.branco3.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyColors.branco1),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onFieldSubmitted: onSubmitted,
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
            SizedBox(height: 40),
            Text(
              "Falta pouco!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: MyFonts.fontSecundary,
                fontSize: 26,
                color: MyColors.branco1,
              ),
            ),
            SizedBox(height: 39),

            // Campos de entrada
            buildTextField(
              hint: "CEP",
              controller: cepController,
              keyboardType: TextInputType.number,
              autoFocus: true,
              onSubmitted: (value) => buscarCep(value),
            ),
            SizedBox(height: 30),

            buildTextField(hint: "Bairro", controller: bairroController),
            SizedBox(height: 30),

            buildTextField(hint: "Logradouro", controller: logradouroController),
            SizedBox(height: 30),

            buildTextField(hint: "Número", controller: numeroController, keyboardType: TextInputType.number),
            SizedBox(height: 30),

            buildTextField(hint: "Cidade", controller: cidadeController),
            SizedBox(height: 50),

            // Botão Cadastrar
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Cadastrar"),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(300, 49),
                  backgroundColor: MyColors.azul2,
                  foregroundColor: MyColors.branco1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),

            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/cadastro');
              },
              child: Text(
                "Aqui",
                style: TextStyle(
                  fontFamily: MyFonts.fontTerc,
                  fontSize: 14,
                  color: MyColors.azul1,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            Text(
              "Voltar ao Cadastro?",
              style: TextStyle(fontFamily: MyFonts.fontTerc, fontSize: 14, color: MyColors.branco1),
            ),
          ],
        ),
      ),
    );
  }
}
