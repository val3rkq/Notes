import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    required this.onTap,
    required this.icon,
  });

  final Function()? onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: Color(0xFFAEFF50),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 25,
          color: Colors.black,
        ),
      ),
    );
  }
}
