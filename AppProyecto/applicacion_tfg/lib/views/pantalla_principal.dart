import 'package:flutter/material.dart';
import 'package:applicacion_tfg/controllers/login.dart';
import 'package:applicacion_tfg/views/components/barra_busqueda.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({Key? key}) : super(key: key);

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int opcSeleccionada = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 209, 209, 209),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'The Choice',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.purple[700],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [BarraBusqueda()],
        ),
      ),
    );
  }
}
