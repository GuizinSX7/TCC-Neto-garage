import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/components/Menubar.dart';
import 'package:tcc_neto_garage/components/VeiculoCard.dart';
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
  bool pagarNoLocal = false;

  List<Map<String, dynamic>> veiculos = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Map<String, dynamic>> _options = [
    {"title": "Lavagem de Motor", "isChecked": false},
    {"title": "Polimento e Vitrificação de farol (par)", "isChecked": false},
    {"title": "Vitrificação de Plásticos", "isChecked": false},
    {"title": "Vitrificação de Pintura", "isChecked": false},
    {"title": "Vitrificação de Couro", "isChecked": false},
    {"title": "Higienização de Bancos de Tecido", "isChecked": false},
    {"title": "Higienização de Bancos de Couro", "isChecked": false},
    {"title": "Remoção de Piche", "isChecked": false},
    {"title": "Remoção de Chuva Ácida", "isChecked": false},
    {"title": "Revitalizador de Plásticos Internos", "isChecked": false},
    {"title": "Revilatizador de Plásticos Externos", "isChecked": false},
    {
      "title":
          "Descontaminação + Enceramento (Cera em pasta com 7 meses de proteção)",
      "isChecked": false
    }
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is DateTime) {
      selectedDay = args;
      carregarHorariosDisponiveis();
      carregarGrausDeLavagem(); // ✅ Agora a lista de graus de lavagem será carregada também
    }
    carregarVeiculosUsuario().then((dados) {
      setState(() {
        veiculos = dados;
      });
    });
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

  Future<List<Map<String, dynamic>>> carregarVeiculosUsuario() async {
    try {
      String? cpfUsuario = await _buscarCPFUsuario();
      if (cpfUsuario == null) return [];

      QuerySnapshot snapshot = await _firestore
          .collection("veiculos cadastrados")
          .where("CPF", isEqualTo: cpfUsuario)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Erro ao carregar veículos: $e");
      return [];
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
                width: 240,
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
                    "SELECIONE UM GRAU DE LAVAGEM",
                    style: TextStyle(
                        fontSize: 14,
                        color: MyColors.branco1,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                height: 60,
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
                          backgroundColor: MyColors.branco1,
                          title: Text(
                            'Graus de lavagem',
                            style: TextStyle(
                              color: MyColors.preto1,
                            ),
                          ),
                          content: SizedBox(
                            width: 300,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: grausDeLavagem.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    grausDeLavagem[index],
                                    style: TextStyle(
                                      color: MyColors.preto1,
                                      fontSize: 16,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedItemGrauLavagem =
                                          grausDeLavagem[index];
                                    });
                                    Navigator.of(context).pop();
                                  },
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
                      Expanded(
                        child: Text(
                          selectedItemGrauLavagem ?? 'Graus de lavagem',
                          style: TextStyle(
                            color: MyColors.preto1,
                            fontSize: 16,
                          ),
                          overflow:
                              TextOverflow.ellipsis, // Adiciona os três pontos
                          maxLines: 1, // Limita a apenas uma linha
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
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
                    "SERVIÇOS EXTRAS",
                    style: TextStyle(
                        fontSize: 20,
                        color: MyColors.branco1,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                width: 320,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: MyColors.branco1,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: _options.map((option) {
                    return CheckboxListTile(
                      checkColor: MyColors.branco1,
                      activeColor: MyColors.azul2,
                      title: Text(
                        option["title"],
                        style: TextStyle(
                          color: MyColors.preto1,
                          fontSize: 16,
                        ),
                      ),
                      value: option["isChecked"],
                      onChanged: (bool? value) {
                        setState(() {
                          option["isChecked"] = value;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 40,
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
                height: 45,
              ),
              Container(
                width: 320,
                height: 150,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(30, 255, 255, 255),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: MyColors.branco1,
                    width: 2,
                  ),
                ),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: carregarVeiculosUsuario(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro ao carregar veículos'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Nenhum veículo cadastrado'));
                    }

                    List<Map<String, dynamic>> vehicles = snapshot.data!;

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: vehicles.map((vehicle) {
                          String vehicleType = vehicle['Categoria'] ?? 'Sedan';
                          String imagePath = ''; // Padrão para qualquer tipo de veículo

                          if (vehicleType.toLowerCase() == 'suv') {
                            imagePath = "assets/icons/SUV.png";// Ícone para SUV
                          } else if (vehicleType.toLowerCase() == 'sedan') {
                            imagePath =  "assets/icons/Sedan.png"; // Ícone para Sedã
                          } else if (vehicleType.toLowerCase() == 'moto') {
                            imagePath =  "assets/icons/Moto.png"; // Ícone para Moto
                          } else if (vehicleType.toLowerCase() == 'picape') {
                            imagePath =  "assets/icons/Picape.png"; // Ícone para Picape
                          } else if (vehicleType.toLowerCase() == 'hatch') {
                            imagePath =  "assets/icons/Hatch.png"; // Ícone para Hatch (usando o mesmo ícone de carro)
                          }

                          return Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: VehicleCard(
                              model: vehicle['Modelo'] ?? 'Desconhecido',
                              plate: vehicle['Placa'] ?? 'Sem placa',
                              vehicleIcon: imagePath,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Valor a ser pago",
                style: TextStyle(
                  color: MyColors.branco1,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 200,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(30, 255, 255, 255),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: MyColors.branco1,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    "R\$",
                    style: TextStyle(
                      color: MyColors.branco1,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Formas de pagamento",
                style: TextStyle(
                  color: MyColors.branco1,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(30, 255, 255, 255),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: MyColors.branco1,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 3,
                          ),
                          Icon(
                            Icons.credit_card,
                            color: MyColors.branco1,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            "Cartão de \ncrédito",
                            style: TextStyle(
                              color: MyColors.branco1,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(30, 255, 255, 255),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: MyColors.branco1,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 3,
                        ),
                        Icon(Icons.credit_card),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          "Cartão de \ndébito",
                          style: TextStyle(
                            color: MyColors.branco1,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(30, 255, 255, 255),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: MyColors.branco1,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 2,
                          ),
                          Icon(Icons.pix),
                          const SizedBox(
                            width: 3,
                          ),
                          Text("Pagar com \npix",
                              style: TextStyle(
                                color: MyColors.branco1,
                                fontSize: 12,
                              ))
                        ],
                      )),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: pagarNoLocal,
                    onChanged: (bool? newValue) {
                      setState(() {
                        pagarNoLocal = newValue!;
                      });
                    },
                    checkColor: MyColors.branco1,
                    activeColor: MyColors.azul2,
                  ),
                  Text(
                    "Pagar no local",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Icon(Icons.location_on),
                ],
              ),
              const SizedBox(
                height: 70,
              ),
              Menubar()
            ],
          ),
        ),
      ),
    );
  }
}
