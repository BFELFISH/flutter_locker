import 'package:locker/beans/location.dart';
import 'package:locker/database/location_details_entry.dart';
import 'package:locker/database/location_entry.dart';

class LocationDetail{
  int id;
  int locationId;
  Location location;
  ///位置详情(例如第几格
  String locationDetail;

  LocationDetail({this.id, this.location, this.locationDetail});

  LocationDetail.fromJson(Map<String,dynamic> map)
      : id = map[LocationDetailsEntry.columnId],
        locationId = map[LocationDetailsEntry.columnLocationId],
        locationDetail = map[LocationDetailsEntry.columnName];


}