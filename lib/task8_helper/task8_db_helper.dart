import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class task8_db {
  static final db_name = 'user_data.db';
  static final db_version = 1;
  static final t_name_user = 'User_info';

  // COLUMNS for user
  static final u_Id = 'id';
  static final u_mail = 'mail';
  static final u_mobile = 'Mobile';
  static final u_pass = 'Password';
  static final u_resetPass1 = 'resetPass1';
  static final u_resetPass2 = 'resetPass2';
  static final i_itemList = 'item_list';

  static Database? _database;
  static String? _dbPath;

  task8_db._privateConstructor();

  static final task8_db instance = task8_db._privateConstructor();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    _dbPath = join(documentDirectory.path, db_name);
    return await openDatabase(_dbPath!,
        version: db_version, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $t_name_user (
        $u_Id INTEGER PRIMARY KEY AUTOINCREMENT,
        $u_mail TEXT NOT NULL,
        $u_mobile TEXT UNIQUE NOT NULL,
        $u_pass TEXT NOT NULL,
        $u_resetPass1 TEXT NOT NULL,
        $u_resetPass2 TEXT NOT NULL,
        $i_itemList TEXT NOT NULL
      )
    ''');
  }

  Future<int> insert(mail, mobile, pass, reset1, reset2, card_items) async {
    try {
      Database db = await instance.database;
      Map<String, dynamic> row = {
        u_mail: mail,
        u_mobile: mobile,
        u_pass: pass,
        u_resetPass1: reset1,
        u_resetPass2: reset2,
        i_itemList: jsonEncode(card_items),
      };
      return await db.insert(t_name_user, row);
    } catch (e) {
      print("Error inserting data: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> querySpacific(String Id) async {
    try {
      Database db = await instance.database;
      List<Map<String, dynamic>> results = await db.query(
        t_name_user,
        where: "$u_mobile = ?",
        whereArgs: [Id],
      );
      return results;
    } catch (e) {
      print("Error querying data: $e");
      return [];
    }
  }

  Future<int> updateSpacific(String Id, String Pass) async {
    Database db = await instance.database;
    if (t_name_user.isNotEmpty) {
      var update = await db.update(t_name_user, {"$u_pass": "$Pass"},
          where: "$u_mobile = ?", whereArgs: [Id]);
      return update;
    } else {
      print("table is not exist");
      return -1;
    }
  }

  Future<int> updateSpecificUserItems(
      String userId, List<Map<String, dynamic>> items) async {
    final db = await database;
    try {
      return await db.update(
        t_name_user,
        {
          'item_list': jsonEncode(items),
        },
        where: '$u_mobile = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      print('Error updating items data: $e');
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> queryall() async {
    try {
      Database db = await instance.database;
      return await db.query(t_name_user);
    } catch (e) {
      print("Error querying data: $e");
      return [];
    }
  }
}
