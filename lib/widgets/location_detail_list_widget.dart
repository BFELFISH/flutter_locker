import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:locker/beans/location.dart';
import 'package:locker/beans/location_detial.dart';
import 'package:locker/config/page_status.dart';
import 'package:locker/database/location_details_entry.dart';
import 'package:locker/pages/add_location_detail_page.dart';
import 'package:locker/providers/location_detail_provider.dart';
import 'package:locker/routes/navigator_utils.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/views/ink_btn.dart';
import 'package:locker/widgets/empty_widget.dart';
import 'package:locker/widgets/error_widget.dart';
import 'package:locker/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class LocationDetaiListlWidget extends StatelessWidget {
  final Location location;
  final Function(LocationDetail locationDetail) tapItemCallBack;
  List<Map> locationDetails;

  LocationDetaiListlWidget(this.location, this.tapItemCallBack);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: pageBg)),
      child: Consumer<LocationDetailProvider>(
        builder: (context, provider, child) {
          return FutureBuilder(
              future: provider.getLocationDetails(location),
              builder: (context, snapShop) {
                if (snapShop.connectionState == ConnectionState.done) {
                  if (provider.pageStatus == PageStatus.success) {
                    locationDetails = provider.locationDetails;
                    return _buildList();
                  } else if (PageStatus.error == provider.pageStatus) {
                    return CustomErrorWidget();
                  } else {
                    locationDetails = provider.locationDetails;
                    return _buildList();
                  }
                } else
                  return LoadingWidget();
              });
        },
      ),
    );
  }

  _buildList() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 8, right: 8),
      child: AnimationLimiter(
        child: GridView.builder(
          itemCount: locationDetails.length + 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: locationDetails.length + 1,
              duration: const Duration(milliseconds: 250),
              child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: index == locationDetails.length
                        ? _addClassificationWidget(context)
                        : InkBtn(
                            onTap: () {
                              ///返回一个LocationDetail实例
                              tapItemCallBack(LocationDetail(
                                  id: locationDetails[index]['${LocationDetailsEntry.columnId}'],
                                  locationDetail: locationDetails[index]['${LocationDetailsEntry.columnName}'],
                                  location: location));
                            },
                            borderRadius: BorderRadius.circular(15),
                            color: pink_fbecec,
                            child: Center(
                              child: Text('${locationDetails[index]['${LocationDetailsEntry.columnName}']}'),
                            ),
                          ),
                  )),
            );
          },
        ),
      ),
    );
  }

  ///添加新的分类
  _addClassificationWidget(context) {
    return InkBtn(
      onTap: () {
        NavigatorUtils.toAddLocationDetail(context, location);
      },
      borderRadius: BorderRadius.circular(15),
      color: blue_d6e0f0,
      child: Container(
        width: 50,
        height: 50,
        child: Icon(
          Icons.add,
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }
}
