import 'package:flutter/material.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500), // Adjust duration as needed
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _animateText();
    _navigateToMain();
  }

  _animateText() async {
    await Future.delayed(
        Duration(milliseconds: 500)); // Delay before animation starts
    _controller.forward(); // Start the opacity animation
  }

  _navigateToMain() async {
    await Future.delayed(Duration(seconds: 4)); // Simulate a delay
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => MyHomePage(
                title: 'Home Page',
                additionalString: '',
                login: false,
              )),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Center(
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_grocery_store,
                        size: 100, color: Colors.white),
                    SizedBox(height: 20),
                    Container(
                      height: 100,
                      width: 300,
                      child: Image.asset(
                        'assets/image/nextgen.png',
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Your Future Friend',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}