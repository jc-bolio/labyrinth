import 'dart:ui';
import 'package:box2d_flame/box2d.dart';
import 'package:labyrinth/game.dart';
import 'package:sensors/sensors.dart';

class Ball {
  MazeGame game;
  // Objetos con físicas
  Body body;
  CircleShape shape;
  // Escala para los sensores
  double sensorScale = 5;
  // Clase para dibujar
  Paint paint;
  // Sin movimiento de aceleración inicial
  Vector2 acceleration = Vector2.zero();
  double ballScale = 0;

  // Genera la bola con sus físicas
  Ball(this.game, Vector2 position) {
    ballScale = game.screenSize.width /  game.scale;
    shape = CircleShape();
    shape.p.setFrom(Vector2.zero());
    shape.radius = 0.1; // bola de 10 cm

    paint = Paint();
    paint.color = Color(0xffffffff);

    BodyDef bodyDef = BodyDef();
    bodyDef.linearVelocity = Vector2.zero();
    bodyDef.position = position;
    bodyDef.fixedRotation = false;
    bodyDef.bullet = false;
    bodyDef.type = BodyType.DYNAMIC;
    body = game.world.createBody(bodyDef);
    body.userData = this;

    FixtureDef fixDef = FixtureDef();
    fixDef.density = 10;
    fixDef.restitution = 0;
    fixDef.friction = 1;
    fixDef.shape = shape;
    body.createFixtureFromFixtureDef(fixDef);
    // Hace uso del sensor
    gyroscopeEvents.listen((GyroscopeEvent event) {
      // Añade a la aceleracion los datos del sensor por el factor de escala
      if(!game.pauseGame){
        acceleration.add(Vector2(event.y / sensorScale, event.x / sensorScale));
      }
    });
  }
  // Dibuja la bola
  void render(Canvas canvas) {
    canvas.save();
    // Mueve el canvas a la esquina superior izquierda de la bola
    canvas.translate(body.position.x, body.position.y);
    // Dibuja el circulo
    canvas.drawCircle(Offset(0, 0), .1, paint);
    canvas.restore();
  }
  bool over =false;
  void update(double time) {
    // Mueve a la bola cada cuadro por su aceleración
    body.applyForceToCenter(acceleration);

    if (!over && !game.screenRect
        .overlaps(Rect.fromLTWH(body.position.x * ballScale, body.position.y * ballScale, 0.1, 0.1))) {
      body.linearVelocity = Vector2.zero();
      over = true;
      game.pop();
    }
  }
}
