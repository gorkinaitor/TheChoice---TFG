import 'package:applicacion_tfg/controllers/enrutamiento/app_router.dart';
import 'package:applicacion_tfg/models/modelo_subir_producto.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ArrancarSupabase.inicializarSupabase();
  await supabase;
  runApp((Principal()));
}

final supabase = Supabase.instance.client;

class Principal extends StatelessWidget {
  Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      title: 'The Choice',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 233, 230, 68)),
        useMaterial3: true,
      ),
    );
  }
}
