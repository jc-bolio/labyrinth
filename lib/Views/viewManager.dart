import 'dart:ui';
import 'package:labyrinth/Views/base.dart';
import 'package:labyrinth/Views/menuBackground.dart';
import 'package:labyrinth/Views/playingView.dart';
import 'package:labyrinth/Views/switchMessage.dart';
import 'package:labyrinth/game.dart';

class ViewManager {
  List<BaseView> views;
  MazeGame game;
  BaseView get activeView => views.firstWhere((view) => view.active,
      orElse:() {
        return null;
      });

  ViewManager(this.game) {
    _generateViews();
  }

  void _generateViews() {
    if (views == null) {
      views = List();
      views.add(PlayingView(GameView.Playing, this));
      views.add(MenuBackground(GameView.MenuBackground, this));
    }
  }

  void changeView(GameView nextView,{SwitchMessage message}) {
    activeView?.moveToBackground(message: message);
    var nextActiveView = views.firstWhere((view) => view.view == nextView,
        orElse: () {
          return null;
        });
    nextActiveView?.setActive(message: message);
    activeView?.active = false;
    nextActiveView?.active = true;
  }

  void render(Canvas canvas) {
    activeView?.render(canvas);
  }

  void update(double time) {
    activeView?.update(time);
  }
}