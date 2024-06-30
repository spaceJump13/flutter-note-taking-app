import 'package:flutter/material.dart';
import 'package:flutter_uas/HomePage.dart';
import 'package:flutter_uas/LoginPage.dart';
import 'package:flutter_uas/RegisterPage.dart';
import 'package:flutter_uas/model/note.dart';
import 'package:flutter_uas/model/pin.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized

  await Hive.initFlutter();

  Hive.registerAdapter(PinAdapter());
  Hive.registerAdapter(NoteAdapter());

  // Open boxes
  await Hive.openBox<Note>('boxnotes');
  await Hive.openBox<Pin>('pinBoxes');

  // Clear boxpin if needed
  // Hive.box<Pin>('pinBoxes').clear();

  // Check if boxpin is not empty
  bool hasPin = Hive.box<Pin>('pinBoxes').isNotEmpty;

  runApp(MyApp(hasPin: hasPin));
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final bool hasPin;

  MyApp({required this.hasPin});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Hive Register/Login Example',
      theme: ThemeData.dark(),
      home: hasPin ? LoginPage() : RegisterPage(),
      // home: RegisterPage(),
    );
  }
}
