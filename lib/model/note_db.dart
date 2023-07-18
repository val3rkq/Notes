import 'package:hive_flutter/hive_flutter.dart';

class NoteDB {

  late Map notes;

  final _noteBox = Hive.box('noteBox');

  void createInitialData() {
    notes = {};
  }

  void loadData() {
    notes = _noteBox.get('NOTES');
  }

  void updateDB() {
    _noteBox.put('NOTES', notes);
  }
}
