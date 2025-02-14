import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class LoginComp extends StatefulWidget {

  final VoidCallback onRedefinirSenha;

  const LoginComp({super.key, required this.onRedefinirSenha});

  @override
  State<LoginComp> createState() => _LoginCompState();
}

class _LoginCompState extends State<LoginComp> {

  final _formKey = GlobalKey<FormState>();
  bool _isSwitched = false;

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
                      hintText: "Email ou CPF",
                      hintStyle: TextStyle(color: MyColors.branco4,),
                      contentPadding: const EdgeInsets.symmetric(vertical:10, horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 48,),
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
                      hintStyle: TextStyle(color: MyColors.branco4,),
                      contentPadding: const EdgeInsets.symmetric(vertical:10, horizontal: 20),
                    ),
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
                  child: Transform.scale(
                    scale: 0.6,
                    child: Switch (
                      value: _isSwitched,
                      onChanged: (bool value) {
                        setState(() {
                          _isSwitched = value;
                        });
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/Home");
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(250, 50),
                    backgroundColor: MyColors.azul3,
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
                )
              ],
            ),
          ),
        ],
      ),
          );
  }
}