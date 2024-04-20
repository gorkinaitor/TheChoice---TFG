import 'package:flutter/material.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

// ignore: camel_case_types
class _PantallaPrincipalState extends State<PantallaPrincipal> {
  //Esto nos vale para controlar la opcion que esta seleccionada por defecto.
  //Esto va como un array donde el orden es el del codigo, en este caso nuestra primera opcion
  //es la primera escrita, por tanto la 0
  int opcSeleccionada = 0;

  @override
  Widget build(BuildContext context) {
    //final colors = Theme.of(context)
    //  .colorScheme; // Esto hereda el color definido en el main
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'La Elección',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 7.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.logout),
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: Colors.purple[700],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [BarraBusqueda()],
        ),
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

class BarraBusqueda extends StatefulWidget {
  const BarraBusqueda({
    super.key,
  });

  @override
  State<BarraBusqueda> createState() => _BarraBusquedaState();
}

class _BarraBusquedaState extends State<BarraBusqueda> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          FocusScope.of(context).requestFocus();
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey)),
          child: Row(
            children: [
              const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                      hintText: 'Buscar...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10)),
                  onTap: () {
                    // Esto evita que se cierre el teclado cuando se toca el TextField
                    Future.delayed(Duration.zero, () {
                      _controller.selection = TextSelection(
                          baseOffset: 0, extentOffset: _controller.text.length);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
