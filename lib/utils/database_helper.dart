import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todoApplication/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //Declare the singleton databaseHelper
  static Database _database;

  //defining the column along with the database table name
  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance(); //named constructor to create instance of Database
  //construct the factory constructor

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); //this is executed only once, singleton object
    }

    return _databaseHelper;
  }

  //create the getter for the database refrence variable
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    //get directory path for both android and ios to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'note.db'; //define the path to database

    //create database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDd);
    return notesDatabase;
  }

  //create a function to that will help create the database
  void _createDd(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,'
        '$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  //define the functions to perform CRUD operation:

  //Fetch operation: get all Note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

    var result =
        await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    return result;
  }

  //insert operation: insert a note object to database
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  //update operation: update a note object and save it to database
  Future<int> updatetNote(Note note) async {
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  //delete operation: delete a note object from database
  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  //get number of Notes objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //get the 'Map List' [List<Map>] and convert it to 'Note List' [List<Note>]
  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList(); //get 'Map List' from database

    int count =
        noteMapList.length; //count the number of map entries in the database
    List<Note> noteList = List<Note>();
    //for loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}
