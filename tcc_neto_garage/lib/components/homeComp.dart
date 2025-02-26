import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tcc_neto_garage/shared/style.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agende agora!")),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
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
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Data selecionada: \${_selectedDay.toLocal()}".split(' ')[0],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Container(
            width: 239,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: MyColors.cinza2,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Text(
              "FEEDBACKS",
              style: TextStyle(
                color: MyColors.branco1,
                fontWeight: FontWeight.bold,
                fontFamily: MyFonts.fontSecundary,
                fontSize: 20,
              ),
            ),
          ),
          Expanded(child: FeedbackWidget()),
        ],
      ),
    );
  }
}

class FeedbackWidget extends StatefulWidget {
  @override
  _FeedbackWidgetState createState() => _FeedbackWidgetState();
}

class _FeedbackWidgetState extends State<FeedbackWidget> {
  final List<Map<String, dynamic>> _feedbacks = [];
  int _selectedStars = 0;

  void _addFeedback() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController _controller = TextEditingController();
        int tempStars = _selectedStars;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Adicionar Feedback"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: "Digite seu feedback"),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < tempStars ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setDialogState(() {
                            tempStars = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      setState(() {
                        _feedbacks.add({
                          'text': _controller.text,
                          'stars': tempStars,
                        });
                        _selectedStars = tempStars;
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text("Adicionar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 120,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MyColors.branco1,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _feedbacks.map((feedback) => ListTile(
                      title: Text(feedback['text']),
                      subtitle: Row(
                        children: List.generate(5, (index) =>
                          Icon(
                            index < feedback['stars'] ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    )).toList(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(Icons.add_circle, size: 20, color: Colors.grey),
              onPressed: _addFeedback,
            ),
          ),
        ],
      ),
    );
  }
}
