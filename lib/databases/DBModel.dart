class DBModel {
  int id;
  String name, mark, date;

  DBModel(this.name, this.mark, this.date);

  //convert a model object into a map object
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mark': mark,
      'date': date,
    };
  }

  //convert to model object from map object
  DBModel.fromMapObject(Map<dynamic, dynamic> map) {
    name = map["name"];
    mark = map["mark"];
    date = map["date"];
    id = map["id"];
  }
}
