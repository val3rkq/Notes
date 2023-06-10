import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/model/note_db.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // variables for scroll
  final ScrollController _scrollController = ScrollController();

  // database
  var noteBox = Hive.box('noteBox');
  NoteDB db = NoteDB();

  // controllers for editing text
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // add new note
  void addNote() {
    setState(() {
      db.notes.add(shortLine(nameController.text.toString(), 35));
      db.descriptions.add(shortLine(descriptionController.text.toString(), 40));
      nameController.clear();
      descriptionController.clear();
    });
    db.updateDB();
    // scroll to bottom
    SchedulerBinding.instance.addPostFrameCallback((_) => scrollToBottom());
  }

  // edit current note
  void editNote(int index) {
    setState(() {
      db.notes[index] = shortLine(nameController.text.toString(), 35);
      db.descriptions[index] = shortLine(descriptionController.text.toString(), 40);

      // put current note on first position in notesList
      String currentNote = db.notes[index];
      db.notes[0] = db.notes[index];
      db.notes[index] = currentNote;

      String currentDescription = db.descriptions[index];
      db.descriptions[0] = db.descriptions[index];
      db.descriptions[index] = currentDescription;
      nameController.clear();
      descriptionController.clear();
    });
    db.updateDB();
  }

  // delete this note
  void deleteNote(int index) {
    setState(() {
      db.notes.removeAt(index);
      db.descriptions.removeAt(index);
      nameController.clear();
      descriptionController.clear();
    });
    db.updateDB();
  }

  // return first line of note_name and note_description if they are too long
  String shortLine(String line, int maxCountSymbols) {
    if (line.length > maxCountSymbols) {
      String line1;
      line1 = '${line.substring(0, maxCountSymbols - 3)}...';
      return line1;
    }
    return line;
  }

  // scroll our notesList to bottom when i add new note
  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 1500),
      curve: Curves.easeOut,
    );
  }

  // show bottom sheet for creating tasks
  void createNote({required bool isEdit, required int index}) {
    setState(() {
      if (isEdit) {
        nameController.text = db.notes[index];
        descriptionController.text = db.descriptions[index];
      } else {
        nameController.text = '';
        descriptionController.text = '';
      }
    });
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return AddNoteBottomSheet(context, isEdit, index);
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
        title: Text(
          'NOTES',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        elevation: 0,
        toolbarHeight: 65,
        backgroundColor: Colors.indigo[600],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: db.notes.length,
          itemBuilder: (context, index) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          deleteNote(index);
                        },
                        icon: Icons.delete_rounded,
                        backgroundColor: Colors.red.shade400,
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ],
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      createNote(isEdit: true, index: index);
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.55),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 6), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                db.notes[index],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              Text(
                                db.descriptions[index],
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 15),
                              ),
                            ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNote(isEdit: false, index: db.notes.length);
        },
        backgroundColor: Colors.black,
        child: Icon(
          Icons.edit_rounded,
          size: 27,
        ),
      ),
    );
  }

  Container AddNoteBottomSheet(BuildContext context, bool isEdit, int index) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      height: 700,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close_rounded,
              color: Colors.black,
            ),
          ),
          title: Text(
            !isEdit ? 'Make Note' : 'Edit Note',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          actions: [
            isEdit
                ? IconButton(
                    onPressed: () {
                      deleteNote(index);
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.delete_rounded,
                      color: Colors.black,
                    ),
                  )
                : SizedBox(),
            IconButton(
              onPressed: () {
                if (isEdit) {
                  editNote(index);
                } else {
                  addNote();
                }
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.check_rounded,
                color: Colors.black,
              ),
            ),
          ],
          centerTitle: true,
          toolbarHeight: 60,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 25),
            child: SafeArea(
              child: ListView(
                children: [
                  TextFormField(
                    autofocus: isEdit ? false : true,
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: 'Name of the note',
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
                  SizedBox(
                    height: 18,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 15,
                    decoration: InputDecoration(
                        hintText: 'Describe the note',
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
                  SizedBox(
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
