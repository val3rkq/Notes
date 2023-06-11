import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:notes/model/recycle_db.dart';

import 'model/note_db.dart';

class RecycleBinScreen extends StatefulWidget {
  const RecycleBinScreen({Key? key}) : super(key: key);

  @override
  State<RecycleBinScreen> createState() => _RecycleBinScreenState();
}

class _RecycleBinScreenState extends State<RecycleBinScreen> {

  // database
  var noteBox = Hive.box('noteBox');
  NoteDB db = NoteDB();

  var recycleBox = Hive.box('recycleBox');
  RecycleDB dbr = RecycleDB();

  // restore note
  void restoreNote(int index) {
    setState(() {
      db.notes.insert(0, dbr.notes[index]);
      dbr.notes.removeAt(index);

      db.descriptions.insert(0, dbr.descriptions[index]);
      dbr.descriptions.removeAt(index);

      db.dates.insert(0, DateFormat('dd MMM yyyy kk:mm').format(DateTime.now()));
      dbr.dates.removeAt(index);
    });
    db.updateDB();
    dbr.updateDB();

    print(db.notes);
    print(dbr.notes);
  }

  // delete forever current note
  void deleteNote(int index) {
    setState(() {
      dbr.notes.removeAt(index);
      dbr.descriptions.removeAt(index);
      dbr.dates.removeAt(index);
    });
    db.updateDB();
    dbr.updateDB();

    print(db.notes);
    print(dbr.notes);
  }

  // delete forever all notes
  void deleteAll() {
    setState(() {
      dbr.notes = [];
      dbr.descriptions = [];
      dbr.dates = [];
    });
    db.updateDB();
    dbr.updateDB();

    print(db.notes);
    print(dbr.notes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_rounded, color: Colors.black,),
        ),
        centerTitle: true,
        title: Text(
          'Deleted Notes',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
        ),
        elevation: 0,
        // shadowColor: Colors.black,
        toolbarHeight: 60,
        backgroundColor: Color(0xFF8EC3B0),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFDEF5E5),
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: ListView.builder(
          itemCount: dbr.notes.length,
          itemBuilder: (context, index) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          restoreNote(index);
                        },
                        icon: Icons.publish_rounded,
                        backgroundColor: Color(0xFF56A2E5),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      SizedBox(width: 15,),
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          deleteNote(index);
                        },
                        icon: Icons.delete_rounded,
                        backgroundColor: Color(0xFFF16866),
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ],
                  ),
                  child: MaterialButton(
                    onPressed: () {},
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            // color: Colors.transparent,
                            color: Colors.grey.withOpacity(0.55),
                            spreadRadius: 0.5,
                            blurRadius: 6,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dbr.notes[index],
                                    softWrap: false,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    dbr.descriptions[index],
                                    maxLines: 5,
                                    softWrap: false,
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 15),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
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
      floatingActionButton: Container(
        width: 65,
        height: 65,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              deleteAll();
            },
            backgroundColor: Color(0xFFBCEAD5),
            // backgroundColor: Color(0xFF0FC9DF),
            // backgroundColor: Colors.orange,
            child: Icon(
              Icons.delete_forever_rounded,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
