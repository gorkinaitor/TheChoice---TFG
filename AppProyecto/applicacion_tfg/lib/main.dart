import 'package:applicacion_tfg/controllers/enrutamiento/app_router.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:applicacion_tfg/controllers/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ArrancarSupabase.inicializarSupabase();
  runApp((const Principal()));
}

final supabase = Supabase.instance.client;

class Principal extends StatelessWidget {
  const Principal({super.key});

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
