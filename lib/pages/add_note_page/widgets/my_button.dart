import 'package:flutter/material.dart';
import 'package:notes/constants.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onTap,
  });

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 15, top: 15),
          decoration: BoxDecoration(
            color: mainColor,
            shape: BoxShape.circle
          ),
          width: 50,
          height: 50,
          child: Icon(Icons.check_rounded, color: black),
        ),
      ),
    );
  }
}
