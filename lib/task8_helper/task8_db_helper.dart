// ignore_for_file: camel_case_types

import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../Address/address_data.dart';

class task8_db {
  static final db_name = 'user_data.db';
  static final db_version = 1;

  //User
  static final t_name_user = 'User';
  static final u_Id = 'id';
  static final u_mail = 'mail';
  static final u_mobile = 'Mobile';
  static final u_pass = 'Password';
  static final u_resetPass1 = 'resetPass1';
  static final u_resetPass2 = 'resetPass2';
  static final i_itemList = 'item_list';
  static final u_adress1 = 'Adress1';
  static final u_adress2 = 'Adress2';
  static final u_adress3 = 'Adress3';

  //orders
  static final tableOrders = 'Orders';
  static final OrderId = 'order_id';
  static final OrderUserId = 'user_id';
  static final OrderDetails = 'order_details';
  static final OrderIsCompleted = 'is_completed';
  static final OrderIsApproved = 'is_approved';
  static final OrderTotalPrice = 'total_price';
  static final OrderDate = 'date';
  static final Notify_Seller = 'Notify_Seller';
  static final IsOrderCancel = 'IsOrder_Cancel';

  //Seller
  static final TableSeller = 'Seller';
  static final SellerId = 'seller_id';
  static final SellerName = 'seller_Name';
  static final SellerStoreName = 'seller_store_Name';
  static final SellerMail = 'seller_mail';
  static final SellerMobile = 'seller_Mobile';
  static final SellerPass = 'seller_Password';
  static final SellerResetPass1 = 'seller_resetPass1';
  static final SellerResetPass2 = 'seller_resetPass2';
  static final SellerAdress = 'seller_Address';

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
    return await openDatabase(_dbPath!, version: db_version, onCreate: _onCreate);
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
        $i_itemList TEXT NOT NULL,
        $u_adress1 TEXT NOT NULL,
        $u_adress2 TEXT NOT NULL,
        $u_adress3 TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableOrders (
        $OrderId INTEGER PRIMARY KEY AUTOINCREMENT,
        $OrderUserId INTEGER NOT NULL,
        $OrderDetails TEXT NOT NULL,
        $OrderIsCompleted BOOLEAN,
        $OrderIsApproved BOOLEAN,
        $OrderTotalPrice REAL, 
        $OrderDate TEXT,
        $Notify_Seller BOOLEAN,
        $IsOrderCancel BOOLEAN,
        FOREIGN KEY ($OrderUserId) REFERENCES $t_name_user ($u_Id)
      )
    ''');

    await db.execute('''
    CREATE TABLE $TableSeller (
      $SellerId INTEGER PRIMARY KEY AUTOINCREMENT,
      $SellerName TEXT NOT NULL,
      $SellerStoreName TEXT NOT NULL,
      $SellerMail TEXT NOT NULL,
      $SellerMobile TEXT NOT NULL,
      $SellerPass TEXT NOT NULL,
      $SellerResetPass1 TEXT,
      $SellerResetPass2 TEXT,
      $SellerAdress TEXT NOT NULL
    )
  ''');
  }

  Future<int> insert(mail, mobile, pass, reset1, reset2, cardItems, address1, address2, address3) async {
    try {
      Database db = await instance.database;
      Map<String, dynamic> row = {
        u_mail: mail,
        u_mobile: mobile,
        u_pass: pass,
        u_resetPass1: reset1,
        u_resetPass2: reset2,
        i_itemList: jsonEncode(cardItems),
        u_adress1: address1.toJsonString(),
        u_adress2: address2.toJsonString(),
        u_adress3: address3.toJsonString(),
      };
      return await db.insert(t_name_user, row);
    } catch (e) {
      print("Error inserting data: $e");
      return -1;
    }
  }

  Future<int> insertSeller(S_mail,S_name,S_store_name,S_mobile, S_pass, S_reset1, S_reset2, S_address) async {
    try {
      Database db = await instance.database;
      Map<String, dynamic> row = {
        SellerMail: S_mail,
        SellerName: S_name,
        SellerStoreName: S_store_name,
        SellerMobile: S_mobile,
        SellerPass: S_pass,
        SellerResetPass1: S_reset1,
        SellerResetPass2: S_reset2,
        SellerAdress: S_address.toJsonString(),
      };
      return await db.insert(TableSeller, row);
    } catch (e) {
      print("Error inserting data: $e");
      return -1;
    }
  }

  Future<void> insertOrder(int userId, List<Map<String, dynamic>> orderDetails, bool isCompleted, bool isApproved, double totalPrice) async {
    Database db = await instance.database;
    String orderDetailsJson = jsonEncode(orderDetails);
    String currentDate = DateTime.now().toIso8601String();
    await db.insert(
      tableOrders,
      {
        OrderUserId: userId,
        OrderDetails: orderDetailsJson,
        OrderIsCompleted: isCompleted ? 1 : 0,
        OrderIsApproved: isApproved ? 1 : 0,
        OrderTotalPrice: totalPrice,
        OrderDate: currentDate,
        Notify_Seller : 0,
        IsOrderCancel : 0
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Handle conflicts by replacing existing rows
    );
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

  Future<List<Map<String, dynamic>>> querySpacificSeller(String Id) async {
    try {
      Database db = await instance.database;
      List<Map<String, dynamic>> results = await db.query(
        TableSeller,
        where: "$SellerMobile = ?",
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

  Future<int> updateSpecificUserItems(String userId, List<Map<String, dynamic>> items) async {
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

  Future<int> updateSpecificUserAddress(String userId, AddressData obj, int no) async {
    Database db = await instance.database;
    if (t_name_user.isNotEmpty) {
      var update = await db.update(
          t_name_user, {'Adress${no}': obj.toJsonString()},
          where: "$u_mobile = ?", whereArgs: [userId]);
      return update;
    } else {
      print("table is not exist");
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

  Future<List<Map<String, dynamic>>> queryallSeller() async {
    try {
      Database db = await instance.database;
      return await db.query(TableSeller);
    } catch (e) {
      print("Error querying data: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getOrdersForUser(int userId) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableOrders,
      where: '$OrderUserId = ?',
      whereArgs: [userId],
    );
    return maps;
  }
  //not used
  Future<int> updateOrderApproval(int orderId, bool isApproved) async {
    Database db = await instance.database;
    try {
      return await db.update(
        tableOrders,
        {
          OrderIsApproved: isApproved ? 1 : 0,
        },
        where: '$OrderId = ?',
        whereArgs: [orderId],
      );
    } catch (e) {
      print('Error updating order approval: $e');
      return -1;
    }
  }
  //not used
  Future<int> deleteSpecificOrder(int orderId) async {
    Database db = await instance.database;
    try {
      return await db.delete(
        tableOrders,
        where: '$OrderId = ?',
        whereArgs: [orderId],
      );
    } catch (e) {
      print('Error deleting order: $e');
      return -1;
    }
  }

  Future<int> updateNotify_Seller(int orderId) async {
    Database db = await instance.database;
    try {
      return await db.update(
        tableOrders,
        {
          Notify_Seller: 1,
        },
        where: '$OrderId = ?',
        whereArgs: [orderId],
      );
    } catch (e) {
      print('Error updating order approval: $e');
      return -1;
    }
  }

  Future<int> updateOrderStatus(int orderId) async {
    Database db = await instance.database;
    try {
      return await db.update(
        tableOrders,
        {
          IsOrderCancel: 1,
        },
        where: '$OrderId = ?',
        whereArgs: [orderId],
      );
    } catch (e) {
      print('Error updating order approval: $e');
      return -1;
    }
  }

}