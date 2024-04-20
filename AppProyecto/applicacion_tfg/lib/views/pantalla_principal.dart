import 'package:flutter/material.dart';

class pantallaPrincipal extends StatefulWidget {
  const pantallaPrincipal({super.key});

  @override
  State<pantallaPrincipal> createState() => _pantallaPrincipalState();
}

// ignore: camel_case_types
class _pantallaPrincipalState extends State<pantallaPrincipal> {
  //Esto nos vale para controlar la opcion que esta seleccionada por defecto.
  //Esto va como un array donde el orden es el del codigo, en este caso nuestra primera opcion
  //es la primera escrita, por tanto la 0
  int opcSeleccionada = 0;

  @override
  Widget build(BuildContext context) {
    //final colors = Theme.of(context)
    //  .colorScheme; // Esto hereda el color definido en el main
    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'The Choice',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.logout),
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: Colors.purple[700],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType
            .shifting, //Animacion de lo que hace la barra de tareas
        currentIndex: //El indice, que define que opcion esta seleccionada, para relacionarla en un futuro
            opcSeleccionada, //Esto atributo define que pestaña esta seleccionada
        onTap: (valorActual) => {
          //Registra cuando se presiona una accion (como un onclick)
          setState(() {
            opcSeleccionada = valorActual;
          })
        },
        elevation: 0, //Quita la linea del menu
        items: [
          //Cada objeto del menu de abajo
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: 'Inicio',
            backgroundColor: Colors.purple[200],
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Favoritos',
            backgroundColor: Color.fromARGB(255, 240, 28, 13),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: 'Mensajes',
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
