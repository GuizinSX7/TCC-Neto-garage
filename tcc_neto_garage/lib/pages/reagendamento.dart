import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';

class reagendamentoHorario extends StatefulWidget {
  const reagendamentoHorario({super.key});

  @override
  State<reagendamentoHorario> createState() => _reagendamentoHorarioState();
}

class _reagendamentoHorarioState extends State<reagendamentoHorario> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final DateTime _now = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<String> diasIndisponiveis = [];
  String? selectedItemHorario;
  Map<String, dynamic>? selectedVehicle;
  Map<String, dynamic>? veiculoDoAgendamento;
  String? horarioSelecionadoAgendamento;
  DateTime diaAgendamento = DateTime.now();
  DateTime focusedDayAgendamento = DateTime.now();
  List<String> grausDeLavagem = [];
  List<String> items = [];

  // final _formKey = GlobalKey<FormState>();

  late Map<String, dynamic> agendamento;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Pegue os argumentos aqui
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      agendamento = args;

      // Exemplo de uso:
      veiculoDoAgendamento = agendamento['veiculo'];
      horarioSelecionadoAgendamento = agendamento['horario'];
      diaAgendamento = DateTime.parse(agendamento['data']);
      focusedDayAgendamento = diaAgendamento;
    }

    carregarHorariosDisponiveis();
    carregarDiasIndisponiveis();
  }

  String capitalize(String s) {
    return s[0].toUpperCase() + s.substring(1);
  }

  Future<void> carregarHorariosDisponiveis() async {
    try {
      String diaSemana = DateFormat('EEEE', 'pt_BR').format(_selectedDay);
      diaSemana = capitalize(diaSemana);
      String dataFormatada = DateFormat('yyyy-MM-dd').format(_selectedDay);

      // 1. Buscar horários padrão para o dia da semana
      final snapshotPadrao = await FirebaseFirestore.instance
          .collection('disponibilidade')
          .doc(diaSemana)
          .collection('horarios')
          .where('disponivel', isEqualTo: true)
          .get();

      List<String> horariosPadrao =
          snapshotPadrao.docs.map((doc) => doc.id).toList();

      // 2. Buscar agendamentos para a data selecionada
      final snapshotAgendados = await FirebaseFirestore.instance
          .collection('agendamentos')
          .doc(dataFormatada)
          .collection('horarios')
          .get();

      Set<String> horariosIndisponiveis =
          snapshotAgendados.docs.map((doc) => doc.id).toSet();

      // 3. Filtrar apenas horários disponíveis
      List<String> horariosDisponiveis = horariosPadrao
          .where((horario) => !horariosIndisponiveis.contains(horario))
          .toList();

      horariosDisponiveis.sort((a, b) {
        DateTime timeA = DateFormat('HH:mm').parse(a);
        DateTime timeB = DateFormat('HH:mm').parse(b);
        return timeA.compareTo(timeB);
      });

      setState(() {
        items = horariosDisponiveis;
      });
    } catch (e) {
      print("Erro ao carregar horários disponíveis: $e");
    }
  }

  Future<void> carregarDiasIndisponiveis() async {
    try {
      List<String> diasIndisponiveisTemp = [];

      final snapshotAgendamentos =
          await FirebaseFirestore.instance.collection('agendamentos').get();

      // Criar uma lista de Futures
      List<Future<void>> verificacoes = [];

      for (var docDia in snapshotAgendamentos.docs) {
        verificacoes.add(() async {
          String data = docDia.id;
          DateTime date = DateTime.parse(data);
          String diaSemana = DateFormat('EEEE', 'pt_BR').format(date);
          diaSemana = capitalize(diaSemana);

          final snapshotPadrao = await FirebaseFirestore.instance
              .collection('disponibilidade')
              .doc(diaSemana)
              .collection('horarios')
              .where('disponivel', isEqualTo: true)
              .get();

          int totalHorariosPadrao = snapshotPadrao.docs.length;

          final snapshotHorariosAgendados = await FirebaseFirestore.instance
              .collection('agendamentos')
              .doc(data)
              .collection('horarios')
              .get();

          int totalAgendados = snapshotHorariosAgendados.docs.length;

          if (totalAgendados >= totalHorariosPadrao &&
              totalHorariosPadrao > 0) {
            diasIndisponiveisTemp.add(data);
          }
        }());
      }

      // Espera todas as requisições serem concluídas
      await Future.wait(verificacoes);

      setState(() {
        diasIndisponiveis = diasIndisponiveisTemp;
      });
      print(diasIndisponiveis);
    } catch (e) {
      print("Erro ao carregar dias indisponíveis: $e");
    }
  }

  String formatarCategoria(String categoria) {
    if (categoria.isEmpty) return categoria;
    return categoria[0].toUpperCase() + categoria.substring(1).toLowerCase();
  }

  Future<void> atualizarAgendamento(DateTime novaDataSelecionada) async {
    String dataAntiga = DateFormat('yyyy-MM-dd').format(focusedDayAgendamento);
    String dataNova = DateFormat('yyyy-MM-dd').format(novaDataSelecionada);
    String horarioAntigo = (horarioSelecionadoAgendamento ?? '').trim();
    String horarioNovo = (selectedItemHorario ?? '').trim();

    print(
        'Movendo agendamento de $dataAntiga $horarioAntigo para $dataNova $horarioNovo');

    if (horarioNovo.isEmpty || horarioAntigo.isEmpty) {
      print("Horário novo ou antigo está vazio.");
      return;
    }

    try {
      final docRefAntigo = FirebaseFirestore.instance
          .collection('agendamentos')
          .doc(dataAntiga)
          .collection('horarios')
          .doc(horarioAntigo);

      final snapshot = await docRefAntigo.get();

      if (!snapshot.exists) {
        print("Agendamento antigo não encontrado.");
        return;
      }

      final dados = snapshot.data() as Map<String, dynamic>?;

      if (dados == null || dados.isEmpty) {
        print("Dados do agendamento estão vazios ou nulos.");
        return;
      }

      // Atualiza os campos de data e horário
      dados['horario'] = horarioNovo;
      dados['data'] = dataNova;

      final docRefNovo = FirebaseFirestore.instance
          .collection('agendamentos')
          .doc(dataNova)
          .collection('horarios')
          .doc(horarioNovo);

      // Garante que a data (documento pai) será "visível" com um campo opcional
      await FirebaseFirestore.instance
          .collection('agendamentos')
          .doc(dataNova)
          .set({'existe': true}, SetOptions(merge: true));

      // Cria o novo documento
      await docRefNovo.set(dados);

      // Remove o antigo
      await docRefAntigo.delete();
      print("Agendamento movido com sucesso para $dataNova às $horarioNovo.");

      // Verifica se ainda há agendamentos para a data antiga
      final horariosAntigosRef = FirebaseFirestore.instance
          .collection('agendamentos')
          .doc(dataAntiga)
          .collection('horarios');
      final horariosSnapshot = await horariosAntigosRef.get();

      // Se não houver mais agendamentos, deleta o documento da data antiga
      if (horariosSnapshot.docs.isEmpty) {
        await FirebaseFirestore.instance
            .collection('agendamentos')
            .doc(dataAntiga)
            .delete();
        print(
            "Documento da data antiga deletado, pois não há mais agendamentos.");
      }
    } catch (e) {
      print("Erro ao atualizar agendamento: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: MyColors.gradienteGeral,
        ),
        child: SingleChildScrollView(
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
              const SizedBox(
                height: 20,
              ),
              Text("Selecione uma data para reagendar",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MyColors.branco1,
                  )),
              const SizedBox(
                height: 35,
              ),
              Container(
                width: 350,
                decoration: BoxDecoration(
                  color: MyColors.branco1,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TableCalendar(
                    locale: 'pt_BR',
                    focusedDay: _focusedDay,
                    firstDay: DateTime(_now.year, _now.month, 1),
                    lastDay: DateTime(2040),
                    calendarFormat: _calendarFormat,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Mês',
                      CalendarFormat.twoWeeks: '2 Semanas',
                      CalendarFormat.week: 'Semana',
                    },
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      carregarHorariosDisponiveis();
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    enabledDayPredicate: (day) {
                      // Bloqueia dias antes da data atual
                      if (day.isBefore(
                          DateTime(_now.year, _now.month, _now.day))) {
                        return false;
                      }

                      // Bloqueia todas as sextas-feiras
                      if (day.weekday == DateTime.friday) {
                        return false;
                      }

                      // Bloqueia dias que estão na lista de diasIndisponiveis
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(day);
                      if (diasIndisponiveis.contains(formattedDate)) {
                        return false;
                      }

                      return true;
                    },
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: MyColors.azul2,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        shape: BoxShape.circle,
                      ),
                      disabledTextStyle:
                          TextStyle(color: MyColors.cinza1, fontSize: 16),
                      defaultTextStyle: TextStyle(
                        color: MyColors.preto1,
                        fontSize: 16,
                      ),
                      outsideDaysVisible: false,
                      weekendTextStyle: TextStyle(color: Colors.red),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: MyColors.preto1),
                      leftChevronIcon:
                          Icon(Icons.chevron_left, color: MyColors.preto1),
                      rightChevronIcon:
                          Icon(Icons.chevron_right, color: MyColors.preto1),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
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
                          color: MyColors.branco1,
                          borderRadius: BorderRadius.circular(12),
                          border: Border(
                            left: BorderSide(color: MyColors.branco1, width: 2),
                            right:
                                BorderSide(color: MyColors.branco1, width: 2),
                            bottom:
                                BorderSide(color: MyColors.branco1, width: 2),
                            top: BorderSide(color: MyColors.branco1, width: 2),
                          )),
                      offset: Offset(0, 0),
                    ),
                    items: items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                            color: MyColors.preto1,
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
                height: 35,
              ),
              ElevatedButton(
                onPressed: () {
                  atualizarAgendamento(_selectedDay);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.azul2,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  fixedSize: Size(200, 50),
                ),
                child: Text(
                  "Reagendar",
                  style: TextStyle(
                    fontSize: 15,
                    color: MyColors.branco1,
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
