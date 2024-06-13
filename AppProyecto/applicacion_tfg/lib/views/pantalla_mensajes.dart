import 'dart:async';
import 'package:applicacion_tfg/controllers/Mensajes.dart';
import 'package:applicacion_tfg/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart';

class PantallaMensajes extends StatefulWidget {
  final String id_conversacion;
  final String idUsuario2;

  const PantallaMensajes({Key? key, required this.id_conversacion, required this.idUsuario2}) : super(key: key);

  static Route<void> route(String conversationId, String usuario2id) {
    return MaterialPageRoute(
      builder: (context) => PantallaMensajes(id_conversacion: conversationId, idUsuario2: usuario2id),
    );
  }

  @override
  State<PantallaMensajes> createState() => _PantallaMensajesState();
}

class _PantallaMensajesState extends State<PantallaMensajes> {
  late final Stream<List<Mensajes>> _mensajesStream;

  //Carga los mensajes existentes del usuario logueado con otro usuario concreto en memoria
  @override
  void initState() {
    super.initState();
    final _id = supabase.auth.currentUser!.id;
    _mensajesStream = supabase
        .from('mensajes')
        .stream(primaryKey: ['id'])
        .eq('id_conversacion', widget.id_conversacion)
        .order('fecha')
        .map((maps) => maps
            .map((map) => Mensajes.fromMap(map: map, usuarioId: _id))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
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
      //Carga los mensajes de la conversación en la pantalla
      body: StreamBuilder<List<Mensajes>>(
        stream: _mensajesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //Muestra un mensaje de error
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final mensajes = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: mensajes.isEmpty
                      ? const Center(
                          child: Text('Comienza a chatear :)'),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: mensajes.length,
                          itemBuilder: (context, index) {
                            final mensaje = mensajes[index];
                            return _CapsulaMensaje(
                              mensaje: mensaje,
                            );
                          },
                        ),
                ),
                _BarraMensaje(id_conversacion: widget.id_conversacion, idUsuario2: widget.idUsuario2,),
              ],
            );
          } else {
            // Si no hay error ni datos, muestra un indicador de carga
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class _BarraMensaje extends StatefulWidget {
  final String id_conversacion;
  final String idUsuario2;

  const _BarraMensaje({Key? key, required this.id_conversacion, required this.idUsuario2}) : super(key: key);

  @override
  State<_BarraMensaje> createState() => _BarraMensajeState();
}

class _BarraMensajeState extends State<_BarraMensaje> {
  late final TextEditingController _teclado;

  @override
  void initState() {
    _teclado = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _teclado.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[400],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  autofocus: false,
                  controller: _teclado,
                  decoration: const InputDecoration(
                    hintText: 'Mensaje',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              TextButton(
                onPressed: _enviarMensaje,
                child: const Icon(Icons.send, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _enviarMensaje() async {
    final text = _teclado.text;
    final idUsuario1 = supabase.auth.currentUser?.id;
    if (text.isEmpty) {
      return;
    }
    _teclado.clear();
    FocusScope.of(context).unfocus();
  
    await supabase.from('mensajes').insert({
      'id_conversacion': widget.id_conversacion,
      'id_emisor': idUsuario1,
      'id_receptor': widget.idUsuario2,
      'contenido_mensaje': text,
    });
  }
}

class _CapsulaMensaje extends StatelessWidget {
  const _CapsulaMensaje({
    Key? key,
    required this.mensaje,
  }) : super(key: key);

  final Mensajes mensaje;
  

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!mensaje.esMio)
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: mensaje.esMio
                ? Theme.of(context).primaryColor
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(mensaje.contenido_mensaje),
        ),
      ),
      const SizedBox(width: 12),
      Text(format(mensaje.fecha, locale: 'es_short')),
      const SizedBox(width: 60),
    ];
    if (mensaje.esMio) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment:
            mensaje.esMio ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
