import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/constants.dart';
import 'package:notes/generated/l10n.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: mainColor,
      ),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      child: Text(
        S.of(context).home_title,
        style: GoogleFonts.bebasNeue(fontSize: 30, color: black),
      ),
    );
  }
}
