import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locker/beans/location.dart';
import 'package:locker/beans/location_detial.dart';
import 'package:locker/config/page_status.dart';
import 'package:locker/database/good_entry.dart';
import 'package:locker/providers/good_list_provider.dart';
import 'package:locker/providers/location_detail_provider.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/widgets/empty_widget.dart';
import 'package:locker/widgets/error_widget.dart';
import 'package:locker/widgets/good/good_list_widget.dart';
import 'package:locker/widgets/loading_widget.dart';
import 'package:locker/widgets/location_list_widget.dart';
import 'package:provider/provider.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  List<Map> locations;
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Builder(builder: (context) {
      return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: pageBg),
          ),
          child: LocationListWidget(_toGoodOfLocation));
    });
  }

  _toGoodOfLocation(LocationDetail location) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GoodListWidget(
                  false,
                  columns: [GoodEntry.columnLocation],
                  values: [location?.id.toString()],
                )));
  }
}
