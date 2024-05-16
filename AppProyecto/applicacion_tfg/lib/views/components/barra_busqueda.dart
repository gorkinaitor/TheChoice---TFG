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
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey),
          ),
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
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                  onTap: () {
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
