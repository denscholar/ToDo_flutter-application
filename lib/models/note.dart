class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Note(this._title, this._date, this._priority, [this._description]);

  Note.withId(this._title, this._date, this._priority, [this._description]);

  // getter

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  int get priority => _priority;

  // setter

  set title(String newTitle) {
    if (newTitle.length <= 25) {
      //condition for title
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 25) {
      this._description = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  //Define a function to convert the Note object into a map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>(); //instantiate an empty map object
    //then start insert into the map object with the keys and its values

    if (id != null) {
      map['id'] = _id;
    }

    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

  //Define a function to extract a Note object from the Map object

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
  }
}
