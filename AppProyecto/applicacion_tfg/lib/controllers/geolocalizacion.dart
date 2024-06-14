import 'package:location/location.dart';

// Función asíncrona para obtener la ubicación del usuario.
Future<LocationData?> geolocalizaUsuario() async {
  Location posicion =
      new Location(); // Instancia de la clase Location para manejar la ubicación.

  bool
      _servicioActivado; // Variable para verificar si el servicio de ubicación está activado.
  PermissionStatus
      _permisosConcedidos; // Variable para verificar el estado de los permisos de ubicación.
  final LocationData
      _datosPosicion; // Variable para almacenar los datos de ubicación.

  // Verifica si el servicio de ubicación está activado.
  _servicioActivado = await posicion.serviceEnabled();
  if (!_servicioActivado) {
    // Si el servicio no está activado, solicita activarlo.
    _servicioActivado = await posicion.requestService();

    // Si no se activa el servicio, devuelve null.
    if (!_servicioActivado) {
      return null;
    }
  }

  // Verifica si se han concedido los permisos de ubicación.
  _permisosConcedidos = await posicion.hasPermission();
  if (_permisosConcedidos == PermissionStatus.denied) {
    // Si los permisos no están concedidos, solicita permisos al usuario.
    _permisosConcedidos = await posicion.requestPermission();

    // Si no se conceden los permisos, devuelve null.
    if (_permisosConcedidos != PermissionStatus.granted) {
      return null;
    }
  }

  // Obtiene los datos de ubicación del usuario.
  _datosPosicion = await posicion.getLocation();
  return _datosPosicion; // Devuelve los datos de ubicación obtenidos.
}
