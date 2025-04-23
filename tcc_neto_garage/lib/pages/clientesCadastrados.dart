import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc_neto_garage/components/VeiculoCard.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class Clientescadastrados extends StatefulWidget {
  const Clientescadastrados({super.key});

  @override
  State<Clientescadastrados> createState() => _ClientescadastradosState();
}

class _ClientescadastradosState extends State<Clientescadastrados> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> carregarVeiculosUsuario(
      String userId) async {
    try {
      final snapshot = await _firestore
          .collection('veiculos cadastrados')
          .where('CPF', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Erro ao carregar veículos: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: MyColors.branco1,
                ),
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('usuarios').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Erro ao carregar usuários'));
              }

              final users = snapshot.data?.docs ?? [];

              if (users.isEmpty) {
                return const Center(child: Text('Nenhum usuário cadastrado.'));
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: users.map((doc) {
                    final user = doc.data() as Map<String, dynamic>;
                    final userId = doc.id;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.person,
                                    size: 32, color: Colors.blue),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    user['nome completo'] ?? 'Sem nome',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '📧 Email: ${user['email'] ?? 'Sem email'}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              '🏡 Logradouro: ${user['logradouro'] ?? 'Sem logradouro'}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              '🏠 Casa: ${user['numero'] ?? 'Sem casa'}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 10,),
                            Container(
                              width: 320,
                              height: 150,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(30, 255, 255, 255),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: MyColors.branco1,
                                  width: 2,
                                ),
                              ),
                              child: FutureBuilder<List<Map<String, dynamic>>>(
                                future: carregarVeiculosUsuario(userId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Erro ao carregar veículos'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return Center(
                                        child:
                                            Text('Nenhum veículo cadastrado'));
                                  }

                                  List<Map<String, dynamic>> vehicles =
                                      snapshot.data!;

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: vehicles.map((vehicle) {
                                        String vehicleType =
                                            vehicle['Categoria']
                                                    ?.toLowerCase() ??
                                                'sedan';
                                        String imagePath = '';

                                        switch (vehicleType) {
                                          case 'suv':
                                            imagePath = "assets/icons/SUV.png";
                                            break;
                                          case 'sedã':
                                            imagePath =
                                                "assets/icons/Sedan.png";
                                            break;
                                          case 'moto':
                                            imagePath = "assets/icons/Moto.png";
                                            break;
                                          case 'picape':
                                            imagePath =
                                                "assets/icons/Picape.png";
                                            break;
                                          case 'hatch':
                                            imagePath =
                                                "assets/icons/Hatch.png";
                                            break;
                                        }

                                        return VehicleCard(
                                          model: vehicle['Modelo'] ??
                                              'Desconhecido',
                                          plate:
                                              vehicle['Placa'] ?? 'Sem placa',
                                          vehicleIcon: imagePath,
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}
