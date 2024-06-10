import 'package:applicacion_tfg/controllers/enrutamiento/app_router.dart';
import 'package:applicacion_tfg/models/modelo_subir_producto.dart';
import 'package:flutter/material.dart';
import 'package:applicacion_tfg/controllers/login.dart';
import 'package:flutter/widgets.dart';
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
        children: [
          const SizedBox(height: 30),
          if (_correo != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.0),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      if (_foto != null)
                        ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              _foto!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Correo $_correo',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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
        ],
      )),
    );
  }
}
