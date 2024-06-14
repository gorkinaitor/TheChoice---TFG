import 'package:applicacion_tfg/controllers/enrutamiento/app_router.dart';
import 'package:applicacion_tfg/models/modelo_subir_producto.dart';
import 'package:flutter/material.dart';
import 'package:applicacion_tfg/views/components/barra_busqueda.dart';
import 'package:applicacion_tfg/controllers/lista_productos.dart';

class PantallaPrincipal extends StatefulWidget {
  final PaqueteSubida claseCompartida;

  //Constructor que requiere el parámetro claseCompartida
  PantallaPrincipal({required this.claseCompartida});

  //Se crea el estado de la pantalla
  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

//Widget de la pantalla principal
class _PantallaPrincipalState extends State<PantallaPrincipal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 209, 209, 209),
        //Barra de arriba
        appBar: AppBar(
          centerTitle: true,
          title: const Text('The Choice',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              )),
          backgroundColor: Color.fromARGB(255, 206, 122, 241),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: BarraBusqueda(),
            ),
            //Se llama a la clase Lista, y se le pasa paqueteSubida
            Expanded(child: Lista(claseCompartida: paqueteSubida))
          ],
        ));
  }
}
