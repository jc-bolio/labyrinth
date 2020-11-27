import 'package:flame/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labyrinth/Views/menu.dart';
import 'dart:async';

void main() async {
  // Asegura que flame esté listo antes de iniciar el juego
  await setupFlame();
  runApp(App());
}

// Configurar Flame
Future setupFlame() async {
  // Requerido por Flutter para usar async
  WidgetsFlutterBinding.ensureInitialized();
  var flameUtil = Util();
  // Obliga a la aplicación a estar en pantalla completa
  await flameUtil.fullScreen();
  // Obliga a la aplicación a estar en orientación vertical
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Menu(),
    );
  }
}