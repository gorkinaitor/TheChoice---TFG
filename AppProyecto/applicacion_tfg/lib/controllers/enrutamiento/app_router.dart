import 'package:applicacion_tfg/views/mensajes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:applicacion_tfg/views/pantalla_principal.dart';
import 'package:applicacion_tfg/views/perfil_Usuario.dart';
import 'package:applicacion_tfg/views/components/barraNavegacion.dart';

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
              path: '/configuracion',
              builder: (context, state) => PerfilUsuario(),
            ),
          ],
        ),
         StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/mensajes',
              builder: (context, state) => Mensajes(),
            ),
          ],
        ),
      ],
    ),
  ],
);
