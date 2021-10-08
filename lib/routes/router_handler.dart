import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:locker/beans/location.dart';
import 'package:locker/database/location_entry.dart';
import 'package:locker/pages/add_classification_page.dart';
import 'package:locker/pages/add_good_page.dart';
import 'package:locker/pages/add_location_detail_page.dart';
import 'package:locker/pages/add_location_page.dart';
import 'package:locker/pages/home/home_page.dart';
import 'package:locker/pages/home/splash_page.dart';
import 'package:locker/pages/manage_class_page.dart';
import 'package:locker/pages/manage_location_page.dart';
import 'package:locker/pages/password_page.dart';
import 'package:locker/pages/select_class_page.dart';
import 'package:locker/pages/select_location_details_page.dart';
import 'package:locker/pages/select_location_page.dart';
import 'package:locker/utils/log_utils.dart';

class RouterHandler {
  static var rootHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return SplashPage();
  });
  static var homeHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return HomePage();
  });
  static var addGoodHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return AddGoodPage();
  });
  static var selectClassHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return SelectClassPage();
  });
  static var selectLocationHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return SelectLocationPage();
  });
  static var selectLocationDetailHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {});
  static var addClassHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return AddClassPage();
  });
  static var addLocationHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return AddLocationPage();
  });
  static var addLocationDetailHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return AddLocationDetailPage(Location(
        id: int.parse(params[LocationEntry.columnId].first),
        locationName: params[LocationEntry.columnName].first,
        pic: params[LocationEntry.columnPic].first));
  });
  static var manageClassHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return ManageClassPage();
  });
  static var manageLocationHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return ManageLocationPage();
  });
  static var passwrodPageHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return PasswordPage();
  });
}
