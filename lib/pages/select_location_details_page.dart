import 'package:flutter/cupertino.dart';
import 'package:locker/beans/location.dart';
import 'package:locker/beans/location_detial.dart';
import 'package:locker/widgets/location_detail_list_widget.dart';

class SelectLocationDetailPage extends StatelessWidget  {
  final Location location;
  final Function(LocationDetail locationDetail) tapItemCallBack;

  SelectLocationDetailPage(this.location, this.tapItemCallBack);

  @override
  Widget build(BuildContext context) {
    return LocationDetaiListlWidget(location,tapItemCallBack);
  }
}
