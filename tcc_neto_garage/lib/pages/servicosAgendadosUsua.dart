import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class AgendamentosUsuario extends StatefulWidget {
  const AgendamentosUsuario({super.key});

  @override
  State<AgendamentosUsuario> createState() => _AgendamentosUsuarioState();
}

class _AgendamentosUsuarioState extends State<AgendamentosUsuario> {
  String? cpfUsuario;
  late Future<List<Map<String, dynamic>>> agendamentosFuturos;

  @override
  void initState() {
    super.initState();
    agendamentosFuturos = _carregarAgendamentosUsuario();
  }

  Future<List<Map<String, dynamic>>> _carregarAgendamentosUsuario() async {
    cpfUsuario = await _buscarCPFUsuario();
    if (cpfUsuario == null) return [];
    return await buscarAgendamentosDoUsuario();
  }

  Future<String?> _buscarCPFUsuario() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

    if (userId.isEmpty) return null;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("usuarios")
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first;
      var cpf = doc["CPF"];

      if (cpf is int) {
        return cpf.toString();
      } else if (cpf is String) {
        return cpf;
      }
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> buscarAgendamentosDoUsuario() async {
    if (cpfUsuario == null) return [];

    final agendamentosRef =
        FirebaseFirestore.instance.collection('agendamentos');
    final snapshotDatas = await agendamentosRef.get();

    List<Map<String, dynamic>> agendamentosUsuario = [];

    for (var dataDoc in snapshotDatas.docs) {
      final data = dataDoc.id;
      final horariosRef = agendamentosRef.doc(data).collection('horarios');
      final horariosSnapshot = await horariosRef.get();

      for (var horarioDoc in horariosSnapshot.docs) {
        final dados = horarioDoc.data();
        final veiculo = dados['veiculo'] as Map<String, dynamic>?;

        if (veiculo != null && veiculo['CPF'] == cpfUsuario) {
          agendamentosUsuario.add({
            'data': data,
            'horario': dados['horario'],
            'veiculo': veiculo,
            'servicosExtras': dados['servicosExtras'],
            'preco': dados['preco'],
            'grauLavagem': dados['grauLavagem'],
          });
        }
      }
    }

    return agendamentosUsuario;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
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
          FutureBuilder<List<Map<String, dynamic>>>(
            future: agendamentosFuturos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: MyColors.azul3,
                ));
              }
              if (snapshot.hasError) {
                return const Center(
                    child: Text('Erro ao carregar agendamentos'));
              }

              final agendamentos = snapshot.data ?? [];

              if (agendamentos.isEmpty) {
                return const Center(
                    child: Text('Nenhum agendamento encontrado'));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: agendamentos.length,
                itemBuilder: (context, index) {
                  final agendamento = agendamentos[index];
                  final veiculo = agendamento['veiculo'];

                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("📅 Data: ${agendamento['data']}",
                              style: const TextStyle(color: Colors.white)),
                          Text("⏰ Horário: ${agendamento['horario']}",
                              style: const TextStyle(color: Colors.white)),
                          Text(
                              "🚗 Veículo: ${veiculo['Modelo']} - ${veiculo['Placa']}",
                              style: const TextStyle(color: Colors.white)),
                          Text(
                              "🧼 Grau de Lavagem: ${agendamento['grauLavagem']}",
                              style: const TextStyle(color: Colors.white)),
                          Text("💰 Preço total: R\$ ${agendamento['preco']}",
                              style: const TextStyle(color: Colors.white)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    "/Reagendamento",
                                    arguments:
                                        agendamento,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColors.azul2,
                                  foregroundColor: MyColors.branco1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 5,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                ),
                                child: const Text(
                                  "Reagendar",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    ));
  }
}
