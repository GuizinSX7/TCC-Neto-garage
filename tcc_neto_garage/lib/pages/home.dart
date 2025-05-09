import 'package:flutter/material.dart';
import 'package:tcc_neto_garage/components/Menubar.dart';
import 'package:tcc_neto_garage/components/homeAdmComp.dart';
import 'package:tcc_neto_garage/components/homeComp.dart';
import 'package:tcc_neto_garage/pages/ajustes.dart';
import 'package:tcc_neto_garage/pages/funcionarios.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? tipoUsuario;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
    buscarTipoUsuario().then((tipo) {
      if (mounted) {
        setState(() {
          tipoUsuario = tipo;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          tipoUsuario == "normal"
              ? HomeComp()
              : tipoUsuario == "adm"
                  ? HomeAdmComp()
                  : const Center(child: CircularProgressIndicator()),

          const Funcionarios(),
          const Ajustes()
        ],
      ),
      bottomNavigationBar: Menubar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}