import 'package:flutter/material.dart';
import 'package:applicacion_tfg/views/components/barra_busqueda.dart';

class PantallaMensajes extends StatefulWidget {
  const PantallaMensajes({Key? key}) : super(key: key);
  @override
  State<PantallaMensajes> createState() => _PantallaMensajesState();
}

class _PantallaMensajesState extends State<PantallaMensajes> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Mensajes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}
