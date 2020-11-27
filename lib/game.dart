import 'dart:ui';
import 'package:box2d_flame/box2d.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:labyrinth/Views/base.dart';
import 'package:labyrinth/Views/viewManager.dart';

class GameWidget extends StatefulWidget {
  @override
  _GameWidgetState createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  MazeGame game;

  _GameWidgetState() {
    game = new MazeGame();
  }

  @override
  void initState() {
    super.initState();
    game.pop = () {
      Navigator.pop(context);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        game.widget,
      ]),
    );
  }
}

class MazeGame extends Game {
  // Necesarios para Box2D
  static const int WORLD_POOL_SIZE = 100;
  static const int WORLD_POOL_CONTAINER_SIZE = 10;
  // Mundo físico del juego
  World world;
  // Cero de gravedad
  final Vector2 _gravity = Vector2.zero();
  // Factor de escala
  final int scale = 5;
  // Tamaño de la pantalla
  Size screenSize;
  // Tamaño del rectangulo basado en la pantalla
  Rect _screenRect;
  Rect get screenRect => _screenRect;
  // Maneja las vistas y transiciones
  ViewManager _viewManager;

  bool pauseGame = false;

  MazeGame({GameView startView = GameView.Playing}) {
    world = new World.withPool(
        _gravity, DefaultWorldPool(WORLD_POOL_SIZE, WORLD_POOL_CONTAINER_SIZE));
    initialize(startView: startView);
  }

  Future initialize({GameView startView = GameView.Playing}) async {
    // Usa resize en cuanto flutter está listo
    resize(await Flame.util.initialDimensions());
    _viewManager = ViewManager(this);
    _viewManager.changeView(startView);
  }

  void resize(Size size) {
    // Guarda el el tamaño de la pantalla y su rectangulo asociado
    screenSize = size;
    _screenRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    super.resize(size);
  }

  @override
  void render(Canvas canvas) {
    // Si no hay valor de la pantalla termina el render
    if (screenSize == null || pauseGame) {
      return;
    }
    // Guarda el canvas y ajusta el tamaño y escala
    canvas.save();
    canvas.scale(screenSize.width / scale);
    _viewManager?.render(canvas);
    // Termina el canvas y restaura la pantalla
    canvas.restore();
  }

  @override
  void update(double time) {
    if (screenSize == null || pauseGame) {
      return;
    }

    // Realiza los calculos de las físicas
    world.stepDt(time, 100, 100);
    _viewManager?.update(time);
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      pauseGame = true;
    }
    else{
      pauseGame = false;
    }
  }

  Function() pop;
}