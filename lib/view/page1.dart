// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';

import 'package:untitled7/view/page2.dart';


class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/smart_home.png',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 120),
                  child: Text(
                    "Smart !\nHome App",
                    style: TextStyle(
                      color:Color(0xfffffffA),
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,

                  ),
                ),
                SizedBox(
                  height: 400,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Page2()));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 50, right: 50),
                    child: Container(
                      height: 65,
                      width: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: LinearGradient(colors: [
                            Color(0xff667EEA),
                            Color(0xff764BA2),
                          ])),
                      child: Center(
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                            color: Color(0xffE5E5E5),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),

                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
