import 'package:applicacion_tfg/controllers/enrutamiento/app_router.dart';
import 'package:applicacion_tfg/models/modelo_subir_producto.dart';
import 'package:flutter/material.dart';
import 'package:applicacion_tfg/controllers/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PerfilUsuario extends StatefulWidget {
  final PaqueteSubida claseCompartida;
  PerfilUsuario({required this.claseCompartida});

  @override
  State<PerfilUsuario> createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  String? _googleToken;
  String? _correo;
  String? _foto;
  late SupabaseClient _supabase;

  String? enviarCorreo() {
    return _correo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Tu perfil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Login(
              googleTokenUsuario: (token, correo, foto, supabase) {
                setState(() {
                  _googleToken = token;
                  _correo = correo;
                  _foto = foto;
                  _supabase = supabase;
                  paqueteSubida.setCorreo = correo;
                  paqueteSubida.setSupabaseClient = _supabase;
                });
              },
              onLogout: () {
                setState(() {
                  _googleToken = null;
                  _correo = null;
                  _foto = null;
                  paqueteSubida.setCorreo = "";
                });
              },
            ),
          ),
          if(_correo != null) ...[
            Text(
              'Correo Electronico: $_correo',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              'Token de Google: $_googleToken',
              style: TextStyle(fontSize: 10),
            ),
          ],
          _foto != null
              ? Image.network(
                  _foto!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
              : SizedBox(),
        ],
      )),
    );
  }
}
