import 'package:flame/game.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
        Text('Welcome!',
        style: TextStyle(


fontSize: 25,
fontWeight: FontWeight.bold,


        ),),
        // SizedBox(height:90,),
 Padding(padding: EdgeInsets.all(40)),
        ElevatedButton(
          onPressed: null,
          child: Text('Start Game'),
        ),
          ],
        ),
      ),
    );
  }
}
