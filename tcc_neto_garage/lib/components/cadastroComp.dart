import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class Cadastrocomp extends StatefulWidget {
  final VoidCallback continuarCadastro;

  const Cadastrocomp({super.key, required this.continuarCadastro});

  @override
  State<Cadastrocomp> createState() => _CadastrocompState();
}

class _CadastrocompState extends State<Cadastrocomp> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 300,
              height: 45,
              child: TextFormField(
                cursorColor: MyColors.branco1,
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
                  hintText: "Nome Completo",
                  hintStyle: TextStyle(
                    color: MyColors.branco4,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              height: 45,
              child: TextFormField(
                cursorColor: MyColors.branco1,
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
                  hintText: "E-mail",
                  hintStyle: TextStyle(
                    color: MyColors.branco4,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              height: 45,
              child: TextFormField(
                cursorColor: MyColors.branco1,
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
                  hintText: "Senha",
                  hintStyle: TextStyle(
                    color: MyColors.branco4,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              height: 45,
              child: TextFormField(
                cursorColor: MyColors.branco1,
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
                  hintText: "Confirmar Senha",
                  hintStyle: TextStyle(
                    color: MyColors.branco4,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              height: 45,
              child: TextFormField(
                cursorColor: MyColors.branco1,
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
                  hintText: "CPF",
                  hintStyle: TextStyle(
                    color: MyColors.branco4,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  widget.continuarCadastro();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(250, 50),
                  backgroundColor: MyColors.azul3,
                ),
                child: Text(
                  "Continuar",
                  style: TextStyle(
                      color: MyColors.branco1,
                      fontSize: 14,
                      fontFamily: MyFonts.fontTerc,
                      fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }
}
