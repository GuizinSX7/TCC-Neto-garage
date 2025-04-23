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
      final data =
          await agendamentosRef.doc(doc.id).collection('horarios').get();

      for (var horarioDoc in data.docs) {
        var agendamento = horarioDoc.data();
        agendamento['data'] = doc.id;
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
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 60),
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
                                                    for (var servico in extras) {
                                                      texto +=
                                                          "\n- ${servico['titulo']}";
                                                    }
                                                  }

                                                  return texto;
                                                }(),
                                                style: TextStyle(
                                                  color: MyColors.cinzaEscuro3,
                                                  fontSize: 14,
                                                  fontFamily: MyFonts.fontTerc,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "Veículo: ${veiculo['Modelo'] ?? ''} - ${veiculo['Categoria'] ?? ''}${placa.isNotEmpty ? ' | Placa: $placa' : ''}",
                                                style: TextStyle(
                                                  color: MyColors.cinzaEscuro3,
                                                  fontSize: 12,
                                                  fontFamily: MyFonts.fontTerc,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (criadoEm != null)
                                          Positioned(
                                            top: 4,
                                            right: 8,
                                            child: Text(
                                              formatarTempoDecorrido(criadoEm),
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 11,
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
              SizedBox(height: 30),
              Menubar(),
            ],
          ),
        ),
      ),
    );
  }
}
