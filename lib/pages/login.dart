import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:villajob/pages/empleador.dart';
import 'package:villajob/pages/registro.dart';
import 'package:villajob/pages/trabajadores.dart';

import '../widgets_reutilizables/reutilizables.dart';

class LoginScreem extends StatefulWidget {
  const LoginScreem({super.key});

  @override
  State<LoginScreem> createState() => _LoginScreemState();
}

class _LoginScreemState extends State<LoginScreem> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 47, 152, 233),
          Color.fromRGBO(236, 163, 249, 1)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(
            children: [
              LogoWidget("assets/images/logo.png"),
              const SizedBox(
                height: 30,
              ),
              reusableTextFiell("Correo",
                  Icons.person_outline, false, _emailTextController),
              const SizedBox(
                height: 30,
              ),
              reusableTextFiell("Contraseña", Icons.lock_outline, true,
                  _passwordTextController),
              const SizedBox(
                height: 30,
              ),

              loginButton(context, true, () {///boton para el logeo 
                FirebaseAuth.instance
  .signInWithEmailAndPassword(
    email: _emailTextController.text,
    password: _passwordTextController.text)
  .then((value) {
    // Autenticación exitosa, obtenemos el correo electrónico del usuario
    String? userEmail = value.user!.email;
    
    // Realiza la búsqueda del tipo de usuario en Firestore
    FirebaseFirestore.instance
      .collection('usuarios')
      .where('email', isEqualTo: userEmail)
      .get()
      .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // El usuario existe en Firestore
             var userData = querySnapshot.docs[0].data() as Map<String, dynamic>;
              String? userType = userData['opcion'];
          
          // Redirige a la pantalla correspondiente según el tipo de usuario
          if (userType == 'Trabajador') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TrabajadoresScreen()),
            );
          } else if (userType == 'Empleador') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EmpleadoresScreen()),
            );
          }
        } else {
          // El usuario no existe en Firestore o no tiene asignado un tipo de usuario
          print('El usuario no existe o no tiene asignado un tipo de usuario');
        }
      });
  })
  .catchError((error) {
    // Error durante la autenticación
    print('Error de inicio de sesión: ${error.toString()}');
  });
              }),
              Opcion_de_registro()
            ],
          ),
        )),
      ),
    );
  }

  Row Opcion_de_registro() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("No tengo cuenta", style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegistroScreen()));
          },
          child: const Text(
            "? REGISTRAR",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
