// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../util/assets.dart';

class ProjectBox extends StatelessWidget {
  const ProjectBox({
    super.key,
    required this.projectName,
    required this.projectImg,
    required this.description,
    required this.id,
    required this.name,
  });
  final String projectName;
  final String projectImg;
  final String description;
  final String id;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            image: AssetImage(projectImg),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.transparent,
            Colors.black,
          ], stops: [
            0.5,
            0.9
          ], transform: GradientRotation((22 / 7) / 2))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "projectName:$projectName",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                "name:$name",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                "id:$id",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Text(
                description,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              /*Text(
                "Active devices:$activeDevices",
                style: TextStyle(
                    color: Color.fromARGB(132, 255, 255, 255), fontSize: 15),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
