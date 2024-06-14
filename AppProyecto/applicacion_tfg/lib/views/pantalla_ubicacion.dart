import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

// Define una clase StatefulWidget llamada PantallaUbicacion
class PantallaUbicacion extends StatefulWidget {
  const PantallaUbicacion({Key? key}) : super(key: key);

  @override
  _PantallaUbicacionState createState() => _PantallaUbicacionState();
}

// Define el estado asociado a PantallaUbicacion
class _PantallaUbicacionState extends State<PantallaUbicacion> {
  late GoogleMapController mapController; // Controlador del mapa
  LatLng ubicacionInicial = const LatLng(40.41677675134732,
      -3.70342072991743); // Ubicación inicial del mapa (Madrid)
  Set<Marker> marcadores = {}; // Conjunto de marcadores en el mapa
  LatLng? ubicacionMarcador; // Ubicación seleccionada por el usuario

  // Método que se ejecuta cuando el mapa es creado
  void CreacionMapa(GoogleMapController controller) {
    mapController = controller;
    marcadores.add(
      Marker(
        markerId: const MarkerId('localizacionInicial'),
        position: ubicacionInicial,
      ),
    );

    // Muestra el AlertDialog al inicio
  }

  // Método que se ejecuta cuando el usuario pulsa el mapa
  void pulsarMapa(LatLng coordenadas) {
    setState(() {
      ubicacionInicial = coordenadas; // Actualiza la ubicación inicial
      marcadores.clear(); // Limpia los marcadores existentes
      marcadores.add(
        Marker(
          markerId: const MarkerId('coordenadasSeleccionadas'),
          position:
              coordenadas, // Añade un nuevo marcador en la ubicación seleccionada
        ),
      );
    });

    ubicacionMarcador = coordenadas; // Guarda la ubicación seleccionada

    // Muestra el AlertDialog con las coordenadas seleccionadas
    mostrarAlertDialog();
  }

  // Método para obtener la ubicación del usuario
  Future<void> GeolocalizarUsuario() async {
    LocationData? locationData = await Location.instance
        .getLocation(); // Obtiene la ubicación actual del usuario

    if (locationData != null) {
      LatLng userLocation = LatLng(
          locationData.latitude!,
          locationData
              .longitude!); // Crea una nueva LatLng con la ubicación del usuario

      mapController.animateCamera(CameraUpdate.newLatLng(
          userLocation)); // Mueve la cámara a la ubicación del usuario

      ubicacionMarcador = userLocation; // Guarda la ubicación del usuario

      setState(() {
        ubicacionInicial = userLocation; // Actualiza la ubicación inicial
        pulsarMapa(
            userLocation); // Añade un marcador en la ubicación del usuario
      });

      mapController.animateCamera(CameraUpdate.newLatLng(
          userLocation)); // Mueve la cámara nuevamente a la ubicación del usuario
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "No se pudo encontrar la ubicación"))); // Muestra un mensaje de error si no se puede obtener la ubicación
    }
  }

  // Método para mostrar un AlertDialog con las coordenadas seleccionadas
  void mostrarAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ubicación actual'),
          content: Text(
              'Latitud: ${ubicacionMarcador!.latitude}, Longitud: ${ubicacionMarcador!.longitude}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el AlertDialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta la etiqueta de modo debug
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Selección de Ubicación',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 135, 238, 140),
        ),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated:
                  CreacionMapa, // Define el método que se ejecuta cuando el mapa es creado
              initialCameraPosition: CameraPosition(
                target:
                    ubicacionInicial, // Define la posición inicial de la cámara
                zoom: 15.0,
              ),
              markers: marcadores, // Define los marcadores en el mapa
              onTap:
                  pulsarMapa, // Define el método que se ejecuta cuando se pulsa el mapa
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        GeolocalizarUsuario(); // Llama al método para obtener la ubicación del usuario
                      },
                      child: const Icon(Icons.my_location),
                    ),
                  ),
                  const SizedBox(width: 40),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        // Llama al método para confirmar la ubicación seleccionada
                        Navigator.of(context).pop(
                            ubicacionMarcador); // Cierra la pantalla y devuelve la ubicación seleccionada
                      },
                      child: const Icon(Icons.done_outline),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Código alternativo comentado

/*

//En un arrebato de locura, intente arreglar esto funcionando bien. 
//Saque un codigo de ejemplo que simplificaba todo el sistema, lo adapte y luego volvi en mi y vi que lo que ya estaba hecho funcionaba bien.
//Lo dejo aqui por si, algun dia, me da por simplificarlo.

//- GK

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaSeleccion extends StatefulWidget {
  @override
  _MapaSeleccionState createState() => _MapaSeleccionState();
}

class _MapaSeleccionState extends State<MapaSeleccion> {
  late GoogleMapController mapController;
  LatLng ubicacionSeleccionada = LatLng(0, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Ubicación'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0), // Centro del mapa al iniciar
          zoom: 10, // Zoom inicial
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        onTap: (LatLng coordenadas) {
          setState(() {
            ubicacionSeleccionada = coordenadas;
          });
          mostrarAlertDialog(context, ubicacionSeleccionada); // Muestra un AlertDialog con las coordenadas seleccionadas
        },
      ),
    );
  }

  // Método para mostrar un AlertDialog con las coordenadas de la ubicación seleccionada
  void mostrarAlertDialog(BuildContext context, LatLng ubicacion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ubicación Seleccionada'),
          content: Text(
            'Latitud: ${ubicacion.latitude.toString()}, Longitud: ${ubicacion.longitude.toString()}',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el AlertDialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MapaSeleccion(),
  ));
}

*/
