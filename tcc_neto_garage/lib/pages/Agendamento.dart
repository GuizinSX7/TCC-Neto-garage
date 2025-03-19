import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class telaDeAgendamento extends StatefulWidget {
  const telaDeAgendamento({super.key});

  @override
  State<telaDeAgendamento> createState() => _telaDeAgendamentoState();
}

class _telaDeAgendamentoState extends State<telaDeAgendamento> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back)
        ),
        backgroundColor: MyColors.azul3,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: MyColors.gradienteGeral,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(
                  
                )
              ],
            )
          ],
        ),
      )
    );
  }
}