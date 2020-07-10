import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'DBModel.dart';

class DataBaseHelper {
  static DataBaseHelper _dataBaseHelper;
  static Database _database;

  String dbName = "AutoEcoleSeries.db";
  String noteTableName = "SeriesList";
  String clmId = "id";
  String clmName = 'name';
  String clmMark = "mark";
  String clmDate = "date";
  String clmAnswers = 'answers';

  DataBaseHelper.createInstance();

  factory DataBaseHelper() {
    if (_dataBaseHelper == null)
      _dataBaseHelper = DataBaseHelper.createInstance();

    return _dataBaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDB();
    }
    return _database;
  }

  Future<Database> initializeDB() async {
    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), dbName),
      // When the database is first created, create a table to store data.
      onCreate: _createDB,
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 2,
    );

    return database;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute(
      "CREATE TABLE $noteTableName($clmId INTEGER PRIMARY KEY AUTOINCREMENT, "
      "$clmName TEXT, $clmMark TEXT, $clmDate TEXT, $clmAnswers TEXT)",
    );
  }

  //save serie data result into the db
  Future insertTest(DBModel model) async {
    Database db = await database;
    var result = await db.insert(noteTableName, model.toMap());
    return result;
  }

  //update data in db
  Future updateTest(DBModel model) async {
    Database db = await database;
    var result = await db.update(
      noteTableName,
      model.toMapforUpdate(),
      where: "$clmId = ?",
      whereArgs: [model.id],
    );
    return result;
  }

  //get serie data from db
  Future<List<DBModel>> getTestsList() async {
    List testsMapList = await getTestsMapList();
    int count = testsMapList.length;

    List<DBModel> testsList = List();
    for (int i = 0; i < count; i++) {
      testsList.add(DBModel.fromMapObject(testsMapList[i]));
    }

    return testsList;
  }

  //fetch operation: get all data from db
  Future getTestsMapList() async {
    Database db = await database;
    var result = await db.query(noteTableName);
    return result;
  }

  //delete all data
  Future deleteAll() async {
    final db = await database;
    db.delete(noteTableName);
  }

  //delete operation
  Future deleteTest(int id) async {
    Database db = await database;
    var result =
        await db.delete(noteTableName, where: "$clmId = ?", whereArgs: [id]);
    return result;
  }
}
