import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ArrancarSupabase {
  static Future<void> inicializarSupabase() async {
    await Supabase.initialize(
        url: 'https://wbevjccsvzkvsjhldqzr.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndiZXZqY2NzdnprdnNqaGxkcXpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTUzODA0OTUsImV4cCI6MjAzMDk1NjQ5NX0.92_MWRERudonOtClITiVUgHti_etGgkwWv3HXzJYmL0');
  }

  static final supabase = Supabase.instance.client;
}

class PaqueteSubida {
  //INICIALIZACION DE TODAS LAS VARIABLES NECESARIAS
  late String correo;
  late String titulo;
  late String descripcion;
  late bool producto;
  late File rutaImagen;
  late String nombreImagen;
  late LatLng coord;
  late SupabaseClient supabase = supabase;
  late String urlFoto = "";
  late String idProveedor;
  bool hasIniciadoSesion = false;

  //GETTERS DE TODAS LAS VARIABLES NECESARIAS
  String get getCorreo => correo;
  String get getTitulo => titulo;
  String get getDescripcion => descripcion;
  bool get getProducto => producto;
  File get getRutaImagen => rutaImagen;
  String get getNombreImagen => nombreImagen;
  LatLng get getCoord => coord;
  SupabaseClient get getSupabaseClient => supabase;
  String get getIdProveedor => idProveedor;
  bool get getHasIniciadoSesion => hasIniciadoSesion;

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

  set setIdProveedor(String _idProveedor) {
    idProveedor = _idProveedor;
  }

  set setHasIniciadoSesion(bool _hasIniciadoSesion) {
    hasIniciadoSesion = _hasIniciadoSesion;
  }

  Future<void> subirDatos() async {
    final response = await supabase.from('productos').insert([
      {
        'correo': correo,
        'titulo': titulo,
        'descripcion': descripcion,
        'productoTipo': producto,
        'rutaImagen': nombreImagen,
        'latitud': coord.latitude,
        'longitud': coord.longitude,
        'rutaurl': urlFoto,
        'id_proveedor': idProveedor
      }
    ]);
  }

  Future<void> subirImagen() async {
    var uuid = Uuid();
    String idUnico = uuid.v4();
    final File imagenSubir = rutaImagen;

    final UserResponse userResponse = await supabase.auth.getUser();
    final User? user = userResponse.user;
    //print('User ID: ${user?.id}');

    final almacenamiento = supabase.storage.from('prueba');

    final response = await almacenamiento.upload(
        'misImagenes/${user?.id}/my-image-$idUnico.jpg', imagenSubir);

    final publicUrlResponse = almacenamiento
        .getPublicUrl('misImagenes/${user?.id}/my-image-$idUnico.jpg');

    urlFoto = publicUrlResponse;

    subirDatos();
  }
}
