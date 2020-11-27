import 'package:flutter/widgets.dart';
import 'package:labyrinth/Views/switchMessage.dart';
import 'package:labyrinth/Views/viewManager.dart';

enum GameView {
  MenuBackground,
  Playing,
  Win,
}

abstract class BaseView {
  bool active = false;
  final GameView _view;
  final ViewManager _viewManager;
  GameView get view => _view;
  ViewManager get viewManager => _viewManager;

  BaseView(this._view, this._viewManager);

  void setActive({SwitchMessage message});
  void moveToBackground({SwitchMessage message});
  void render(Canvas canvas);
  void update(double time);
}
