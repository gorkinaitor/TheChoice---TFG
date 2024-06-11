import 'package:applicacion_tfg/main.dart';
import 'package:flutter/material.dart';

Future<void> addFavoritos(String userId, int productoId) async {
  await supabase.from('favoritos2').insert({
    'id_user': userId,
    'id_producto': productoId,
  });
}

Future<void> delFavoritos(String userId, int productoId) async {
  await supabase.from('favoritos2').delete().match({
    'id_user': userId,
    'id_producto': productoId,
  });
}

Future<List<Map<String, dynamic>>> getFavoritos(String userId) async {
  final lista = await supabase
      .from('favoritos2')
      .select('id_user, id_producto')
      .eq('id_user', userId);

  return lista;
}

Future<bool> getEstaFavorito(String userId, int productoId) async {
  final lista = await supabase
      .from('favoritos2')
      .select('id_user, id_producto')
      .eq('id_user', userId)
      .eq('id_producto', productoId);

  return lista.isNotEmpty;
}

class BotonFavoritos extends StatefulWidget {
  final String userId;
  final int productoId;

  BotonFavoritos({required this.userId, required this.productoId});

  @override
  _BotonFavoritosState createState() => _BotonFavoritosState();
}

class _BotonFavoritosState extends State<BotonFavoritos> {
  late bool _esFavorito;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _comprobarFavorito();
  }

  Future<void> _comprobarFavorito() async {
    bool esFavorito = await getEstaFavorito(widget.userId, widget.productoId);
    setState(() {
      _esFavorito = esFavorito;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _cargando
        ? CircularProgressIndicator()
        : IconButton(
            onPressed: () async {
              if (_esFavorito) {
                await delFavoritos(widget.userId, widget.productoId);
              } else {
                await addFavoritos(widget.userId, widget.productoId);
              }

              setState(() {
                _esFavorito = !_esFavorito;
              });
            },
            icon: Icon(_esFavorito ? Icons.favorite : Icons.favorite_border),
          );
  }
}
