import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: Text("Welcome back!", style: TextStyle(color: Colors.white),
        
          
        ),
        backgroundColor: Colors.deepPurple[600],
        elevation: 0,
      ),

      body: SingleChildScrollView(
        // child: ,
      ),
    );
  }
}
