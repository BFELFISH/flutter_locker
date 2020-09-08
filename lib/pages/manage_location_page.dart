import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locker/beans/location.dart';
import 'package:locker/config/page_status.dart';
import 'package:locker/database/location_entry.dart';
import 'package:locker/providers/location_detail_provider.dart';
import 'package:locker/providers/location_provider.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/widgets/empty_widget.dart';
import 'package:locker/widgets/error_widget.dart';
import 'package:locker/widgets/loading_widget.dart';
import 'package:locker/widgets/manage_location_list_item_widget.dart';
import 'package:provider/provider.dart';

class ManageLocationPage extends StatefulWidget {
  @override
  _ManageLocationPageState createState() => _ManageLocationPageState();
}

class _ManageLocationPageState extends State<ManageLocationPage> {
  List<Map> locations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: pageBg)),
        child: Consumer<LocationProvider>(
          builder: (context , provider,child){
            return FutureBuilder(
              future: provider.getAllLocation(),
              builder: (context, snapShop) {
                if (snapShop.connectionState == ConnectionState.done) {
                  if (provider.pageStatus == PageStatus.success) {
                    locations = provider.list;
                    return _buildList();
                  } else if (PageStatus.empty == provider.pageStatus) {
                    return EmptyWidget();
                  } else if (PageStatus.error == provider.pageStatus) {
                    return CustomErrorWidget();
                  } else {
                    return LoadingWidget();
                  }
                } else {
                  return LoadingWidget();
                }
              },
            );
          },

        ),
      ),
    );
  }

  _buildList() {
    return ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return ManageLocationItemWidget(Location(
              id: locations[index][LocationEntry.columnId],
              locationName: locations[index][LocationEntry.columnName],
              pic: locations[index][LocationEntry.columnPic]));
        });
  }
}
