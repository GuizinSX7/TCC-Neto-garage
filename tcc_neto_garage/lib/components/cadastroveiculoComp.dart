import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class Cadastroveiculo extends StatefulWidget {
  const Cadastroveiculo({super.key});

  @override
  State<Cadastroveiculo> createState() => _CadastroveiculoState();
}

class _CadastroveiculoState extends State<Cadastroveiculo> {
  String? selectedVehicle; // Variável para armazenar o veículo selecionado
  String? selectedColor;   // Variável para armazenar a cor selecionada
  final _formKey = GlobalKey<FormState>();

  // Função para selecionar o veículo
  void selectVehicle(String vehicleName) {
    setState(() {
      selectedVehicle = vehicleName;
    });
  }

  // Função para selecionar a cor
  void selectColor(String colorName) {
    setState(() {
      selectedColor = colorName;
    });
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
              const SizedBox(height: 30), // Espaço antes do botão de voltar
              // Botão de voltar
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: MyColors.branco1, // Cor do ícone
                    size: 24, // Tamanho do ícone
                  ),
                  onPressed: () {
                    // Navega de volta para a tela inicial (home)
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
                'Selecione o modelo do seu \nveículo:',
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
                          _buildSelectableIcon("picape", "assets/icons/Picape.png", "Picape"),
                          const SizedBox(width: 39.11),
                          _buildSelectableIcon("moto", "assets/icons/Moto.png", "Moto"),
                          const SizedBox(width: 39.11),
                          _buildSelectableIcon("hatch", "assets/icons/Hatch.png", "Hatch"),
                        ],
                      ),
                      const SizedBox(height: 32.11),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSelectableIcon("suv", "assets/icons/SUV.png", "SUV"),
                          const SizedBox(width: 39.11),
                          _buildSelectableIcon("sedan", "assets/icons/Sedan.png", "Sedan"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              buildForm(context),
              const SizedBox(height: 32),
              Container(
                width: 304,
                height: 166,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(75, 233, 236, 239),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: MyColors.branco1, width: 3),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        _buildColorButton("color1", Color(0xFF14532D)),
                        const SizedBox(width: 13.05),
                        _buildColorButton("color2", Color(0xFF38BDF8)),
                        const SizedBox(width: 13.05),
                        _buildColorButton("color3", Color(0xFF1E3A8A)),
                        const SizedBox(width: 13.05),
                        _buildColorButton("color4", Color(0xFFF472B6)),
                        const SizedBox(width: 13.05),
                        _buildColorButton("color5", Color(0xFF4C1D95)),
                        const SizedBox(width: 13.05),
                        _buildColorButton("color6", MyColors.branco1),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildColorButton("color7", Color(0xFFFACC15)),
                        const SizedBox(width: 13.05),
                        _buildColorButton("color8", Color(0xFFF59E0B)),
                        const SizedBox(width: 13.05),
                        _buildColorButton("color9", Color(0xFFDC2626)),
                        const SizedBox(width: 13.05),
                        _buildColorButton("color10", MyColors.preto1),
                        const SizedBox(width: 13.05),
                        _buildColorButton("color11", Color(0xFF713F12)),
                        const SizedBox(width: 13.05),
                        _buildColorButton("color12", Color(0xFFA8A29E)),
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
                  border: Border.all(color: MyColors.branco1, width: 3),
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(75, 233, 236, 239),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: TextFormField(
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
                      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16), // Ajuste do padding interno
                    ),
                    textAlignVertical: TextAlignVertical.center,
                  ),
                ),
              ),
              const SizedBox(height: 37),
              Container(
                width: 290,
                height: 49,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: MyColors.azul2,
                ),
                child: MaterialButton(
                  onPressed: () {
                    // Ação ao pressionar o botão
                    if (selectedVehicle != null && selectedColor != null) {
                      print("Veículo selecionado: $selectedVehicle");
                      print("Cor selecionada: $selectedColor");
                    } else {
                      print("Selecione um veículo e uma cor antes de cadastrar.");
                    }
                  },
                  child: Text(
                    "Cadastrar seu veículo",
                    style: TextStyle(
                      color: MyColors.branco1,
                      fontSize: 14,
                      fontFamily: MyFonts.fontTerc,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 62), // Espaço de 62 pixels após o botão
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildSelectableIcon(String iconName, String assetPath, String vehicleName) {
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
                    color: color == MyColors.branco1 ? Colors.black : Colors.white,
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
          Container(
            width: 304,
            height: 45,
            decoration: BoxDecoration(
              border: Border.all(color: MyColors.branco1, width: 3),
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(75, 233, 236, 239),
            ),
            child: Material(
              color: Colors.transparent,
              child: TextFormField(
                cursorColor: MyColors.branco1,
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  filled: true,
                  hintText: "Marca: ",
                  hintStyle: TextStyle(
                    color: MyColors.branco1,
                    fontSize: 14,
                    fontFamily: MyFonts.fontTerc,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Ajuste do padding interno
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
            ),
          ),
          const SizedBox(height: 48),
          Container(
            width: 304,
            height: 45,
            decoration: BoxDecoration(
              border: Border.all(color: MyColors.branco1, width: 3),
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(75, 233, 236, 239),
            ),
            child: Material(
              color: Colors.transparent,
              child: TextFormField(
                cursorColor: MyColors.branco1,
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  filled: true,
                  hintText: "Placa: ",
                  hintStyle: TextStyle(
                    color: MyColors.branco1,
                    fontSize: 14,
                    fontFamily: MyFonts.fontTerc,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Ajuste do padding interno
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}