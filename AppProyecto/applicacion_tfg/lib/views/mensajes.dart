import 'package:flutter/material.dart';
import 'package:applicacion_tfg/views/components/barra_busqueda.dart';

class Mensajes extends StatefulWidget {
  @override
  State<Mensajes> createState() => _MensajesState();
}

class _MensajesState extends State<Mensajes> {
  
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
