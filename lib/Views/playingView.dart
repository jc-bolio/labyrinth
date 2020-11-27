import 'dart:ui';
import 'package:box2d_flame/box2d.dart';
import 'package:labyrinth/GameObjects//ball.dart';
import 'package:labyrinth/GameObjects/daedalus.dart';
import 'package:labyrinth/GameObjects/wall.dart';
import 'package:labyrinth/Views/base.dart';
import 'package:labyrinth/Views/viewManager.dart';
import 'package:labyrinth/Views/switchMessage.dart';
import 'package:labyrinth/helper.dart';


class PlayingView extends BaseView {
  Ball player;
  bool _initRequired = true;
  Daedalus mazeBuilder;

  PlayingView(GameView view, ViewManager viewManager) : super(view, viewManager);

  @override
  void setActive({SwitchMessage message}) {
    if (_initRequired) {
      _initRequired = false;
      // Genera la bola al centro de la pantalla
      player = Ball(viewManager.game,
          scaleVectorBy(Vector2(Wall.wallWidth * 4, Wall.wallWidth * 4),
              viewManager.game.screenSize.width / viewManager.game.scale));
      mazeBuilder = Daedalus(viewManager.game);
      mazeBuilder.generateMaze();
    }
  }

  @override
  void moveToBackground({SwitchMessage message}) {
    // TODO: implementar moveToBackground
  }

  @override
  void render(Canvas canvas) {
    player?.render(canvas);
    mazeBuilder?.render(canvas);
  }

  @override
  void update(double time) {
    player?.update(time);
  }
}
