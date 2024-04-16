import 'package:applicacion_tfg/views/pantalla_principal.dart';
import 'package:flutter/material.dart';

void main() {
  runApp((const Principal()));
}

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Choice',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 233, 230, 68)),
        useMaterial3: true,
      ),
      home: const pantallaPrincipal(),
    );
  }
}
