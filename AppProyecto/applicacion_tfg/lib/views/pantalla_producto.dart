import 'package:flutter/material.dart';

class PantallaProducto extends StatefulWidget {
  const PantallaProducto({Key? key}) : super(key: key);

  @override
  State<PantallaProducto> createState() => _PantallaProductoState();
}

class _PantallaProductoState extends State<PantallaProducto> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Productos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 221, 168, 108),
      ),
    );
  }
}