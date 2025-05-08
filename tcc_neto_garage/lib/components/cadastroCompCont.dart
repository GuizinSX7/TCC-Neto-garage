import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tcc_neto_garage/shared/style.dart';

class Continuar extends StatefulWidget {
  final VoidCallback voltar;
  final VoidCallback cadastrar;

  final TextEditingController cepController;
  final TextEditingController bairroController;
  final TextEditingController logradouroController;
  final TextEditingController cidadeController;
  final TextEditingController numeroController;

  const Continuar(
      {super.key,
      required this.voltar,
      required this.cadastrar,
      required this.cepController,
      required this.bairroController,
      required this.cidadeController,
      required this.logradouroController,
      required this.numeroController});

  @override
  _ContinuarState createState() => _ContinuarState();
}

class _ContinuarState extends State<Continuar> {
  bool isLoading = false;

  void onChanged(String value) {
    final cleanCep =
        value.replaceAll(RegExp(r'\D'), ''); // Remove qualquer não dígito
    if (cleanCep.length == 8) {
      buscarCep(cleanCep);
    }
  }

  Future<void> buscarCep(String cep) async {
    setState(() => isLoading = true);
    try {
      final response =
          await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
      final data = json.decode(response.body);
      if (data.containsKey('erro')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CEP não encontrado')),
        );
      } else {
        setState(() {
          widget.bairroController.text = data['bairro'] ?? '';
          widget.logradouroController.text = data['logradouro'] ?? '';
          widget.cidadeController.text = data['localidade'] ?? '';
        });
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar CEP')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  final _formKey = GlobalKey<FormState>();

  Widget buildTextField({
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onFieldSubmitted,
    void Function(String)? onChanged, // NOVO
    String? Function(String?)? validator,
  }) {
    return SizedBox(
      width: 300,
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
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
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
                onChanged: (value) {
                  final cleanCep = value.replaceAll(
                      RegExp(r'\D'), ''); // Remove qualquer não dígito
                  if (cleanCep.length == 8) {
                    buscarCep(cleanCep);
                  }
                },
                onFieldSubmitted: (value) => buscarCep(
                    value), // Essa linha pode ser removida se você usar onChanged para a busca
                validator: (String? cep) {
                  if (cep == null || cep.trim().isEmpty) {
                    return 'CEP obrigatório';
                  }
                  if (!RegExp(r'^\d{8}$').hasMatch(cep.trim())) {
                    return 'CEP inválido (deve conter 8 números)';
                  }
                  return null;
                }),
            SizedBox(height: 30),
            buildTextField(
                hintText: "Bairro",
                controller: widget.bairroController,
                validator: (String? bairro) {
                  if (bairro == null || bairro.trim().isEmpty) {
                    return 'Bairro obrigatório';
                  }
                  if (bairro.trim().length < 3) {
                    return 'Bairro muito curto';
                  }
                  if (!RegExp(r'^[A-Za-zÀ-ÿ\s]+$').hasMatch(bairro.trim())) {
                    return 'O bairro deve conter apenas letras';
                  }
                  return null;
                }),
            SizedBox(height: 30),
            buildTextField(
                hintText: "Logradouro",
                controller: widget.logradouroController,
                validator: (String? logradouro) {
                  if (logradouro == null || logradouro.trim().isEmpty) {
                    return 'Logradouro obrigatório';
                  }
                  if (logradouro.trim().length < 3) {
                    return 'Logradouro muito curto';
                  }
                  if (!RegExp(r'^[A-Za-zÀ-ÿ0-9\s\-\/]+$')
                      .hasMatch(logradouro.trim())) {
                    return 'O logradouro não pode conter caracteres especiais';
                  }

                  return null;
                }),
            SizedBox(height: 30),
            buildTextField(
                hintText: "Número",
                controller: widget.numeroController,
                keyboardType: TextInputType.number,
                validator: (String? numero) {
                  if (numero == null || numero.trim().isEmpty) {
                    return 'Número obrigatório';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(numero.trim())) {
                    return 'O campo deve conter apenas números';
                  }
                  return null;
                }),
            SizedBox(height: 30),
            buildTextField(
                hintText: "Cidade",
                controller: widget.cidadeController,
                validator: (String? cidade) {
                  if (cidade == null || cidade.trim().isEmpty) {
                    return 'Cidade obrigatória';
                  }
                  if (cidade.trim().length < 3) {
                    return 'Cidade muito curta';
                  }
                  if (!RegExp(r'^[A-Za-zÀ-ÿ\s]+$').hasMatch(cidade.trim())) {
                    return 'A cidade deve conter apenas letras';
                  }
                  return null;
                }),
            SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.cadastrar();
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(300, 49),
                  backgroundColor: MyColors.azul2,
                  foregroundColor: MyColors.branco1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: MyColors.branco1)
                    : Text(
                        "Cadastrar",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: MyFonts.fontTerc,
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
            const SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }
}
