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

// Instancia compartida de la clase PaqueteSubida para pasar datos entre pantallas
final PaqueteSubida paqueteSubida = PaqueteSubida();

// Configuración de las rutas de la aplicación usando GoRouter
final GoRouter appRouter = GoRouter(
  routes: [
    // Rutas dentro del índice de la barra de navegación inferior
    StatefulShellRoute.indexedStack(
      builder: (context, state, nestedNavigator) {
        return BarraNav(
            navegacionConEstado:
                nestedNavigator); // Barra de navegación inferior
      },
      branches: [
        // Rama para la pantalla principal
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => PantallaPrincipal(
                  claseCompartida:
                      paqueteSubida), // Pantalla principal con acceso al paquete de datos compartido
            ),
          ],
        ),
        // Rama para la pantalla de perfil de usuario
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/perfilUsuario',
              builder: (context, state) => PerfilUsuario(
                  claseCompartida:
                      paqueteSubida), // Pantalla de perfil de usuario con acceso al paquete de datos compartido
            ),
          ],
        ),
        // Rama para la pantalla de conversaciones/mensajes
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/mensajes',
              builder: (context, state) => PantallaConversaciones(),
            ),
          ],
        ),
        // Rama para la pantalla de subir producto
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/pantallaSubirProducto',
              builder: (context, state) => PantallaSubirProducto(
                  claseCompartida:
                      paqueteSubida), // Pantalla de subir producto con acceso al paquete de datos compartido
            ),
          ],
        )
      ],
    ),

    // Rutas fuera de la barra de navegación inferior

    // Ruta para la pantalla de ubicación
    GoRoute(
        path: '/pantallaUbicacion2',
        builder: (context, state) => PantallaUbicacion()),

    // Ruta para la pantalla de producto, con parámetros extra
    GoRoute(
      path: '/pantallaProducto',
      builder: (context, state) {
        final producto = state.extra
            as Map<String, dynamic>; // Parámetros extra recibidos en la ruta
        return PantallaProducto(
            producto: producto); // Pantalla de producto con los datos recibidos
      },
    ),
  ],
);
