import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcc_neto_garage/components/Menubar.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class Clientes extends StatefulWidget {
  const Clientes({super.key});

  @override
  State<Clientes> createState() => _ClientesState();
}

class _ClientesState extends State<Clientes> {
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
                "Clientes",
                style: TextStyle(
                  color: MyColors.branco1,
                  fontSize: 24,
                  fontFamily: MyFonts.fontSecundary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30,),

              Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      // Navigator.pushNamed(context, routeName)
                    },
                    child: Container(
                      width: 380,
                      height: 160,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(70, 248, 249, 250),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: MyColors.branco4,
                          width: 2.0,
                        )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/cliente.png',
                          ),
                          SizedBox(width: 25,),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Jorge Armando dos Santos",
                                style: TextStyle(
                                  color: MyColors.branco1,
                                  fontSize: 15,
                                  fontFamily: MyFonts.fontSecundary,
                                  fontWeight: FontWeight.bold
                                ),
                              ),

                              Text(
                                "Carro Cadastrado!",
                                style: TextStyle(
                                  color: MyColors.branco1,
                                  fontSize: 12,
                                  fontFamily: MyFonts.fontSecundary,
                                  fontWeight: FontWeight.bold
                                ),
                              ),

                              Text(
                                "Lavagem de Grau 3",
                                style: TextStyle(
                                  color: MyColors.branco1,
                                  fontSize: 20,
                                  fontFamily: MyFonts.fontSecundary,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50,),

                  GestureDetector(
                    onTap: (){
                      // Navigator.pushNamed(context, routeName)
                    },
                    child: Container(
                      width: 380,
                      height: 160,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(70, 248, 249, 250),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: MyColors.branco4,
                          width: 2.0,
                        )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/cliente.png',
                          ),
                          SizedBox(width: 25,),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Pedro Roberto Fregolente",
                                style: TextStyle(
                                  color: MyColors.branco1,
                                  fontSize: 15,
                                  fontFamily: MyFonts.fontSecundary,
                                  fontWeight: FontWeight.bold
                                ),
                              ),

                              Text(
                                "Carro Cadastrado!",
                                style: TextStyle(
                                  color: MyColors.branco1,
                                  fontSize: 12,
                                  fontFamily: MyFonts.fontSecundary,
                                  fontWeight: FontWeight.bold
                                ),
                              ),

                              Text(
                                "Lavagem de Grau 2",
                                style: TextStyle(
                                  color: MyColors.branco1,
                                  fontSize: 20,
                                  fontFamily: MyFonts.fontSecundary,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50,),

                  GestureDetector(
                    onTap: (){
                      // Navigator.pushNamed(context, routeName)
                    },
                    child: Container(
                      width: 380,
                      height: 160,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(70, 248, 249, 250),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: MyColors.branco4,
                          width: 2.0,
                        )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/cliente.png',
                          ),
                          SizedBox(width: 25,),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Henrique Jubiscleuton Nunes",
                                style: TextStyle(
                                  color: MyColors.branco1,
                                  fontSize: 15,
                                  fontFamily: MyFonts.fontSecundary,
                                  fontWeight: FontWeight.bold
                                ),
                              ),

                              Text(
                                "Carro Cadastrado!",
                                style: TextStyle(
                                  color: MyColors.branco1,
                                  fontSize: 12,
                                  fontFamily: MyFonts.fontSecundary,
                                  fontWeight: FontWeight.bold
                                ),
                              ),

                              Text(
                                "Lavagem de Grau 2",
                                style: TextStyle(
                                  color: MyColors.branco1,
                                  fontSize: 20,
                                  fontFamily: MyFonts.fontSecundary,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 89,),
                  Menubar(),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}