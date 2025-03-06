import 'dart:async';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tcc_neto_garage/components/Menubar.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class HomeComp extends StatefulWidget {
  const HomeComp({super.key});

  @override
  State<HomeComp> createState() => _HomeCompState();
}

class _HomeCompState extends State<HomeComp> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _now = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  late Timer _timer;

  final TextEditingController _comentarioController = TextEditingController();
  int _notaSelecionada = 0; // Padrão 5 estrelas
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<String?> _buscarCPFUsuario() async {
    String userId = _auth.currentUser?.uid ?? "";

    if (userId.isEmpty) return null;

    QuerySnapshot snapshot = await _firestore
        .collection("usuarios")
        .where("email", isEqualTo: _auth.currentUser?.email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    }
    return null;
  }

  Future<void> _enviarFeedback() async {
    String? cpf = await _buscarCPFUsuario();

    if (cpf == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erro: CPF não encontrado.")));
      return;
    }

    await _firestore.collection("feedbacks").add({
      "CPF": cpf,
      "comentario": _comentarioController.text,
      "nota": _notaSelecionada,
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Feedback enviado!")));

    _comentarioController.clear();
    setState(() {
      _notaSelecionada = 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 100),
          Text(
            "Agende seu horário!",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: MyColors.branco1),
          ),
          const SizedBox(height: 30),
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
                  if (selectedDay.isBefore(_now)) {
                    return; // Impede a seleção de datas passadas
                  }
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
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
                  outsideDaysVisible: false,
                  weekendTextStyle: TextStyle(color: Colors.red),
                  defaultTextStyle: TextStyle(fontSize: 16),
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
            width: 220,
            height: 40,
            decoration: BoxDecoration(
              color: MyColors.cinza2,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                "FEEDBACK",
                style: TextStyle(
                  fontSize: 20,
                  color: MyColors.branco1,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          Container(
            width: 350,
            decoration: BoxDecoration(
              color: MyColors.branco1,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _notaSelecionada
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        setState(() {
                          _notaSelecionada = index + 1;
                        });
                      },
                    );
                  }),
                ),
                TextField(
                  controller: _comentarioController,
                  decoration: InputDecoration(labelText: "Comentário"),
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _enviarFeedback,
                  child: Text("Enviar"),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            width: 300,
            height: 150,
            decoration: BoxDecoration(
              color: MyColors.branco1,
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
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    return ListTile(
                      leading: Icon(Icons.person, color: Colors.blue),
                      title: Text(data["comentario"] ?? ""),
                      subtitle: Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < data["nota"]
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          );
                        }),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Menubar(),
        ],
      ),
    );
  }
}
