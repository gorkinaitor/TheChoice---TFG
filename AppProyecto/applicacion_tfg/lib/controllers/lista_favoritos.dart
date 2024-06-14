import 'package:flutter/material.dart';
import 'package:applicacion_tfg/main.dart'; // Importa supabase para acceder a la base de datos
import 'package:go_router/go_router.dart'; // Importa GoRouter para la navegación

class ListaFavoritos extends StatefulWidget {
  @override
  State<ListaFavoritos> createState() => _ListaFavoritosState();
}

class _ListaFavoritosState extends State<ListaFavoritos> {
  List<Map<String, dynamic>> items =
      []; // Lista para almacenar los elementos favoritos

  // Función asíncrona para obtener la lista de favoritos del usuario actual
  Future<void> probarListaFavoritoss() async {
    final user =
        supabase.auth.currentUser?.id; // Obtiene el ID del usuario actual

    if (user != null) {
      final response = await supabase
          .from('favoritos2')
          .select(
              'id_user, productos(id,correo,titulo,descripcion,productoTipo,rutaurl, id_proveedor)')
          .eq('id_user',
              user); // Consulta la tabla 'favoritos2' filtrando por el ID del usuario

      setState(() {
        items = List<Map<String, dynamic>>.from(
            response); // Actualiza la lista de items con la respuesta obtenida
      });
    } else {
      print(
          'User not logged in'); // Imprime un mensaje si el usuario no está autenticado
    }

    print(items); // Imprime la lista de items
  }

  @override
  void initState() {
    super.initState();
    probarListaFavoritoss(); // Llama a la función para obtener la lista de favoritos al inicializar el estado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favoritos',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh:
            probarListaFavoritoss, // Función para refrescar la lista al hacer scroll hacia abajo
        child: items.isEmpty
            ? Center(
                child:
                    CircularProgressIndicator()) // Muestra un indicador de carga si no hay items
            : GridView.extent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                padding: const EdgeInsets.all(8.0),
                children: items.map((item) {
                  final producto =
                      item['productos']; // Obtiene el producto de cada item
                  return GestureDetector(
                    onTap: () {
                      context.push('/pantallaProducto',
                          extra: item[
                              'productos']); // Navega a la pantalla de producto al hacer tap
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
                              producto['rutaurl'] ??
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
                          const SizedBox(height: 8),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              producto['titulo'] ??
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
                              producto['descripcion'] ??
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
