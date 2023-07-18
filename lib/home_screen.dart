import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:notes/model/note_db.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // database
  var noteBox = Hive.box('noteBox');
  NoteDB db = NoteDB();

  // controllers for editing text
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // add new note
  void addNote() {
    setState(() {
      db.notes.insert(0, titleController.text.toString());
      db.descriptions.insert(0, descriptionController.text.toString());
      db.dates
          .insert(0, DateFormat('dd MMM yyyy kk:mm').format(DateTime.now()));
      titleController.clear();
      descriptionController.clear();
    });
    db.updateDB();
  }

  // edit current note and put this on first position in notesList
  void editNote(int index) {
    setState(() {
      db.notes.removeAt(index);
      db.notes.insert(0, titleController.text.toString());

      db.descriptions.removeAt(index);
      db.descriptions.insert(0, descriptionController.text.toString());

      db.dates.removeAt(index);
      db.dates
          .insert(0, DateFormat('dd MMM yyyy kk:mm').format(DateTime.now()));

      titleController.clear();
      descriptionController.clear();
    });
    db.updateDB();
  }

  // delete this note
  void deleteNote(int index) {
    setState(() {
      db.notes.removeAt(index);
      db.descriptions.removeAt(index);
      db.dates.removeAt(index);

      titleController.clear();
      descriptionController.clear();
    });
    db.updateDB();
  }

  // show bottom sheet for creating tasks
  void createNote({required bool isEdit, required int index}) {
    setState(() {
      if (isEdit) {
        titleController.text = db.notes[index];
        descriptionController.text = db.descriptions[index];
      } else {
        titleController.text = '';
        descriptionController.text = '';
      }
    });
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return addNoteBottomSheet(context, isEdit, index);
      },
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'NOTES',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
        ),
        elevation: 0,
        toolbarHeight: 60,
        backgroundColor: const Color(0xFF7AD4B4),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFDEF5E5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: ListView.builder(
          itemCount: db.notes.length,
          itemBuilder: (context, index) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          deleteNote(index);
                        },
                        icon: Icons.delete_rounded,
                        backgroundColor: const Color(0xFFF16866),
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ],
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      createNote(isEdit: true, index: index);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.55),
                            spreadRadius: 0.5,
                            blurRadius: 6,
                            offset: const Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    db.notes[index],
                                    softWrap: false,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    db.descriptions[index],
                                    maxLines: 5,
                                    softWrap: false,
                                    style: const TextStyle(
                                        color: Colors.black54, fontSize: 15),
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: SizedBox(
        width: 65,
        height: 65,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              createNote(isEdit: false, index: db.notes.length);
            },
            backgroundColor: const Color(0xFF6EE9B1),
            child: const Icon(
              Icons.edit_rounded,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Container addNoteBottomSheet(BuildContext context, bool isEdit, int index) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      height: 700,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.black,
            ),
          ),
          title: Text(
            !isEdit ? 'Make Note' : 'Edit Note',
            style: const TextStyle(color: Colors.black, fontSize: 18),
          ),
          actions: [
            isEdit
                ? IconButton(
                    onPressed: () {
                      deleteNote(index);
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.delete_rounded,
                      color: Colors.black,
                    ),
                  )
                : const SizedBox(),
            IconButton(
              onPressed: () {
                if (isEdit) {
                  editNote(index);
                } else {
                  addNote();
                }
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.check_rounded,
                color: Colors.black,
              ),
            ),
          ],
          centerTitle: true,
          toolbarHeight: 60,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            child: SafeArea(
              child: ListView(
                children: [
                  isEdit
                      ? Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10, right: 5),
                            child: Text(
                              db.dates[index],
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 12),
                            ),
                          ),
                        )
                      : Container(),
                  TextFormField(
                    autofocus: isEdit ? false : true,
                    textCapitalization: TextCapitalization.sentences,
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: 'Note title',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(color: Color(0xFFDDDDDD), width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1)),
                        hintStyle:
                            TextStyle(color: Color(0xFF676767), fontSize: 15)),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 15,
                    decoration: const InputDecoration(
                        hintText: 'Describe note',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(color: Color(0xFFDDDDDD), width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(color: Colors.black38, width: 1)),
                        hintStyle:
                            TextStyle(color: Color(0xFF676767), fontSize: 15)),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
