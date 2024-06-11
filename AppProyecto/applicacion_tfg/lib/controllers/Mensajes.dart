class Mensajes {
  Mensajes({
    required this.id,
    required this.id_conversacion,
    required this.id_emisor,
    required this.id_receptor,
    required this.content,
    required this.createdAt,
    required this.isMine,
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
  final String content;

  /// Fecha de creación del mensaje
  final DateTime createdAt;

  // Comprueba si el mensaje es enviado por el usuario o no
  final bool isMine;

  Mensajes.fromMap({
    required Map<String, dynamic> map,
    required String? myUserId,
  })  : id = map['id'],
        id_conversacion = map['id_conversacion'],
        id_emisor = map['id_emisor'],
        id_receptor = map['id_receptor'],
        content = map['contenido_mensaje'],
        createdAt = DateTime.parse(map['fecha']),
        isMine = myUserId == map['id_emisor'];
}
