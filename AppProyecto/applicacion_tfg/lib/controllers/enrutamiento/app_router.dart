import 'package:applicacion_tfg/views/pantalla_mensajes.dart';
import 'package:applicacion_tfg/views/pantalla_producto.dart';
import 'package:flutter/material.dart';
import 'package:applicacion_tfg/views/pantalla_ubicacion.dart';
import 'package:go_router/go_router.dart';
import 'package:applicacion_tfg/views/pantalla_principal.dart';
import 'package:applicacion_tfg/views/perfil_Usuario.dart';
import 'package:applicacion_tfg/views/components/barra_navegacion.dart';
import 'package:applicacion_tfg/views/pantalla_subir_producto.dart';

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
              builder: (context, state) => PantallaPrincipal(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/perfilUsuario',
              builder: (context, state) => PerfilUsuario(),
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
              builder: (context, state) => PantallaMensajes(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/pantallaSubirProducto',
              builder: (context, state) => PantallaSubirProducto(),
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
        builder: (context, state) => PantallaProducto())   
  ],
);
