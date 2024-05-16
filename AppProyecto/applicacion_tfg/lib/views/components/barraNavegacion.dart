import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BarraNav extends StatelessWidget {
  final StatefulNavigationShell navegacionConEstado;

  const BarraNav({required this.navegacionConEstado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navegacionConEstado,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: navegacionConEstado.currentIndex,
        onTap: (index) {
          navegacionConEstado.goBranch(index);
        },
        backgroundColor: Colors.amber,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Inicio',
            backgroundColor: Colors.purple[200],
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
            backgroundColor: Colors.amber,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Configuración'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notificaciones'),
        ],
      ),
    );
  }
}
