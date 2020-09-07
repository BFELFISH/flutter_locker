import 'package:flutter/cupertino.dart';
import 'package:locker/beans/location.dart';
import 'package:locker/beans/location_detial.dart';
import 'package:locker/config/page_status.dart';
import 'package:locker/database/location_details_entry.dart';
import 'package:locker/database/location_details_table.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:sqflite/sqflite.dart';

class LocationDetailProvider extends ChangeNotifier{
  final LocationDetailsTable _locationDetailsTable = LocationDetailsTable.getInstance();
  List<Map> locationDetails;

  PageStatus _pageStatus = PageStatus.loading;
  Future getLocationDetails(Location location)async{
    _pageStatus = PageStatus.loading;
    await _locationDetailsTable.openDb();
    locationDetails = await _locationDetailsTable.getLocationDetailsByOneColumn(LocationDetailsEntry.columnLocationId, location.id.toString());
    _pageStatus = getResultStatus(locationDetails);
  }

  PageStatus get pageStatus => _pageStatus;


  Future getLocationDetailById(int id)async{
    await _locationDetailsTable.openDb();
    return await _locationDetailsTable.getLocationDetailsByOneColumn(LocationDetailsEntry.columnId, id.toString());
  }

  Future addLocationDetail(LocationDetail locationDetail)async{
    await _locationDetailsTable.openDb();
    var result ;
    try{
      result = await _locationDetailsTable.insert(locationDetail);
    }on DatabaseException catch (error){
      ToastUtils.show('添加失败');
    }
    await getLocationDetails(locationDetail.location);
    refresh();
    return result;
  }



  refresh(){
    notifyListeners();
  }

}