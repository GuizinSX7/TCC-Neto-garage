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
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: MyColors.gradienteTelas),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "Ajustes",
                  style: TextStyle(
                      color: MyColors.branco1,
                      fontSize: 24,
                      fontFamily: MyFonts.fontSecundary,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 65,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.person, color: MyColors.branco1, size: 30),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              "Perfil",
                              style: TextStyle(
                                  color: MyColors.branco1,
                                  fontSize: 18,
                                  fontFamily: MyFonts.fontTerc,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 20, color: MyColors.branco1),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 380,
                      height: 1,
                      decoration: BoxDecoration(color: MyColors.branco1),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.notifications,
                              color: MyColors.branco1, size: 30),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              "Notificações",
                              style: TextStyle(
                                  color: MyColors.branco1,
                                  fontSize: 18,
                                  fontFamily: MyFonts.fontTerc,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 20, color: MyColors.branco1),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 380,
                      height: 1,
                      decoration: BoxDecoration(color: MyColors.branco1),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.help, color: MyColors.branco1, size: 30),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              "Ajuda",
                              style: TextStyle(
                                  color: MyColors.branco1,
                                  fontSize: 18,
                                  fontFamily: MyFonts.fontTerc,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 20, color: MyColors.branco1),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 380,
                      height: 1,
                      decoration: BoxDecoration(color: MyColors.branco1),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: MyColors.branco1, size: 30),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              "Sobre",
                              style: TextStyle(
                                  color: MyColors.branco1,
                                  fontSize: 18,
                                  fontFamily: MyFonts.fontTerc,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 20, color: MyColors.branco1),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 380,
                      height: 1,
                      decoration: BoxDecoration(color: MyColors.branco1),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.pushNamed(context, routeName)
                      },
                      child: Container(
                        width: 380,
                        height: 50,
                        decoration: BoxDecoration(
                            color: MyColors.azul4,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 8),
                          child: Row(
                            children: [
                              Icon(Icons.person,
                                  color: MyColors.branco1, size: 30),
                              SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  "Sair",
                                  style: TextStyle(
                                      color: MyColors.branco1,
                                      fontSize: 18,
                                      fontFamily: MyFonts.fontTerc,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Icon(Icons.logout,
                                  size: 20, color: MyColors.branco1),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
