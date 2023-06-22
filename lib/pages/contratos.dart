import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:villajob/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContratosScreen extends StatefulWidget {
  const ContratosScreen({Key? key});

  @override
  State<ContratosScreen> createState() => _ContratosScreenState();
}

class _ContratosScreenState extends State<ContratosScreen> {
  late String empleadorId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    obtenerEmpleadorId();
  }

  void obtenerEmpleadorId() {
    String? empleadorEmail = FirebaseAuth.instance.currentUser!.email;

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
      print('Error al obtener el empleador: $error');
      setState(() {
        isLoading = false;
      });
    });
  }

  void cerrarContrato() {
    // Lógica para cerrar el contrato
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
                'Cargando...',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            : FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('usuarios')
                    .doc(empleadorId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text(
                      'Cargando...',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    );
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Text(
                      'Error al cargar los datos',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    );
                  }

                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  final empleadorNombre = userData['nombre'];
                  final empleadorApellido = userData['apellido'];

                  return Text(
                    'Contratos de: $empleadorNombre $empleadorApellido',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  );
                },
              ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 47, 152, 233),
              Color.fromRGBO(236, 163, 249, 1)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('contratos')
                    .where('empleadorId', isEqualTo: empleadorId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Text('Error al cargar los contratos');
                  }

                  final List<QueryDocumentSnapshot> documents =
                      snapshot.data!.docs;

                  if (documents.isEmpty) {
                    return const Center(
                      child: Text('No hay contratos'),
                    );
                  }

                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final document = documents[index];
                      final trabajadorId = document['trabajadorId'];
                      final publicacionId = document['publicacionId'];

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('usuarios')
                            .doc(trabajadorId)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError || !snapshot.hasData) {
                            return const Text('Error al cargar los datos');
                          }

                          final userData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          final trabajadorNombre = userData['nombre'];
                          final trabajadorApellido = userData['apellido'];
                          final trabajadorTelefono = userData['telefono'];
                          final trabajadorCedula = userData['cedula'];

                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('publicaciones')
                                .doc(publicacionId)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError || !snapshot.hasData) {
                                return const Text('Error al cargar los datos');
                              }

                              final publicacionData =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              final descripcion = publicacionData['descripcion'];

                              return ListTile(
                                title: Text('Contrato $index'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                  
                                    Text('Nombre del trabajador: $trabajadorNombre $trabajadorApellido'),
                                    SizedBox(height: 10),
                                    Text('Descripción de la publicación:'),
                                    Text(descripcion),
                                  ],
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Datos del trabajador'),
                                        content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('Datos del trabajador'),
                                            Text('Nombre: $trabajadorNombre'),
                                            Text(
                                                'Apellido: $trabajadorApellido'),
                                            Text(
                                                'Teléfono: $trabajadorTelefono'),
                                            Text('Cédula: $trabajadorCedula'),
                                            SizedBox(height: 10),
                                            Text(
                                                'Descripción de la publicación:'),
                                            Text(descripcion),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              cerrarContrato();
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cerrar Contrato'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Salir'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                trailing: Icon(Icons.arrow_forward_ios),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context); // Regresar a la pantalla anterior
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
