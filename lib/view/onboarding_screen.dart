import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: getPages(),
      onDone: () async {
        // When done button is pressed
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isFirstTime', false);
        Navigator.of(context).pushReplacementNamed('/home');
      },
      onSkip: () async {
        // You can also override onSkip callback
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isFirstTime', false);
        Navigator.of(context).pushReplacementNamed('/home');
      },
      showSkipButton: true,
      skip: const Text(
        'Skip',
        style: TextStyle(color: Colors.blue),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: Colors.blue,
      ),
      done: const Text("Done",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue)),
      dotsDecorator: DotsDecorator(
        activeColor: Colors.blue,
        color: Colors.blue,
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        title: "Welcome",
        body: "To our Modular No-Code IOT Platform. ",
        image: Center(
          child: Image.asset(
            "assets/images/Smart home-rafiki.png",
          ),
        ),
        decoration: const PageDecoration(
          pageColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 34.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          bodyTextStyle: TextStyle(
            fontSize: 26.0,
            color: Colors.grey,
          ),
        ),
      ),
      PageViewModel(
        title: "Features",
        body:
            "This platform allows users to create specific projects using pre-built modules such as temperature sensors, ultrasonic sensors, switches and more!",
        image: Center(
          child: Image.asset(
            "assets/images/Smart home-bro.png",
          ),
        ),
        decoration: const PageDecoration(
          pageColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          bodyTextStyle: TextStyle(
            fontSize: 24.0,
            color: Colors.grey,
          ),
        ),
      ),
      PageViewModel(
        title: "Get Started",
        body: "Let's start using our App to control your projects",
        image: Center(
          child: Image.asset(
            "assets/images/Smart home-cuate.png",
          ),
        ),
        decoration: const PageDecoration(
          pageColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          bodyTextStyle: TextStyle(
            fontSize: 25.0,
            color: Colors.grey,
          ),
        ),
      ),
    ];
  }
}
