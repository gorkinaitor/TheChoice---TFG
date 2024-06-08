class Conversaciones {
  Conversaciones({
    required this.id,
    required this.id_usuario1,
    required this.id_usuario2,
    required this.fecha,
  });

  /// ID de la conversación
  final String id;

  /// ID del usuario 1
  final String id_usuario1;

  /// ID del usuario 2
  final String id_usuario2;

  /// Fecha de creación
  final DateTime fecha;

  Conversaciones.fromMap(Map<String, dynamic> map)
      : id = map['id'],
      id_usuario1 = map['id_usuario1'],
      id_usuario2 = map['id_usuario2'],
      fecha = DateTime.parse(map['created_at']);
}
