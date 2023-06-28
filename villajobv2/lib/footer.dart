import 'package:flutter/material.dart';

Widget createFooter() {
  return BottomAppBar(
    color: Color.fromARGB(255, 255, 255, 255),
    child: Container(
      height: 50,
      child: Center(
        child: Text(
          ':)',
          style: TextStyle(
            fontSize: 18,
            color: const Color.fromARGB(255, 7, 15, 255),
          ),
        ),
      ),
    ),
  );
}
