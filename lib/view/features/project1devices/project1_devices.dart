// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:untitled7/core/util/assets.dart';
import 'package:untitled7/core/widgets/devices_card.dart';
import 'package:untitled7/core/widgets/temperature_gauage.dart';

class Project1Devices extends StatefulWidget {
  const Project1Devices({super.key});

  @override
  State<Project1Devices> createState() => _Project1DevicesState();
}

class _Project1DevicesState extends State<Project1Devices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "project1 devices",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Assets.livingRoom),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.srgbToLinearGamma()),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TemeratureGauage(),
            Container(
              width: double.infinity,
              height: 380,
              decoration: BoxDecoration(
                  color: Color.fromARGB(144, 244, 67, 54),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50))),
              child: GridView.count(
                padding: EdgeInsets.only(top: 20),
                crossAxisCount: 2,
                shrinkWrap: true,
                children: [
                  DevicesCard(
                    deviceName: "light",
                    deviceImg: Assets.light1project1Img,
                  ),
                  DevicesCard(
                    deviceName: "fan",
                    deviceImg: Assets.fanImg,
                  ),
                  DevicesCard(
                    deviceName: "smart\nTv",
                    deviceImg: Assets.smartTvImg,
                  ),
                  DevicesCard(
                    deviceName: "Air-conditioner",
                    deviceImg: Assets.airConditionerImg,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
