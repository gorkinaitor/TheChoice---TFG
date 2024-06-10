import 'package:applicacion_tfg/views/pantalla_conversaciones.dart';
import 'package:applicacion_tfg/views/pantalla_mensajes.dart';
import 'package:applicacion_tfg/views/pantalla_producto.dart';
import 'package:applicacion_tfg/views/pantalla_ubicacion.dart';
import 'package:go_router/go_router.dart';
import 'package:applicacion_tfg/views/pantalla_principal.dart';
import 'package:applicacion_tfg/views/perfil_Usuario.dart';
import 'package:applicacion_tfg/views/components/barra_navegacion.dart';
import 'package:applicacion_tfg/views/pantalla_subir_producto.dart';
import 'package:applicacion_tfg/models/modelo_subir_producto.dart';

final PaqueteSubida paqueteSubida = PaqueteSubida();
final GoRouter appRouter = GoRouter(
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navegacionConEstado) {
        return BarraNav(navegacionConEstado: navegacionConEstado);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) =>
                  PantallaPrincipal(claseCompartida: paqueteSubida),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/perfilUsuario',
              builder: (context, state) =>
                  PerfilUsuario(claseCompartida: paqueteSubida),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/pantallaUbicacion',
              builder: (context, state) => PantallaUbicacion(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/mensajes',
              builder: (context, state) => PantallaConversaciones(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/pantallaSubirProducto',
              builder: (context, state) =>
                  PantallaSubirProducto(claseCompartida: paqueteSubida),
            )
          ],
        )
      ],
    ),

    //RUTAS FUERA DE LA BARRA DE NAVEGACION INFERIOR
    GoRoute(
        path: '/pantallaUbicacion2',
        builder: (context, state) => PantallaUbicacion()),

    GoRoute(
      path: '/pantallaProducto',
      builder: (context, state) {
        final producto = state.extra as Map<String, dynamic>;
        return PantallaProducto(producto: producto);
      },
    ),
  ],
);
