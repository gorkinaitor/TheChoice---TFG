import 'package:applicacion_tfg/main.dart'; // Importa la configuración principal de la aplicación y Supabase.
import 'package:flutter/material.dart';

// Función asíncrona para añadir un producto a la lista de favoritos.
Future<void> addFavoritos(String userId, int productoId) async {
  await supabase.from('favoritos2').insert({
    'id_user': userId,
    'id_producto': productoId,
  });
}

// Función asíncrona para eliminar un producto de la lista de favoritos.
Future<void> delFavoritos(String userId, int productoId) async {
  await supabase.from('favoritos2').delete().match({
    'id_user': userId,
    'id_producto': productoId,
  });
}

// Función asíncrona para obtener la lista de favoritos de un usuario.
Future<List<Map<String, dynamic>>> getFavoritos(String userId) async {
  final lista = await supabase
      .from('favoritos2')
      .select('id_user, id_producto')
      .eq('id_user', userId);

  return lista;
}

// Función asíncrona para verificar si un producto está marcado como favorito por un usuario.
Future<bool> getEstaFavorito(String userId, int productoId) async {
  final lista = await supabase
      .from('favoritos2')
      .select('id_user, id_producto')
      .eq('id_user', userId)
      .eq('id_producto', productoId);

  return lista
      .isNotEmpty; // Devuelve true si el producto está en la lista de favoritos, de lo contrario false.
}

// Widget StatefulWidget que representa un botón de favoritos.
class BotonFavoritos extends StatefulWidget {
  final String userId; // ID del usuario.
  final int productoId; // ID del producto.

  BotonFavoritos({required this.userId, required this.productoId});

  @override
  _BotonFavoritosState createState() => _BotonFavoritosState();
}

class _BotonFavoritosState extends State<BotonFavoritos> {
  late bool _esFavorito; // Estado que indica si el producto es favorito o no.
  bool _cargando =
      true; // Estado que indica si se está cargando la información inicial.

  @override
  void initState() {
    super.initState();
    _comprobarFavorito(); // Llama a la función para comprobar si el producto es favorito.
  }

  // Función asíncrona para comprobar si el producto es favorito.
  Future<void> _comprobarFavorito() async {
    bool esFavorito = await getEstaFavorito(widget.userId,
        widget.productoId); // Obtiene el estado de favorito del producto.
    setState(() {
      _esFavorito = esFavorito; // Actualiza el estado de favorito.
      _cargando = false; // Marca la carga como completada.
    });
  }

  @override
  Widget build(BuildContext context) {
    return _cargando
        ? CircularProgressIndicator() // Muestra un indicador de carga mientras se obtiene la información.
        : IconButton(
            onPressed: () async {
              if (_esFavorito) {
                await delFavoritos(
                    widget.userId,
                    widget
                        .productoId); // Si ya es favorito, elimina de favoritos.
              } else {
                await addFavoritos(widget.userId,
                    widget.productoId); // Si no es favorito, añade a favoritos.
              }

              setState(() {
                _esFavorito = !_esFavorito; // Cambia el estado de favorito.
              });
            },
            icon: Icon(_esFavorito
                ? Icons.favorite
                : Icons
                    .favorite_border), // Muestra el icono de corazón lleno o vacío según el estado de favorito.
          );
  }
}
