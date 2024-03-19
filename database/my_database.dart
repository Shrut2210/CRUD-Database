import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class MyDatabase {
  Future<Database> initDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'data.db');
    return await openDatabase(databasePath);
  }
  Future<bool> copyPasteAssetFileToRoot() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "data.db");

    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      ByteData data =
      await rootBundle.load(join('assets/database', 'data.db'));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
      return true;
    }
    return false;
  }

  Future<List<Map<String, dynamic?>>> getDetails() async {
    Database db = await initDatabase();
    List<Map<String, dynamic?>> list = await db.rawQuery("select Name, Image from tabledata");

    return list;
  }

  Future<void> deleteData(String id) async {
    Database db = await initDatabase();

    var res = db.delete('tabledata', where: 'Name = ?', whereArgs: [id]);
  }

  Future<int> insertData(Map<String, Object?> map)  async {
    Database db = await initDatabase();

    var res = db.insert("tabledata", map);
    return res;

  }

  Future<int> updatData(Map<String, Object?> map, String id)  async {
    Database db = await initDatabase();

    var res = db.update("tabledata", map, where: 'Name = ?', whereArgs: [id]);
    return res;

  }
}

