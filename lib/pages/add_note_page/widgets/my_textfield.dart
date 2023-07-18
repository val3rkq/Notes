import 'package:flutter/material.dart';
import 'package:notes/constants.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.maxLines,
    required this.autofocus,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        hintText: hintText,
        hintStyle: hintTextStyle,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: grey8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: grey8),
        ),
      ),
    );
  }
}
