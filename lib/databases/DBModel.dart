class DBModel {
  int id;
  String name, mark, date, answers;

  DBModel(this.id, this.name, this.mark, this.date, this.answers);

  //convert a model object into a map object
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mark': mark,
      'date': date,
      'answers': answers,
    };
  }

  //used in update data in db
  Map<String, dynamic> toMapforUpdate() {
    return {
      'mark': mark,
      'date': date,
      'answers': answers,
    };
  }

  //convert to model object from map object
  DBModel.fromMapObject(Map<dynamic, dynamic> map) {
    name = map["name"];
    mark = map["mark"];
    date = map["date"];
    id = map["id"];
    answers = map["answers"] ?? '';
  }
}
