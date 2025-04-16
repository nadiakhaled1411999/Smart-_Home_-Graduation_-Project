// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:untitled7/view/features/style/app_colors.dart';

class DefaultButton extends StatelessWidget {
  DefaultButton(
      {super.key,
      required this.onTap,
      this.height = 60,
      this.width = 130,
      this.color = AppColors.primaryColor,
      required this.text});
  void Function() onTap;
  double height;
  double width;
  Color color;
  String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: color),
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
