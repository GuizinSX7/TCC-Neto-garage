import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';
import 'dart:convert';

class Funcionarios extends StatefulWidget {
  const Funcionarios({super.key});

  @override
  State<Funcionarios> createState() => _FuncionariosState();
}

class _FuncionariosState extends State<Funcionarios> {
  // Função para buscar os funcionários no Firebase Firestore
  Future<List<Map<String, dynamic>>> _getFuncionarios() async {
    try {
      // Consulta para buscar todos os documentos da coleção "funcionarios"
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('funcionarios').get();
      // Retorna uma lista de mapas contendo os dados dos funcionários
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Erro ao buscar funcionários: $e');
      return [];
    }
  }

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
                const SizedBox(height: 100),
                Text(
                  "Funcionários",
                  style: TextStyle(
                    color: MyColors.branco1,
                    fontSize: 24,
                    fontFamily: MyFonts.fontSecundary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 60),
                // Usando o FutureBuilder para buscar e exibir os funcionários
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _getFuncionarios(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Erro ao carregar funcionários.'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text('Nenhum funcionário encontrado.'));
                    } else {
                      // Se houver dados, cria os cards para cada funcionário
                      List<Map<String, dynamic>> funcionarios = snapshot.data!;
                      return Column(
                        children: funcionarios.map((funcionario) {
                          return Container(
                            width: 380,
                            height: 160,
                            margin: const EdgeInsets.only(bottom: 100),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(70, 248, 249, 250),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: MyColors.branco4,
                                width: 2.0,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.memory(
                                  base64Decode(
                                      funcionario['Image'] ?? ''),
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error,
                                        color: Colors.red);
                                  },
                                ),
                                SizedBox(width: 25),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      funcionario['nome'] ??
                                          'Nome desconhecido',
                                      style: TextStyle(
                                        color: MyColors.branco1,
                                        fontSize: 15,
                                        fontFamily: MyFonts.fontSecundary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${funcionario['Idade']} anos',
                                      style: TextStyle(
                                        color: MyColors.branco1,
                                        fontSize: 12,
                                        fontFamily: MyFonts.fontSecundary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Cursos já feitos:",
                                      style: TextStyle(
                                        color: MyColors.branco1,
                                        fontSize: 12,
                                        fontFamily: MyFonts.fontSecundary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    for (var curso
                                        in funcionario['Cursos'] ?? [])
                                      Text(
                                        "• $curso",
                                        style: TextStyle(
                                          color: MyColors.branco1,
                                          fontSize: 12,
                                          fontFamily: MyFonts.fontSecundary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
                const SizedBox(height: 152),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
