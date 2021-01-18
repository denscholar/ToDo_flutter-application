import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todoApplication/UI/note_detail.dart';
import 'package:todoApplication/models/note.dart';
import 'package:todoApplication/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Notes'),
        ),
        body: ListView.builder(
          itemCount: count,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
              child: Card(
                  color: Colors.white,
                  elevation: 5.0,
                  child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            getColorPriorityColor(this.noteList[index].priority),
                        child:
                            getColorPriorityIcon(this.noteList[index].priority),
                      ),
                      title: Text(
                        this.noteList[index].title,
                        style: TextStyle(fontSize: 20.0, color: Colors.black),
                      ),
                      subtitle: Text(this.noteList[index].date,
                          style: TextStyle(fontSize: 18.0, color: Colors.red, fontWeight: FontWeight.w500)),
                      trailing: GestureDetector(
                        onTap: () {
                          _delete(context, noteList[index]);
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.grey,
                        ),
                      ),
                      onTap: () async{
                       bool result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoteDetailScreen(
                                    'Edit Note', this.noteList[index])));
                        if (result == true) {
                          updateListView();
                        }
                      })),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Add Note',
            onPressed: () async {
             bool result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoteDetailScreen(
                            'Add Note',
                            Note('', '', 2),
                          )));
              if (result == true) {
                updateListView();
              }
            }));
  }

  // void navigateToNoteDetail(String title) {
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => NoteDetailScreen(title)));
  // }

  //color priority
  Color getColorPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;

      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  //Return the priority icon

  Icon getColorPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;

      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  //delete function
  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted successfully');
      updateListView(); //updating the listview when deleting
    }
  }

  //SnackBar
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

//updating the listview function
  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
