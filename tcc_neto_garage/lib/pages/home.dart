import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/components/homeAdmComp.dart';
import 'package:tcc_neto_garage/components/homeComp.dart';
import 'package:tcc_neto_garage/shared/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeUsuarioState();
}

class _HomeUsuarioState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? tipoUsuario;

  Future<String?> buscarTipoUsuario() async {
    String userId = _auth.currentUser?.uid ?? "";

    if (userId.isEmpty) return null;

    QuerySnapshot snapshot = await _firestore
        .collection("usuarios")
        .where("email", isEqualTo: _auth.currentUser?.email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first;
      var tipo = doc["tipo_usuario"];
      tipoUsuario = tipo;

      if (tipo is String) {
        return tipo;
      }
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    buscarTipoUsuario().then((tipo) {
      if (mounted) {
        setState(() {
          tipoUsuario = tipo;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: MyColors.gradienteGeral,
        ),
        child: Center(
          child: SingleChildScrollView(
              child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (tipoUsuario == "normal") HomeComp(),
                if (tipoUsuario == "adm") HomeAdmComp()
              ],
            ),
          )),
        ),
      ),
    );
  }
}
