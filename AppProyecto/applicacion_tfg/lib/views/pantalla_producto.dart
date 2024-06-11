import 'package:applicacion_tfg/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:applicacion_tfg/controllers/favoritos.dart';

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
    final user = supabase.auth.currentUser;

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
        backgroundColor: const Color.fromARGB(255, 221, 168, 108),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
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

            if (user != null)
              BotonFavoritos(
                userId: supabase.auth.currentSession!.user.id,
                productoId: producto['id'],
              ),

            const SizedBox(height: 16),
            Text(
              producto['titulo'] ?? 'No Title',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              producto['descripcion'] ?? 'No Description',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            // Agrega más detalles del producto según sea necesario
          ],
        ),
      ),
    );
  }
}
