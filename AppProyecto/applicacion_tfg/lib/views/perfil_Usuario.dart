import 'package:flutter/material.dart';
import 'package:applicacion_tfg/controllers/login.dart';

class PerfilUsuario extends StatefulWidget {
  @override
  State<PerfilUsuario> createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  String? _googleToken;
  String? _correo;
  String? _foto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tu perfil'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Login(
              googleTokenUsuario: (token, correo, foto) {
                setState(() {
                  _googleToken = token;
                  _correo = correo;
                  _foto = foto;
                });
              },
              onLogout: () {
                setState(() {
                  _googleToken = null;
                  _correo = null;
                  _foto = null;
                });
              },
            ),
          ),
          Text(
            'Correo Electronico: $_correo',
            style: TextStyle(fontSize: 15),
          ),
          Text(
            'Token de Google: $_googleToken',
            style: TextStyle(fontSize: 10),
          ),
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
