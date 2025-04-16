// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class TemeratureGauage extends StatelessWidget {
  const TemeratureGauage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: AnimatedRadialGauge(
        duration: Duration(seconds: 1),
        value: 10,
        radius: 120,
        axis: GaugeAxis(
            max: 100,
            min: 0,
            degrees: 180,
            progressBar: GaugeProgressBar.rounded(color: getColor(10)),
            style: GaugeAxisStyle(
              background: Colors.transparent,
              segmentSpacing: 10,
            ),
            segments: [
              GaugeSegment(
                  from: 0,
                  to: 40,
                  border: GaugeBorder(color: Colors.red, width: 2)),
              GaugeSegment(
                  from: 40,
                  to: 70,
                  border: GaugeBorder(color: Colors.red, width: 2)),
              GaugeSegment(
                  from: 70,
                  to: 100,
                  border: GaugeBorder(color: Colors.red, width: 2)),
            ]),
        builder: (context, child, value) => Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color.fromARGB(144, 244, 67, 54)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "40",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                "Humidity30%",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Color getColor(double value) {
    if (value <= 40) {
      return Colors.white;
    } else if (value >= 40 && value <= 70) {
      return Colors.blue;
    } else {
      return Colors.red;
    }
  }
}
