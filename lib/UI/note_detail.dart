import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoApplication/customWidget/customTextfield.dart';
import 'package:todoApplication/models/note.dart';
import 'package:todoApplication/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class NoteDetailScreen extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetailScreen(this.appBarTitle, this.note);
  @override
  _NoteDetailScreenState createState() =>
      _NoteDetailScreenState(this.note, appBarTitle);
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  static var _priorities = ['High', 'Low'];
  DatabaseHelper helper =
      DatabaseHelper(); //define the singletone instance of the databasehelper

  final String appBarTitle;
  final Note note;

  _NoteDetailScreenState(this.note, this.appBarTitle);

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descriptionController.text = note.description;

    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
        ),
        body: ListView(
          children: [
            ListTile(
              title: DropdownButton(
                  items: _priorities.map((String dropDownStringItem) {
                    return DropdownMenuItem(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  style: textStyle,
                  value: getPriorityASString(note.priority),
                  onChanged: (valueSelecetedByUser) {
                    setState(() {
                      debugPrint('user Select $valueSelecetedByUser');
                      updatePriority(valueSelecetedByUser);
                    });
                  }),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
              child: CustomTextField(
                  onChange: (value) {
                    updateTitle();
                  },
                  controller: titleController,
                  textStyle: textStyle,
                  labelText: 'Title'),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
              child: CustomTextField(
                onChange: (value) {
                  updateDescription();
                },
                controller: descriptionController,
                textStyle: textStyle,
                labelText: 'Description',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: RaisedButton(
                            color: Colors.blue,
                            child: Text(
                              'Save',
                              style: textStyle,
                            ),
                            onPressed: () {
                              save();
                            })),
                    SizedBox(width: 20.0),
                    Expanded(
                        child: RaisedButton(
                            color: Colors.blue,
                            child: Text(
                              'Delete',
                              style: textStyle,
                            ),
                            onPressed: () {
                              _delete();
                            })),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  //convert the string priority in the form of integer before saving to database
  void updatePriority(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;

      case 'Low':
        note.priority = 2;
        break;
    }
  }

  //convert integer priority to string priority and display it to the user in the dropdown
  String getPriorityASString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; //High
        break;

      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  //update the title
  void updateTitle() {
    note.title = titleController.text;
  }

  //update the description
  void updateDescription() {
    note.description = descriptionController.text;
  }

  //save data to database

  void save() async {
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      //csse 1, update operation
      result = await helper.updatetNote(note);
    } else {
      //case 2, insert operation
      result = await helper.insertNote(note);
    }
    if (result != 0) {
      _showAlertDialog('Status', 'Note save successfully'); //success
    } else {
      _showAlertDialog('Status', 'Problem Saving notes'); //success
    }
  }

  //Dialogue Bank

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  //delete
  void _delete() async {
    //case1 if the user is trying to delete a new note
    moveToLastScreen();
    if (note.id == null) {
      _showAlertDialog('Status', 'No message was deleted');
      return;
    }
    int result = await helper.deleteNote(note.id);
    //the user is trying to delete the note which already have a valid id
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error occure while Deleting Note');
    }
  }

  //move to last screen
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
