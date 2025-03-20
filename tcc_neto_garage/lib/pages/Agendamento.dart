import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class telaDeAgendamento extends StatefulWidget {
  const telaDeAgendamento({super.key});

  @override
  State<telaDeAgendamento> createState() => _telaDeAgendamentoState();
}

class _telaDeAgendamentoState extends State<telaDeAgendamento> {
  String? selectedItem;
  List<String> items = [];
  late DateTime selectedDay;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Obtém a data passada via argumento
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is DateTime) {
      selectedDay = args;
      print("Data recebida: $selectedDay"); // Para depuração
      carregarHorariosDisponiveis(); // Carrega os horários após receber a data
    }
  }

  // Future<void> criarDiaComHorarios(String data, List<String> horarios) async {
  //   final db = FirebaseFirestore.instance;

  //   for (String horario in horarios) {
  //     await db
  //         .collection('agendamentos')
  //         .doc(data)
  //         .collection('horarios')
  //         .doc(horario)
  //         .set({'disponivel': true});
  //   }
  // }

  String capitalize(String s) {
    return s[0].toUpperCase() + s.substring(1);
  }

  Future<void> agendarHorario(
      String data, String horario, String userId) async {
    await FirebaseFirestore.instance
        .collection('agendamentos')
        .doc(data)
        .collection('horarios')
        .doc(horario)
        .update({
      'disponivel': false,
      'usuarioId': userId,
    });
  }

  Future<void> carregarHorariosDisponiveis() async {
    try {
      String diaSemana = DateFormat('EEEE', 'pt_BR').format(selectedDay!);

      diaSemana = capitalize(diaSemana);
      print("Dia selecionado: $diaSemana");

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          backgroundColor: MyColors.azul3,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: MyColors.gradienteGeral,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
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
                child: DropdownButton<String>(
                  value: selectedItem,
                  isDense: true,
                  hint: const Text(
                    'Selecione um horário',
                    style: TextStyle(
                      color: MyColors.branco1,
                      fontSize: 16,
                    ),
                  ),
                  dropdownColor: const Color.fromARGB(30, 233, 236, 239),
                  iconEnabledColor: MyColors.branco1, // Define a cor do ícone
                  style: const TextStyle(
                    color: MyColors.branco1,
                    fontSize: 16,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  isExpanded: true,
                  items: items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedItem = newValue;
                    });
                  },
                  underline: SizedBox(),
                  icon: Padding(
                    padding: const EdgeInsets.only(
                        left:
                            8.0), 
                    child: const Icon(
                      Icons.arrow_drop_down,
                      color: MyColors.branco1,
                    ),
                  ),
                  padding: EdgeInsets.all(10),
                ),
              )
            ],
          ),
        ));
  }
}
