import 'package:flutter/material.dart';
import 'package:labyrinth/Views/base.dart';
import 'package:labyrinth/game.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  MazeGame game;
  @override
  void initState() {
    super.initState();
    game = MazeGame(startView: GameView.MenuBackground);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          game.widget,
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Laberinto",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      letterSpacing: 6,
                      color: Colors.white),
                ),
                RaisedButton(
                    child: Text("Jugar"),
                    onPressed: () async {
                      game.pauseGame = true; // Detiene el fondo
                      await Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => GameWidget()));
                      game.pauseGame = false; // Reinicia cuando termina
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
