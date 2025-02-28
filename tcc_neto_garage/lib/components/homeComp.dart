import 'dart:async';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TableCalendar(
            locale: 'pt_BR',
            focusedDay: _focusedDay,
            firstDay: DateTime(_now.year, _now.month, 1), // Bloqueia meses passados
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
          ),
        ],
      ),
    );
  }
}
