import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:thirty_seconds/homepage.dart';

void main() {
  final game = StartGame();
  runApp(GameWidget(game: game));
}
