import 'dart:ui';
import 'package:box2d_flame/box2d.dart';
import 'package:labyrinth/GameObjects/ball.dart';
import 'package:labyrinth/GameObjects/wall.dart';
import 'package:labyrinth/Views/base.dart';
import 'package:labyrinth/Views/switchMessage.dart';
import 'package:labyrinth/Views/viewManager.dart';
import 'package:labyrinth/helper.dart';

class MenuBackground extends BaseView {
  Ball player;
  bool _initRequired = true;
  Wall leftWall;
  Wall topWall;
  Wall rightWall;
  Wall bottomWall;
  MenuBackground(GameView view, ViewManager viewManager) : super(view, viewManager);

  @override
  void render(Canvas canvas) {
    player?.render(canvas);
    leftWall?.render(canvas);
    topWall?.render(canvas);
    rightWall?.render(canvas);
    bottomWall?.render(canvas);
  }

  @override
  void setActive({SwitchMessage message}) {
    if (_initRequired) {
      var screenSize = viewManager.game.screenSize;
      player = Ball(
          viewManager.game,
          scaleVectorBy(
              Vector2(screenSize.width / 2, (screenSize.height / 100) * 20),
              viewManager.game.screenSize.width / viewManager.game.scale));

      leftWall = Wall(
        viewManager.game,
        Vector2.zero(),
        Vector2(0, screenSize.height),
      );

      topWall = Wall(
        viewManager.game,
        Vector2.zero(),
        Vector2(screenSize.width, 0),
      );

      var rightStart = Vector2(viewManager.game.screenRect.right, 0);
      rightStart.sub(Vector2(Wall.wallWidth, 0));

      var rightEnd =
      Vector2(viewManager.game.screenRect.right, screenSize.height);
      rightEnd.sub(Vector2(Wall.wallWidth, 0));
      rightWall = Wall(viewManager.game, rightStart, rightEnd);

      var bottomStart = Vector2(0, screenSize.height);
      bottomStart.sub(Vector2(0, Wall.wallWidth));

      var bottomEnd =
      Vector2(screenSize.width, screenSize.height - Wall.wallWidth);
      bottomEnd.sub(Vector2(0, Wall.wallWidth));

      rightEnd.sub(Vector2(Wall.wallWidth, 0));
      bottomWall = Wall(viewManager.game, bottomStart, bottomEnd);
    }
  }

  @override
  void moveToBackground({SwitchMessage message}) {
    // TODO: implementar moveToBackground
  }

  @override
  void update(double t) {
    player?.update(t);
  }

}