import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:locker/beans/location.dart';
import 'package:locker/beans/location_detial.dart';
import 'package:locker/config/page_status.dart';
import 'package:locker/pages/select_location_details_page.dart';
import 'package:locker/providers/location_provider.dart';
import 'package:locker/routes/navigator_utils.dart';
import 'package:locker/utils/assert_utils.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/views/ink_btn.dart';
import 'package:locker/widgets/empty_widget.dart';
import 'package:locker/widgets/error_widget.dart';
import 'package:locker/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class LocationListWidget extends StatefulWidget {
  final Function( LocationDetail detail) tapItemCallBack;

  LocationListWidget(this.tapItemCallBack);

  @override
  _LocationListWidgetState createState() => _LocationListWidgetState();
}

class _LocationListWidgetState extends State<LocationListWidget> {
  List<Map> locations;

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, provider, child) {
        if (provider.pageStatus == PageStatus.success && locations != null) {
          locations = provider.list;
          return _buildLocationList();
        } else {
          return FutureBuilder(
            future: provider.getAllLocation(),
            builder: (context, snapshop) {
              if (snapshop.connectionState == ConnectionState.done) {
                if (provider.pageStatus == PageStatus.success) {
                  locations = provider.list;
                  return _buildLocationList();
                } else if (PageStatus.empty == provider.pageStatus) {
                  return EmptyWidget();
                } else {
                  return CustomErrorWidget();
                }
              } else {
                return LoadingWidget();
              }
            },
          );
        }
      },
    );
  }

  _buildLocationList() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: pageBg)
      ),
      margin: EdgeInsets.only(top: 10, left: 8, right: 8),
      child: AnimationLimiter(
        child: GridView.builder(
          itemCount: locations.length + 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: locations.length + 1,
              duration: const Duration(milliseconds: 250),
              child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child:
                        index == locations.length ? _addClassificationWidget() : _buildLocationListItemWidget(Location.fromJsonMap(locations[index])),
                  )),
            );
          },
        ),
      ),
    );
  }

  ///添加新的分类
  _addClassificationWidget() {
    return InkBtn(
      onTap: () {
        NavigatorUtils.toAddLocation(context);
      },
      borderRadius: BorderRadius.circular(15),
      gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: details1),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: pink_ffe4e4,
                  offset: Offset(2.0,2.0),
                  blurRadius: 10.0
              )
            ]
        ),
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

  _buildLocationListItemWidget(Location location) {
    return InkBtn(
      onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectLocationDetailPage(location,widget.tapItemCallBack)));
      },
      gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: editWidget2),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: pink_ffe4e4,
                  offset: Offset(2.0,2.0),
                  blurRadius: 10.0
              )
            ]
        ),
        width: 100,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(image: AssetImage(AssertUtils.getAssertImagePath(location.pic)),width: 40,height: 40,),
            ),
            Text(
              '${location.locationName}',
              style: TextStyle(color: black_2d4059, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
