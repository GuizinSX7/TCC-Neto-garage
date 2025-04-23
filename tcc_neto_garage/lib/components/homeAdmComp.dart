import 'dart:async';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc_neto_garage/components/Menubar.dart';
import 'package:tcc_neto_garage/shared/style.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeAdmComp extends StatefulWidget {
  @override
  State<HomeAdmComp> createState() => _HomeAdmCompState();
}

class _HomeAdmCompState extends State<HomeAdmComp> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _now = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  late Timer _timer;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _buscarHorariosDoDia(_selectedDay);
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

  Future<List<Map<String, dynamic>>> _buscarHorariosDoDia(
      DateTime diaSelecionado) async {
    final dataFormatada = DateFormat('yyyy-MM-dd').format(diaSelecionado);
    final docRef = FirebaseFirestore.instance
        .collection('agendamentos')
        .doc(dataFormatada)
        .collection('horarios');

    final snapshot = await docRef.get();

    List<Map<String, dynamic>> horarios = [];

    for (var doc in snapshot.docs) {
      final dados = doc.data();
      final servicosExtras = dados['servicosExtras'] ?? [];

      horarios.add({
        'horario': doc.id,
        'modelo': dados['veiculo']?['Modelo'] ?? 'Não informado',
        'grauLavagem': dados['grauLavagem'] ?? 'Não informado',
        'placa': dados['veiculo']?['Placa'] ?? 'Não informado',
        'servicosExtras': List<Map<String, dynamic>>.from(servicosExtras),
      });
    }

    return horarios;
  }

  void _mostrarModalHorarios(BuildContext context, DateTime dia) async {
    List<Map<String, dynamic>> horarios = await _buscarHorariosDoDia(dia);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Horários agendados"),
          content: horarios.isEmpty
              ? Text("Nenhum horário agendado para este dia.")
              : SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: horarios.length,
                    itemBuilder: (context, index) {
                      final horario = horarios[index];
                      return ListTile(
                        leading: Icon(Icons.access_time),
                        title: Text("${horario['horario']}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Modelo: ${horario['modelo']}"),
                            Text(
                                "Grau da Lavagem: ${horario['grauLavagem'].toString().split(':')[0]}"),
                            Text("Placa: ${horario['placa']}"),
                            if ((horario['servicosExtras'] as List)
                                .isNotEmpty) ...[
                              Text("Serviços Extras:"),
                              ...horario['servicosExtras']
                                  .map<Widget>((servico) {
                                return Text("- ${servico['titulo']}");
                              }).toList(),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
              child: Text(
                "Fechar",
                style: TextStyle(color: MyColors.branco1),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<List<double>> calcularFaturamentoAnual() async {
    List<double> faturamentoMensal = List.generate(12, (index) => 0.0);
    final agora = DateTime.now();
    final anoAtual = agora.year;

    final agendamentosSnapshot =
        await _firestore.collection('agendamentos').get();

    for (var doc in agendamentosSnapshot.docs) {
      final dataDoc = doc.id;

      try {
        final data = DateTime.parse(dataDoc);

        if (data.year == anoAtual) {
          final horariosSnapshot =
              await doc.reference.collection('horarios').get();

          for (var horarioDoc in horariosSnapshot.docs) {
            final dados = horarioDoc.data();
            // Valor da lavagem
            double precoLavagem =
                double.tryParse(dados['preco'].toString()) ?? 0.0;
            faturamentoMensal[data.month - 1] +=
                precoLavagem; // Adiciona o valor de cada mês
          }
        }
      } catch (e) {
        print('Erro ao processar agendamento em $dataDoc: $e');
      }
    }

    return faturamentoMensal;
  }

  Widget _buildBarChartAnual(List<double> faturamentoMensal) {
    return BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < 12) {
                    List<String> meses = [
                      "Jan",
                      "Fev",
                      "Mar",
                      "Abr",
                      "Mai",
                      "Jun",
                      "Jul",
                      "Ago",
                      "Set",
                      "Out",
                      "Nov",
                      "Dez"
                    ];
                    return SideTitleWidget(
                      meta: meta,
                      space: 4,
                      child: Text(
                        meses[index],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: MyColors.preto1,
                        ),
                      ),
                    );
                  }
                  return Container();
                }),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        barGroups: List.generate(12, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                fromY: 0,
                toY: faturamentoMensal[index],
                color: MyColors.azul2,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
            showingTooltipIndicators: [0],
          );
        }),
        barTouchData: BarTouchData(
          enabled: false,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.transparent,
            tooltipPadding: EdgeInsets.zero,
            tooltipMargin: 4,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                rod.toY.toStringAsFixed(2),
                TextStyle(
                  color: MyColors.preto1,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              );
            },
          ),
        ),
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

                  _mostrarModalHorarios(context, selectedDay);
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                enabledDayPredicate: (day) {
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
                    return Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: MyColors.azul3,
                    ));
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
                                                return CircularProgressIndicator(
                                                  strokeWidth: 3,
                                                  color: MyColors.azul3,
                                                );
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
          Container(
            decoration: BoxDecoration(
              color: MyColors.branco1,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 350,
            width: 350,
            child: FutureBuilder<List<double>>(
              future: calcularFaturamentoAnual(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: MyColors.azul3,
                      ),
                    ),
                  );
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Text("Erro ao carregar faturamento anual.");
                }

                final faturamentoMensal = snapshot.data!;
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 350,
                        height: 250,
                        child: _buildBarChartAnual(faturamentoMensal),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Faturamento",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: MyColors.preto1),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 50,
          ),
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
                "Usuários cadastrados",
                style: TextStyle(
                    fontSize: 20,
                    color: MyColors.branco1,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              width: 350,
              height: 100,
              decoration: BoxDecoration(
                color: MyColors.branco1,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Icon(Icons.person, color: MyColors.preto1, size: 70),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 2,
                    height: 80,
                    decoration: BoxDecoration(
                      color: MyColors.preto1,
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Text("CLENTES",
                      style: TextStyle(
                        fontSize: 30,
                        color: MyColors.preto1,
                      ))
                ],
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, "/ClientesCadastrados");
            },
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
