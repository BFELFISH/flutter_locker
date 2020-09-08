import 'package:flutter/cupertino.dart';
import 'package:locker/beans/location.dart';
import 'package:locker/beans/location_detial.dart';
import 'package:locker/config/page_status.dart';
import 'package:locker/database/location_entry.dart';
import 'package:locker/database/location_table.dart';
import 'package:locker/providers/location_detail_provider.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class LocationProvider extends ChangeNotifier {
  final String TAG = 'LocationProvider';

  PageStatus _pageStatus = PageStatus.loading;
  List<Map> list;
  LocationTable _locationTable = LocationTable.getInstance();

  PageStatus get pageStatus => _pageStatus;

  Future getAllLocation() async {
    await _locationTable.openDb();
    _pageStatus = PageStatus.loading;
    list = await _locationTable.getAllLocation();
    _pageStatus = getResultStatus(list);
  }

  Future getLocationById(int id) async {
    await _locationTable.openDb();
    List<Map> result = await _locationTable.getLocationByOneColumn(LocationEntry.columnId, id.toString());
    return result;
  }

  Future addLocation(Location location) async {
    await _locationTable.openDb();
    var result;
    try {
      result = await _locationTable.insert(location);
    } on DatabaseException catch (error) {
      ToastUtils.show('添加失败，该位置已存在');
    }
    await getAllLocation();
    refresh();
    return result;
  }

  Future deleteById(Location location, BuildContext context) async {
    await _locationTable.openDb();
    List<Map> result;
    var result2;
    try {
      LocationDetailProvider provider = Provider.of<LocationDetailProvider>(context, listen: false);

      ///删除对应的所有子位置
      await provider.getLocationDetails(location).whenComplete(() {
        result = provider.locationDetails;
        result.forEach((element) async{
        await  provider.deleteById(LocationDetail(id: element[LocationEntry.columnId], location: location), context);
        });
      });
      result2 = await _locationTable.delete(location.id);
    } on DatabaseException catch (error) {
      ToastUtils.show('删除失败，该位置不存在！');
    }
    await getAllLocation();
    refresh();
    return result2;
  }

  Future updateLocation(Location location)async{
    await _locationTable.openDb();
    var result = await _locationTable.update(location);
    await getAllLocation();
    refresh();
    return result;
  }

  refresh() {
    notifyListeners();
  }
}
