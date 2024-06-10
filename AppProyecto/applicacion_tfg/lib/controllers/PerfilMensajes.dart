class PerfilMensajes {
  PerfilMensajes({
    required this.googleId,
    required this.createdAt,
  });

  /// Google ID del perfil
  final String googleId;

  /// Fecha de creacion del perfil
  final DateTime createdAt;

  PerfilMensajes.fromMap(Map<String, dynamic> map)
      : googleId = map['google_id'],
        createdAt = DateTime.parse(map['created_at']);
}
