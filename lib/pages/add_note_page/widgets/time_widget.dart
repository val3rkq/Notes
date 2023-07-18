import 'package:flutter/material.dart';
import 'package:notes/constants.dart';
import 'package:notes/model/note_db.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({
    super.key,
    required this.db,
    required this.index,
    required this.date,
  });

  final NoteDB db;
  final int index;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, left: 5),
        child: Text(
          '$date  ${db.notes[date][index]['time']}',
          style: timeWidgetTextStyle,
        ),
      ),
    );
  }
}
