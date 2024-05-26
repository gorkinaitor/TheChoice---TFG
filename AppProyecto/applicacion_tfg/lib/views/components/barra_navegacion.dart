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
        type: BottomNavigationBarType.fixed,
        currentIndex: navegacionConEstado.currentIndex,
        onTap: (index) {
          navegacionConEstado.goBranch(index);
        },
        backgroundColor: Color.fromARGB(255, 224, 212, 221),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home_filled),
            label: 'Inicio',
            backgroundColor: Colors.purple[200],
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: 'Perfil',
            backgroundColor: Colors.amber,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Configuración',
            backgroundColor: Colors.lightGreen,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.publish_outlined),
            activeIcon: Icon(Icons.upload),
            label: 'Subir Producto',
          ),
        ],
      ),
    );
  }
}
