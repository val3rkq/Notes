import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/constants.dart';
import 'package:notes/model/note_db.dart';

import 'note_tile.dart';

class NoteSlidableTile extends StatelessWidget {
  const NoteSlidableTile({
    super.key,
    required this.onDelete,
    required this.onTap,
    required this.db,
    required this.index,
    required this.date,
  });

  final Function(BuildContext)? onDelete;
  final Function()? onTap;
  final NoteDB db;
  final int index;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.3,
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: onDelete,
              icon: Icons.delete_rounded,
              backgroundColor: red,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(17),
                bottomLeft: Radius.circular(17),
              ),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: NoteTile(
              db: db,
              index: index,
              date: date,
            ),
          ),
        ),
      ),
    );
  }
}
