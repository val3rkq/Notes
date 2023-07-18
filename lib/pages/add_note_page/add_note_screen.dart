import 'package:flutter/material.dart';
import 'package:notes/model/note_db.dart';

import 'widgets/my_button.dart';
import 'widgets/my_textfield.dart';
import 'widgets/time_widget.dart';

class AddNotePage extends StatelessWidget {
  const AddNotePage({
    super.key,
    required this.onTap,
    required this.isEdit,
    required this.db,
    required this.date,
    required this.titleController,
    required this.descriptionController,
    required this.index,
  });

  final Function()? onTap;
  final bool isEdit;
  final NoteDB db;
  final String date;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: const Color(0xFF151515),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          toolbarHeight: 70,
          leading: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ),
          actions: [
            MyButton(
              onTap: onTap,
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
          child: Column(
            children: [
              // datetime if note is editing
              isEdit
                  ? TimeWidget(
                      db: db,
                      index: index,
                      date: date,
                    )
                  : const SizedBox(),

              // title
              MyTextField(
                controller: titleController,
                hintText: 'Note title',
                maxLines: 1,
                autofocus: false,
              ),

              const SizedBox(
                height: 10,
              ),
              // description
              MyTextField(
                controller: descriptionController,
                hintText: 'Description',
                maxLines: 29,
                autofocus: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
