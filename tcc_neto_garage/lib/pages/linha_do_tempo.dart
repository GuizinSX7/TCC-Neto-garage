import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TimelineScreen(),
    );
  }
}

class TimelineScreen extends StatefulWidget {
  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final List<TimelineEvent> events = [
    TimelineEvent(
      date: 'Junho de 2024',
      description:
          'Aqui foi o começo de tudo, depois de um tempo já possuindo alguns produtos e cuidando dos nossos carros, eu e meu irmão decidimos lavar carros para fora pois muitas pessoas elogiavam a maneira que nossos carros eram sempre muito limpos e com um brilho máximo.',
      imagePath: 'assets/images/image 2.png',
      width: 130,
      height: 270,
    ),
    TimelineEvent(
      date: 'Setembro de 2024',
      description:
          'Depois de 2 meses trabalhando e lavando muitos carros, conseguimos adquirir novos produtos para cada vez mais melhorar nossos serviços, buscando a satisfação total dos nossos clientes com um carro no brilho máximo.',
      imagePath: 'assets/images/image 3.png',
      width: 138,
      height: 212,
    ),
    TimelineEvent(
      date: 'Novembro de 2024',
      description:
          'Fizemos o cadastro no Google Business da Neto Garage para ter um alcance maior e as pessoas conhecerem nosso serviço, aonde estamos localizados e o horário de funcionamento da nossa empresa.',
      imagePath: 'assets/images/image 5.png',
      width: 160,
      height: 198,
    ),
    TimelineEvent(
      date: 'Janeiro de 2025',
      description:
          'Após lavar muitos carros, conseguimos realizar nosso sonho que era fechar uma parceria com uma marca tão relevante e importante no cenário das estéticas automotivas como a Vonix.',
      imagePath: 'assets/images/image 4.png',
      width: 141,
      height: 194,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: MyColors.gradienteGeral,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: MyColors.branco1,
                      size: 24,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Image.asset(
                  'assets/images/Logo.png',
                  width: 230,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return TimelineItem(
                      event: events[index],
                      isFirst: index == 0,
                      isLast: index == events.length - 1,
                      isTextLeft: index % 2 != 0,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimelineEvent {
  final String date;
  final String description;
  final String imagePath;
  final double width;
  final double height;

  TimelineEvent({
    required this.date,
    required this.description,
    required this.imagePath,
    required this.width,
    required this.height,
  });
}

class TimelineItem extends StatelessWidget {
  final TimelineEvent event;
  final bool isFirst;
  final bool isLast;
  final bool isTextLeft;

  const TimelineItem(
      {required this.event,
      required this.isFirst,
      required this.isLast,
      required this.isTextLeft});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: isTextLeft
            ? [
                Expanded(
                  child: Image.asset(
                    event.imagePath,
                    width: event.width,
                    height: event.height,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    if (!isFirst) Container(width: 4, height: 50, color: Colors.blue),
                    Container(width: 16, height: 16, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue)),
                    if (!isLast) Container(width: 4, height: 50, color: Colors.blue),
                  ],
                ),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(event.date, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text(event.description, style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ),
              ]
            : [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(event.date, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text(event.description, style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    if (!isFirst) Container(width: 4, height: 50, color: Colors.blue),
                    Container(width: 16, height: 16, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue)),
                    if (!isLast) Container(width: 4, height: 50, color: Colors.blue),
                  ],
                ),
                Expanded(
                  child: Image.asset(
                    event.imagePath,
                    width: event.width,
                    height: event.height,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
      ),
    );
  }
}
