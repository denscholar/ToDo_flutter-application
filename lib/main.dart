import 'package:flutter/material.dart';
import 'package:todoApplication/UI/async.dart';
import 'package:todoApplication/UI/note_detail.dart';
import 'package:todoApplication/UI/note_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo Application',
      home: NoteList(),
    );

  }
}
