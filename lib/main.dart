import 'package:flutter/material.dart';
import 'pages/home_page/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  var noteBox = await Hive.openBox('box');
  // noteBox.deleteAll(noteBox.keys);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
    );
  }
}
