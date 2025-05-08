import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class Menubar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  Menubar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: MyColors.azul3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, "Início", "assets/icons/inicio.png", 43.94, 38),
          _buildNavItem(1, "Funcionários", "assets/icons/funcionarios.png", 71.25, 38),
          _buildNavItem(2, "Ajustes", "assets/icons/ajustes.png", 38, 36),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, String iconPath, double width, double height) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            color: isSelected ? MyColors.branco1 : MyColors.cinza3,
            width: width,
            height: height,
          ),
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