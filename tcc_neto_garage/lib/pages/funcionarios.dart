import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/components/Menubar.dart';
import 'package:tcc_neto_garage/pages/home.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class Funcionarios extends StatefulWidget {
  const Funcionarios({super.key});

  @override
  State<Funcionarios> createState() => _FuncionariosState();
}

class _FuncionariosState extends State<Funcionarios> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(gradient: MyColors.gradienteTelas),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Text(
                "Funcionários",
                style: TextStyle(
                    color: MyColors.branco1,
                    fontSize: 24,
                    fontFamily: MyFonts.fontSecundary,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 60,
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
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
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/FuncionarioP.png'),
                          SizedBox(
                            width: 25,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Gabriel de Souza Neto Pires",
                                style: TextStyle(
                                    color: MyColors.branco1,
                                    fontSize: 15,
                                    fontFamily: MyFonts.fontSecundary,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "17 anos",
                                style: TextStyle(
                                    color: MyColors.branco1,
                                    fontSize: 12,
                                    fontFamily: MyFonts.fontSecundary,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Cursos já feitos:",
                                style: TextStyle(
                                    color: MyColors.branco1,
                                    fontSize: 12,
                                    fontFamily: MyFonts.fontSecundary,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "• Curso 01",
                                style: TextStyle(
                                    color: MyColors.branco1,
                                    fontSize: 12,
                                    fontFamily: MyFonts.fontSecundary,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "• Curso 02",
                                style: TextStyle(
                                    color: MyColors.branco1,
                                    fontSize: 12,
                                    fontFamily: MyFonts.fontSecundary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  GestureDetector(
                    onTap: () {
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
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/FuncionarioP.png'),
                          SizedBox(
                            width: 25,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Gabriel de Souza Neto Pires",
                                style: TextStyle(
                                    color: MyColors.branco1,
                                    fontSize: 15,
                                    fontFamily: MyFonts.fontSecundary,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "21 anos",
                                style: TextStyle(
                                    color: MyColors.branco1,
                                    fontSize: 12,
                                    fontFamily: MyFonts.fontSecundary,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Cursos já feitos:",
                                style: TextStyle(
                                    color: MyColors.branco1,
                                    fontSize: 12,
                                    fontFamily: MyFonts.fontSecundary,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "• Curso 01",
                                style: TextStyle(
                                    color: MyColors.branco1,
                                    fontSize: 12,
                                    fontFamily: MyFonts.fontSecundary,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "• Curso 02",
                                style: TextStyle(
                                    color: MyColors.branco1,
                                    fontSize: 12,
                                    fontFamily: MyFonts.fontSecundary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 152,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
