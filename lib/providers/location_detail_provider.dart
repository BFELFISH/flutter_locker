import 'package:flutter/cupertino.dart';
import 'package:locker/beans/location.dart';
import 'package:locker/beans/location_detial.dart';
import 'package:locker/config/page_status.dart';
import 'package:locker/database/good_entry.dart';
import 'package:locker/database/location_details_entry.dart';
import 'package:locker/database/location_details_table.dart';
import 'package:locker/providers/good_list_provider.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class LocationDetailProvider extends ChangeNotifier {
  final LocationDetailsTable _locationDetailsTable = LocationDetailsTable.getInstance();
  List<Map> locationDetails;

  PageStatus _pageStatus = PageStatus.loading;

  Future getLocationDetails(Location location) async {
    _pageStatus = PageStatus.loading;
    await _locationDetailsTable.openDb();
    locationDetails = await _locationDetailsTable.getLocationDetailsByOneColumn(LocationDetailsEntry.columnLocationId, location.id.toString());
    _pageStatus = getResultStatus(locationDetails);
  }

  PageStatus get pageStatus => _pageStatus;

  Future getLocationDetailById(int id) async {
    await _locationDetailsTable.openDb();
    return await _locationDetailsTable.getLocationDetailsByOneColumn(LocationDetailsEntry.columnId, id.toString());
  }

  Future addLocationDetail(LocationDetail locationDetail) async {
    await _locationDetailsTable.openDb();
    var result;
    try {
      result = await _locationDetailsTable.insert(locationDetail);
    } on DatabaseException catch (error) {
      ToastUtils.show('添加失败');
    }
    await getLocationDetails(locationDetail.location);
    refresh();
    return result;
  }

  Future deleteById(LocationDetail locationDetail, BuildContext context) async {
    await _locationDetailsTable.openDb();
    List<Map> result;
    var result2;
    try {
      GoodListProvider provider = Provider.of<GoodListProvider>(context, listen: false);

      ///根据locational detail 的id拿到相应物品列表
      await provider.getGoodByParam(GoodEntry.columnLocation, locationDetail.id.toString());
      result = provider.goodList;
      if (result != null) {
        result.forEach((element) async {
          await provider.deleteGoodById(element[GoodEntry.columnId]);
        });
        await provider.getAllGoodList();
        provider.refresh();
      }
      result2 = await _locationDetailsTable.delete(locationDetail.id);
    } on DatabaseException catch (error) {
      ToastUtils.show('删除失败');
    }
    await getLocationDetails(locationDetail.location);
    refresh();
    return result2;
  }

  Future updateLocationDetail(LocationDetail locationDetail) async {
    await _locationDetailsTable.openDb();
    var result;
    try {
      result = await _locationDetailsTable.update(locationDetail);
    } on DatabaseException catch (error) {
      ToastUtils.show('更新失败');
    }
    await getLocationDetails(locationDetail.location);
    refresh();
    return result;
  }

  refresh() {
    notifyListeners();
  }
}
