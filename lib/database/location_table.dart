
import 'package:locker/beans/location.dart';
import 'package:locker/database/base_database_helper.dart';
import 'package:locker/database/location_entry.dart';
import 'package:locker/database/sql_string.dart';
import 'package:sqflite/sqflite.dart';

class LocationTable extends BaseDbHelper {
  static LocationTable _instance;

  LocationTable._internal();

  static LocationTable getInstance() {
    if (_instance == null) _instance = LocationTable._internal();
    return _instance;
  }

  @override
  createTableString() {
    return "create table ${LocationEntry.tableName}(${LocationEntry.columnId} $INTEGER primary key,${LocationEntry.columnName} $TEXT not null unique,${LocationEntry.columnPic} $TEXT)";
  }

  @override
  getTableName() {
    return LocationEntry.tableName;
  }

  @override
  Future<Database> getDataBase() async {
    await super.getDataBase();
    await openDb();
    List<Map> result = await getAllLocation();
    if(result.length<=0){
      initLocation();
    }
  }

  Future getAllLocation() async {
    List<Map> maps = await db.rawQuery("select * from ${LocationEntry.tableName}");
    return maps;
  }

  ///根据一个参数查询数据库
  Future getLocationByOneColumn(String columnName, String key) async {
    List<Map> maps = await db.rawQuery("select * from ${LocationEntry.tableName} where $columnName = $key");
    return maps;
  }

  ///根据多个参数查询
  Future getLocationByColumns(List<String> columns, List<String> keys) async {
    String query = "select * from ${LocationEntry.tableName} where ";
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
  Future insert(Location bean) async {
    return await db.rawInsert("insert into ${LocationEntry.tableName} (${LocationEntry.columnName},${LocationEntry.columnPic}) values (?,?)", [
      bean.locationName,
      bean.pic
    ]);
  }

  ///更新数据库
  Future update(Location bean) async {
    return await db.rawUpdate(
        "update ${LocationEntry.tableName} set ${LocationEntry.columnName} = ${bean.locationName},${LocationEntry.columnPic} = ${bean.pic}  where ${LocationEntry.columnId} = ${bean.id}");
  }

  ///预加载分类信息
  initLocation() async {
    Map locationMap = {
      '书桌':'book_shelf',
      '衣柜':'wardrobe',
      '冰箱':'fridge',
    };
    try {
      locationMap.forEach((key, value)async {
        await db.rawInsert(
          "insert into ${LocationEntry.tableName} (${LocationEntry.columnName},${LocationEntry.columnPic}) values (?,?)",
          [
            key,
            value
          ],
        );
      });
    } catch (error) {
    }
  }
}
