import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class Cadastroveiculo extends StatefulWidget {
  const Cadastroveiculo({super.key});

  @override
  State<Cadastroveiculo> createState() => _CadastroveiculoState();
}

class _CadastroveiculoState extends State<Cadastroveiculo> {
  String? selectedVehicle;
  String? selectedColor;
  String? tipoMoto;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _observacoesController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> _buscarCPFUsuario() async {
    String userId = _auth.currentUser?.uid ?? "";

    if (userId.isEmpty) return null;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
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

  void selectVehicle(String vehicleName) {
    setState(() {
      selectedVehicle = vehicleName;
    });
  }

  void selectColor(String colorName) {
    setState(() {
      selectedColor = colorName;
    });
  }

  Future<bool> verificarPlacaExistente(String placa) async {
    placa = placa.toUpperCase();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('veiculos cadastrados')
        .where('Placa', isEqualTo: placa)
        .get();

    print(
        "Consulta de placa retornou ${querySnapshot.docs.length} resultados.");

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> cadastrarVeiculo() async {
    if (selectedVehicle == null || selectedColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("Selecione um veículo e uma cor antes de cadastrar.")),
      );
      return;
    }
    if (selectedVehicle == "moto" && tipoMoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Você precisa selecionar o tipo da moto antes de cadastrar.")),
      );
      return;
    }

    String? cpfUsuario = await _buscarCPFUsuario();

