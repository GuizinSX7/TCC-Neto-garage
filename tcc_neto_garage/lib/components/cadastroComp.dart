import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class CadastroComp extends StatefulWidget {
  const CadastroComp({super.key});

  @override
  State<CadastroComp> createState() => _CadastroCompState();
}

class _CadastroCompState extends State<CadastroComp> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            // key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 45,
                  width: 300,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nome Completo",
                    hintStyle: TextStyle(
                      color: MyColors.branco4
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(30, 233, 236, 239),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: MyColors.branco1,
                        width: 10,
                      )
                    )
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}