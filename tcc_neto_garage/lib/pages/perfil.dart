import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:tcc_neto_garage/components/Menubar.dart';
import 'package:tcc_neto_garage/shared/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  String nome = "";
  String email = "";
  String endereco = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<String?> _buscarCPFUsuario() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

    if (userId.isEmpty) return null;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("usuarios")
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser?.email)
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

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final cpf = await _buscarCPFUsuario(); // <- aqui você espera o valor

      if (cpf != null) {
        final doc = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(cpf)
            .get();

        if (doc.exists) {
          setState(() {
            nome = doc['nome completo'] ?? '';
            email = doc['email'] ?? user.email ?? '';
          });
        }
      }
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
                const SizedBox(height: 30),
                Text(
                  'Seu Perfil',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: MyFonts.fontSecundary,
                    color: MyColors.branco1,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/perfil.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      nome,
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: MyFonts.fontPrimary,
                        color: MyColors.branco1,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Icon(
                      Icons.edit,
                      color: MyColors.branco1,
                      size: 15,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    email,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: MyFonts.fontPrimary,
                      color: MyColors.branco1,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // ScrollView dos veículos
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: 380,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(30, 233, 236, 239),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: MyColors.branco1, width: 1),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Iconify(
                          Mdi.file_document,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 1,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 15),
                      Text(
                        "Serviços já agendados",
                        style: TextStyle(
                          fontSize: 24,
                          color: MyColors.branco1,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Container Email
                InfoContainer(
                  label: "E-mail:",
                  value: email,
                ),

                const SizedBox(height: 15),

                // Container Senha
                GestureDetector(
                  child: InfoContainer(
                    label: "Senha:",
                    value: "********",
                  ),
                  onTap: () async {
                    final TextEditingController senhaController =
                        TextEditingController();

                    String? novaSenha = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Atualizar senha"),
                        content: TextField(
                          controller: senhaController,
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: "Nova senha",
                              labelStyle: TextStyle(
                                color: MyColors.branco1,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: MyColors
                                        .branco1), // Cor da borda quando não está focado
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: MyColors
                                        .branco1), // Cor da borda quando está focado
                              )),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(), // cancela
                            child: Text(
                              "Cancelar",
                              style: TextStyle(
                                color: MyColors.branco1,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(senhaController.text),
                            child: Text(
                              "Salvar",
                              style: TextStyle(
                                color: MyColors.branco1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (novaSenha != null && novaSenha.length >= 6) {
                      try {
                        await FirebaseAuth.instance.currentUser
                            ?.updatePassword(novaSenha);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Senha atualizada com sucesso!")),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Erro ao atualizar a senha: $e")),
                        );
                      }
                    } else if (novaSenha != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "A senha deve ter pelo menos 6 caracteres.")),
                      );
                    }
                  },
                ),

                const SizedBox(height: 15),

                // Container Endereço
                InfoContainer(
                  label: "Endereço",
                  value: "",
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Menubar(), // MenuBar adicionada aqui
    );
  }
}

// Widget para os containers de E-mail, Senha e Endereço
class InfoContainer extends StatelessWidget {
  final String label;
  final String value;

  const InfoContainer({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 50,
      decoration: BoxDecoration(
        color: const Color.fromARGB(30, 233, 236, 239),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: MyColors.branco1, width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(color: MyColors.branco1, fontSize: 12),
                children: [
                  TextSpan(
                    text: "$label ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: value,
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Icon(Icons.edit, color: MyColors.branco1),
        ],
      ),
    );
  }
}
