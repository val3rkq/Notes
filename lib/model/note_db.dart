import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/constants.dart';

class NoteDB {

  late Map notes;

  final _noteBox = Hive.box(boxName);

  void createInitialData() {
    notes = {};
  }

  void loadData() {
    notes = _noteBox.get(dataName);
  }

  void updateDB() {
    _noteBox.put(dataName, notes);
  }
}
