import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/components/Menubar.dart';
import 'package:tcc_neto_garage/components/VeiculoCard.dart';
import 'package:tcc_neto_garage/pages/home.dart';
import 'package:tcc_neto_garage/shared/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

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
  num precoASerPago = 0;
  List<String> diasIndisponiveis = [];

  List<Map<String, dynamic>> veiculos = [];
  Map<String, dynamic>? selectedVehicle;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _options = [];

  final token = dotenv.env['TOKEN'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is DateTime) {
      selectedDay = args;
      carregarHorariosDisponiveis();
      carregarGrausDeLavagem();
    }

    carregarVeiculosUsuario().then((dados) {
      setState(() {
        veiculos = dados;

        if (selectedVehicle == null) {
          selectedVehicle = {"Categoria": "Hatch"};
          servicosExtras("Hatch");
        }
      });
    });
  }

  Future<void> carregarHorariosDisponiveis() async {
    try {
      String diaSemana = DateFormat('EEEE', 'pt_BR').format(selectedDay);
      diaSemana = capitalize(diaSemana);
      String dataFormatada = DateFormat('yyyy-MM-dd').format(selectedDay);

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

  Future<void> carregarGrausDeLavagem() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('graus de lavagem')
          .doc('Descrições')
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;

        List<MapEntry<String, String>> grausList = [];
        String? moto;

        data.forEach((key, value) {
          if (key.toLowerCase().contains('moto')) {
            moto = "$key: $value";
          } else {
            grausList.add(MapEntry(key, value));
          }
        });

        grausList.sort((a, b) {
          final regExp = RegExp(r'\d+');
          final numA =
              int.tryParse(regExp.firstMatch(a.key)?.group(0) ?? '') ?? 0;
          final numB =
              int.tryParse(regExp.firstMatch(b.key)?.group(0) ?? '') ?? 0;
          return numA.compareTo(numB);
        });

        List<String> graus =
            grausList.map((e) => "${e.key}: ${e.value}").toList();

        if (moto != null) {
          graus.add(moto!);
        }

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

  String formatarCategoria(String categoria) {
    if (categoria.isEmpty) return categoria;
    return categoria[0].toUpperCase() + categoria.substring(1).toLowerCase();
  }

  Future<void> calcularPrecoLavagem() async {
    try {
      precoASerPago = 0;

      String categoriaVeiculo =
          formatarCategoria(selectedVehicle!["Categoria"]);

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('graus de lavagem')
          .doc(categoriaVeiculo)
          .get();

      if (!doc.exists) {
        print(
            "Documento '$categoriaVeiculo' não encontrado na coleção 'graus de lavagem'.");
        return;
      }

      if (selectedItemGrauLavagem != null) {
        String extrairGrau(String texto) {
          RegExp regex =
              RegExp(r'grau [1-3]|Grau de moto', caseSensitive: false);
          Match? match = regex.firstMatch(texto);
          return match != null ? match.group(0)! : '';
        }

        if (extrairGrau(selectedItemGrauLavagem!) == "Grau de moto") {
          String tipoMoto = selectedVehicle!['TipoMoto'] ?? '';

          if (tipoMoto.contains("Grande")) {
            precoASerPago += 60;
          } else if (tipoMoto.contains("Media")) {
            precoASerPago += 40;
          } else {
            print("Tipo de moto não reconhecido.");
          }
        } else {
          String chaveGrau = extrairGrau(selectedItemGrauLavagem!);
          if (chaveGrau.isNotEmpty) {
            dynamic precoGrau = doc.get(chaveGrau);
            if (precoGrau is num) {
              precoASerPago += precoGrau;
            } else {
              print("Preço do grau não é um número.");
            }
          } else {
            print("Grau de lavagem não encontrado no texto.");
          }
        }
        print("Preço a ser pago: $precoASerPago");
      } else {
        print("Erro: 'selectedItemGrauLavagem' está nulo.");
      }
    } catch (e) {
      print("Erro ao calcular preço da lavagem: $e");
    }
  }

  Future<void> servicosExtras(String categoriaCarro) async {
    categoriaCarro = formatarCategoria(selectedVehicle!["Categoria"]);

    final doc = await FirebaseFirestore.instance
        .collection('servicos extras')
        .doc(categoriaCarro)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      final List<Map<String, dynamic>> tempOptions = [];

      final servicos = [
        {"title": "Lavagem de Motor", "key": "Lavagem de motor"},
        {
          "title": "Polimento e Vitrificação de farol (par)",
          "key": "Polimento de farol"
        },
        {
          "title": "Vitrificação de Plásticos",
          "key": "Vitrificacao de plasticos"
        },
        {"title": "Vitrificação de Pintura", "key": "Vitrificacao de pintura"},
        {"title": "Vitrificação de Couro", "key": "Vitrificacao de couro"},
        {
          "title": "Higienização de Bancos de Tecido",
          "key": "Higienizacao de bancos em tecidos"
        },
        {
          "title": "Higienização de Bancos de Couro",
          "key": "Higienizacao de bancos em couro"
        },
        {"title": "Remoção de Piche", "key": "Remocao de piche"},
        {"title": "Remoção de Chuva Ácida", "key": "Remocao de chuva acida"},
        {
          "title": "Revitalizador de Plásticos interno e externo",
          "key": "Revitalizacao de plasticos"
        },
        {
          "title":
              "Descontaminação + Enceramento (Cera em pasta com 7 meses de proteção)",
          "key": "Lavagem de descontaminacao mais enceramento em pasta"
        },
      ];

      for (var servico in servicos) {
        final key = servico["key"];
        if (data.containsKey(key)) {
          tempOptions.add({
            "title": servico["title"],
            "isChecked": false,
            "price": data[key]
          });
        }
      }

      setState(() {
        _options = tempOptions;
      });
      print(_options);
    }
  }

  Future<String?> criarLinkPagamento({
    required String token,
    required String titulo,
  }) async {
    final url = Uri.parse('https://api.mercadopago.com/checkout/preferences');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
      "items": [
        {
          "title": titulo,
          "quantity": 1,
          "currency_id": "BRL",
          "unit_price": precoASerPago,
        }
      ],
      "auto_return": "approved",
      "back_urls": {
        "success": "meuapp://pagamento/sucesso",
        "failure": "meuapp://pagamento/falha",
      },
      "payment_methods": {
        "excluded_payment_types": [
          {"id": "ticket"},
          {"id": "atm"},
          {"id": "digital_currency"},
          {"id": "paypal"}
        ],
        "installments": 1
      },
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print(data['init_point']);
      return data['init_point'];
    } else {
      print("Erro: ${response.body}");
      return null;
    }
  }

  Future<void> agendarHorario() async {
    try {
      final cpfUsuario = await _buscarCPFUsuario();

      if (selectedItemHorario == null ||
          selectedItemGrauLavagem == null ||
          selectedVehicle == null) {
        print("Dados incompletos para agendamento.");
        return;
      }

      final String dataFormatada = DateFormat('yyyy-MM-dd').format(selectedDay);

      final servicosSelecionados = _options
          .where((servico) => servico["isChecked"] == true)
          .map((servico) => {
                "titulo": servico["title"],
                "preco": servico["price"],
              })
          .toList();

      final agendamento = {
        "userID": cpfUsuario,
        "data": dataFormatada,
        "horario": selectedItemHorario,
        "grauLavagem": selectedItemGrauLavagem,
        "veiculo": selectedVehicle,
        "preco": precoASerPago,
        "servicosExtras": servicosSelecionados,
        "criadoEm": FieldValue.serverTimestamp(),
        "disponivel": false,
      };

      await _firestore.collection('agendamentos').doc(dataFormatada).set(
          {'criadoEm': FieldValue.serverTimestamp()}, SetOptions(merge: true));

      await _firestore
          .collection('agendamentos')
          .doc(dataFormatada)
          .collection('horarios')
          .doc(selectedItemHorario)
          .set(agendamento);

      print("Agendamento criado com sucesso!");
    } catch (e) {
      print("Erro ao agendar horário: $e");
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
                                final grau = grausDeLavagem[index];
                                final isMoto =
                                    grau.toLowerCase().contains('moto');
                                final isCategoriaMoto =
                                    (selectedVehicle?["Categoria"]
                                                ?.toLowerCase() ??
                                            '') ==
                                        'moto';
                                final isDisabled = isCategoriaMoto && !isMoto;

                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isDisabled
                                          ? Colors.grey
                                          : MyColors.preto1,
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      grau,
                                      style: TextStyle(
                                        color: isDisabled
                                            ? Colors.grey
                                            : MyColors.preto1,
                                        fontSize: 16,
                                      ),
                                    ),
                                    enabled: !isDisabled,
                                    onTap: isDisabled
                                        ? null
                                        : () {
                                            setState(() {
                                              selectedItemGrauLavagem = grau;
                                            });
                                            Navigator.of(context).pop();
                                            calcularPrecoLavagem();
                                          },
                                  ),
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
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
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
                        '${option["title"]}',
                        style: TextStyle(
                          color: MyColors.preto1,
                          fontSize: 16,
                        ),
                      ),
                      value: option["isChecked"],
                      onChanged: (bool? value) {
                        setState(() {
                          option["isChecked"] = value!;

                          if (value) {
                            precoASerPago += option["price"];
                          } else {
                            precoASerPago -= option["price"];
                          }
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
                          String vehicleType =
                              vehicle['Categoria']?.toLowerCase() ?? 'sedã';
                          String imagePath = '';

                          switch (vehicleType) {
                            case 'suv':
                              imagePath = "assets/icons/SUV.png";
                              break;
                            case 'sedã':
                              imagePath = "assets/icons/Sedan.png";
                              break;
                            case 'moto':
                              imagePath = "assets/icons/Moto.png";
                              break;
                            case 'picape':
                              imagePath = "assets/icons/Picape.png";
                              break;
                            case 'hatch':
                              imagePath = "assets/icons/Hatch.png";
                              break;
                          }

                          bool isSelected = selectedVehicle != null &&
                              selectedVehicle!['Placa'] == vehicle['Placa'];

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedVehicle = vehicle;
                              });

                              final categoria = vehicle['Categoria'];
                              servicosExtras(categoria);

                              calcularPrecoLavagem();
                              print(precoASerPago);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? MyColors.azul3
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? MyColors.azul3
                                        : Colors.transparent,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: VehicleCard(
                                  model: vehicle['Modelo'] ?? 'Desconhecido',
                                  plate: vehicle['Placa'] ?? 'Sem placa',
                                  vehicleIcon: imagePath,
                                ),
                              ),
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
                    "R\$ ${precoASerPago.toStringAsFixed(2)}",
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
                "Confirmar agendamento",
                style: TextStyle(
                  color: MyColors.branco1,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    // final link = await criarLinkPagamento(
                    //     token: "${token}",
                    //     titulo: "Agendamento para o dia ${selectedDay}");

                    // if (link != null) {
                    //   final uri = Uri.parse(link);
                    //   if (await canLaunchUrl(uri)) {
                    //     await launchUrl(uri, mode: LaunchMode.externalApplication);
                    //   } else {
                    //     print("Não foi possível abrir o link");
                    //   }
                    // }

                    await agendarHorario();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.azul3,
                    foregroundColor: MyColors.branco1,
                  ),
                  child: Text(
                    "Pagar",
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
