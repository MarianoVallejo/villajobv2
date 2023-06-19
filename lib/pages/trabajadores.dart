import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:villajob/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrabajadoresScreen extends StatefulWidget {
  const TrabajadoresScreen({Key? key});

  @override
  State<TrabajadoresScreen> createState() => _TrabajadoresScreenState();
}

class _TrabajadoresScreenState extends State<TrabajadoresScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Trabajador",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('publicaciones').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error al cargar las publicaciones');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasData) {
                    final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final document = documents[index];

                        // Obtener el ID del empleador
                        final empleadorId = document['empleadorId'];

                        // Obtener la información del empleador desde la colección de usuarios
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('usuarios').doc(empleadorId).get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError || !snapshot.hasData) {
                              // Manejar el error o el documento no encontrado
                              return Container();
                            }

                            final userData = snapshot.data!.data() as Map<String, dynamic>;
                            final empleadorNombre = userData['nombre'];
                            final empleadorApellido = userData['apellido'];
                            final empleadorTelefono = userData['telefono'];

                            // Mostrar la publicación junto con el nombre y apellido del empleador
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(document['descripcion']),
                                      content: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Empleador: $empleadorNombre $empleadorApellido'),
                                          Text('Teléfono: $empleadorTelefono'),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'Salir');
                                          },
                                          child: Text('Salir'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'Postular');
                                          },
                                          child: Text('Postular'),
                                        ),
                                      ],
                                    );
                                  },
                                ).then((value) {
                                  if (value == 'Salir') {
                                    // Acción al presionar "Salir"
                                  } else if (value == 'Postular') {
                                    // Acción al presionar "Postular"
                                  }
                                });
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text(document['descripcion']),
                                  subtitle: Text('Empleador: $empleadorNombre $empleadorApellido\nTeléfono: $empleadorTelefono\nPrecio: ${document['precio']}'),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }

                  return Container();
                },
              ),
            ),
            ElevatedButton(
              child: Text("Salir"),
              onPressed: () {
                print("Saliendo");
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreem()));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
