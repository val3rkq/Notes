import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:notes/model/note_db.dart';
import 'package:notes/model/note_model.dart';
import 'package:notes/pages/add_note_page/add_note_screen.dart';

import 'widgets/rounded_btn.dart';
import 'widgets/no_data_widget.dart';
import 'widgets/note_slidable_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // database
  var noteBox = Hive.box('box');
  NoteDB db = NoteDB();

  // controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // add new note
  void addNote() {
    DateTime now = DateTime.now();
    String date = DateFormat('dd MMM yyyy').format(now);

    Note newNote = Note(
      title: titleController.text.toString(),
      description: descriptionController.text.toString(),
      date: date,
      time: DateFormat('kk:mm').format(now),
    );

    if (!db.notes.containsKey(date)) {
      db.notes[date] = [];
    }
    db.notes[date].insert(0, newNote.toMap());
    db.updateDB();
  }

  // edit current note and put it on first position in notesList
  void editNote(int index, String date) {
    db.notes[date].removeAt(index);
    addNote();
    db.updateDB();
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
    if (noteBox.get('NOTES') == null) {
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
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFADFD50),
          ),
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          child: Text(
            'Notes',
            style: GoogleFonts.bebasNeue(fontSize: 30, color: Colors.black),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF151515),
      body: SizedBox(
        child: db.notes.isEmpty
            ? const NoDataWidget()
            : SlidableAutoCloseBehavior(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: db.notes.length,
                  itemBuilder: (context, index) {
                    print(db.notes);
                    // get date
                    String currentDate = db.notes.keys.toList()[index];
                    if (!db.notes[currentDate].isEmpty) {
                      return Column(
                        children: [
                          // date
                          Container(
                            padding: const EdgeInsets.only(top: 15, left: 15),
                            alignment: Alignment.topLeft,
                            child: Text(
                              currentDate,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),

                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: db.notes[currentDate].length,
                            itemBuilder: (context, index2) {
                              return NoteSlidableTile(
                                onDelete: (context) {
                                  deleteNote(index2, currentDate);
                                },
                                onTap: () {
                                  createNote(
                                    isEdit: true,
                                    index: index2,
                                    date: currentDate,
                                  );
                                },
                                db: db,
                                index: index2,
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
