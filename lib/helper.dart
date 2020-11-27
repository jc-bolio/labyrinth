import 'dart:ui';
import 'package:box2d_flame/box2d.dart';

// Convierte a un Offset no nulo a Vector2
Vector2 offsetToVector2(Offset value) {
  if (value == null) throw new ArgumentError.notNull("value");
  return Vector2(value.dx, value.dy);
}
// Escala ambos valores de un Vector2 no nulo por el factor del valor dado
Vector2 scaleVectorBy(Vector2 value, double scale) {
  if (value == null) throw new ArgumentError.notNull("value");
  return Vector2(value.x / scale, value.y / scale);
}
//create a new scaled size by a given factor
Size scaleSizeBy(Size value, double scale){
  if (value == null) throw new ArgumentError.notNull("value");
  return Size(value.width /scale, value.height/scale);
}