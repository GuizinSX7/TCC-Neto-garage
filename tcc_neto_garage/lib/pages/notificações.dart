import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';
import 'package:tcc_neto_garage/components/Menubar.dart';

class Notificacoes extends StatefulWidget {
  const Notificacoes({super.key});

  @override
  State<Notificacoes> createState() => _NotificacoesState();
}

class _NotificacoesState extends State<Notificacoes> {
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
                'Notificações',
                style: TextStyle(
                  color: MyColors.branco1,
                  fontSize: 24,
                  fontFamily: MyFonts.fontSecundary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30,),
              
              Container(
                width: 380,
                height: 639,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(70, 248, 249, 250),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: MyColors.branco4,
                    width: 2.0,
                    )
                  ),
                child: Column(  
                  children: [
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: (){
                        // Navigator.pushNamed(context, routeName)
                      },
                      child: Container(
                        width: 300,
                        height: 136,
                        decoration: BoxDecoration(
                          color: MyColors.branco4,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: 
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/sino.png'
                            ),
                            SizedBox(width: 15,),
                            Text(
                              "Você tem uma lavagem\nde Grau 01 agendada\npara amanhã.",
                              style: TextStyle(
                                color: MyColors.cinzaEscuro3,
                                fontSize: 15,
                                fontFamily: MyFonts.fontTerc,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 15,),
                            Text(
                              "agora",
                              style: TextStyle(
                                color: MyColors.cinzaEscuro3,
                                fontSize: 10,
                                fontFamily: MyFonts.fontTerc,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 35,),
                    GestureDetector(
                      onTap: (){
                        // Navigator.pushNamed(context, routeName)
                      },
                      child: Container(
                        width: 300,
                        height: 136,
                        decoration: BoxDecoration(
                          color: MyColors.branco4,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: 
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/sino.png'
                            ),
                            SizedBox(width: 15,),
                            Text(
                              "Você agendou uma\nlavagem de Grau 01 para\no dia 10/02 às 15h00.",
                              style: TextStyle(
                                color: MyColors.cinzaEscuro3,
                                fontSize: 15,
                                fontFamily: MyFonts.fontTerc,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 15,),
                            Text(
                              "há 5 dias",
                              style: TextStyle(
                                color: MyColors.cinzaEscuro3,
                                fontSize: 10,
                                fontFamily: MyFonts.fontTerc,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),


                  ],
                ),
              ),

              SizedBox(height: 30,),
              Menubar(),
            ],
          ),
        ),
      ),
    );
  }
}