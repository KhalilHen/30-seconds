import 'package:flutter/material.dart';
import 'package:thirty_seconds/pages/login.dart';
import 'package:thirty_seconds/pages/sign_up.dart';

class AccountPage extends StatefulWidget {
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> with TickerProviderStateMixin {
  late AnimationController scaleAnimationController;
  late Animation<double> scaleAnimation;

  late AnimationController fadeAnimationController;

  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();
    scaleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(
        reverse: true,
      );
    scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(parent: scaleAnimationController, curve: Curves.easeInOut));

    fadeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: fadeAnimationController, curve: Curves.easeInOut));
    fadeAnimationController.forward();
  }

  @override
  void dispose() {
    scaleAnimationController.dispose();

    fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: Text(
          "Welcome",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple[600],
        elevation: 0,
      ),
      body: Center(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: scaleAnimation.value,
                    child: child,
                  );
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.deepPurple[100],
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                "Login or sign up!",
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.deepPurple[800],
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.deepPurple[200]!,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "To get access to all the features",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.deepPurple[600],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[600],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                    minimumSize: Size(250, 55),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  )),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => SignUpPage(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            }));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(color: Colors.deepPurple[600]!, width: 2)),
                      elevation: 5,
                      minimumSize: Size(250, 55)),
                  child: Text(
                    "Sign up",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple[600]),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
