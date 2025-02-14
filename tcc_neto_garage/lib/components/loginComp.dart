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
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 25,),
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
                ),
                const SizedBox(height: 31,),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: MyColors.branco1
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/images/google.png",
                      width: 37,
                      height: 37,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
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
                          Navigator.pushNamed(context, )
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