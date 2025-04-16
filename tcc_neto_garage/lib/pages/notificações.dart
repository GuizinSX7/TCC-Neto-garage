import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc_neto_garage/shared/style.dart';
import 'package:tcc_neto_garage/components/Menubar.dart';

class Notificacoes extends StatefulWidget {
  const Notificacoes({super.key});

  @override
  State<Notificacoes> createState() => _NotificacoesState();
}

class _NotificacoesState extends State<Notificacoes> {
  List<Map<String, dynamic>> agendamentos = [];

  @override
  void initState() {
    super.initState();
    fetchAgendamentos();
  }

  Future<void> fetchAgendamentos() async {
    final agendamentosRef =
        FirebaseFirestore.instance.collection('agendamentos');
    final agendamentosSnapshot = await agendamentosRef.get();

    List<Map<String, dynamic>> tempAgendamentos = [];

    for (var doc in agendamentosSnapshot.docs) {
      final data =
          await agendamentosRef.doc(doc.id).collection('horarios').get();

      for (var horarioDoc in data.docs) {
        var agendamento = horarioDoc.data();
        agendamento['data'] = doc.id;

        // === REGEX PARA SIMPLIFICAR O TEXTO DO GRAU DE LAVAGEM ===
        final grau = agendamento['grauLavagem'];
        if (grau != null) {
          final match = RegExp(r'Grau\s(?:de\s)?(?:moto|Moto|\d+)').firstMatch(grau);
          if (match != null) {
            agendamento['grauLavagem'] = 'Lavagem ${match.group(0)}';
          }
        }

        tempAgendamentos.add(agendamento);
      }
    }

    if (mounted) {
      setState(() {
        agendamentos = tempAgendamentos;
      });
    }
  }

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
        decoration: BoxDecoration(gradient: MyColors.gradienteTelas),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 5),
              Text(
                'Notificações',
                style: TextStyle(
                  color: MyColors.branco1,
                  fontSize: 24,
                  fontFamily: MyFonts.fontSecundary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: 380,
                height: 639,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(70, 248, 249, 250),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: MyColors.branco4,
                    width: 2.0,
                  ),
                ),
                child: agendamentos.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: agendamentos.length,
                        itemBuilder: (context, index) {
                          final ag = agendamentos[index];
                          final veiculo = ag['veiculo'] ?? {};
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              width: 300,
                              decoration: BoxDecoration(
                                color: MyColors.branco4,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset('assets/images/sino.png'),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Foi feito um agendamento para uma lavagem de Grau: ${ag['grauLavagem'] ?? ''}\npara o dia ${ag['data']} às ${ag['horario'] ?? ''}.",
                                          style: TextStyle(
                                            color: MyColors.cinzaEscuro3,
                                            fontSize: 15,
                                            fontFamily: MyFonts.fontTerc,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Veículo: ${veiculo['Modelo'] ?? ''} - ${veiculo['Categoria'] ?? ''}",
                                          style: TextStyle(
                                            color: MyColors.cinzaEscuro3,
                                            fontSize: 12,
                                            fontFamily: MyFonts.fontTerc,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              SizedBox(height: 30),
              Menubar(),
            ],
          ),
        ),
      ),
    );
  }
}

