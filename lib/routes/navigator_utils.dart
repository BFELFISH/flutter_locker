import 'package:fluro/fluro.dart';
import 'package:locker/beans/goods.dart';
import 'package:locker/beans/location.dart';
import 'package:locker/database/location_entry.dart';
import 'package:locker/routes/routes.dart';

class NavigatorUtils {
  static toHome(context) {
    Routes.navigateTo(context, Routes.home, transitionDuration: Duration(milliseconds: 500), transitionType: TransitionType.fadeIn, replace: true);
  }

  static toAddGood(context,{Good good}) {
    Routes.navigateTo(context, Routes.addGood, transitionDuration: Duration(milliseconds: 500), transitionType: TransitionType.inFromRight,params: {

    });
  }

  static toSelectClass(context) async {
    return await Routes.navigateTo(context, Routes.selectClassPage, transitionDuration: Duration(milliseconds: 500));
  }

  static toSelectLocation(context) async {
    return await Routes.navigateTo(context, Routes.selectLocationPage, transitionDuration: Duration(milliseconds: 500));
  }

  static toAddClass(context) async {
    return await Routes.navigateTo(context, Routes.addClassPage, transitionDuration: Duration(milliseconds: 500));
  }

  static toAddLocation(context) async {
    return await Routes.navigateTo(context, Routes.addLocationPage, transitionDuration: Duration(milliseconds: 500));
  }

  static toManageClass(context) async {
    return await Routes.navigateTo(context, Routes.manageClassPage, transitionDuration: Duration(milliseconds: 500));
  }

  static toAddLocationDetail(context, Location location) async {
    return await Routes.navigateTo(context, Routes.addLocationDetailPage, transitionDuration: Duration(milliseconds: 500), params: {
      LocationEntry.columnId: location.id.toString(),
      LocationEntry.columnName: location.locationName,
      LocationEntry.columnPic: location.pic
    });
  }


}
