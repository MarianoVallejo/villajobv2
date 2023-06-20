import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:villajob/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:villajob/pages/registroPubli.dart';

class EmpleadoresScreen extends StatefulWidget {
  const EmpleadoresScreen({Key? key});

  @override
  State<EmpleadoresScreen> createState() => _EmpleadoresScreenState();
}

class _EmpleadoresScreenState extends State<EmpleadoresScreen> {
  late String empleadorId;
  late bool isLoading = true;

  @override
  void initState() {
    super.initState();
    obtenerEmpleadorId();
  }

  void obtenerEmpleadorId() async {
    // Obtener el ID del empleador actualmente autenticado
    String? empleadorEmail = FirebaseAuth.instance.currentUser!.email;

    // Obtener el documento del empleador desde la colección de usuarios
    FirebaseFirestore.instance
        .collection('usuarios')
        .where('email', isEqualTo: empleadorEmail)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        empleadorId = snapshot.docs[0].id;
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      print('Error al obtener el trabajador: $error');
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: isLoading
            ? Text(
                'Cargando...', // Mostrar texto de carga mientras se obtiene el valor de trabajadorId
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            : FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('usuarios').doc(empleadorId).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text(
                      'Cargando...', // Mostrar texto de carga mientras se obtiene la información del trabajador
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    );
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Text(
                      'Error al cargar los datos',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    );
                  }

                  final userData = snapshot.data!.data() as Map<String, dynamic>;
                  final empleadorNombre = userData['nombre'];
                  final empleadorApellido = userData['apellido'];

                  return Text(
                    'Empleador: $empleadorNombre $empleadorApellido',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  );
                },
              ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 47, 152, 233),
          Color.fromRGBO(236, 163, 249, 1)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text("Registrar Publicación"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistroPublicacionScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      child: Text("Salir"),
                      onPressed: () {
                        print("Saliendo");
                        FirebaseAuth.instance.signOut().then((value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreem()),
                          );
                        });
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
