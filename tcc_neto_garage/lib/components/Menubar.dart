import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class Menubar extends StatefulWidget {
  @override
  _MenubarScreenState createState() => _MenubarScreenState();
}

class _MenubarScreenState extends State<Menubar> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Exemplo de ação ao clicar no item
    switch (index) {
      case 0:
        print("Início clicado!");
        break;
      case 1:
        print("Funcionários clicado!");
        break;
      case 2:
        print("Ajustes clicado!");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 68,
      decoration: BoxDecoration(
        color: MyColors.azul3, // Fundo azul escuro
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(), // Cria espaço flexível à esquerda
          _buildNavItem(0, "Início", "assets/icons/inicio.png", 43.94, 38),
          SizedBox(width: 28),
          _buildNavItem(
              1, "Funcionários", "assets/icons/funcionarios.png", 71.25, 38),
          SizedBox(width: 28),
          _buildNavItem(2, "Ajustes", "assets/icons/ajustes.png", 38, 36),
          Spacer(), // Cria espaço flexível à direita
        ],
      ),
    );
  }

  Widget _buildNavItem(
      int index, String label, String iconPath, double width, double height) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            color: isSelected ? MyColors.branco1 : MyColors.cinza3,
            width: width,
            height: height,
          ),
          SizedBox(height: 0), // Espaço entre ícone e texto
          Text(
            label,
            style: TextStyle(
              color: isSelected ? MyColors.branco1 : MyColors.cinza3,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
