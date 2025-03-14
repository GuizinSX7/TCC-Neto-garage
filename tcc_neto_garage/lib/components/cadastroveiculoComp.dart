import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class Cadastroveiculo extends StatefulWidget {
  const Cadastroveiculo({super.key});

  @override
  State<Cadastroveiculo> createState() => _CadastroveiculoState();
}

class _CadastroveiculoState extends State<Cadastroveiculo> {
  String? selectedIcon;
  final _formKey = GlobalKey<FormState>(); // Armazena o ícone selecionado

  // Função para selecionar o ícone
  void selectIcon(String iconName) {
    setState(() {
      selectedIcon = iconName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20), // Adiciona espaçamento lateral
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 61),
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
              textAlign: TextAlign.center, // Centraliza o texto
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: MyFonts.fontSecundary,
                color: MyColors.branco1,
              ),
            ),
            const SizedBox(height: 40),

            // Container para agrupar os ícones com padding lateral de 73
            Center(
              child: Container(
                child: Column(
                  children: [
                    // Ícones superiores (Picape, Moto, Hatch)
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Centraliza os ícones na linha
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
                    // Ícones inferiores (SUV, Sedan)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSelectableIcon(
                            "suv", "assets/icons/SUV.png", "SUV"),
                        const SizedBox(width: 39.11),
                        _buildSelectableIcon(
                            "sedan", "assets/icons/Sedan.png", "Sedan"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 50),
            buildForm(context), // Adiciona o formulário abaixo dos ícones

            // Botões de cores
            const SizedBox(
                height: 48), // Espaço entre o campo "Placa:" e os botões de cor
            // Container para os botões de cores
            // Container para os botões de cores
            // Container para os botões de cores
            Container(
              width: 304,
              height: 166,
              decoration: BoxDecoration(
                color: const Color.fromARGB(75, 233, 236, 239),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: MyColors.branco1, width: 3), // Borda adicionada aqui
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12), // Adiciona padding interno
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinha o texto à esquerda
                children: [
                  // HintText "Cor:"
                  const Text(
                    "Cor:",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: MyFonts.fontTerc,
                      color: MyColors.branco1, // Ajuste conforme necessário
                    ),
                  ),
                  const SizedBox(
                      height: 16), // Espaçamento de 16px antes dos botões

                  // Primeira linha de botões de cores
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
                  const SizedBox(
                      height: 16), // Mantém espaçamento igual entre as linhas

                  // Segunda linha de botões de cores
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
          ],
        ),
      ),
    );
  }

  // Widget para construir os ícones clicáveis com texto
  Widget _buildSelectableIcon(
      String iconName, String assetPath, String vehicleName) {
    bool isSelected = selectedIcon == iconName;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => selectIcon(iconName),
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

  // Função para criar os botões de cor
  Widget _buildColorButton(String colorName, Color color) {
    bool isSelected = selectedIcon == colorName;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIcon = colorName;
        });
      },
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
                  width: 18, // Tamanho do círculo
                  height: 18,
                  decoration: BoxDecoration(
                    color:
                        color == MyColors.branco1 ? Colors.black : Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null, // Sem círculo quando não selecionado
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
            ),
            child: Material(
              color: Colors.transparent,
              child: TextFormField(
                cursorColor: MyColors.branco1,
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(75, 233, 236, 239),
                  filled: true,
                  hintText: "Marca: ",
                  hintStyle: TextStyle(
                    color: MyColors.branco1,
                    fontSize: 14,
                    fontFamily: MyFonts.fontTerc,
                  ),
                  border: InputBorder.none,
                ),
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
            ),
            
            child: Material(
              color: Colors.transparent,
              child: TextFormField(
                cursorColor: MyColors.branco1,
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(75, 233, 236, 239),
                  filled: true,
                  hintText: "Placa: ",
                  hintStyle: TextStyle(
                    color: MyColors.branco1,
                    fontSize: 14,
                    fontFamily: MyFonts.fontTerc,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
