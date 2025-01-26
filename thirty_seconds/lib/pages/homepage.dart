import 'package:flame/game.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:thirty_seconds/pages/setup_teams.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   '/logo.png',
            //   height: 200,
            //   width: 200,
            // ),
            Image.asset(
              'assets/logo.png',
              height: 200,
              width: 200,
            ),
            //* Doesn't work
            SizedBox(height: 40),
            Text(
              "Thirty Seconds",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.deepPurple[800], shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.deepPurple[200]!,
                  offset: const Offset(3, 3),
                )
              ]),
            ),

            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SetupTeamsPage()),
                );
              },
              child: Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}
