// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'dart:core';

import '../util/assets.dart';

class DevicesCard extends StatelessWidget {
  const DevicesCard({
    super.key,
    required this.deviceName,
    required this.deviceImg,

  });
  final String deviceName;
  final String deviceImg;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      color: Color.fromARGB(230, 244, 67, 54),
      elevation: 20,
      child: Column(
        children: [
          Image.asset(
            deviceImg,
            color: Colors.white,
            width: 90,
            height: 90,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                  deviceName,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
                Transform.rotate(
                    angle: (22 / 7) / 2,
                    child: Switch(
                      value: false,
                      onChanged: (value) {},
                      activeColor: Colors.green,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