    if (cpfUsuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao buscar o CPF do usuário.")),
      );
      return;
    }

    String placa = _placaController.text.trim();

    // Verifica se a placa já está cadastrada
    bool placaExistente = await verificarPlacaExistente(placa);

    if (placaExistente) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Placa já cadastrada!")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('veiculos cadastrados').add({
        'CPF': cpfUsuario, // Adicionando o CPF ao cadastro
        'Categoria': selectedVehicle,
        'Cor': selectedColor,
        'Modelo': _modeloController.text,
        'Placa': placa.toUpperCase(),
        'TipoMoto': selectedVehicle == 'moto' ? tipoMoto : null,
        'Observacoes': _observacoesController.text,
        'dataCadastro': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veículo cadastrado com sucesso!")),
      );

      Future.delayed(const Duration(milliseconds: 1000), () {
        Navigator.pushReplacementNamed(context, "/Home");
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao cadastrar: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: MyColors.gradienteGeral,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
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
                const SizedBox(height: 7),
                const Text(
                  'Cadastro de Veículo:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: MyFonts.fontSecundary,
                    color: MyColors.branco1,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Selecione a categoria do seu \nveículo:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: MyFonts.fontSecundary,
                    color: MyColors.branco1,
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSelectableIcon(
                                "picape", "assets/icons/Picape.png", "Picape"),
                            const SizedBox(width: 39.11),
                            _buildSelectableIcon(
                                "moto", "assets/icons/Moto.png", "Moto"),
                            const SizedBox(width: 39.11),
                            _buildSelectableIcon(
                                "hatch", "assets/icons/Hatch.png", "Hatch"),
                          ],
                        ),
                        const SizedBox(height: 32.11),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSelectableIcon(
                                "SUV", "assets/icons/SUV.png", "SUV"),
                            const SizedBox(width: 39.11),
                            _buildSelectableIcon(
                                "sedã", "assets/icons/Sedan.png", "Sedã"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                buildForm(context),
                const SizedBox(
                  height: 48,
                ),
                if (selectedVehicle == "moto") ...[
                  Container(
                    width: 300,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(30, 233, 236, 239),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: MyColors.branco1, width: 1),
                    ),
                    child: DropdownButtonFormField2<String>(
                        value: tipoMoto,
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            color: MyColors.branco1,
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        iconStyleData: IconStyleData(
                          icon: Icon(Icons.arrow_drop_down,
                              color: MyColors.branco1),
                        ),
                        buttonStyleData: const ButtonStyleData(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          height: 50,
                          width: double.infinity,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        hint: Text(
                          "Tipo da moto",
                          style: TextStyle(
                            color: MyColors.branco4,
                          ),
                        ),
                        items: ['Media', 'Grande'].map((tipo) {
                          return DropdownMenuItem<String>(
                            value: tipo,
                            child: Text(
                              tipo,
                              style: const TextStyle(color: MyColors.preto1),
                            ),
                          );
                        }).toList(),
                        selectedItemBuilder: (context) {
                          return ['Media', 'Grande'].map((tipo) {
                            return Text(
                              tipo,
                              style: TextStyle(color: MyColors.branco1),
                            );
                          }).toList();
                        },
                        onChanged: (value) {
                          setState(() {
                            tipoMoto = value;
                          });
                        },
                        validator: (value) {
                          if (selectedVehicle == "moto" && value == null) {
                            return "Selecione o tipo da moto.";
                          }
                          return null;
                        }),
                  ),
                  const SizedBox(
                    height: 28,
                  )
                ],
                const SizedBox(height: 20),
                Container(
                  width: 304,
                  height: 166,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(30, 233, 236, 239),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: MyColors.branco1, width: 1),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Cor:",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: MyFonts.fontTerc,
                          color: MyColors.branco1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildColorButton("Verde", Color(0xFF14532D)),
                          const SizedBox(width: 13.05),
                          _buildColorButton("Azul claro", Color(0xFF38BDF8)),
                          const SizedBox(width: 13.05),
                          _buildColorButton("Azul Escuro", Color(0xFF1E3A8A)),
                          const SizedBox(width: 13.05),
                          _buildColorButton("Rosa", Color(0xFFF472B6)),
                          const SizedBox(width: 13.05),
                          _buildColorButton("Roxo", Color(0xFF4C1D95)),
                          const SizedBox(width: 13.05),
                          _buildColorButton("Branco", MyColors.branco1),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildColorButton("Amarelo", Color(0xFFFACC15)),
                          const SizedBox(width: 13.05),
                          _buildColorButton("laranja", Color(0xFFF59E0B)),
                          const SizedBox(width: 13.05),
                          _buildColorButton("Vermelho", Color(0xFFDC2626)),
                          const SizedBox(width: 13.05),
                          _buildColorButton("Preto", MyColors.preto1),
                          const SizedBox(width: 13.05),
                          _buildColorButton("Marrom", Color(0xFF713F12)),
                          const SizedBox(width: 13.05),
                          _buildColorButton("Cinza", Color(0xFFA8A29E)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 34),
                Container(
                  width: 304,
                  height: 87,
                  decoration: BoxDecoration(
                    border: Border.all(color: MyColors.branco1, width: 1),
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(30, 233, 236, 239),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: TextFormField(
                      controller: _observacoesController,
                      cursorColor: MyColors.branco1,
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        filled: true,
                        hintText: "Observações: ",
                        hintStyle: TextStyle(
                          color: MyColors.branco1,
                          fontSize: 14,
                          fontFamily: MyFonts.fontTerc,
                        ),
                        border: InputBorder.none,
                        alignLabelWithHint: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16), // Ajuste do padding interno
                      ),
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                ),
                const SizedBox(height: 37),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        cadastrarVeiculo();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(290, 50),
                      backgroundColor: MyColors.azul2,
                    ),
                    child: Text(
                      "Cadastrar veículo",
                      style: TextStyle(
                          color: MyColors.branco1,
                          fontSize: 14,
                          fontFamily: MyFonts.fontTerc,
                          fontWeight: FontWeight.bold),
                    )),
                const SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectableIcon(
      String iconName, String assetPath, String vehicleName) {
    bool isSelected = selectedVehicle == iconName;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => selectVehicle(iconName),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Image.asset(
                  assetPath,
                  width: 50,
                  color: isSelected ? Colors.blue : null,
                ),
                const SizedBox(height: 7),
                Text(
                  vehicleName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: MyFonts.fontSecundary,
                    color: MyColors.branco1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorButton(String colorName, Color color) {
    bool isSelected = selectedColor == colorName;

    return GestureDetector(
      onTap: () => selectColor(colorName),
      child: Container(
        width: 30.12,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: isSelected
            ? Center(
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color:
                        color == MyColors.branco1 ? Colors.black : Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(children: [
          SizedBox(
            width: 300,
            child: TextFormField(
              controller: _modeloController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              cursorColor: MyColors.branco1,
              decoration: InputDecoration(
                fillColor: const Color.fromARGB(30, 233, 236, 239),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: MyColors.branco1, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: MyColors.branco1, width: 1),
                ),
                hintText: "Modelo",
                hintStyle: TextStyle(
                  color: MyColors.branco4,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
              validator: (String? Marca) {
                if (Marca == null || Marca.isEmpty) {
                  return "O Marca não pode estar vazio";
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: 300,
            child: TextFormField(
              controller: _placaController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              cursorColor: MyColors.branco1,
              decoration: InputDecoration(
                fillColor: const Color.fromARGB(30, 233, 236, 239),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: MyColors.branco1, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: MyColors.branco1, width: 1),
                ),
                hintText: "Placa",
                hintStyle: TextStyle(
                  color: MyColors.branco4,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
              validator: (String? Placa) {
                if (Placa == null || Placa.isEmpty) {
                  return "Este campo é obrigatório";
                }
                if (Placa.length != 7) {
                  return "Placa inválida";
                }
                return null;
              },
            ),
          ),
        ]),
      ),
    );
  }
}
