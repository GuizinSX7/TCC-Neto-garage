import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:tcc_neto_garage/shared/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async'; 
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
  StreamSubscription<User?>? _userSubscription;
  StreamSubscription<DocumentSnapshot>? _userDataSubscription;

  @override
  void initState() {
    super.initState();
    _setupAuthListener();
    _loadUserData();
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    _userDataSubscription?.cancel();
    super.dispose();
  }

  Future<void> _setupAuthListener() async {
    _userSubscription =
        FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        // Atualiza o email local com o email verificado do Firebase Auth
        if (user.email != null && user.email != email) {
          setState(() {
            email = user.email!;
          });
        }

        // Recarrega todos os dados do usuário
        await _loadUserData();
      }
    });
  }

  Future<String?> _buscarCPFUsuario() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("usuarios")
        .where("email", isEqualTo: user.email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var doc = snapshot.docs.first;
      var cpf = doc["CPF"];
      return cpf?.toString();
    }
    return null;
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cpf = await _buscarCPFUsuario();
    if (cpf == null) return;

    // Configura listener para dados do usuário no Firestore
    _userDataSubscription?.cancel();
    _userDataSubscription = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(cpf)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        setState(() {
          nome = doc['nome completo'] ?? '';
          // Usa o email do Firestore apenas se o usuário não tiver email verificado
          // ou se estiver diferente do email autenticado
          if (user.email == null || !user.emailVerified) {
            email = doc['email'] ?? user.email ?? '';
          }
        });
      }
    });
  }

  Future<void> atualizarEmail(String novoEmail, String senhaAtual) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Reautenticação
      final credenciais = EmailAuthProvider.credential(
        email: user.email!,
        password: senhaAtual,
      );
      await user.reauthenticateWithCredential(credenciais);

      // Atualiza o email no Firestore
      final cpf = await _buscarCPFUsuario();
      if (cpf != null) {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(cpf)
            .update({'email': novoEmail.trim()});
      }

      // Envia o email de verificação
      await user.verifyBeforeUpdateEmail(novoEmail.trim());

      // Atualiza o estado local imediatamente
      setState(() {
        email = novoEmail.trim();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Email de verificação enviado! Verifique seu novo email.'),
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar email: ${e.toString()}'),
          duration: Duration(seconds: 5),
        ),
      );
      rethrow;
    }
  }

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
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: MyColors.gradienteGeral,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                Icon(
                  Icons.person,
                  size: 120,
                ),
                const SizedBox(height: 25),

                // Nome editável
                GestureDetector(
                  onTap: () async {
                    final TextEditingController nomeController =
                        TextEditingController(text: nome);

                    String? novoNome = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Atualizar nome"),
                        content: TextField(
                          controller: nomeController,
                          decoration: InputDecoration(
                            labelText: "Novo nome",
                            labelStyle: TextStyle(color: MyColors.branco1),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: MyColors.branco1),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: MyColors.branco1),
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Cancelar",
                                style: TextStyle(color: MyColors.branco1)),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(nomeController.text),
                            child: Text("Salvar",
                                style: TextStyle(color: MyColors.branco1)),
                          ),
                        ],
                      ),
                    );

                    if (novoNome != null && novoNome.trim().isNotEmpty) {
                      final cpf = await _buscarCPFUsuario();
                      if (cpf != null) {
                        await FirebaseFirestore.instance
                            .collection('usuarios')
                            .doc(cpf)
                            .update({
                          'nome completo': novoNome.trim(),
                        });
                        setState(() {
                          nome = novoNome.trim();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Nome atualizado com sucesso!")),
                        );
                      }
                    }
                  },
                  child: Row(
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

                GestureDetector(
                  child: Container(
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
                  onTap: () {
                    Navigator.pushNamed(context, "/ServicosAgendadosUsua");
                  },
                ),

                const SizedBox(height: 15),

                GestureDetector(
                  onTap: () async {
                    final TextEditingController emailController =
                        TextEditingController(text: email);

                    String? novoEmail = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Atualizar e-mail"),
                        content: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Novo e-mail",
                            labelStyle: TextStyle(color: MyColors.branco1),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: MyColors.branco1),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: MyColors.branco1),
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Cancelar",
                                style: TextStyle(color: MyColors.branco1)),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(emailController.text),
                            child: Text("Salvar",
                                style: TextStyle(color: MyColors.branco1)),
                          ),
                        ],
                      ),
                    );

                    if (novoEmail != null && novoEmail.trim().isNotEmpty) {
                      try {
                        final senhaController = TextEditingController();
                        final senhaAtual = await showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Confirme sua senha"),
                            content: TextField(
                              controller: senhaController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Senha atual",
                                labelStyle: TextStyle(color: MyColors.branco1),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: MyColors.branco1),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: MyColors.branco1),
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text("Cancelar",
                                    style: TextStyle(color: MyColors.branco1)),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context)
                                    .pop(senhaController.text),
                                child: Text("Confirmar",
                                    style: TextStyle(color: MyColors.branco1)),
                              ),
                            ],
                          ),
                        );

                        if (senhaAtual != null && senhaAtual.isNotEmpty) {
                          await atualizarEmail(novoEmail.trim(), senhaAtual);

                          // Atualiza no Firestore (opcional, pois o usuário precisará verificar primeiro)
                          final cpf = await _buscarCPFUsuario();
                          if (cpf != null) {
                            await FirebaseFirestore.instance
                                .collection('usuarios')
                                .doc(cpf)
                                .update({'email': novoEmail.trim()});
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "Email de verificação enviado! Por favor, verifique seu novo e-mail.")),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Erro ao atualizar o e-mail: $e")),
                        );
                      }
                    }
                  },
                  child: InfoContainer(
                    label: "E-mail:",
                    value: email,
                  ),
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
                            labelStyle: TextStyle(color: MyColors.branco1),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: MyColors.branco1),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: MyColors.branco1),
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Cancelar",
                                style: TextStyle(color: MyColors.branco1)),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(senhaController.text),
                            child: Text("Salvar",
                                style: TextStyle(color: MyColors.branco1)),
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
                GestureDetector(
                  child: InfoContainer(
                    label: "Endereço",
                    value: "",
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/EditEndereco");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
