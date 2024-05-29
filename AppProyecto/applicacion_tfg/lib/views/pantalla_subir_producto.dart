import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PantallaSubirProducto extends StatefulWidget {
  const PantallaSubirProducto({super.key});

  @override
  State<PantallaSubirProducto> createState() => _PantallaSubirProductoState();
}

class _PantallaSubirProductoState extends State<PantallaSubirProducto> {
  bool experiencia = false;
  String experienciaOAlojamiento = 'Alojamiento';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Subir Producto',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.tealAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Detalles del Producto',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Introduce el título del producto',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Introduce la descripción del producto',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          experienciaOAlojamiento,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Switch(
                          value: experiencia,
                          activeColor: Colors.teal,
                          onChanged: (bool value) {
                            setState(() {
                              experiencia = value;
                              experienciaOAlojamiento =
                                  experiencia ? 'Experiencia' : 'Alojamiento';
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4.0,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.location_on,
                      color: Colors.yellow,
                    ),
                    title: const Text('Ubicación'),
                    subtitle: const Text('Selecciona la ubicación'),
                    onTap: () {
                      //
                      context.push('/pantallaUbicacion2');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4.0,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.image, color: Colors.purple),
                    title: const Text('Imágenes'),
                    subtitle: const Text('Añade imágenes del producto'),
                    onTap: () {
                      // Acción para añadir imágenes
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
