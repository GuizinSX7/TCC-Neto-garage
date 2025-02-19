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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centraliza os inputs
          children: [
            // Campo CEP
            const SizedBox(
              height: 40,
            ),
            Text(
              "Falta pouco!",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: MyFonts.fontSecundary,
                  fontSize: 26,
                  color: MyColors.branco1),
            ),
            const SizedBox(
              height: 39,
            ),
            SizedBox(
              width: 300,
              height: 45,
              child: TextFormField(
                controller: cepController,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  // labelText: 'CEP',
                  labelStyle: TextStyle(color: MyColors.branco4),
                  hintText: "CEP",
                  filled: true,
                  fillColor: MyColors.branco3.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: MyColors.branco1),
                  ),
                ),
                onFieldSubmitted: (value) => buscarCep(value),
              ),
            ),
            SizedBox(height: 30),
      
            // Campo Bairro
            SizedBox(
              width: 300,
              height: 45,
              child: TextFormField(
                controller: bairroController,
                decoration: InputDecoration(
                  // labelText: 'Bairro',
                  labelStyle: TextStyle(color: MyColors.branco4),
                  hintText: "Bairro",
                  filled: true,
                  fillColor: MyColors.branco3.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: MyColors.branco1),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
      
            // Campo Logradouro
            SizedBox(
              width: 300,
              height: 45,
              child: TextFormField(
                controller: logradouroController,
                decoration: InputDecoration(
                  // labelText: 'Logradouro',
                  labelStyle: TextStyle(color: MyColors.branco4),
                  hintText: "Logradouro",
                  filled: true,
                  fillColor: MyColors.branco3.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: MyColors.branco1),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
      
            // Campo Número
            SizedBox(
              width: 300,
              height: 45,
              child: TextFormField(
                controller: numeroController,
                decoration: InputDecoration(
                  // labelText: 'Número',
                  labelStyle: TextStyle(color: MyColors.branco4),
                  hintText: "Número",
                  filled: true,
                  fillColor: MyColors.branco3.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: MyColors.branco1),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
      
            // Campo Cidade
            SizedBox(
              width: 300,
              height: 45,
              child: TextFormField(
                controller: cidadeController,
                decoration: InputDecoration(
                  // labelText: 'Cidade',
                  labelStyle: TextStyle(color: MyColors.branco4),
                  hintText: "Cidade",
                  filled: true,
                  fillColor: MyColors.branco3.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: MyColors.branco1),
                  ),
                ),
              ),
            ),
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
                Navigator.pushNamed(
                    context, '/cadastro'); // Substitua pelo nome correto da rota
              },
              child: Text(
                "Aqui",
                style: TextStyle(
                  fontFamily: MyFonts.fontTerc,
                  fontSize: 14,
                  color: MyColors.azul1, // Adiciona cor para parecer um link
                  decoration: TextDecoration
                      .underline, // Sublinhado para parecer mais um link
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
