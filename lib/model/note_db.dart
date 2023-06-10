import 'package:hive_flutter/hive_flutter.dart';

class NoteDB {

  late List<String> notes;
  late List<String> descriptions;

  final _noteBox = Hive.box('noteBox');

  void createInitialData() {
    notes = [];
    descriptions = [];
  }

  void loadData() {
    notes = _noteBox.get('NOTES');
    descriptions = _noteBox.get('DESCRIPTIONS');
  }

  void updateDB() {
    _noteBox.put('NOTES', notes);
    _noteBox.put('DESCRIPTIONS', descriptions);
  }
}
