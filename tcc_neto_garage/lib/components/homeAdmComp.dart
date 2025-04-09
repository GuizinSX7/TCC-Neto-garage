import 'dart:async';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc_neto_garage/components/Menubar.dart';
import 'package:tcc_neto_garage/shared/style.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class HomeAdmComp extends StatefulWidget {
  @override
  State<HomeAdmComp> createState() => _HomeAdmCompState();
}

class _HomeAdmCompState extends State<HomeAdmComp> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _now = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  XFile? imagem;
  XFile? foto;

  late Timer _timer;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(hours: 1), (timer) {
      DateTime now = DateTime.now();
      if (_focusedDay.month != now.month) {
        setState(() {
          _now = now;
          _focusedDay = DateTime(now.year, now.month, 1);
          _selectedDay = now;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<String?> _buscarNomeUsuario(String cpf) async {
    if (cpf.isEmpty) return null;

    DocumentSnapshot snapshot =
        await _firestore.collection("usuarios").doc(cpf).get();

    if (snapshot.exists) {
      return snapshot["nome completo"];
    } else {
      return "Usuário não encontrado";
    }
  }

  Future<Widget> _exibirImagemBase64(String? imagemBase64) async {
    if (imagemBase64 == null || imagemBase64.isEmpty) {
      return SizedBox(); // Retorna um SizedBox vazio se não houver imagem
    }
    try {
      // Decodificar a string base64
      final bytes = base64Decode(imagemBase64);

      // Retornar o widget Image
      return Image.memory(
        bytes,
        width: 200,
        height: 200,
        fit: BoxFit.contain,
      );
    } catch (e) {
      return Text('Erro ao carregar imagem');
    }
  }

  Future<List<String>> buscarHorariosIndisponiveis(String diaSemana) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('agendamentos')
        .doc(diaSemana)
        .collection('horarios')
        .where('disponivel', isEqualTo: false)
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  void mostrarHorariosIndisponiveis(
      BuildContext context, String diaSemana) async {
    final horarios = await buscarHorariosIndisponiveis(diaSemana);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Horários indisponíveis em $diaSemana'),
        content: horarios.isEmpty
            ? Text('Todos os horários estão disponíveis!')
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: horarios
                    .map((hora) => ListTile(
                          leading: Icon(Icons.block, color: Colors.red),
                          title: Text(hora),
                        ))
                    .toList(),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar', style: TextStyle(color: MyColors.branco1)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 100),
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

                  // Pega o nome do dia da semana em português
                  final diasSemana = [
                    'Segunda-feira',
                    'Terça-feira',
                    'Quarta-feira',
                    'Quinta-feira',
                    'Sexta-feira',
                    'Sábado',
                    'Domingo'
                  ];

                  String dia = diasSemana[selectedDay.weekday - 1];

                  mostrarHorariosIndisponiveis(context, dia);
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                enabledDayPredicate: (day) {
                  // Bloqueia dias antes da data atual
                  if (day.isBefore(DateTime(_now.year, _now.month, _now.day))) {
                    return false;
                  }

                  // Bloqueia todas as sextas-feiras
                  if (day.weekday == DateTime.friday) {
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
          const SizedBox(height: 50),
          Container(
              width: 350,
              height: 300,
              decoration: BoxDecoration(
                color: MyColors.branco1,
                borderRadius: BorderRadius.circular(10),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection("feedbacks")
                    .orderBy("criadoEm", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("Nenhum feedback ainda."));
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 0),
                          children: snapshot.data!.docs.map((doc) {
                            Map<String, dynamic> data =
                                doc.data() as Map<String, dynamic>;
                            String cpfFeedback = data["CPF"];
                            String? imagemBase64 = data["Imagem"];
                            return FutureBuilder<String?>(
                              future: _buscarNomeUsuario(cpfFeedback),
                              builder: (context, userSnapshot) {
                                if (userSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      child: Icon(Icons.person,
                                          color: Colors.white),
                                    ),
                                    title: Text("Carregando..."),
                                  );
                                }
                                String nomeUsuario =
                                    userSnapshot.data ?? "Usuário Anônimo";

                                return Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        child: Icon(Icons.person,
                                            color: Colors.white),
                                      ),
                                      title: Text(
                                        nomeUsuario,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: MyColors.preto1,
                                            fontSize: 14),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(data["comentario"] ?? "",
                                              style: TextStyle(
                                                  color: Colors.black54)),
                                          SizedBox(height: 5),
                                          Row(
                                            children: List.generate(5, (index) {
                                              return Icon(
                                                index < data["Nota"]
                                                    ? Icons.star
                                                    : Icons.star_border,
                                                color: Colors.amber,
                                              );
                                            }),
                                          ),
                                          FutureBuilder<Widget>(
                                            future: _exibirImagemBase64(
                                                imagemBase64),
                                            builder: (context, imageSnapshot) {
                                              if (imageSnapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              }
                                              return imageSnapshot.data ??
                                                  SizedBox();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      if (!_isExpanded)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Text(
                            "Mostrar mais",
                            style: TextStyle(
                              color: MyColors.azul1,
                              fontSize: 14,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              )),
          const SizedBox(
            height: 50,
          ),
          Menubar(),
        ],
      ),
    );
  }
}
