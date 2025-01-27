import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(
        reverse: true,
      );
    scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    animationController.dispose();
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
                onPressed: () {},
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
                onPressed: () {},
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
    );
  }
}
