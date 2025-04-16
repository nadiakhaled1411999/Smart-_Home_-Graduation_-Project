// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:gradients/gradients.dart';
import 'package:untitled7/view/features/project1devices/project1_devices.dart';

import '../../../core/util/assets.dart';
import '../../../core/widgets/projectbox.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white24,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(Assets.userImage)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Column(
                          children: [
                            GradientText(
                              "Hello",
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.start,
                              colors: [
                                Color(0xff667EEA),
                                Color(0xff764BA2),
                              ],
                            ),
                            GradientText(
                              "Smart home",
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.start,
                              colors: [
                                Color(0xff667EEA),
                                Color(0xff764BA2),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Image(
                    image: AssetImage(Assets.menuImage),
                    height: 35,
                    width: 35,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 1, top: 50, right: 190, bottom: 20.0),
              child: GradientText(
                "your projects ",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
                colors: [
                  Color(0xff667EEA),
                  Color(0xff764BA2),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20.0,
                children: [
                  InkWell(
                    onTap: () {
                      //  Navigator.push(context,
                      //      MaterialPageRoute(builder: (context) =>  Project1Devices(),));
                    },
                    child: ProjectBox(
                      name: "uu",
                      id: "2",
                      projectName: 'project1',
                      projectImg: Assets.project1,
                      //activeDevices: '0',
                      description: 'nn',
                    ),
                  ),
                  ProjectBox(
                    name: "ll",
                    id: "2",
                    projectName: 'project2',
                    projectImg: Assets.project2,
                    // activeDevices: '1',
                    description: 'bb',
                  ),
                  ProjectBox(
                    name: "nnnn",
                    id: "2",
                    projectName: 'project3',
                    projectImg: Assets.project3,
                    //activeDevices: '3',
                    description: 'mm',
                  ),
                  ProjectBox(
                    name: "mm",
                    id: "2",
                    projectName: 'project4',
                    projectImg: Assets.project4,
                    // activeDevices: '4',
                    description: 'nnn',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
