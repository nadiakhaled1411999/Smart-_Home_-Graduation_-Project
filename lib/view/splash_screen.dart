import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/web_socket/web_socket.dart';

class Splash_screen extends StatefulWidget {
  @override
  _Splash_screenState createState() => _Splash_screenState();
}

class _Splash_screenState extends State<Splash_screen> {
  late WebSocketService webSocketService;

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(
        Duration(seconds: 7)); // Duration matches your splash screen duration
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      Navigator.pushReplacementNamed(context, '/onBoardingScreen');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 7000,
      splash: Lottie.asset('assets/images/ss.jpg'),
      nextScreen:
          Container(), // Placeholder, navigation handled in _navigateToNextScreen
      splashIconSize: 280,
      splashTransition: SplashTransition.fadeTransition,
      // pageTransitionType: PageTransitionType.fade,
      backgroundColor: Colors.white,
    );
  }
}
