import 'package:location/location.dart';

Future<LocationData?> geolocalizaUsuario() async {
  Location posicion = new Location();

  bool _servicioActivado;
  PermissionStatus _permisosConcedidos;
  final LocationData _datosPosicion;

  _servicioActivado = await posicion.serviceEnabled();
  if (!_servicioActivado) {
    _servicioActivado = await posicion.requestService();

    if (!_servicioActivado) {
      return null;
    }
  }

  _permisosConcedidos = await posicion.hasPermission();
  if (_permisosConcedidos == PermissionStatus.denied) {
    _permisosConcedidos = await posicion.requestPermission();

    if (_permisosConcedidos != PermissionStatus.granted) {
      return null;
    }
  }

  _datosPosicion = await posicion.getLocation();
  return _datosPosicion;
}
