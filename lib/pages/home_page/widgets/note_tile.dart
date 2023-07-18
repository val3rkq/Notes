import 'package:flutter/material.dart';
import 'package:notes/model/note_db.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({
    super.key,
    required this.db,
    required this.date,
    required this.index,
  });

  final NoteDB db;
  final String date;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    db.notes[date][index]['title'],
                    softWrap: false,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    db.notes[date][index]['description'],
                    maxLines: 5,
                    softWrap: false,
                    style: const TextStyle(color: Colors.white54, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
