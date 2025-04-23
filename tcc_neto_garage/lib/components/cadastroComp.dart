import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class Cadastrocomp extends StatefulWidget {
  final VoidCallback continuarCadastro;

  final TextEditingController controllerEmail;
  final TextEditingController controllerPassword;
  final TextEditingController controllerCPF;
  final TextEditingController controllerNomeCompleto;

  const Cadastrocomp(
      {super.key,
      required this.continuarCadastro,
      required this.controllerEmail,
      required this.controllerCPF,
      required this.controllerNomeCompleto,
      required this.controllerPassword});

  @override
  State<Cadastrocomp> createState() => _CadastrocompState();
}

class _CadastrocompState extends State<Cadastrocomp> {
  final _formKey = GlobalKey<FormState>();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                controller: widget.controllerNomeCompleto,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                validator: (String? nome) {
                  if (nome == null || nome.isEmpty) {
                    return "O nome não pode estar vazio";
                  }
                  if (RegExp(r'\d').hasMatch(nome)) {
                    return "O nome não pode conter números";
                  }
                  if (nome.length <= 8) {
                    return "Nome muito curto";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                controller: widget.controllerEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                validator: (String? email) {
                  
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                  obscureText: _obscureTextPassword,
                  controller: widget.controllerPassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureTextPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  validator: (String? password) {
                    if (password == null || password.isEmpty) {
                      return "A senha não pode estar vazia";
                    }
                    if (password.contains(" ")) {
                      return "Senha inválida";
                    }
                    if (password.length < 8) {
                      return "A senha deve conter pelo menos 8 caracteres";
                    }
                    if (!RegExp(r'[a-zA-Z]').hasMatch(password)) {
                      return "A senha deve conter pelo menos uma letra";
                    }
                    if (!RegExp(r'[0-9]').hasMatch(password)) {
                      return "A senha deve conter pelo menos um número";
                    }
                    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
                      return "A senha deve conter pelo menos um caracter especial";
                    }
                    return null;
                  }),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                  controller: _controllerConfirmPassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: _obscureTextConfirmPassword,
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
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureTextConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: _toggleConfirmPasswordVisibility,
                    ),
                  ),
                  validator: (String? passwordConfirm) {
                    if (passwordConfirm == null || passwordConfirm.isEmpty) {
                      return "A senha não pode estar vazia";
                    }
                    if (passwordConfirm.contains(" ")) {
                      return "Senha inválida";
                    }
                    if (passwordConfirm.length < 8) {
                      return "A senha deve conter pelo menos 8 caracteres";
                    }
                    if (!RegExp(r'[a-zA-Z]').hasMatch(passwordConfirm)) {
                      return "A senha deve conter pelo menos uma letra";
                    }
                    if (!RegExp(r'[0-9]').hasMatch(passwordConfirm)) {
                      return "A senha deve conter pelo menos um número";
                    }
                    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                        .hasMatch(passwordConfirm)) {
                      return "A senha deve conter pelo menos um caracter especial";
                    }
                    if (passwordConfirm != widget.controllerPassword.text) {
                      return "As senhas n são compatíveis";
                    }
                    return null;
                  }),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                controller: widget.controllerCPF,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                validator: (String? cpf) {
                  if (cpf == null || cpf.isEmpty) {
                    return "O CPF não pode estar vazio";
                  }
                  String cleanedCpf = cpf.replaceAll(RegExp(r'\D'), '');
                  if (cleanedCpf.length != 11) {
                    return "CPF inválido! O CPF deve ter 11 dígitos";
                  }
                  if (RegExp(r"^(.)\1{10}$").hasMatch(cleanedCpf)) {
                    return "CPF inválido! CPF com números repetidos";
                  }
                  if (RegExp(r'\D').hasMatch(cpf)) {
                    return "O CPF deve conter apenas números";
                  }
                  return null;
                },
              ), 
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.continuarCadastro();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(250, 50),
                  backgroundColor: MyColors.azul2,
                ),
                child: Text(
                  "Continuar",
                  style: TextStyle(
                      color: MyColors.branco1,
                      fontSize: 14,
                      fontFamily: MyFonts.fontTerc,
                      fontWeight: FontWeight.bold),
                )),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 245,
              height: 1,
              decoration: BoxDecoration(color: MyColors.branco1),
            ),
            const SizedBox(
              height: 13,
            ),
            SizedBox(
              width: 233,
              child: Row(
                children: [
                  Text(
                    "Já tem uma conta?",
                    style: TextStyle(
                        fontSize: 14,
                        color: MyColors.branco1,
                        fontFamily: MyFonts.fontTerc),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/");
                    },
                    child: Text(
                      "Clique aqui",
                      style: TextStyle(
                          fontSize: 14,
                          color: MyColors.azul1,
                          fontFamily: MyFonts.fontTerc),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
