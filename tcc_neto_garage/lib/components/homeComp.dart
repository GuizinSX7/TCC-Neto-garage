import 'dart:async';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tcc_neto_garage/components/Menubar.dart';
import 'package:tcc_neto_garage/pages/camera.dart';
import 'package:tcc_neto_garage/shared/style.dart';
import 'package:camera/camera.dart';
import 'dart:convert';
import 'dart:io';

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
  XFile? imagem;

  late Timer _timer;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _comentarioController = TextEditingController();
  int _notaSelecionada = 0; // Padrão 5 estrelas
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<String?> _buscarCPFUsuario() async {
    String userId = _auth.currentUser?.uid ?? "";

    if (userId.isEmpty) return null;

    QuerySnapshot snapshot = await _firestore
        .collection("usuarios")
        .where("email", isEqualTo: _auth.currentUser?.email)
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

  Future<void> _enviarFeedback() async {
    try {
      String? cpf = await _buscarCPFUsuario();

      if (cpf == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Erro: CPF não encontrado.")));
        return;
      }

      // Consultar a coleção de feedbacks para contar quantos feedbacks já existem
      QuerySnapshot snapshot = await _firestore.collection("feedbacks").get();
      int feedbackCount = snapshot.docs.length;

      // Gerar um novo ID com base no número de feedbacks existentes
      String feedbackId = 'feedback_${feedbackCount + 1}';

      String? imagemBase64 = await _converterImagemParaBase64(imagem);

      // Adicionar o feedback com o ID gerado
      await _firestore.collection("feedbacks").doc(feedbackId).set({
        "CPF": cpf,
        "comentario": _comentarioController.text,
        "Nota": _notaSelecionada,
        "Imagem": imagemBase64,
        "criadoEm": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Feedback enviado!")));

      _comentarioController.clear();
      setState(() {
        _notaSelecionada = 5;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao enviar feedback. Tente novamente.")),
      );
    }
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

  Future<String?> _converterImagemParaBase64(XFile? imagem) async {
    if (imagem == null) {
      return null; // Retorna null caso não haja imagem
    }

    try {
      final bytes = await imagem.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print("Erro ao converter a imagem para base64: $e");
      return null;
    }
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
                enabledDayPredicate: (day) {
                  return !day
                      .isBefore(DateTime(_now.year, _now.month, _now.day));
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
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            width: 350,
            height: 270,
            decoration: BoxDecoration(
              color: MyColors.branco1,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: _comentarioController,
                      style: TextStyle(color: MyColors.preto1),
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(30, 233, 236, 239),
                        filled: true,
                        hintText: "Deixe seu comentário aqui",
                        hintStyle: TextStyle(
                            color: const Color.fromARGB(131, 0, 0, 0)),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: MyColors.preto1),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: MyColors.preto1),
                        ),
                      ),
                      maxLines: 3,
                      cursorColor: MyColors.preto1,
                      keyboardType: TextInputType.text,
                      validator: (String? comentario) {
                        if (comentario == null || comentario.isEmpty) {
                          return "Campo obrigatório";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.file_upload,
                        color: MyColors.azul2,
                        size: 30,
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _enviarFeedback();

                              String? imagemBase64 =
                                  await _converterImagemParaBase64(imagem);
                              if (imagemBase64 != null) {
                                print(
                                    "Imagem convertida para Base64: $imagemBase64");
                                // Aqui, você pode enviar a imagem para Firestore, por exemplo.
                              } else {
                                print("Nenhuma imagem foi selecionada.");
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(150, 45),
                            backgroundColor: MyColors.azul2,
                          ),
                          child: Text(
                            "Enviar",
                            style: TextStyle(
                                color: MyColors.branco1,
                                fontSize: 14,
                                fontFamily: MyFonts.fontTerc,
                                fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(width: 20),
                      GestureDetector(
                        child: Icon(
                          Icons.camera_alt,
                          color: MyColors.azul2,
                          size: 30,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => cameraFeedBack(
                                // Supondo que CameraPage seja o nome da página da câmera
                                imagemTirada: (XFile file) {
                                  setState(() {
                                    imagem = file;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
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
                                        backgroundImage: NetworkImage(
                                            "URL_TO_USER_IMAGE"), // Adicionar imagem de perfil
                                        child: Icon(Icons.person,
                                            color: Colors.white),
                                      ),
                                      title: Text(
                                        nomeUsuario,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
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
              )
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
