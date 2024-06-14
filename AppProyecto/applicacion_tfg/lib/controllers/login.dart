import 'dart:async';
import 'package:applicacion_tfg/main.dart'; // Asegúrate de importar Supabase y otros recursos necesarios
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:applicacion_tfg/models/modelo_subir_producto.dart'; // Importa el modelo necesario

class Login extends StatefulWidget {
  final Function(String, String, String?, SupabaseClient, GoogleSignInAccount?)?
      googleTokenUsuario; // Función callback para manejar el token de usuario de Google
  final Function()? onLogout; // Función callback para manejar el logout

  Login({this.googleTokenUsuario, this.onLogout});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? _userId; // ID de usuario actual
  String _buttonText = 'Iniciar Sesión'; // Texto del botón de inicio de sesión
  final GoogleSignIn _googleSignIn =
      GoogleSignIn(); // Instancia de GoogleSignIn para iniciar sesión con Google
  final PaqueteSubida paqueteSubida =
      PaqueteSubida(); // Instancia del paquete de subida

  StreamSubscription<AuthState>?
      _authSubscription; // Suscripción al cambio de estado de autenticación

  @override
  void initState() {
    super.initState();

    // Escucha los cambios en el estado de autenticación de Supabase
    _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (mounted) {
        // Verifica si el widget está montado
        setState(() {
          _userId = data.session?.user.id; // Obtiene el ID del usuario actual
          // Actualiza el texto del botón dependiendo del estado de autenticación
          if (_userId != null) {
            _buttonText = 'Cerrar Sesión';
          } else {
            _buttonText = 'Iniciar Sesión';
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel(); // Cancela la suscripción al salir del widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_userId != null) {
          await _googleSignIn.signOut(); // Cierra sesión con Google
          await supabase.auth.signOut(); // Cierra sesión con Supabase
          widget.onLogout
              ?.call(); // Llama a la función de logout proporcionada por el widget padre
        } else {
          await _signInWithGoogle(); // Inicia sesión con Google
        }
      },
      child: Text(
          _buttonText), // Muestra el texto del botón dependiendo del estado de autenticación
    );
  }

  Future<void> _signInWithGoogle() async {
    // Identificador del cliente web para autenticación con Google
    const webClientId =
        '935894590591-r3qj6j37781a3blm4k5si469g9a0aok1.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(clientId: webClientId);
    final googleUser = await googleSignIn.signIn(); // Inicia sesión con Google
    if (googleUser == null) {
      return; // El usuario canceló el inicio de sesión
    }
    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken; // Token de acceso de Google
    final idToken = googleAuth.idToken; // Token de ID de Google

    final correo = googleUser.email; // Correo electrónico del usuario
    final String? foto =
        googleUser.photoUrl; // URL de la foto de perfil del usuario

    if (accessToken == null || idToken == null) {
      throw 'No Access Token or ID Token found.'; // Lanza una excepción si no se encontró token de acceso o ID
    }

    // Inicia sesión con Supabase usando el token de ID de Google
    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    // Llama a la función de callback proporcionada por el widget padre para manejar el token de usuario de Google
    if (widget.googleTokenUsuario != null) {
      widget.googleTokenUsuario!(idToken, correo, foto, supabase, googleUser);

      paqueteSubida.setCorreo =
          correo; // Establece el correo en el paquete de subida
      paqueteSubida.setIdProveedor = supabase.auth.currentUser!
          .id; // Establece el ID del proveedor en el paquete de subida
    }
  }
}
