import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginComp extends StatefulWidget {

  final VoidCallback onRedefinirSenha;

  const LoginComp({super.key, required this.onRedefinirSenha});

  @override
  State<LoginComp> createState() => _LoginCompState();
}

class _LoginCompState extends State<LoginComp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  bool _isSwitched = false;
  bool _obscureText = true;

  final TextEditingController _controllerEmailLogin = TextEditingController();
  final TextEditingController _controllerPasswordLogin = TextEditingController();

  Future<void> _login() async {
    try {
      if (_formKey.currentState!.validate()) {
        await _auth.signInWithEmailAndPassword(
          email: _controllerEmailLogin.text,
          password: _controllerPasswordLogin.text,
        );
        _showSnackBar("Login realizado com sucesso", MyColors.azul1);
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, "/Perfil");
        });
      }
    } on FirebaseAuthException catch (e) { 
      String errorMessage;
      switch (e.code) {
        case 'invalid-credential': 
          errorMessage = 'E-mail ou senha inválidos.';
          break;
        default:
          errorMessage = 'Erro ao tentar fazer login. Código: ${e.code}';
      }


      _showSnackBar(errorMessage, MyColors.vermelho1);
    } catch (e) {
      print("Erro inesperado: $e");
      _showSnackBar('Erro inesperado: $e', MyColors.vermelho1);
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

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 63,),
          Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _controllerEmailLogin,
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
                      hintText: "Email",
                      hintStyle: TextStyle(color: MyColors.branco4,),
                      contentPadding: const EdgeInsets.symmetric(vertical:10, horizontal: 20),
                    ),
                    validator: (String? email) {
                      if (email == null || email.isEmpty) {
                        return "O email não pode estar vazio";
                      }
                      if (email.length < 10) {
                        return "O email deve conter pelo menos 10 caracteres";
                      }
                      if (!email.contains("@")) {
                        return "Email inválido";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 40,),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: _controllerPasswordLogin,
                    obscureText: _obscureText,
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
                      hintStyle: TextStyle(color: MyColors.branco4,),
                      contentPadding: const EdgeInsets.symmetric(vertical:10, horizontal: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
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
                    }
                  ),
                ),
                const SizedBox(height: 27,),
                SizedBox(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: widget.onRedefinirSenha,
                        child: Text( 
                            "Redefinir senha",
                            style: TextStyle(
                              fontFamily: MyFonts.fontTerc,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: MyColors.branco1,
                            ),
                          )
                      )
                    ]
                  ),
                ),
                const SizedBox(height: 18,),
                SizedBox(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [             
                      Text(
                        "Lembre-se de mim",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: MyFonts.fontTerc,
                        ),
                      ),
                      const SizedBox(width: 113.5,),
                      Transform.scale(
                          scale: 0.8,
                          child: Switch (
                            value: _isSwitched,
                            onChanged: (bool value) {
                              setState(() {
                                _isSwitched = value;
                              });
                            },
                              activeColor: MyColors.branco2, // Cor do botão quando ativo
                              activeTrackColor: MyColors.azul1, // Cor da trilha quando ativo        
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 25,),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(250, 50),
                    backgroundColor: MyColors.azul2,
                  ), 
                  child: Text(
                    "Entrar",
                    style: TextStyle(
                      color: MyColors.branco1,
                      fontSize: 14,
                      fontFamily: MyFonts.fontTerc,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ),
                const SizedBox(height: 60,),
                Container(
                  width: 245,
                  height: 1,
                  decoration: BoxDecoration(
                    color: MyColors.branco1
                  ),
                ),
                const SizedBox(
                  height: 13,
                ),
                SizedBox(
                  width: 223,
                  child: Row(
                    children: [
                      Text(
                        "Não tem uma conta?",
                        style: TextStyle(
                          fontSize: 14,
                          color: MyColors.branco1,
                          fontFamily: MyFonts.fontTerc
                        ),
                      ),
                      const SizedBox(width: 3,),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/Cadastro");
                        },
                        child: Text(
                          "Cadastre-se",
                          style: TextStyle(
                            fontSize: 14,
                            color: MyColors.azul1,
                            fontFamily: MyFonts.fontTerc
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}