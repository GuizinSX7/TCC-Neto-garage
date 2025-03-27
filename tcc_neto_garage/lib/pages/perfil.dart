import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:tcc_neto_garage/components/Menubar.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: MyColors.gradienteGeral,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: MyColors.branco1,
                      size: 24,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Seu Perfil',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: MyFonts.fontSecundary,
                    color: MyColors.branco1,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/perfil.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Guilherme Ferraresi Dallacqua',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: MyFonts.fontPrimary,
                        color: MyColors.branco1,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Icon(
                      Icons.edit,
                      color: MyColors.branco1,
                      size: 15,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'guilhermeferrasini@gmail.com',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: MyFonts.fontPrimary,
                      color: MyColors.branco1,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                
                // ScrollView dos veículos
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      VehicleCard(model: 'Hilux SRV 2015', plate: 'ABC1B34'),
                      SizedBox(width: 15),
                      VehicleCard(model: 'Corolla XEI 2020', plate: 'XYZ2C56'),
                      SizedBox(width: 15),
                      VehicleCard(model: 'Civic Touring 2019', plate: 'LMN3D78'),
                      SizedBox(width: 15),
                      VehicleCard(model: 'Ranger Limited 2021', plate: 'OPQ4E90'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Container Serviços Agendados
                Container(
                  width: 380,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(30, 233, 236, 239),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: MyColors.branco1, width: 1),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Iconify(
                          Mdi.file_document,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 1,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 15),
                      Text(
                        "Serviços já agendados",
                        style: TextStyle(
                          fontSize: 24,
                          color: MyColors.branco1,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Container Email
                InfoContainer(
                  label: "E-mail:",
                  value: "guilhermeferrasini@gmail.com",
                ),

                const SizedBox(height: 15),

                // Container Senha
                InfoContainer(
                  label: "Senha:",
                  value: "********",
                ),

                const SizedBox(height: 15),

                // Container Endereço
                InfoContainer(
                  label: "Endereço",
                  value: "",
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Menubar(), // MenuBar adicionada aqui
    );
  }
}

// Widget dos Cards dos Veículos
class VehicleCard extends StatelessWidget {
  final String model;
  final String plate;

  const VehicleCard({
    required this.model,
    required this.plate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 101,
        height: 101,
        decoration: BoxDecoration(
          color: const Color.fromARGB(30, 233, 236, 239),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: MyColors.branco1, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping,
              size: 40,
              color: Colors.white,
            ),
            SizedBox(height: 8),
            Text(
              model,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors.branco1,
                fontSize: 12,
                fontFamily: MyFonts.fontPrimary,
              ),
            ),
            Text(
              plate,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors.branco1,
                fontSize: 10,
                fontFamily: MyFonts.fontPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para os containers de E-mail, Senha e Endereço
class InfoContainer extends StatelessWidget {
  final String label;
  final String value;

  const InfoContainer({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 50,
      decoration: BoxDecoration(
        color: const Color.fromARGB(30, 233, 236, 239),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: MyColors.branco1, width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(color: MyColors.branco1, fontSize: 16),
              children: [
                TextSpan(
                  text: "$label ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
          Icon(Icons.edit, color: MyColors.branco1),
        ],
      ),
    );
  }
}