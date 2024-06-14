import 'package:applicacion_tfg/controllers/enrutamiento/app_router.dart'; // Importa el enrutador de la aplicación
import 'package:applicacion_tfg/models/modelo_subir_producto.dart'; // Importa el modelo para subir productos
import 'package:flutter/material.dart'; // Importa el paquete de Flutter para construir la interfaz de usuario
import 'package:supabase_flutter/supabase_flutter.dart'; // Importa el paquete de Supabase para Flutter

// Función principal que se ejecuta al iniciar la aplicación
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Asegura que los widgets de Flutter estén inicializados
  await ArrancarSupabase.inicializarSupabase(); // Inicializa Supabase
  await supabase; // Espera a que Supabase esté listo
  runApp((Principal())); // Ejecuta la aplicación principal
}

// Define el cliente de Supabase como una instancia global
final supabase = Supabase.instance.client;

// Define la clase Principal, que es un StatelessWidget
class Principal extends StatelessWidget {
  Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter, // Configuración del enrutador para la navegación
      debugShowCheckedModeBanner: false, // Oculta la etiqueta de modo debug
      title: 'The Choice', // Título de la aplicación
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 233, 230,
                68)), // Define el esquema de colores de la aplicación
        useMaterial3: true, // Habilita el uso de Material Design 3
      ),
    );
  }
}
