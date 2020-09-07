import 'dart:developer';

import 'package:locker/beans/location_detial.dart';
import 'package:locker/database/classification_table.dart';
import 'package:locker/database/good_table.dart';
import 'package:locker/database/location_details_table.dart';
import 'package:locker/database/location_table.dart';
import 'package:sqflite/sqflite.dart';

class SqlManager {
  ///数据库版本
  static const _VERSION = 1;

  ///数据库名称
  static const _NAME = 'good_manager.db';
  static Database _database;

  static init() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + _NAME;
    _database = await openDatabase(path, version: _VERSION, onCreate: (Database db, int version) async {});
  }

  ///查找表是否存在
  static isTableExits(String tableName) async {
    await getCurrentDatabase();
    var res = await _database.rawQuery("select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res != null && res.length > 0;
  }

  ///获取database
  static Future<Database> getCurrentDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database;
  }

  ///关闭database
  static close() {
    _database?.close();
    _database = null;
  }

  static createTable()async{
    await GoodTable.getInstance().getDataBase();
    await ClassificationTable.getInstance().getDataBase();
    await LocationTable.getInstance().getDataBase();
    await LocationDetailsTable.getInstance().getDataBase();
  }

}
