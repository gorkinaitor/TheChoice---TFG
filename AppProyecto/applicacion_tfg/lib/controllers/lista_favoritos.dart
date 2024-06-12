import 'package:flutter/material.dart';
import 'package:applicacion_tfg/main.dart'; // Asegúrate de importar supabase
import 'package:go_router/go_router.dart';

class ListaFavoritos extends StatefulWidget {
  @override
  State<ListaFavoritos> createState() => _ListaFavoritosState();
}

class _ListaFavoritosState extends State<ListaFavoritos> {
  List<Map<String, dynamic>> items = [];

  Future<void> probarListaFavoritoss() async {
    final user = supabase.auth.currentUser?.id;

    if (user != null) {
      final response = await supabase
          .from('favoritos2')
          .select(
              'id_user, productos(id,correo,titulo,descripcion,productoTipo,rutaurl, id_proveedor)')
          .eq('id_user', user);

      setState(() {
        items = List<Map<String, dynamic>>.from(response);
      });
    } else {
      print('User not logged in');
    }

    print(items);
  }

  @override
  void initState() {
    super.initState();
    probarListaFavoritoss();
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
        onRefresh: probarListaFavoritoss,
        child: items.isEmpty
            ? Center(child: CircularProgressIndicator())
            : GridView.extent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                padding: const EdgeInsets.all(8.0),
                children: items.map((item) {
                  final producto = item['productos'];
                  return GestureDetector(
                    onTap: () {
                      context.push('/pantallaProducto', extra: item['productos']);
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
                              producto['rutaurl'] ?? '',
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
                              producto['titulo'] ?? 'No Title',
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
                              producto['descripcion'] ?? 'No Description',
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
