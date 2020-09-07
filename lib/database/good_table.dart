import 'package:locker/beans/goods.dart';
import 'package:locker/database/base_database_helper.dart';
import 'package:locker/database/sql_string.dart';
import 'package:sqflite/sqflite.dart';

import 'good_entry.dart';

class GoodTable extends BaseDbHelper {
  final String TAG = 'GoodTable';
  static GoodTable _instance;

  GoodTable._internal();

  static GoodTable getInstance() {
    if (_instance == null) {
      _instance = GoodTable._internal();
    }
    return _instance;
  }

  @override
  createTableString() {
    return "create table ${GoodEntry.tableName}(${GoodEntry.columnId} $INTEGER primary key,${GoodEntry.columnName} $TEXT not null,${GoodEntry.columnBuyDate} $TEXT,${GoodEntry.columnExpDate} $TEXT,${GoodEntry.columnPrdDate} $TEXT,${GoodEntry.columnNum} $INTEGER,"
        "${GoodEntry.columnPrice} $REAL,${GoodEntry.columnPic} $BLOB,${GoodEntry.columnLocation} $INTEGER,${GoodEntry.columnRemarks} $TEXT,${GoodEntry.columnWarnDays} $INTEGER,${GoodEntry.columnClassification} $INTEGER)";
  }

  @override
  getTableName() {
    return GoodEntry.tableName;
  }

  ///返回所有物品
  Future getAllGood() async {
    List<Map> maps = await db.rawQuery("select * from ${GoodEntry.tableName}");
    return maps;
  }

  ///根据一个参数查询数据库
  Future getGoodByOneColumn(String columnName, String key) async {
    List<Map> maps = await db.rawQuery("select * from ${GoodEntry.tableName} where $columnName = $key");
    return maps;
  }

  Future getGoodByName(String value) async {
    String query = "select * from ${GoodEntry.tableName} where ${GoodEntry.columnName} like '%$value%'";
    return await db.rawQuery(query);
  }

  ///根据多个参数查询
  Future getGoodByColumns(List<String> columns, List<String> keys) async {
    String query = "select * from ${GoodEntry.tableName} where ";
    //两个列表的长度应该一致
    if (columns.length != keys.length) {
      return null;
    }
    for (int i = 0; i < columns.length; i++) {
      query += "${columns[i]} = ${keys[i]}";
      if (i != columns.length - 1) {
        query += 'OR';
      }
    }
    List<Map> maps = await db.rawQuery(query);
    return maps;
  }

  ///插入数据
  Future insert(Good bean) async {
    var result = await db.rawInsert(
        "insert into ${GoodEntry.tableName} (${GoodEntry.columnName},${GoodEntry.columnBuyDate},${GoodEntry.columnExpDate},${GoodEntry.columnPrdDate},${GoodEntry.columnNum},${GoodEntry.columnPrice},${GoodEntry.columnPic},${GoodEntry.columnLocation},${GoodEntry.columnRemarks},${GoodEntry.columnWarnDays},${GoodEntry.columnClassification}) values (?,?,?,?,?,?,?,?,?,?,?)",
        [
          bean.name,
          bean.buyDate,
          bean.expDate,
          bean.prdDate,
          bean.numOfGood,
          bean.price,
          bean.pic,
          bean.locationDetail?.id,
          bean.remarks,
          bean.warnDays,
          bean.classification?.id
        ]);
    return result;
  }

  ///更新数据库
  Future update(Good bean) async {
    var result = await db.rawUpdate(
        "update ${GoodEntry.tableName} set "
            "${GoodEntry.columnName} = ?,"
            "${GoodEntry.columnBuyDate} = ?,"
            "${GoodEntry.columnPrdDate} = ?,"
            "${GoodEntry.columnExpDate} = ?,"
            "${GoodEntry.columnNum} = ?,"
            "${GoodEntry.columnPrice} = ?,"
            "${GoodEntry.columnPic} = ?,"
            "${GoodEntry.columnLocation} = ?,"
            "${GoodEntry.columnRemarks} = ?,"
            "${GoodEntry.columnWarnDays} = ?,"
            "${GoodEntry.columnClassification} = ?"
            "where ${
            GoodEntry.columnId} = ?",[
              '${bean.name}',
              '${bean.buyDate}',
              '${bean.prdDate}',
              '${bean.expDate}',
              bean.numOfGood,
      bean.price,
      bean.pic,
      bean.locationDetail?.id,
      '${bean.remarks}',
      bean.warnDays,
      bean.classification?.id,
      bean.id
    ]);
    return result;
  }

  Future delete(int id) async {
    var result = await db.rawDelete('DELETE FROM ${GoodEntry.tableName} WHERE ${GoodEntry.columnId} = ?', ['$id']);
    return result;
  }

  @override
  Future<Database> getDataBase() async {
    await super.getDataBase();
  }
}
