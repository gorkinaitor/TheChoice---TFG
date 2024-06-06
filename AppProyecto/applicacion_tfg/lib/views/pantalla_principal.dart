import 'package:applicacion_tfg/controllers/enrutamiento/app_router.dart';
import 'package:applicacion_tfg/models/modelo_subir_producto.dart';
import 'package:flutter/material.dart';
import 'package:applicacion_tfg/views/components/barra_busqueda.dart';
import 'package:applicacion_tfg/controllers/lista_productos.dart';

class PantallaPrincipal extends StatefulWidget {
  final PaqueteSubida claseCompartida;
  PantallaPrincipal({required this.claseCompartida});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int opcSeleccionada = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'La Elección',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 206, 122, 241),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: BarraBusqueda(),
            ),
            Expanded(child: Lista(claseCompartida: paqueteSubida))
          ],
        ));
  }
}
