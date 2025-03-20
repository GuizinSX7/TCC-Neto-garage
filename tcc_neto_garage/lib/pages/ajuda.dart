import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/components/Menubar.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class Ajuda extends StatefulWidget {
  const Ajuda({super.key});

  @override
  State<Ajuda> createState() => _AjudaState();
}

class _AjudaState extends State<Ajuda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset('assets/images/voltar.png'),
        ),
        backgroundColor: MyColors.azul3,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: MyColors.gradienteTelas
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 5,),
              Text(
                "Precisa de ajuda?",
                style: TextStyle(
                  color: MyColors.branco1,
                  fontSize: 24,
                  fontFamily: MyFonts.fontSecundary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Entre em contato",
                style: TextStyle(
                  color: MyColors.branco1,
                  fontSize: 20,
                  fontFamily: MyFonts.fontSecundary,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                "conosco.",
                style: TextStyle(
                  color: MyColors.branco1,
                  fontSize: 20,
                  fontFamily: MyFonts.fontSecundary,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 5,),

              Image.asset('assets/images/sac.png'),
              SizedBox(height: 120,),

              Image.asset('assets/images/infoAjuda.png'),

              SizedBox(height: 214,),
              Menubar(),
            ],
          ),
        ),
      ),
    );
  }
}