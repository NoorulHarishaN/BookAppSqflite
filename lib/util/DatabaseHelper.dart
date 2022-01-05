import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';

import '../model/BookItem.dart';

import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper _instance = DatabaseHelper._internal(); //internal construction
  static Database _db;

  final String tableItem = "books";
  final String columnId = "id";
  final String columnBookName= "book_name";
  final String authorName = "author_name";

  factory DatabaseHelper() {
    if (_instance == null) {
      _instance = DatabaseHelper._internal();
    }
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDb();
    return _db;
  }

  initDb() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = documentDirectory.path + "todo_db.db";

    var db = await openDatabase(path, version:  1, onCreate: _onCreate);
    return db;
  }

  Future<void> _onCreate(Database db, int version) async{
    await db.execute(
      "CREATE TABLE $tableItem ($columnId INTEGER PRIMARY KEY, $columnBookName TEXT, $authorName TEXT)"
    );
  }


  Future<int> saveItem(BookItem item) async{
      var dbClient = await db;
      int res = await dbClient.insert('$tableItem', item.toMap());
      return res;
  }

  Future<BookItem> getItem(int id) async {
      var dbClient = await db;
      var result = await dbClient.rawQuery('SELECT * FROM $tableItem WHERE $columnId = $id');
      return BookItem.fromMap(result.first);
  }

  Future<List> getAllItems() async {
      var dbClient = await db;
      var result = await dbClient.rawQuery('SELECT * FROM $tableItem ORDER BY $columnId DESC');
      return result.toList();
  }

  Future<int> getItemsCount() async {
      var dbClient = await db;
      return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tableItem')
      );
  }

  Future<int> deleteItem(int id) async{
      var dbClient = await db;
      return await dbClient.delete(tableItem, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> updateItem(BookItem item) async {
      var dbClient = await db;
      return await dbClient.update(tableItem, item.toMap(), where: '$columnId = ?', whereArgs: [item.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }


}
