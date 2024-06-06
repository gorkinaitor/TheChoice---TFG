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
        backgroundColor: Color.fromARGB(255, 210, 158, 233),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), 
              activeIcon: Icon(Icons.settings),
              label: 'Configuración',
            ),
          BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined), 
              activeIcon: Icon(Icons.message),
              label: 'Mensajes',
              ),
          BottomNavigationBarItem(
            icon: Icon(Icons.publish_outlined),
            activeIcon: Icon(Icons.publish),
            label: 'Subir Producto',
          ),
        ],
      ),
    );
  }
}
