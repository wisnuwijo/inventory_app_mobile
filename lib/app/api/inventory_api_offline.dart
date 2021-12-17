import 'dart:io';
import 'package:inventory_app/app/helper/file_system.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class InventoryApiOffline {
  static const String DB_NAME = 'inventory.db';

  Future<Database> get db async {
    Database db;
    if (db != null) {
      return db;
    }

    db = await initDb();

    return db;
  } 

  initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(
      path, 
      version: 1, 
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
          'CREATE TABLE inventory ('+
            'id INTEGER NOT NULL, '+
            'name TEXT NOT NULL, '+
            'stock INTEGER NOT NULL, '+
            'unit TEXT NOT NULL, '+
            'image TEXT NULL, '+
            'note TEXT NULL, '+
            'status TEXT NOT NULL, '+
            'uploaded_at TEXT NULL, ' +
            'PRIMARY KEY (id))'
        );
      });

    return db;
  }

  add({
    String name,
    int stock,
    String unit,
    File image,
    String note,
  }) async {
    var dbClient = await db;

    String imagePath = '';
    if (image != null) {
      imagePath = await FileSystem().copyImage(image);
      print('imagePath : $imagePath');
    }

    String insertQuery = "INSERT INTO " + 
      "inventory (name, stock, unit, image, note, status, uploaded_at) " +
      "VALUES ('$name', '$stock', '$unit', '$imagePath', '$note', 'offline', NULL);";
    
    await dbClient.rawQuery(insertQuery);
    this.offlineData();
  }

  Future<List<Map>> offlineData() async {
    var dbClient = await db;
    String query = "SELECT * FROM inventory WHERE status = 'offline'";
    final data = await dbClient.rawQuery(query);
    print("offline data : $data");

    return data;
  }

  Future setToOnline(int id) async {
    var dbClient = await db;
    String query = "UPDATE inventory SET status = 'online' WHERE id = $id";
    await dbClient.rawQuery(query);
  }
}