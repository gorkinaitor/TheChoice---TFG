class Mensajes {
  Mensajes({
    required this.id,
    required this.id_conversacion,
    required this.id_emisor,
    required this.id_receptor,
    required this.contenido_mensaje,
    required this.fecha,
    required this.esMio,
  });

  /// ID del mensaje
  final String id;

  /// ID de la conversación
  final String id_conversacion;

  /// Google ID del perfil asociado al emisor del mensaje
  final String id_emisor;

  /// Google ID del perfil asociado al receptor del mensaje
  final String id_receptor;

  /// Contenido del mensaje
  final String contenido_mensaje;

  /// Fecha de creación del mensaje
  final DateTime fecha;

  // Comprueba si el mensaje es enviado por el usuario o no
  final bool esMio;

  Mensajes.fromMap({
    required Map<String, dynamic> map,
    required String? usuarioId,
  })  : id = map['id'],
        id_conversacion = map['id_conversacion'],
        id_emisor = map['id_emisor'],
        id_receptor = map['id_receptor'],
        contenido_mensaje = map['contenido_mensaje'],
        fecha = DateTime.parse(map['fecha']),
        esMio = usuarioId == map['id_emisor'];
}
