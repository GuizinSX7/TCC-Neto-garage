import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class TelaDeAgendamento extends StatefulWidget {
  const TelaDeAgendamento({super.key});

  @override
  State<TelaDeAgendamento> createState() => _TelaDeAgendamentoState();
}

class _TelaDeAgendamentoState extends State<TelaDeAgendamento> {
  String? selectedItemHorario;
  String? selectedItemGrauLavagem;
  List<String> items = [];
  List<String> grausDeLavagem = [];
  late DateTime selectedDay;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is DateTime) {
      selectedDay = args;
      carregarHorariosDisponiveis();
      carregarGrausDeLavagem(); // ✅ Agora a lista de graus de lavagem será carregada também
    }
  }

  Future<void> carregarHorariosDisponiveis() async {
    try {
      String diaSemana = DateFormat('EEEE', 'pt_BR').format(selectedDay);
      diaSemana = capitalize(diaSemana);

      final snapshot = await FirebaseFirestore.instance
          .collection('agendamentos')
          .doc(diaSemana)
          .collection('horarios')
          .where('disponivel', isEqualTo: true)
          .get();

      List<String> horarios = snapshot.docs.map((doc) => doc.id).toList();

      horarios.sort((a, b) {
        DateTime timeA = DateFormat('HH:mm').parse(a);
        DateTime timeB = DateFormat('HH:mm').parse(b);
        return timeA.compareTo(timeB);
      });

      setState(() {
        items = horarios;
      });
    } catch (e) {
      print("Erro ao carregar horários: $e");
    }
  }

  Future<void> carregarGrausDeLavagem() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('graus de lavagem')
          .doc('Descrições') // Pegando o documento correto
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;

        List<String> graus = [];
        data.forEach((key, value) {
          graus.add("$key: $value");
        });

        setState(() {
          grausDeLavagem = graus;
        });
      } else {
        print("Documento 'Descrições' não encontrado!");
      }
    } catch (e) {
      print("Erro ao carregar graus de lavagem: $e");
    }
  }

  String capitalize(String s) {
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: MyColors.azul3,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: MyColors.gradienteGeral,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Agendamento",
                style: TextStyle(
                  color: MyColors.branco1,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                width: 320,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(30, 233, 236, 239),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: MyColors.branco1,
                    width: 2,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    value: selectedItemHorario,
                    hint: const Text(
                      'Selecione um horário',
                      style: TextStyle(
                        color: MyColors.branco1,
                        fontSize: 16,
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(30, 233, 236, 239),
                          borderRadius: BorderRadius.circular(12),
                          border: Border(
                              left:
                                  BorderSide(color: MyColors.branco1, width: 2),
                              right:
                                  BorderSide(color: MyColors.branco1, width: 2),
                              bottom:
                                  BorderSide(color: MyColors.branco1, width: 2),
                              top: BorderSide.none)),
                      offset: Offset(0, 0),
                    ),
                    items: items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                            color: MyColors.branco1,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedItemHorario = newValue;
                      });
                    },
                    customButton: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedItemHorario ?? 'Selecione um horário',
                            style: TextStyle(
                              color: MyColors.branco1,
                              fontSize: 16,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: MyColors.branco1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 320,
                decoration: BoxDecoration(
                  color: MyColors.branco1,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: MyColors.branco1,
                    width: 2,
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.branco1,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: MyColors.branco1, width: 2),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Graus de lavagem'),
                          content: SizedBox(
                            width: 300,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: grausDeLavagem.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(grausDeLavagem[index]),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedItemGrauLavagem ?? 'Graus de lavagem',
                        style: TextStyle(
                          color: MyColors.preto1,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
