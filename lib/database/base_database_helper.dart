import 'package:flutter/cupertino.dart';
import 'package:locker/database/sql_manager.dart';
import 'package:sqflite/sqflite.dart';

/***
 * 表操作的父类
 */
abstract class BaseDbHelper {
  bool isTableExits = false;
  Database db;

  createTableString();

  getTableName();

  openDb() async {
    if (!isTableExits) await getDataBase();
    if (db == null) db = await SqlManager.getCurrentDatabase();
    if (!db.isOpen) db = await open();
  }

  closeDb() {
    db?.close();
  }

  createTableBaseString(String sql) {
    return sql;
  }

  Future<Database> getDataBase() async {
    return await open();
  }

  @mustCallSuper
  prepare(name, String createSql) async {
    isTableExits = await SqlManager.isTableExits(name);
    print('test build table$name');
    if (!isTableExits) {
      Database db = await SqlManager.getCurrentDatabase();
      return await db.execute(createSql);
    }
  }

  @mustCallSuper
  open() async {
    if (!isTableExits) {
      await prepare(getTableName(), createTableString());
    }
    return await SqlManager.getCurrentDatabase();
  }
}
