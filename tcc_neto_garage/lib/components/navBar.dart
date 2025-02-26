import 'package:flutter/material.dart';

class navBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const navBar({required this.currentIndex, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 29, 34, 93)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 110.0),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
          if (index == currentIndex && index != 0) {
              return;
            }
            debugPrint('Navegando para a página de índice: $index');

            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/Início');
                break;
              case 1:
                Navigator.pushNamed(context, '/Funcionários');
                break;
              case 2:
                Navigator.pushNamed(context, '/Ajustes');
                break;
              default:
                Navigator.pushNamed(context, '/home');
            }
                        // Se for uma nova página, chame a função de navegação
            onTap(index);
          },

          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Image.asset(
                  'assets/images/InícioIcon.png'
                ),
              ),
            ),

            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Image.asset(
                  'assets/images/FuncionáriosIcon.png'
                ),
              ),
            ),

            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Image.asset(
                  'assets/images/AjustesIcon.png'
                ),
              ),
            ),
          ],
          backgroundColor: const Color.fromARGB(255, 29, 34, 93),
          elevation: 0,
          selectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}