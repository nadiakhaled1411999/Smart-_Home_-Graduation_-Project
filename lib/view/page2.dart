// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:untitled7/view/login_screen.dart';
import 'package:untitled7/view/signup_screen.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 80),
                child: Container(
                  child: Image.asset(
                    'assets/images/s1.jpg',
                    fit: BoxFit.fill,
                    width: double.infinity,
                  ),
                ),
              ),
              SizedBox(
                height: 0.1,
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(colors: [
                      Color(0xff667EEA),
                      Color(0xff764BA2),
                    ])),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Image.asset(
                          'assets/Icons/bb.jpg',
                          height: 30,
                          width: 30,
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        "Continue with Google",
                        style: TextStyle(
                            color: Color(0xffE5E5E5),
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                },
                child: Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: LinearGradient(colors: [
                        Color(0xff667EEA),
                        Color(0xff764BA2),
                      ])),
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Color(0xffE5E5E5),
                          fontSize: 25,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "don’t have an account?",
                style: TextStyle(
                  color: Color(0xff000000),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupScreen()));
                },
                child: GradientText(
                  "create account",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                  colors: [
                    Color(0xff667EEA),
                    Color(0xff764BA2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
