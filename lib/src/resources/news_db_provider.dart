import 'package:sqflite/sqflite.dart';
import "package:path_provider/path_provider.dart";
import "dart:io";
import "package:path/path.dart";
import "dart:async";
import "../models/item_model.dart";
import "repository.dart";

class NewsDbProvider implements Source, Cache {
  Database db;
  NewsDbProvider() {
    init();
  }
  // using vim initialize the db
  void init() async {
    // getApplicationDocumentsDirectory() function
    //allows you to make a reference to a directory in your mobile device
    //This reference is stored in documentsDirectory
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // the path variable stores the actual path/ to the database
    //join function essentially joins two strings
    final path = join(documentsDirectory.path, "items.db");
    //openDatabase : will open an existing db or create a new db
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute("""CREATE TABLE Items 
        ( id INTERGER PRIMARY KEY,
          text TEXT,
          by TEXT,
          time INTEGER,
          text TEXT,
          parent INTEGER,
          kids BLOB,
          dead INTEGER,
          deleted INTEGER,
          url TEXT,
          score INTEGER,
          title TEXT,
          descendants INTEGER
        );
        """);
      },
    );
  }

  Future<ItemModel> fetchItem(int id) async {
    final maps = await db.query(
      "Items",
      columns: null, //its kept null, because we want the entire item
      where: "id=?", //search criteria
      whereArgs: [id], //argument for "?" , protects against sql injection
    );
    if (maps.length > 0) {
      return ItemModel.fromDb(maps.first);
    }
    return null;
  }

  Future<int> addItem(ItemModel item) {
    return db.insert(
      "Items",
      item.toMapForDb(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<List<int>> fetchTopIds() {
    return null;
  }

  Future<int> clear() {
    return db.delete("Items");
  }
}

final newsDbProvider = NewsDbProvider();
