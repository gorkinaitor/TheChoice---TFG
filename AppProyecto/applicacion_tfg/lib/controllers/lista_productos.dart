import 'package:flutter/material.dart';
import 'package:applicacion_tfg/models/modelo_subir_producto.dart'; // Importa el modelo de subir producto
import 'package:applicacion_tfg/main.dart'; // Importa supabase para acceder a la base de datos
import 'package:go_router/go_router.dart'; // Importa GoRouter para la navegación

class Lista extends StatefulWidget {
  final PaqueteSubida claseCompartida; // Instancia compartida de PaqueteSubida
  Lista({required this.claseCompartida});

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  List<Map<String, dynamic>> items = []; // Lista para almacenar los productos

  // Función asíncrona para obtener y mostrar la lista de productos
  Future<void> probarListas() async {
    final datos = await supabase
        .from('productos')
        .select(); // Consulta todos los productos

    setState(() {
      items = List<Map<String, dynamic>>.from(
          datos); // Actualiza la lista de items con los datos obtenidos
    });
  }

  @override
  void initState() {
    super.initState();
    probarListas(); // Llama a la función para obtener la lista de productos al inicializar el estado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh:
            probarListas, // Función para refrescar la lista al hacer scroll hacia abajo
        child: items.isEmpty
            ? Center(
                child:
                    CircularProgressIndicator()) // Muestra un indicador de carga si no hay productos
            : GridView.extent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                padding: const EdgeInsets.all(8.0),
                children: items.map((item) {
                  return GestureDetector(
                    onTap: () {
                      context.push('/pantallaProducto',
                          extra:
                              item); // Navega a la pantalla de producto al hacer tap
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Image.network(
                              item['rutaurl'] ??
                                  '', // Muestra la imagen del producto o un ícono de error si no está disponible
                              height: 100,
                              width: 130,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image,
                                  size: 100,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              item['titulo'] ??
                                  'No Title', // Muestra el título del producto o un texto predeterminado si no hay título
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              item['descripcion'] ??
                                  'No Description', // Muestra la descripción del producto o un texto predeterminado si no hay descripción
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }
}
