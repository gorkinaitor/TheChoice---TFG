import 'package:applicacion_tfg/main.dart';
import 'package:applicacion_tfg/views/pantalla_mensajes.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PantallaConversaciones extends StatefulWidget {
  @override
  _PantallaConversacionesState createState() => _PantallaConversacionesState();
}

class _PantallaConversacionesState extends State<PantallaConversaciones> {
  late Stream<List<Map<String, dynamic>>> _conversacionesStream;

  @override
  void initState() {
    super.initState();
    prepararConversaciones();

    // Listener para cambios en el estado de autenticación
    supabase.auth.onAuthStateChange.listen((AuthState event) {
      if (mounted) {
        setState(() {
          prepararConversaciones();
        });
      }
    });
  }

  void prepararConversaciones() {
    final miUsuarioId = supabase.auth.currentUser?.id;
    if (miUsuarioId != null) {
      final streamUsuario1 = supabase
          .from('conversaciones')
          .stream(primaryKey: ['id'])
          .eq('id_usuario1', miUsuarioId);

      final streamUsuario2 = supabase
          .from('conversaciones')
          .stream(primaryKey: ['id'])
          .eq('id_usuario2', miUsuarioId);

      _conversacionesStream = Rx.combineLatest2(
        streamUsuario1,
        streamUsuario2,
        (List<Map<String, dynamic>> id_usuario1, List<Map<String, dynamic>> id_usuario2) {
          return [...id_usuario1, ...id_usuario2];
        },
      ).asBroadcastStream();
    } else {
      _conversacionesStream = Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Session?>(
      stream: supabase.auth.onAuthStateChange.map((event) => event.session),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras se espera la respuesta del stream
          return Scaffold(
            appBar: AppBar(title: Text('Chats')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final estaAutenticado = snapshot.data?.user != null;
        if (!estaAutenticado) {
          // Si el usuario no está autenticado, muestra un mensaje
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Chats',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              backgroundColor: Colors.lightBlue,
            ),
            body: Center(child: Text('No estás logueado. Por favor inicia sesión.')),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Chats',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              backgroundColor: Colors.lightBlue,
            ),
            body: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _conversacionesStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final conversaciones = snapshot.data!;
                  return ListView.builder(
                    itemCount: conversaciones.length,
                    itemBuilder: (context, index) {
                      final conversacion = conversaciones[index];
                      final otroUsuarioId = conversacion['email_usuario1'] == supabase.auth.currentUser!.email
                          ? conversacion['email_usuario2']
                          : conversacion['email_usuario1'];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
                          ),
                        ),    
                      child: ListTile(
                        title: Text('$otroUsuarioId'),
                        onTap: () {
                          if(conversacion['id_usuario1']== supabase.auth.currentUser!.id){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PantallaMensajes(
                                  id_conversacion: conversacion['id'],
                                  idUsuario2: conversacion['id_usuario2'],
                                ),
                              ),
                            );
                          } else{
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PantallaMensajes(
                                  id_conversacion: conversacion['id'],
                                  idUsuario2: conversacion['id_usuario1'],
                                ),
                              ),
                            );
                          }
                        },
                      ));
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          );
        }
      },
    );
  }
}