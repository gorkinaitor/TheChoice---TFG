import 'package:applicacion_tfg/controllers/constantesMensajes.dart';
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
    _setupConversacionesStream();

    // Listener para cambios en el estado de autenticación
    supabase.auth.onAuthStateChange.listen((AuthState event) {
      if (mounted) {
        setState(() {
          _setupConversacionesStream();
        });
      }
    });
  }

  void _setupConversacionesStream() {
    final miUsuarioId = supabase.auth.currentUser?.email;
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

  void _mostrarPopupIniciarConversacion() {
    String? _destinatarioSeleccionado;
    final TextEditingController _mensajeInicialController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _obtenerPosiblesDestinatarios(), // Método para obtener la lista de posibles destinatarios
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // Muestra un indicador de carga mientras se obtienen los datos
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final posiblesDestinatarios = snapshot.data!;
              return AlertDialog(
                title: Text('Iniciar Conversación'),
                content: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      DropdownButtonFormField<String>(
                        items: posiblesDestinatarios.map((destinatario) {
                          return DropdownMenuItem<String>(
                            value: destinatario['google_id'],
                            child: Text(destinatario['google_id']),
                          );
                        }).toList(),
                        onChanged: (selectedDestinatario) {
                          // Aquí puedes manejar la selección del destinatario
                          print('Destinatario seleccionado: $selectedDestinatario');
                          _destinatarioSeleccionado = selectedDestinatario;
                        },
                        decoration: InputDecoration(labelText: 'Destinatario'),
                      ),
                      TextField(
                        controller: _mensajeInicialController,
                        decoration: InputDecoration(labelText: 'Mensaje inicial'),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Enviar'),
                    onPressed: () async {
                      if (_destinatarioSeleccionado != null && _mensajeInicialController.text.isNotEmpty) {
                        try {
                          await _iniciarConversacion(_destinatarioSeleccionado!, _mensajeInicialController.text);
                          Navigator.of(context).pop();
                        } catch (error) {
                          print('Error al iniciar la conversación: $error');
                          // Muestra un mensaje de error en la UI si es necesario
                        }
                      }
                    },
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  /// Método para obtener la lista de posibles destinatarios
  Future<List<Map<String, dynamic>>> _obtenerPosiblesDestinatarios() async {
    // Realiza la consulta a la tabla de perfiles
    final response = await supabase.from('perfiles').select();

    // Procesa los datos obtenidos y los devuelve como una lista de mapas
    final List<Map<String, dynamic>> posiblesDestinatarios = response;

    return posiblesDestinatarios;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Session?>(
      stream: supabase.auth.onAuthStateChange.map((event) => event.session),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras se espera la respuesta del stream
          return Scaffold(
            appBar: AppBar(title: Text('Conversaciones')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final estaAutenticado = snapshot.data?.user != null;
        if (!estaAutenticado) {
          // Si el usuario no está autenticado, muestra un mensaje
          return Scaffold(
            appBar: AppBar(title: Text('Conversaciones')),
            body: Center(child: Text('No estás logueado. Por favor inicia sesión.')),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Conversaciones'),
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _mostrarPopupIniciarConversacion,
                ),
              ],
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
                      final otroUsuarioEmail = conversacion['id_usuario1'] == supabase.auth.currentUser!.email
                          ? conversacion['id_usuario2']
                          : conversacion['id_usuario1'];
                      return ListTile(
                        title: Text('Chat con $otroUsuarioEmail'), // Puedes cambiar esto para mostrar el nombre del usuario
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PantallaMensajes(
                                id_conversacion: conversacion['id'],
                                idUsuario2: conversacion['id_usuario2'],
                              ),
                            ),
                          );
                        },
                      );
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

  Future<void> _iniciarConversacion(String idUsuarioSeleccionado, String mensajeInicial) async {
    final String? miUsuarioCorreo = supabase.auth.currentUser!.email;

    // Verificar si ya existe una conversación entre los dos usuarios
    final response1 = await supabase
        .from('conversaciones')
        .select()
        .eq('id_usuario1', miUsuarioCorreo!)
        .eq('id_usuario2', idUsuarioSeleccionado);

    final response2 = await supabase
        .from('conversaciones')
        .select()
        .eq('id_usuario1', idUsuarioSeleccionado)
        .eq('id_usuario2', miUsuarioCorreo);

    if (response1.isNotEmpty || response2.isNotEmpty) {
      // La conversación ya existe, reutilizarla
      final conversacionExistente = response1.isNotEmpty ? response1[0] : response2[0];
      print('Conversación ya existente: ${conversacionExistente['id']}');
    } else {
      // La conversación no existe, crear una nueva
      final nuevaConversacion = await supabase
          .from('conversaciones')
          .insert({
            'id_usuario1': miUsuarioCorreo,
            'id_usuario2': idUsuarioSeleccionado,
          })
          .select()
          .single();

      if (nuevaConversacion.isEmpty) {
        throw Exception('Error al crear la nueva conversación');
      }

      print('Nueva conversación creada: ');

      final response3 = await supabase
        .from('conversaciones')
        .select()
        .eq('id_usuario1', miUsuarioCorreo)
        .eq('id_usuario2', idUsuarioSeleccionado);

      final response4 = await supabase
        .from('conversaciones')
        .select()
        .eq('id_usuario1', idUsuarioSeleccionado)
        .eq('id_usuario2', miUsuarioCorreo);

      var _idConversacion;
      if (response3.isNotEmpty || response4.isNotEmpty) {
        _idConversacion = response3.isNotEmpty ? response3[0]['id'] : response4[0]['id'];
        print(_idConversacion);
      }
      // Opcional: enviar el primer mensaje en la nueva conversación
      if (mensajeInicial.isNotEmpty) {
        await supabase.from('mensajes').insert({
          'id_conversacion': _idConversacion,
          'id_emisor': miUsuarioCorreo,
          'id_receptor': idUsuarioSeleccionado,
          'contenido_mensaje': mensajeInicial,
        });
      }
    }
  }
}
