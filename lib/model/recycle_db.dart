import 'package:hive_flutter/hive_flutter.dart';

class RecycleDB {

  late List<String> notes;
  late List<String> descriptions;
  late List<String> dates;

  final _recycleBox = Hive.box('recycleBox');

  void createInitialData() {
    notes = [];
    descriptions = [];
    dates = [];
  }

  void loadData() {
    notes = _recycleBox.get('NOTES');
    descriptions = _recycleBox.get('DESCRIPTIONS');
    dates = _recycleBox.get('DATES');
  }

  void updateDB() {
    _recycleBox.put('NOTES', notes);
    _recycleBox.put('DESCRIPTIONS', descriptions);
    _recycleBox.put('DATES', dates);
  }
}
