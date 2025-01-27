import 'package:flutter/material.dart';
import 'package:thirty_seconds/pages/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '30 Seconds',
      theme: ThemeData(
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
