import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/components/Menubar.dart';
// import 'package:tcc_neto_garage/components/navBar.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class Ajustes extends StatefulWidget {
  const Ajustes({super.key});

  @override
  State<Ajustes> createState() => _AjustesState();
}

class _AjustesState extends State<Ajustes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: MyColors.gradienteTelas
        ),

        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 75,),
              Text(
                "Ajustes",
                style: TextStyle(
                  color: MyColors.branco1,
                  fontSize: 24,
                  fontFamily: MyFonts.fontSecundary,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 65,),

              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, routeName)
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Perfil.png'
                        ),
                    
                        SizedBox(width: 30,),
                    
                        Text(
                          "Perfil",
                          style: TextStyle(
                            color: MyColors.branco1,
                            fontSize: 18,
                            fontFamily: MyFonts.fontTerc,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                    
                        SizedBox(width: 197,),
                    
                        Image.asset(
                          'assets/images/Avançar.png'
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 43,),
                  Container(
                    width: 380,
                    height: 1,
                    decoration: BoxDecoration(
                    color: MyColors.branco1
                    ),
                  ),
                  SizedBox(height: 41,),

                  GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, routeName)
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Notificações.png'
                        ),
                    
                        SizedBox(width: 30,),
                    
                        Text(
                          "Notificações",
                          style: TextStyle(
                            color: MyColors.branco1,
                            fontSize: 18,
                            fontFamily: MyFonts.fontTerc,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                    
                        SizedBox(width: 140,),
                    
                        Image.asset(
                          'assets/images/Avançar.png'
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 43,),
                  Container(
                    width: 380,
                    height: 1,
                    decoration: BoxDecoration(
                    color: MyColors.branco1
                    ),
                  ),
                  SizedBox(height: 41,),

                  GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, routeName)
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Ajuda.png'
                        ),
                    
                        SizedBox(width: 30,),
                    
                        Text(
                          "Ajuda",
                          style: TextStyle(
                            color: MyColors.branco1,
                            fontSize: 18,
                            fontFamily: MyFonts.fontTerc,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                    
                        SizedBox(width: 197,),
                    
                        Image.asset(
                          'assets/images/Avançar.png'
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 43,),
                  Container(
                    width: 380,
                    height: 1,
                    decoration: BoxDecoration(
                    color: MyColors.branco1
                    ),
                  ),
                  SizedBox(height: 41,),

                  GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, routeName)
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Sobre.png'
                        ),
                    
                        SizedBox(width: 30,),
                    
                        Text(
                          "Sobre",
                          style: TextStyle(
                            color: MyColors.branco1,
                            fontSize: 18,
                            fontFamily: MyFonts.fontTerc,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                    
                        SizedBox(width: 197,),
                    
                        Image.asset(
                          'assets/images/Avançar.png'
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 43,),
                  Container(
                    width: 380,
                    height: 1,
                    decoration: BoxDecoration(
                    color: MyColors.branco1
                    ),
                  ),
                  SizedBox(height: 176,),

                  GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, routeName)
                    },
                    child: Container(
                      width: 380,
                      height: 50,
                      decoration: BoxDecoration(
                        color: MyColors.azul4,
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/Sair.png'
                          ),
                    
                          SizedBox(width: 30,),
                    
                          Text(
                            "Sair",
                            style: TextStyle(
                              color: MyColors.branco1,
                              fontSize: 18,
                              fontFamily: MyFonts.fontTerc,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                    
                          SizedBox(width: 197,),
                    
                          Image.asset(
                            'assets/images/Signout.png'
                          ),
                        ],
                      ),
                    ),
                  ),
                  Menubar()
                ],
              )
            ],
          ),
        ),

      ),
    );
  }
}