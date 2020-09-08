import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:locker/beans/location.dart';
import 'package:locker/beans/location_detial.dart';
import 'package:locker/config/page_status.dart';
import 'package:locker/database/location_details_entry.dart';
import 'package:locker/pages/add_location_detail_page.dart';
import 'package:locker/pages/add_location_page.dart';
import 'package:locker/providers/location_detail_provider.dart';
import 'package:locker/providers/location_provider.dart';
import 'package:locker/utils/assert_utils.dart';
import 'package:locker/utils/sc_utils.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/views/custom_dialog.dart';
import 'package:locker/views/expanded_triangle_icon.dart';
import 'package:locker/widgets/empty_widget.dart';
import 'package:locker/widgets/error_widget.dart';
import 'package:locker/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class ManageLocationItemWidget extends StatefulWidget {
  final Location location;

  ManageLocationItemWidget(this.location);

  @override
  _ManageLocationItemWidgetState createState() => _ManageLocationItemWidgetState();
}

class _ManageLocationItemWidgetState extends State<ManageLocationItemWidget> {
  bool _expanded = false;
  List<Map> locationDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 50,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildLocationItem(),
          _buildLocationDetailList(),
        ],
      ),
    );
  }

  ///位置item
  _buildLocationItem() {
    return Slidable(
      controller: SlidableController(),
      actionPane: SlidableDrawerActionPane(),
      child: Container(
          height: 50,
          decoration: BoxDecoration(border: Border.all(color: gray_e5e5e5)),
          padding: EdgeInsets.only(
            left: 10.0,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(
                      width: 50,
                      image: AssetImage(AssertUtils.getAssertImagePath(widget.location.pic)),
                    ),
                  ),
                  Text(
                    widget.location.locationName,
                    style: TextStyle(color: black_2d4059, fontSize: 18, decoration: TextDecoration.none),
                  ),
                ],
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: ExpandTriangleIcon(
                      isExpanded: _expanded,
                      onPressed: (value) {
                        setState(() {
                          _expanded = !_expanded;
                        });
                      },
                      icon: Image(
                        image: AssetImage(AssertUtils.getAssertImagePath('expanded')),
                      ),
                      height: 30,
                      width: 30,
                    ),
                  ))
            ],
          )),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: '编辑',
          icon: Icons.edit,
          color: main_color,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddLocationPage(
                          location: widget.location,
                        )));
          },
        ),
        IconSlideAction(
          caption: '删除',
          icon: Icons.delete,
          color: main_color,
          onTap: () async {
            showCustomWarningDialog(context, '是否删除此位置?\n注意！该操作会删除此位置下的所有位置详情及其物品！', () async {
              Provider.of<LocationProvider>(context, listen: false).deleteById(widget.location, context).whenComplete(() {
                ToastUtils.show('删除成功');
              });
            });
          },
        )
      ],
    );
  }

  ///位置下的详细位置
  _buildLocationDetailList() {
    return Visibility(
      visible: _expanded,
      child: Consumer<LocationDetailProvider>(
        builder: (context, provider, child) {
          return FutureBuilder(
            future: provider.getLocationDetails(widget.location),
            builder: (context, snapShop) {
              if (snapShop.connectionState == ConnectionState.done) {
                if (provider.pageStatus == PageStatus.success) {
                  locationDetails = provider.locationDetails;
                  return locationDetails == null || locationDetails.length == 0
                      ? Container()
                      : Container(
                          constraints: BoxConstraints(maxHeight: 50.0 * locationDetails.length),
                          child: ListView.builder(
                              itemCount: locationDetails.length,
                              itemBuilder: (context, index) {
                                return _buildLocationDetailItem(LocationDetail(
                                    id: locationDetails[index][LocationDetailsEntry.columnId],
                                    location: widget.location,
                                    locationDetail: locationDetails[index][LocationDetailsEntry.columnName]));
                              }),
                        );
                } else if (PageStatus.error == provider.pageStatus) {
                  return CustomErrorWidget();
                } else if (PageStatus.empty == provider.pageStatus) {
                  return EmptyWidget();
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  _buildLocationDetailItem(LocationDetail locationDetail) {
    return Slidable(
      controller: SlidableController(),
      actionPane: SlidableDrawerActionPane(),
      child: Container(
        color: blue_f1f3f8,
        width: sc.screenWidth(),
        height: 50,
        padding: EdgeInsets.only(left: 60),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(locationDetail.locationDetail),
          ],
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: '编辑',
          icon: Icons.edit,
          color: main_color,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddLocationDetailPage(
                          widget.location,
                          locationDetail: locationDetail,
                        )));
          },
        ),
        IconSlideAction(
          caption: '删除',
          icon: Icons.delete,
          color: main_color,
          onTap: () async {
            showCustomWarningDialog(context, '是否删除此位置?\n注意！该操作会删除此位置下的所有物品！', () async {
              Provider.of<LocationDetailProvider>(context, listen: false).deleteById(locationDetail, context).whenComplete(() {
                ToastUtils.show('删除成功');
              });
            });
          },
        )
      ],
    );
  }
}
