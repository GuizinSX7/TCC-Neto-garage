import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class Resetpassword extends StatefulWidget {
  final VoidCallback onBackToLogin;
  final VoidCallback emailEnviado;

  const Resetpassword({
    super.key,
    required this.onBackToLogin,
    required this.emailEnviado,
  });

  @override
  State<Resetpassword> createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerEmailLogin = TextEditingController();

  void _resetPassword(BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: _controllerEmailLogin.text);
      _showSnackBar("Email de recuperação enviado!", MyColors.azul1);
    } catch (e) {
      _showSnackBar("erro inesperado", MyColors.vermelho1);
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              "Esqueceu sua senha?",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 65,
              width: 292,
              child: Text(
                "Informe um e-mail, enviaremos um código para a criação de uma nova senha. ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: MyColors.branco1,
                  fontFamily: MyFonts.fontSecundary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
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
                    borderSide: BorderSide(color: MyColors.branco1, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: MyColors.branco1, width: 1),
                  ),
                  hintText: "Email de recuperação",
                  hintStyle: TextStyle(
                    color: MyColors.branco4,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                validator: (String? user) {
                  if (user == null || user.isEmpty) {
                    return "O email não pode estar vazio";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 200,
            ),
            ElevatedButton(
              onPressed: widget.onBackToLogin, 
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(250, 50),
                  backgroundColor: MyColors.preto1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: MyColors.branco1,
                      width: 1,
                    )
                  )
              ),
              child: Text(
                "Voltar",
                style: TextStyle(
                  color: MyColors.branco1,
                  fontSize: 14,
                  fontFamily: MyFonts.fontTerc,
                ),
              ),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _resetPassword(context);
                    Future.delayed(const Duration(seconds: 2), () {
                      widget.emailEnviado();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(250, 50),
                  backgroundColor: MyColors.azul2,
                ),
                child: Text(
                  "Enviar",
                  style: TextStyle(
                      color: MyColors.branco1,
                      fontSize: 14,
                      fontFamily: MyFonts.fontTerc,
                      fontWeight: FontWeight.bold),
                )
            ),
          ],
        ),
      ),
    );
  }
}
