import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';

class VehicleCard extends StatelessWidget {
  final String model;
  final String plate;
  
  const VehicleCard({super.key, required this.model, required this.plate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 101,
        height: 101,
        decoration: BoxDecoration(
          color: const Color.fromARGB(30, 233, 236, 239),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: MyColors.branco1, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping,
              size: 40,
              color: Colors.white,
            ),
            SizedBox(height: 8),
            Text(
              model,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors.branco1,
                fontSize: 12,
                fontFamily: MyFonts.fontPrimary,
              ),
            ),
            Text(
              plate,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors.branco1,
                fontSize: 10,
                fontFamily: MyFonts.fontPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}