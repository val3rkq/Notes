import 'package:hive_flutter/hive_flutter.dart';

class NoteDB {

  late List<String> notes;
  late List<String> descriptions;
  late List<String> dates;

  final _noteBox = Hive.box('noteBox');

  void createInitialData() {
    notes = [];
    descriptions = [];
    dates = [];
  }

  void loadData() {
    notes = _noteBox.get('NOTES');
    descriptions = _noteBox.get('DESCRIPTIONS');
    dates = _noteBox.get('DATES');
  }

  void updateDB() {
    _noteBox.put('NOTES', notes);
    _noteBox.put('DESCRIPTIONS', descriptions);
    _noteBox.put('DATES', dates);
  }
}
