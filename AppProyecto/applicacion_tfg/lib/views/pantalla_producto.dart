import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PantallaProducto extends StatefulWidget {
  final Map<String, dynamic> producto;
  const PantallaProducto({Key? key, required this.producto}) : super(key: key);

  @override
  State<PantallaProducto> createState() => _PantallaProductoState();
}

class _PantallaProductoState extends State<PantallaProducto> {
  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go("/");
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  producto['rutaurl']!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              producto['titulo'] ?? 'No Title',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              producto['descripcion'] ?? 'No Description',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            // Agrega más detalles del producto según sea necesario
          ],
        ),
      ),
    );
  }
}
