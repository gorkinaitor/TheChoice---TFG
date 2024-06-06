import 'package:flutter/material.dart';

class BarraBusqueda extends StatefulWidget {
  const BarraBusqueda({Key? key}) : super(key: key);

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
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: Color.fromARGB(255, 209, 209, 209)),
          ),
          child: Row(
            children: [
              Expanded(
                 child: Focus(
                  child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Buscar',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                  onTap: () {
                    Future.delayed(Duration.zero, () {
                      _controller.selection = TextSelection(
                          baseOffset: 0, extentOffset: _controller.text.length);
                      });
                    },
                  )
                )
              ),
              const Padding(
                padding: EdgeInsets.only(right: 10),
              child:  Icon(
                Icons.search,
                color: Color.fromARGB(255, 58, 58, 58),
              )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
