import 'package:applicacion_tfg/main.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:applicacion_tfg/models/modelo_subir_producto.dart';

class ArrancarSupabase {
  static Future<void> inicializarSupabase() async {
    await Supabase.initialize(
        url: 'https://wbevjccsvzkvsjhldqzr.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndiZXZqY2NzdnprdnNqaGxkcXpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTUzODA0OTUsImV4cCI6MjAzMDk1NjQ5NX0.92_MWRERudonOtClITiVUgHti_etGgkwWv3HXzJYmL0');
  }

  static final supabase = Supabase.instance.client;
}

class Login extends StatefulWidget {
  final Function(String, String, String?, SupabaseClient)? googleTokenUsuario;
  final Function()? onLogout;

  Login({this.googleTokenUsuario, this.onLogout});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? _userId;
  String _buttonText = 'Inicio Sesion';
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final PaqueteSubida paqueteSubida = PaqueteSubida();

  @override
  void initState() {
    super.initState();

    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        _userId = data.session?.user.id;
        if (_userId != null) {
          _buttonText = 'Cerrar Sesión';
        } else {
          _buttonText = 'Iniciar Sesión';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          if (_userId != null) {
            await _googleSignIn.signOut();
            await supabase.auth.signOut();
            widget.onLogout!();
          } else {
            await _signInWithGoogle();
                }
              },
        child: Text(_buttonText));
  }

  Future<void> _signInWithGoogle() async {
    const webClientId =
        '935894590591-r3qj6j37781a3blm4k5si469g9a0aok1.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(clientId: webClientId);
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      // El usuario canceló el inicio de sesión
      return;
    }
    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;


    final correo = googleUser.email;
    final String? foto = googleUser.photoUrl;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    if (widget.googleTokenUsuario != null) {
      widget.googleTokenUsuario!(idToken, correo, foto, supabase);

      // Insertar el perfil del usuario en la tabla de perfiles
            final response = await supabase.from('perfiles').upsert({'google_id': correo}, onConflict: 'google_id');
            if (response != null) {
              if (response.error != null) {
                // Manejar el posible error
                print('Error al insertar el perfil: ${response.error!.message}');
              } else {
                print('Perfil insertado correctamente');
              }
            } else {
              print('La respuesta de upsert es nula');
            }

      paqueteSubida.setCorreo = correo;
    }
  }
}