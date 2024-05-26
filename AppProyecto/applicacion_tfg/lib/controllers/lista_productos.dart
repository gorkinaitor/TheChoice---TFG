import 'package:flutter/material.dart';

class lista extends StatefulWidget {
  const lista({
    super.key,
  });

  @override
  State<lista> createState() => _ListaState();
}

class _ListaState extends State<lista> {
  int opcSeleccionada = 0;

  final List<Map<String, String>> items = List.generate(
    20,
    (index) => {
      'title': 'Item $index',
      'description': 'Description of Item $index',
      'image':
          'https://miro.medium.com/v2/resize:fit:1400/1*TVebZE0MHzu7mpFw_bCsrQ.jpeg',
    },
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GridView.extent(
      maxCrossAxisExtent: 200.0,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      padding: const EdgeInsets.all(8.0),
      children: items.map((item) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.network(
                  item['image']!,
                  height: 100,
                  width: 130,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 8),
              Text(
                item['title']!,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                item['description']!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        );
      }).toList(),
    ));
  }
}
