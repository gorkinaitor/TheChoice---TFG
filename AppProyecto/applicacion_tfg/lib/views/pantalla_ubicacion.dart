import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:applicacion_tfg/controllers/geolocalizacion.dart';
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

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    marcadores.add(Marker(
        markerId: const MarkerId('localizacionInicial'),
        position: ubicacionInicial));
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
  }

  Future<void> _goToUserLocation() async {
    LocationData? locationData = await geolocalizaUsuario();

    if (locationData != null) {
      LatLng userLocation =
          LatLng(locationData.latitude!, locationData.longitude!);

      mapController.animateCamera(CameraUpdate.newLatLng(userLocation));
      setState(() {
        ubicacionInicial = userLocation;
        pulsarMapa(userLocation);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se pudo encontrar la ubicacion")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Selección de Ubicación'),
        ),
        body: const Center(
          child: Text('No estás registrado. Por favor regístrate o inicia sesión.'),
        ),
      );
    } else {
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
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  _goToUserLocation();
                },
                icon: const Icon(Icons.location_city),
              )
            ],
          ),
          body: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: ubicacionInicial,
              zoom: 15.0,
            ),
            markers: marcadores,
            onTap: pulsarMapa,
          ),
        ),
      );
    }
  }
}



/*

*/