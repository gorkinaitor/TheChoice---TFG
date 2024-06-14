import 'package:applicacion_tfg/main.dart';
import 'package:applicacion_tfg/views/pantalla_mensajes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:applicacion_tfg/controllers/favoritos.dart';

class PantallaProducto extends StatefulWidget {
  final Map<String, dynamic> producto;

  //Se requiere el parámetro prodcuto para construir esta clase
  const PantallaProducto({Key? key, required this.producto}) : super(key: key);

  @override
  State<PantallaProducto> createState() => _PantallaProductoState();
}

class _PantallaProductoState extends State<PantallaProducto> {
  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;
    final idDestinatario = producto['id_proveedor'];
    final emailDestinatario = producto['correo'];

    //Comprueba el estado de autenticación
    return StreamBuilder<Session?>(
      stream: supabase.auth.onAuthStateChange.map((event) => event.session),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras se espera la respuesta del stream
          return Scaffold(
            appBar: AppBar(title: Text('Producto')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final estaAutenticado = snapshot.data?.user != null;

        // Si el usuario no está autenticado, muestra un mensaje y no le permite acceder a las funcionalidades de esa pantalla
        if (!estaAutenticado) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Productos',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              backgroundColor: Color.fromARGB(255, 221, 168, 108),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: Center(
                child: Text('No estás logueado. Por favor inicia sesión.')),
          );
          // Si el usuario está autenticado, le permite acceder a las funcionalidades de esa pantalla con normalidad
        } else {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Productos',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              backgroundColor: Color.fromARGB(255, 221, 168, 108),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            //Carga los datos del producto que se encuentran en la base de datos
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        producto['rutaurl']!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    producto['titulo'] ?? 'No Title',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    producto['descripcion'] ?? 'No Description',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  BotonFavoritos(
                    userId: supabase.auth.currentSession!.user.id,
                    productoId: producto['id'],
                  ),
                  //Icono que permite ser clickado e inicia una conversación con el proovedor de ese producto
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        Text('Contáctanos',
                            style: TextStyle(color: Colors.black)),
                        IconButton(
                          icon: Icon(Icons.message, color: Colors.black),
                          onPressed: () {
                            //Comprueba si el correo del proovedor es el mismo que el de la sesión actual
                            if (producto['correo'] ==
                                supabase.auth.currentUser?.email) {
                              //Acción que muestra una alerta impidiendo el iniciar una conversación si el proovedor es la misma persona que el usuario
                              mostrarAlertaUsuarioMismo(context, () {});
                            } else {
                              //Acción que inicia la conversación
                              _iniciarConversacion(
                                  context, idDestinatario, emailDestinatario);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> _iniciarConversacion(BuildContext context, String idDestinatario,
      String emailDestinatario) async {
    final supabase = Supabase.instance.client;
    final idUsuarioActual = supabase.auth.currentUser!.id;
    final emailUsuarioActual = supabase.auth.currentUser!.email;

    // Verifica si ya existe una conversación entre los dos usuarios
    final response1 = await supabase
        .from('conversaciones')
        .select()
        .eq('id_usuario1', idUsuarioActual!)
        .eq('id_usuario2', idDestinatario);

    final response2 = await supabase
        .from('conversaciones')
        .select()
        .eq('id_usuario1', idDestinatario)
        .eq('id_usuario2', idUsuarioActual);

    // Si la conversación ya existe, navega a ella
    if (response1.isNotEmpty || response2.isNotEmpty) {
      final conversacionExistente =
          response1.isNotEmpty ? response1[0] : response2[0];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PantallaMensajes(
            id_conversacion: conversacionExistente['id'],
            idUsuario2: idDestinatario,
          ),
        ),
      );
      // Si la conversación no existe, crea una nueva
    } else {
      final nuevaConversacion = await supabase
          .from('conversaciones')
          .insert({
            'id_usuario1': idUsuarioActual,
            'id_usuario2': idDestinatario,
            'email_usuario1': emailUsuarioActual,
            'email_usuario2': emailDestinatario
          })
          .select()
          .single();

      //Navega a la conversación con dicho usuario
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PantallaMensajes(
            id_conversacion: nuevaConversacion['id'],
            idUsuario2: idDestinatario,
          ),
        ),
      );
    }
  }
}

// Pop up que evita que un usuario pueda iniciar una conversación consigo mismo en caso de que sea él el que ha subido el producto
void mostrarAlertaUsuarioMismo(BuildContext context, Function onClose) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('No puedes iniciar una conversación'),
        content: Text('No puedes iniciar una conversación contigo mismo.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onClose();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
