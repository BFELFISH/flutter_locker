import 'package:locker/beans/location_detial.dart';
import 'package:locker/database/base_database_helper.dart';
import 'package:locker/database/location_details_entry.dart';
import 'package:locker/database/sql_string.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:sqflite/sqflite.dart';

class LocationDetailsTable extends BaseDbHelper {
  LocationDetailsTable._internal();

  static LocationDetailsTable _instance;

  static getInstance() {
    if (_instance == null) _instance = LocationDetailsTable._internal();
    return _instance;
  }

  @override
  createTableString() {
    return "create table ${LocationDetailsEntry.tableName}(${LocationDetailsEntry.columnId} $INTEGER primary key,${LocationDetailsEntry.columnName} $TEXT not null,${LocationDetailsEntry.columnLocationId} $INTEGER)";
  }

  @override
  Future<Database> getDataBase() async {
    await super.getDataBase();
  }

  @override
  getTableName() {
    return LocationDetailsEntry.tableName;
  }

  ///根据一个参数查询数据库
  Future getLocationDetailsByOneColumn(String columnName, String key) async {
    List<Map> maps = await db.rawQuery("select * from ${LocationDetailsEntry.tableName} where $columnName = $key");
    return maps;
  }

  ///根据多个参数查询
  Future getLocationDetailsByColumns(List<String> columns, List<String> keys) async {
    String query = "select * from ${LocationDetailsEntry.tableName} where ";
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
    List<Map> maps = await db.rawQuery(query);
    return maps;
  }

  ///插入数据
  Future insert(LocationDetail bean) async {
    return await db.rawInsert(
        "insert into ${LocationDetailsEntry.tableName} (${LocationDetailsEntry.columnName},${LocationDetailsEntry.columnLocationId}) values (?,?)",
        [bean.locationDetail, bean.location.id]);
  }

  Future delete(int id) async {
    var result = await db.rawDelete('DELETE FROM ${LocationDetailsEntry.tableName} WHERE ${LocationDetailsEntry.columnId} = ?', ['$id']);
    return result;
  }

  ///更新数据库
  Future update(LocationDetail bean) async {
    var result;
    try{
      result = await db.rawUpdate(
          "update ${LocationDetailsEntry.tableName} set"
              " ${LocationDetailsEntry.columnName} = ?,"
              "${LocationDetailsEntry.columnLocationId} = ?"
              " where ${LocationDetailsEntry.columnId} = ?",
          ['${bean.locationDetail}', bean.location.id, bean.id]);

    }on DatabaseException catch (error){
      ToastUtils.show('更新失败');
    }
    return result;
  }
}
