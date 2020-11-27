import 'dart:ui';
import 'package:box2d_flame/box2d.dart';
import 'package:labyrinth/game.dart';
import 'package:labyrinth/helper.dart';

class Wall {
  MazeGame game;
  // Ancho de la pared
  static final double wallWidth = 5;
  // Objetos con físicas
  Body body;
  PolygonShape shape;
  // Dibujo
  Path _path;
  Paint _paint;

  Wall(this.game, Vector2 startPoint, Vector2 endPoint) {
    final scaleFactor = game.screenSize.width / game.scale;
    // Construye el objeto como una lista de Vector2 basada en los puntos de inicio y fin
    var shapeVList = _buildShape(startPoint, endPoint);
    shape = PolygonShape();
    shape.set(shapeVList, shapeVList.length);

    BodyDef bodyDef = BodyDef();
    bodyDef.linearVelocity = Vector2.zero();
    bodyDef.position = scaleVectorBy(startPoint, scaleFactor);
    // Objeto estático = no lo afecta la gravedad y tiene colisiones
    bodyDef.type = BodyType.STATIC;
    body = game.world.createBody(bodyDef);
    body.userData = this;

    // Definir propiedades del cuerpo del objeto
    FixtureDef fixDef = FixtureDef();
    fixDef.density = 20;
    fixDef.restitution = 1;
    fixDef.friction = 0;
    fixDef.shape = shape;
    body.createFixtureFromFixtureDef(fixDef);

    // Crea un camino a dibujar basado en la lista de vectores
    _path = Path();
    _path.addPolygon(
        shapeVList.map((vector) => Offset(vector.x, vector.y)).toList(), false);
    // Pinta las paredes
    _paint = Paint();
    _paint.color = Color(0xffffffff);
  }

  List<Vector2> _buildShape(Vector2 start, Vector2 end) {
    final scaleFactor = game.screenSize.width / game.scale;
    var result = new List<Vector2>();
    // Esquina izquierda en (0,0), se mueve el canvas al inicio
    result.add(Vector2.zero());
    // Pared vertical si el punto de inicio en y es menor que el punto final en y
    if (start.y < end.y) {
      var endY = (start.y - end.y).abs();
      result.add(scaleVectorBy(Vector2(0, endY), scaleFactor));
      result.add(scaleVectorBy(Vector2(wallWidth, endY), scaleFactor));
      result.add(scaleVectorBy(Vector2(wallWidth, 0), scaleFactor));
    } else if (start.x < end.x) { // De otra manera la pared es horizontal
      var endX = (start.x - end.x).abs();
      result.add(scaleVectorBy(Vector2(endX, 0), scaleFactor));
      result.add(scaleVectorBy(Vector2(endX, wallWidth), scaleFactor));
      result.add(scaleVectorBy(Vector2(0, wallWidth), scaleFactor));
    }
    return result; // Lista de 4 puntos describiendo los bordes de la pared
  }

  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(body.position.x, body.position.y);
    canvas.drawPath(_path, _paint);
    canvas.restore();
  }
}
