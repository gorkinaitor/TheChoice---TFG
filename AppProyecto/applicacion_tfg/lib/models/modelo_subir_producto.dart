import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaqueteSubida {
  //INICIALIZACION DE TODAS LAS VARIABLES NECESARIAS
  late String correo;
  late String titulo;
  late String descripcion;
  late bool producto;
  late File rutaImagen;
  late String nombreImagen;
  late LatLng coord;
  late SupabaseClient supabase;

  //GETTERS DE TODAS LAS VARIABLES NECESARIAS
  String get getCorreo => correo;
  String get getTitulo => titulo;
  String get getDescripcion => descripcion;
  bool get getProducto => producto;
  File get getRutaImagen => rutaImagen;
  String get getNombreImagen => nombreImagen;
  LatLng get getCoord => coord;
  SupabaseClient get getSupabaseClient => supabase;

  //SETTERS DE TODAS LAS VARIABLES NECESARIAS
  set setCorreo(String _correo) {
    correo = _correo;
  }

  set setTitulo(String _titulo) {
    titulo = _titulo;
  }

  set setDescripcion(String _descripcion) {
    descripcion = _descripcion;
  }

  set setSupabaseClient(SupabaseClient _supabase) {
    supabase = _supabase;
  }

  set setProducto(bool _producto) {
    producto = _producto;
  }

  set setRutaImagen(File _rutaImagen) {
    rutaImagen = _rutaImagen;
  }

  set setNombreImagen(String _nombreImagen) {
    nombreImagen = _nombreImagen;
  }

  set setCoord(LatLng _coord) {
    coord = _coord;
  }

  Future<void> subirDatos() async {
    final response = await supabase.from('test_productos').insert([
      {
        'correo': correo,
        'titulo': titulo,
        'descripcion': descripcion,
        'productoTipo': producto,
        'rutaImagen': nombreImagen,
        'latitud': coord.latitude,
        'longitud': coord.longitude,
      }
    ]);

    if (response.error != null) {
      throw Exception('Error al subir datos: ${response.error!.message}');
    }
  }

  Future<void> subirImagen() async {
    final File imagenSubir = rutaImagen;
    print(await supabase.auth.getUser());

    String? user = (await supabase.auth.getUser()) as String?;
    /*

    final supabaseUrl = 'https://wbevjccsvzkvsjhldqzr.supabase.co';
    final supabaseKey =
        'yeyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndiZXZqY2NzdnprdnNqaGxkcXpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTUzODA0OTUsImV4cCI6MjAzMDk1NjQ5NX0.92_MWRERudonOtClITiVUgHti_etGgkwWv3HXzJYmL0';
    final supabaseClient = SupabaseClient(supabaseUrl, supabaseKey);
    final storage = supabaseClient.storage.from('prueba');
    final response = await storage.upload('/my-image.jpg', rutaImagen);

    */
  }
}
