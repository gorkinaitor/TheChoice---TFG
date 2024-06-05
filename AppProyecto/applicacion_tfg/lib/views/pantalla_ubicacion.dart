import 'package:applicacion_tfg/controllers/geolocalizacion.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PantallaUbicacion extends StatefulWidget {
  const PantallaUbicacion({Key? key}) : super(key: key);

  @override
  _PantallaUbicacionState createState() => _PantallaUbicacionState();
}

class _PantallaUbicacionState extends State<PantallaUbicacion> {
  late GoogleMapController mapController;
  LatLng ubicacionInicial = const LatLng(40.41677675134732, -3.70342072991743);
  Set<Marker> marcadores = {};
  LatLng? ubicacionMarcador;

  void CreacionMapa(GoogleMapController controller) {
    mapController = controller;
    marcadores.add(
      Marker(
        markerId: const MarkerId('localizacionInicial'),
        position: ubicacionInicial,
      ),
    );

    // Muestra la AlertDialog al inicio
  }

  void pulsarMapa(LatLng coordenadas) {
    setState(() {
      ubicacionInicial = coordenadas;
      marcadores.clear();
      marcadores.add(
        Marker(
          markerId: const MarkerId('coordenadasSeleccionadas'),
          position: coordenadas,
        ),
      );
    });

    ubicacionMarcador = coordenadas;

    // Muestra la AlertDialog cada vez que se selecciona una ubicación
    mostrarAlertDialog();
  }

  Future<void> GeolocalizarUsuario() async {
    LocationData? locationData = await Location.instance.getLocation();

    if (locationData != null) {
      LatLng userLocation =
          LatLng(locationData.latitude!, locationData.longitude!);

      mapController.animateCamera(CameraUpdate.newLatLng(userLocation));

      ubicacionMarcador = userLocation;

      setState(() {
        ubicacionInicial = userLocation;
        pulsarMapa(userLocation);
      });

      mapController.animateCamera(CameraUpdate.newLatLng(userLocation));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se pudo encontrar la ubicación")));
    }
  }

  // Método para mostrar la AlertDialog
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
                Navigator.of(context).pop();
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
      debugShowCheckedModeBanner: false,
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
              onMapCreated: CreacionMapa,
              initialCameraPosition: CameraPosition(
                target: ubicacionInicial,
                zoom: 15.0,
              ),
              markers: marcadores,
              onTap: pulsarMapa,
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
                        GeolocalizarUsuario();
                      },
                      child: const Icon(Icons.my_location),
                    ),
                  ),
                  const SizedBox(width: 40),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        // Aquí irá el método para confirmar la ubicación
                        Navigator.of(context).pop(ubicacionMarcador);
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
          mostrarAlertDialog(context, ubicacionSeleccionada);
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
                Navigator.of(context).pop();
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