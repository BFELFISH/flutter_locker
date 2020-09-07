import 'dart:async';

import 'package:locker/beans/classification.dart';
import 'package:locker/database/base_database_helper.dart';
import 'package:locker/database/classification_entry.dart';
import 'package:locker/database/sql_string.dart';
import 'package:locker/utils/log_utils.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:sqflite/sqflite.dart';

class ClassificationTable extends BaseDbHelper {
  static ClassificationTable _instance;

  ClassificationTable._internal();

  static ClassificationTable getInstance() {
    if (_instance == null) _instance = ClassificationTable._internal();
    return _instance;
  }

  @override
  createTableString() {
    return "create table ${ClassificationEntry.tableName}(${ClassificationEntry.columnId} $INTEGER primary key,${ClassificationEntry.columnName} $TEXT unique not null,${ClassificationEntry.columnPic} $TEXT)";
  }

  @override
  getTableName() {
    return ClassificationEntry.tableName;
  }

  @override
  Future<Database> getDataBase() async {
    await super.getDataBase();
    await openDb();
    List<Map> resultClass = await getClassification();
    if (resultClass.length == 0) {
      initClass();
    }
  }

  ///根据一个参数查询数据库
  Future getClassification() async {
    var maps = await db.rawQuery("select * from ${ClassificationEntry.tableName} ");
    return maps;
  }

  ///根据一个参数查询数据库
  Future getClassByOneColumn(String columnName, String key) async {
    List<Map> maps = await db.rawQuery("select * from ${ClassificationEntry.tableName} where $columnName = $key");
    return maps;
  }

  ///根据多个参数查询
  Future getClassByColumns(List<String> columns, List<String> keys) async {
    String query = "select * from ${ClassificationEntry.tableName} where ";
    //两个列表的长度应该一致
    if (columns.length != keys.length) {
      return null;
    }
    for (int i = 0; i < columns.length; i++) {
      query += "${columns[i]} = ${keys[i]}";
      if (i != columns.length - 1) {
        query += '&&';
      }
    }
    List<Map<String, Classification>> maps = await db.rawQuery(query);
    return maps;
  }

  ///插入数据
  Future insert(Classification bean) async {
    var result = await db
        .rawInsert("insert into ${ClassificationEntry.tableName} (${ClassificationEntry.columnName},${ClassificationEntry.columnPic}) values (?,?)", [
      bean.name,
      bean.pic,
    ]);
    return result;
  }

  ///更新数据库
  Future update(Classification bean) async {
    var result = '' ;
    try{
       await db.rawUpdate(
          "update ${ClassificationEntry.tableName} set ${ClassificationEntry.columnName} = ${bean.name},${ClassificationEntry.columnPic} = ${bean.pic} where ${ClassificationEntry.columnId} = ${bean.id}");
    }on DatabaseException catch (error){
    }
    return result;
  }

  Future delete(int id)async{
    var result = await db.rawDelete('DELETE FROM ${ClassificationEntry.tableName} WHERE ${ClassificationEntry.columnId} = ?', ['$id']);
    return result;
  }

  ///预加载分类信息
  initClass() async {
    Map<String, String> classMap = {
      '衣服': 'clothes',
      '饮料': 'coffee',
      '化妆品': 'make_up',
      '药品': 'medicine',
      '鞋子': 'shoes',
      '文具': 'pen',
      '钥匙': 'key',
    };

      classMap.keys.forEach((element) async {
        await db.rawInsert(
            "insert into ${ClassificationEntry.tableName} (${ClassificationEntry.columnName},${ClassificationEntry.columnPic}) values (?,?)", [
          element,
          classMap[element],
        ]);
      });
  }
}
