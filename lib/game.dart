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
  //
  static const int WORLD_POOL_SIZE = 100;
  static const int WORLD_POOL_CONTAINER_SIZE = 10;
  //
  World world;
  //
  final Vector2 _gravity = Vector2.zero();
  //
  final int scale = 5;
  //
  Size screenSize;
  //
  Rect _screenRect;
  Rect get screenRect => _screenRect;
  //
  ViewManager _viewManager;

  bool pauseGame = false;

  MazeGame({GameView startView = GameView.Playing}) {
    world = new World.withPool(
        _gravity, DefaultWorldPool(WORLD_POOL_SIZE, WORLD_POOL_CONTAINER_SIZE));
    initialize(startView: startView);
  }

  //
  Future initialize({GameView startView = GameView.Playing}) async {
    //
    resize(await Flame.util.initialDimensions());
    _viewManager = ViewManager(this);
    _viewManager.changeView(startView);
  }

  void resize(Size size) {
    //
    screenSize = size;
    _screenRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    super.resize(size);
  }

  @override
  void render(Canvas canvas) {
    //
    if (screenSize == null || pauseGame) {
      return;
    }
    //
    canvas.save();
    canvas.scale(screenSize.width / scale);
    _viewManager?.render(canvas);
    //
    canvas.restore();
  }

  @override
  void update(double t) {
    if (screenSize == null || pauseGame) {
      return;
    }

    //
    world.stepDt(t, 100, 100);
    _viewManager?.update(t);
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