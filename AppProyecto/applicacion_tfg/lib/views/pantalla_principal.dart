import 'package:flutter/material.dart';
import 'package:applicacion_tfg/views/components/barra_busqueda.dart';
import 'package:applicacion_tfg/controllers/lista_productos.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({Key? key}) : super(key: key);

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
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
          )
          ),
          backgroundColor: Color.fromARGB(255, 206, 122, 241),
        ),
        body: const Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: BarraBusqueda(),
            ),
            Expanded(child: lista())
          ],
        ));
  }
}
