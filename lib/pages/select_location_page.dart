import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locker/beans/location_detial.dart';
import 'package:locker/routes/navigator_utils.dart';
import 'package:locker/utils/toast_utils.dart';
import 'file:///E:/flutterCodes/locker/locker/lib/widgets/classification/classification_list_widget.dart';
import 'package:locker/widgets/location_list_widget.dart';

class SelectLocationPage extends StatelessWidget {
  SelectLocationPage();

  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
      color: Colors.white,
      child: LocationListWidget(_returnResult),
    );
  }

  _returnResult(LocationDetail detail) {
    Navigator.of(context).pop(detail);
    Navigator.of(context).pop(detail);
  }
}
