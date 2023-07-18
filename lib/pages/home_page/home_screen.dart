import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:notes/constants.dart';
import 'package:notes/model/note_db.dart';
import 'package:notes/model/note_model.dart';
import 'package:notes/pages/add_note_page/add_note_screen.dart';

import 'widgets/home_title.dart';
import 'widgets/no_data_widget.dart';
import 'widgets/note_slidable_tile.dart';
import 'widgets/rounded_btn.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // database
  var noteBox = Hive.box(boxName);
  NoteDB db = NoteDB();

  // controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // add new note
  void addNote() {
    DateTime now = DateTime.now();
    String date = DateFormat(dateFormat).format(now);

    // create new note
    Note newNote = Note(
      title: titleController.text.toString(),
      description: descriptionController.text.toString(),
      date: date,
      time: DateFormat(timeFormat).format(now),
    );

    if (!db.notes.containsKey(date)) {
      db.notes[date] = [];
    }
    // don't forget to convert Note to Map
    db.notes[date].insert(0, newNote.toMap());
    db.updateDB();

    // we don't need to use setState here,
    // because it is used when add_note_page closes
  }

  // edit current note and put it on first position in notesList
  void editNote(int index, String date) {
    db.notes[date].removeAt(index);
    if (db.notes[date].isEmpty) {
      db.notes.remove(date);
    }
    addNote();
    db.updateDB();

    // we don't need to use setState here,
    // because it is used when add_note_page closes
  }

  // delete note by index
  void deleteNote(int index, String date) {
    db.notes[date].removeAt(index);
    if (db.notes[date].isEmpty) {
      db.notes.remove(date);
    }
    db.updateDB();
    setState(() {});
  }

  // clear controllers
  void clearControllers() {
    titleController.clear();
    descriptionController.clear();
  }

  // show bottom sheet for creating tasks
  void createNote(
      {required bool isEdit, required int index, required String date}) {
    setState(() {
      if (isEdit) {
        titleController.text = db.notes[date][index]['title'];
        descriptionController.text = db.notes[date][index]['description'];
      } else {
        titleController.text = '';
        descriptionController.text = '';
      }
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNotePage(
          onTap: () {
            if (isEdit) {
              editNote(index, date);
            } else {
              addNote();
            }
            Navigator.pop(context);
            setState(() {});
          },
          index: index,
          titleController: titleController,
          descriptionController: descriptionController,
          isEdit: isEdit,
          date: date,
          db: db,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (noteBox.get(dataName) == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 10,
        toolbarHeight: 80,
        backgroundColor: transparent,
        centerTitle: true,
        title: const HomeTitle(),
      ),
      backgroundColor: backgroundColor,
      body: SizedBox(
        child: db.notes.isEmpty
            ? const NoDataWidget()
            : SlidableAutoCloseBehavior(
                child: ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: db.notes.length,
                  itemBuilder: (context, index) {
                    // get date
                    String currentDate = db.notes.keys.toList()[index];
                    if (!db.notes[currentDate].isEmpty) {
                      return Column(
                        children: [
                          // show date
                          Container(
                            padding: const EdgeInsets.only(top: 15, left: 15),
                            alignment: Alignment.topLeft,
                            child: Text(currentDate, style: dateTextStyle),
                          ),

                          // show notes for current date
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: db.notes[currentDate].length,
                            itemBuilder: (context, indexDate) {
                              return NoteSlidableTile(
                                onDelete: (context) {
                                  deleteNote(indexDate, currentDate);
                                },
                                onTap: () {
                                  createNote(
                                    isEdit: true,
                                    index: indexDate,
                                    date: currentDate,
                                  );
                                },
                                db: db,
                                index: indexDate,
                                date: currentDate,
                              );
                            },
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
      ),
      floatingActionButton: RoundedButton(
        onTap: () {
          createNote(
            isEdit: false,
            index: db.notes.length,
            date: '',
          );
        },
        icon: Icons.edit_rounded,
      ),
    );
  }
}
