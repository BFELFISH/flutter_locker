import 'package:locker/database/location_entry.dart';

/***
 * 位置信息
 */
class Location {
  int id;

  ///位置名称(书柜等
  String locationName;
  String pic;


  Location({this.id, this.locationName, this.pic});

  Location.fromJsonMap(Map<String, dynamic> map)
      : id = map['${LocationEntry.columnId}'],
        pic = map['${LocationEntry.columnPic}'],
        locationName = map['${LocationEntry.columnName}'];
}
