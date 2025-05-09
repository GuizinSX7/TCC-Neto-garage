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

  String formatarTempoDecorrido(Timestamp criadoEm) {
    final agora = DateTime.now();
    final criado = criadoEm.toDate();
    final diff = agora.difference(criado);

    if (diff.inMinutes < 60) {
      final minutos = diff.inMinutes;
      return 'há $minutos ${minutos == 1 ? 'minuto' : 'minutos'}';
    } else if (diff.inHours < 24) {
      final horas = diff.inHours;
      return 'há $horas ${horas == 1 ? 'hora' : 'horas'}';
    } else if (diff.inDays < 30) {
      final dias = diff.inDays;
      return 'há $dias ${dias == 1 ? 'dia' : 'dias'}';
    } else {
      final meses = (diff.inDays / 30).floor();
      return 'há $meses ${meses == 1 ? 'mês' : 'meses'}';
    }
  }

  Future<void> fetchAgendamentos() async {
    final agendamentosRef =
        FirebaseFirestore.instance.collection('agendamentos');
    final agendamentosSnapshot = await agendamentosRef.get();

    List<Map<String, dynamic>> tempAgendamentos = [];

    for (var doc in agendamentosSnapshot.docs) {
      final data = await agendamentosRef
          .doc(doc.id)
          .collection('horarios')
          .orderBy('criadoEm',
              descending: true) // Ordena os horários por criadoEm
          .get();

      for (var horarioDoc in data.docs) {
        var agendamento = horarioDoc.data();
        agendamento['data'] = doc.id;
        tempAgendamentos.add(agendamento);
      }
    }

    // Ordena a lista principal por criadoEm (mais recente primeiro)
    tempAgendamentos.sort((a, b) {
      final Timestamp aTime = a['criadoEm'] ?? Timestamp.now();
      final Timestamp bTime = b['criadoEm'] ?? Timestamp.now();
      return bTime.compareTo(aTime);
    });

    if (mounted) {
      setState(() {
        agendamentos = tempAgendamentos;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    final altura = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: MyColors.gradienteTelas),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 60.0, left: 5.0), // ajuste o top se necessário
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: MyColors.branco1),
                  ),
                ),
              ),
              SizedBox(height: altura * 0.01),
              Text(
                'Notificações',
                style: TextStyle(
                  color: MyColors.branco1,
                  fontSize: largura * 0.06,
                  fontFamily: MyFonts.fontSecundary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: altura * 0.03),
              Container(
                width: largura * 0.9,
                height: altura * 0.65,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(70, 248, 249, 250),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: MyColors.branco4,
                    width: 2.0,
                  ),
                ),
                child: agendamentos.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(
                        color: MyColors.azul2,
                      ))
                    : ListView.builder(
                        itemCount: agendamentos.length,
                        itemBuilder: (context, index) {
                          final ag = agendamentos[index];
                          final veiculo = ag['veiculo'] ?? {};
                          final placa = veiculo['Placa'] ?? '';
                          final extras = ag['servicosExtras'] ?? [];
                          final criadoEm = ag['criadoEm'] as Timestamp?;

                          String grauCompleto = ag['grauLavagem'] ?? '';
                          final RegExp regex = RegExp(r'Grau\s[\d\w\s]+');
                          final match = regex.firstMatch(grauCompleto);
                          final grau = match != null
                              ? 'Lavagem ${match.group(0)?.toLowerCase()}'
                              : grauCompleto;

                          return Padding(
                            padding: EdgeInsets.all(largura * 0.03),
                            child: Container(
                              width: largura * 0.85,
                              decoration: BoxDecoration(
                                color: MyColors.branco4,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.all(largura * 0.03),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/images/sino.png',
                                    width: largura * 0.08,
                                  ),
                                  SizedBox(width: largura * 0.04),
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: largura * 0.12),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                () {
                                                  String texto =
                                                      "Foi agendado uma lavagem\n"
                                                      "de Grau: $grau\n"
                                                      "para o dia ${ag['data']} às ${ag['horario'] ?? ''}.";

                                                  if (extras.isNotEmpty) {
                                                    texto +=
                                                        "\n\nServiços extras:";
                                                    for (var servico
                                                        in extras) {
                                                      texto +=
                                                          "\n- ${servico['titulo']}";
                                                    }
                                                  }

                                                  return texto;
                                                }(),
                                                style: TextStyle(
                                                  color: MyColors.cinzaEscuro3,
                                                  fontSize: largura * 0.035,
                                                  fontFamily: MyFonts.fontTerc,
                                                ),
                                              ),
                                              SizedBox(height: altura * 0.005),
                                              Text(
                                                "Veículo: ${veiculo['Modelo'] ?? ''} - ${veiculo['Categoria'] ?? ''}${placa.isNotEmpty ? ' | Placa: $placa' : ''}",
                                                style: TextStyle(
                                                  color: MyColors.cinzaEscuro3,
                                                  fontSize: largura * 0.03,
                                                  fontFamily: MyFonts.fontTerc,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (criadoEm != null)
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: Text(
                                              formatarTempoDecorrido(criadoEm),
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: largura * 0.027,
                                                fontFamily: MyFonts.fontTerc,
                                              ),
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
              SizedBox(height: altura * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
