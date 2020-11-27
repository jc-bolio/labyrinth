import 'dart:ui';
import 'package:box2d_flame/box2d.dart' as box2d;
import 'package:theseus/theseus.dart';
import 'package:labyrinth/GameObjects/wall.dart';
import 'package:labyrinth/game.dart';

class Daedalus {

  final MazeGame game;
  final List<Wall> walls = new List();
  int _width;
  int _height;
  OrthogonalMaze _mazeGenerator;
  Size cellSize;

  Daedalus(this.game, {int width = 7, int height = 7}) {
    _width = width;
    _height = width;
    // Calcula el tamaño de las celdas para ajustarse a la pantalla
    cellSize = Size(
      game.screenSize.width / (width),
      game.screenSize.height / (height),
    );
  }

  void generateMaze() {
    walls.clear();
    var mazeOption = MazeOptions(width: _width, height: _height);
    _mazeGenerator = OrthogonalMaze(mazeOption);
    _mazeGenerator.generate();
    // Cierra la entrada del laberinto
    var start = box2d.Vector2.zero();
    walls.add(Wall(game, start, box2d.Vector2(start.x, start.y + cellSize.height),));
    // Genra la celda columna por columna
    for (var y = 0; y < _height; ++y) {
      var py = y * cellSize.height;
      for (var x = 0; x < _width; ++x) {
        var px = cellSize.width * x;
        generateCell(_mazeGenerator.getCell(x, y), Position.xy(x, y),
            box2d.Vector2(px, py));
      }
    }
  }

  void generateCell(int cell, Position position, box2d.Vector2 startPoint) {
    // Revisa los bits de la celda para decidir donde agregar la pared
    if (cell & Maze.N != Maze.N) {
      walls.add(Wall(
        game,
        startPoint,
        box2d.Vector2(startPoint.x + cellSize.width, startPoint.y),
      ));
    }
    if (cell & Maze.S != Maze.S) {
      var southStart = box2d.Vector2(
          startPoint.x,
          startPoint.y +
              (cellSize.height -
                  (position.y == (_height - 1) ? Wall.wallWidth : 0)));
      walls.add(Wall(
        game,
        southStart,
        box2d.Vector2(southStart.x + cellSize.width, southStart.y),
      ));
    }

    if (cell & Maze.W != Maze.W) {
      walls.add(Wall(
        game,
        startPoint,
        box2d.Vector2(
            startPoint.x, startPoint.y + cellSize.height + Wall.wallWidth),
      ));
    }

    if (cell & Maze.E != Maze.E) {
      var eastStart = box2d.Vector2(
          startPoint.x +
              (cellSize.width -
                  (position.x == (_width - 1) ? Wall.wallWidth : 0)),
          startPoint.y);
      walls.add(Wall(
        game,
        eastStart,
        box2d.Vector2(
            eastStart.x, eastStart.y + cellSize.height + Wall.wallWidth),
      ));
    }
  }

  void render(Canvas canvas) {
    walls.forEach((wall) => wall.render(canvas));
  }
}
