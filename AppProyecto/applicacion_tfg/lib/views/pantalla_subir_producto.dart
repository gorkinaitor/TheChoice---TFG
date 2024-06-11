import 'dart:io';
import 'package:applicacion_tfg/controllers/enrutamiento/app_router.dart';
import 'package:applicacion_tfg/main.dart';
import 'package:applicacion_tfg/models/modelo_subir_producto.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PantallaSubirProducto extends StatefulWidget {
  final PaqueteSubida claseCompartida;
  PantallaSubirProducto({required this.claseCompartida});

  @override
  State<PantallaSubirProducto> createState() => _PantallaSubirProductoState();
}

class _PantallaSubirProductoState extends State<PantallaSubirProducto> {
  bool experiencia = false;
  String experienciaOAlojamiento = 'Alojamiento';
  File? imagen;
  final selectorImagen = ImagePicker();
  String imagenTexto = "No se ha seleccionado ninguna imagen";
  late String texto;

  //VARIABLES PARA EXTRAER DATOS
  TextEditingController? controlTextoTitulo = TextEditingController();
  TextEditingController? controlTextoDescripcion = TextEditingController();
  String? textoTitulo;
  String? textoDescripcion;
  String? correo;
  bool producto = false;
  File? archivoImagen;
  String? nombreArchivo;
  LatLng? ubicacionSeleccionada;
  String? idProovedor;

  Future obtenerImagenGaleria() async {
    final imagenSeleccionada = await selectorImagen.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (imagenSeleccionada != null) {
      archivoImagen =
          File(imagenSeleccionada.path); // Obtiene el archivo de la imagen
      nombreArchivo = imagenSeleccionada.name; // Obtiene el nombre del archivo
    }

    setState(() {
      if (imagenSeleccionada != null) {
        imagen = File(imagenSeleccionada.path);
        imagenTexto = "Imagen Seleccionada!";
      } else {
        print("Imagen no Seleccionada");
      }
    });
  }

  //Resumen del producto que acaba de publicar el proovedor
  void mostrarAlerta(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalles del Producto'),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //Comprueba el estado de autenticación  
    return StreamBuilder<Session?>(
      stream: supabase.auth.onAuthStateChange.map((event) => event.session),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Subir Producto')),
            body: Center(child: CircularProgressIndicator()),
          );
        }


        final estaAutenticado = snapshot.data?.user != null;

        // Si el usuario no está autenticado, muestra un mensaje y no le permite acceder a las funcionalidades de esa pantalla
        if (!estaAutenticado) {
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
            body: Center(child: Text('No estás logueado. Por favor inicia sesión.')),
          );
          // Si el usuario está autenticado, le permite acceder a las funcionalidades de esa pantalla con normalidad
        } else {
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
                    //Formulario para añadir un nuevo producto
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
                              controller: controlTextoTitulo,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Introduce el título del producto',
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              maxLines: 4,
                              controller: controlTextoDescripcion,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Introduce la descripción del producto',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
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
                            onTap: () async {
                              ubicacionSeleccionada =
                                  await context.push('/pantallaUbicacion2');
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 4.0,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.image, color: Colors.purple),
                            title: const Text('Imágenes'),
                            subtitle: Text(imagenTexto),
                            onTap: () {
                              // Acción para añadir imágenes
                              obtenerImagenGaleria();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            textoTitulo = controlTextoTitulo?.text;
                            textoDescripcion = controlTextoDescripcion?.text;

                            //FALSE == ALOJAMIENTO, TRUE == EXPERIENCIA
                            producto = experiencia;
                            correo = paqueteSubida.getCorreo;

                            texto =
                                "Autor: $correo \n Titulo: $textoTitulo \n Descripcion: $textoDescripcion \n Producto: $producto \n RutaImagen: $archivoImagen \n NombreImagen: $nombreArchivo \n Ubicacion Coord: $ubicacionSeleccionada";

                            paqueteSubida.setTitulo = textoTitulo!;
                            paqueteSubida.setDescripcion = textoDescripcion!;
                            paqueteSubida.setProducto = producto;
                            paqueteSubida.setRutaImagen = archivoImagen!;
                            paqueteSubida.setNombreImagen = nombreArchivo!;
                            paqueteSubida.setCoord = ubicacionSeleccionada!;

                            //Acción para mostrar el resumen del producto
                            mostrarAlerta(context, texto);
                            paqueteSubida.subirImagen();
                          },
                          child: const Text("Subir Producto"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        }
    );
  }
}