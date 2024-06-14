import 'package:applicacion_tfg/controllers/enrutamiento/app_router.dart'; // Importa el enrutador de la aplicación
import 'package:applicacion_tfg/models/modelo_subir_producto.dart'; // Importa el modelo para subir productos
import 'package:flutter/material.dart'; // Importa el paquete de Flutter para construir la interfaz de usuario
import 'package:applicacion_tfg/controllers/login.dart'; // Importa el controlador de inicio de sesión
import 'package:flutter/widgets.dart'; // Importa widgets de Flutter
import 'package:supabase_flutter/supabase_flutter.dart'; // Importa el paquete de Supabase para Flutter
import 'package:applicacion_tfg/controllers/lista_favoritos.dart'; // Importa el controlador de la lista de favoritos

// Define la clase PerfilUsuario, que es un StatefulWidget
class PerfilUsuario extends StatefulWidget {
  final PaqueteSubida
      claseCompartida; // Recibe un parámetro obligatorio de tipo PaqueteSubida

  PerfilUsuario(
      {required this.claseCompartida}); // Constructor que inicializa claseCompartida

  @override
  State<PerfilUsuario> createState() =>
      _PerfilUsuarioState(); // Crea el estado para PerfilUsuario
}

// Define el estado para PerfilUsuario
class _PerfilUsuarioState extends State<PerfilUsuario> {
  String? _googleToken; // Variable para almacenar el token de Google
  String? _correo; // Variable para almacenar el correo del usuario
  String? _foto; // Variable para almacenar la URL de la foto del usuario
  late SupabaseClient _supabase; // Variable para el cliente de Supabase

  // Función para enviar el correo del usuario
  String? enviarCorreo() {
    return _correo; // Retorna el correo del usuario
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
        backgroundColor: Colors.amber, // Color de fondo del AppBar
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30), // Espacio de 30 píxeles
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
                              _foto!, // URL de la foto del usuario
                              width: 100,
                              height: 100,
                              fit: BoxFit
                                  .cover, // Ajusta la imagen para cubrir el contenedor
                            ),
                          ),
                        const SizedBox(width: 20), // Espacio de 20 píxeles
                        Expanded(
                          child: Text(
                            'Correo: $_correo', // Muestra el correo del usuario
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(child: ListaFavoritos()) // Muestra la lista de favoritos
            ],
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Login(
                googleTokenUsuario: (token, correo, foto, supabase, google) {
                  setState(() {
                    _googleToken = token; // Almacena el token de Google
                    _correo = correo; // Almacena el correo del usuario
                    _foto = foto; // Almacena la URL de la foto del usuario
                    _supabase = supabase; // Almacena el cliente de Supabase
                    paqueteSubida.setCorreo =
                        correo; // Establece el correo en el paquete de subida
                    paqueteSubida.setSupabaseClient =
                        _supabase; // Establece el cliente de Supabase en el paquete de subida
                  });
                },
                onLogout: () {
                  setState(() {
                    _googleToken = null; // Limpia el token de Google
                    _correo = null; // Limpia el correo del usuario
                    _foto = null; // Limpia la URL de la foto del usuario
                    paqueteSubida.setCorreo =
                        ""; // Limpia el correo en el paquete de subida
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
