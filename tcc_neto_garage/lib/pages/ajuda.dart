import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/shared/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class Ajuda extends StatefulWidget {
  const Ajuda({super.key});

  @override
  State<Ajuda> createState() => _AjudaState();
}

class _AjudaState extends State<Ajuda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: MyColors.branco1),
          ),
          backgroundColor: MyColors.azul3,
        ),
        body: Container(
            decoration: BoxDecoration(gradient: MyColors.gradienteTelas),
            child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Precisa de ajuda?",
                      style: TextStyle(
                        color: MyColors.branco1,
                        fontSize: 24,
                        fontFamily: MyFonts.fontSecundary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Entre em contato\nconosco",
                      textAlign:
                          TextAlign.center, // centraliza o texto na linha
                      style: TextStyle(
                        color: MyColors.branco1,
                        fontSize: 20,
                        fontFamily: MyFonts.fontSecundary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.person,
                      color: MyColors.branco1,
                      size: 100,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: 360,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Card(
                        color: const Color(0xFF10172F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 8,
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  FaIcon(FontAwesomeIcons.whatsapp,
                                      color: Colors.white, size: 40),
                                  SizedBox(width: 12),
                                  Text(
                                    'WhatsApp/Telefone',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () async {
                                  final Uri uri = Uri.parse(
                                      'https://wa.me/5514996698464'); // link do WhatsApp
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                  } else {
                                    throw 'Não foi possível abrir $uri';
                                  }
                                },
                                child: const Text(
                                  '(14) 99669-8464 - Rafael Neto',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    decoration: TextDecoration
                                        .underline, // opcional, para indicar que é clicável
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              GestureDetector(
                                onTap: () async {
                                  final Uri uri = Uri.parse(
                                      'https://wa.me/5514997056541'); // link do WhatsApp
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                  } else {
                                    throw 'Não foi possível abrir $uri';
                                  }
                                },
                                child: const Text(
                                  '(14) 99705-6541 - Gabriel Neto',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    decoration: TextDecoration
                                        .underline, // opcional, para indicar que é clicável
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Divider(color: Colors.white),
                              const SizedBox(height: 20),
                              Row(
                                children: const [
                                  FaIcon(FontAwesomeIcons.instagram,
                                      color: Colors.white, size: 40),
                                  SizedBox(width: 12),
                                  Text(
                                    'Instagram',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () async {
                                  final Uri uri = Uri.parse(
                                      'https://www.instagram.com/netoo_garage?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=='); // link do WhatsApp
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                  } else {
                                    throw 'Não foi possível abrir $uri';
                                  }
                                },
                                child: const Text(
                                  '@netoo_garage',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    decoration: TextDecoration
                                        .underline, // opcional, para indicar que é clicável
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
            )));
  }
}
