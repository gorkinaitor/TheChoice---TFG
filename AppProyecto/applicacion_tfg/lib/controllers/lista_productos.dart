import 'package:applicacion_tfg/views/pantalla_producto.dart';
import 'package:flutter/material.dart';

import 'package:applicacion_tfg/models/modelo_subir_producto.dart';
import 'package:applicacion_tfg/main.dart'; // Asegúrate de importar supabase

import 'package:go_router/go_router.dart';


class Lista extends StatefulWidget {
  final PaqueteSubida claseCompartida;
  Lista({required this.claseCompartida});

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  List<Map<String, dynamic>> items = [];

  Future<void> probarListas() async {
    final datos = await supabase.from('test_productos').select();

    setState(() {
      items = List<Map<String, dynamic>>.from(datos);
    });
  }

  @override
  void initState() {
    super.initState();
    probarListas();
  }

  
  @override
  Widget build(BuildContext context) {
  
  /*
    return Scaffold(
      body: items.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.extent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              padding: const EdgeInsets.all(8.0),
              children: items.map((item) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.network(
                          item['rutaurl']!,
                          height: 100,
                          width: 130,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        item['titulo'] ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['descripcion'] ?? 'No Description',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
    
    */

    return Container(
        child: GridView.extent(
      maxCrossAxisExtent: 200.0,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      padding: const EdgeInsets.all(8.0),
      children: 
      items.map((item) {
        return GestureDetector(
          onTap: (){
            context.go('/pantallaProducto');
          },
          child: Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.network(
                  item['rutaurl']!,
                  height: 100,
                  width: 130,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 8),
              Text(
                item['titulo']!,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                item['descripcion']!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        )
        );
      }).toList(),
    ));

  }
}
