import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:locker/config/page_status.dart';
import 'package:locker/database/classification_entry.dart';
import 'package:locker/database/good_entry.dart';
import 'package:locker/database/location_entry.dart';
import 'package:locker/providers/classification_list_provider.dart';
import 'package:locker/providers/location_provider.dart';
import 'package:locker/utils/assert_utils.dart';
import 'package:locker/utils/log_utils.dart';
import 'package:locker/utils/sc_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/views/ink_btn.dart';
import 'package:locker/widgets/error_widget.dart';
import 'package:locker/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

import 'check_item_widget.dart';

class DrawerLeftWidget extends StatefulWidget {
  final GlobalKey<InnerDrawerState> _innerDrawerKey;

  DrawerLeftWidget(this._innerDrawerKey);

  @override
  _DrawerLeftWidgetState createState() => _DrawerLeftWidgetState();
}

class _DrawerLeftWidgetState extends State<DrawerLeftWidget> {
  final List status = [
    '全部',
    '已过期',
    '即将过期',
    '未过期',
  ];

  List classification;

  List location;

  Map<String, CheckItem> statusMap = {};
  Map<String, CheckItem> classMap = {};
  Map<String, CheckItem> locationMap = {};

  @override
  void initState() {
    super.initState();
  }

  bool selectAllStatus = true;

  Function selectAllStatusFunc(selected, allTap) {
    if (allTap) {
      statusMap.forEach((key, value) {
        value.checked = selected;
        value.refresh();
      });
    } else {
      if (!selected) {
        statusMap['全部'].checked = false;
        statusMap['全部'].refresh();
      }
    }
    selectAllStatus = selected;
    //todo 调起加载loading获取数据
  }

  bool selectAllClass = true;

  Function selectAllClassFunc(selected, allTap) {
    if (allTap) {
      classMap.forEach((key, value) {
        value.checked = selected;
        value.refresh();
      });
    } else {
      if (!selected) {
        classMap['全部'].checked = false;
        classMap['全部'].refresh();
      }
    }

    selectAllClass = selected;
  }

  bool selectAllLocation = true;

  Function selectAllLocationFunc(selected, allTap) {
    if (allTap) {
      locationMap.forEach((key, value) {
        value.checked = selected;
        value.refresh();
      });
    } else {
      if (!selected) {
        locationMap['全部'].checked = false;
        locationMap['全部'].refresh();
      }
    }
    selectAllLocation = selected;
  }

  @override
  Widget build(BuildContext context) {
//    return Consumer2<ClassListProvider,LocationProvider>(
//      builder: (context,classProvider,locationProvider,child){
//        if(classification != null && classification.length >0 && location!=null &&location.length>0){
//          return _buildDrawer();
//        }else{
//          return FutureBuilder(
//            future: initList(classProvider,locationProvider),
//            builder: (context, snapshot){
//              if(snapshot.connectionState == ConnectionState.done){
//                if(classProvider.pageStatus == PageStatus.success && locationProvider.pageStatus == PageStatus.success){
//                  classification = [];
//                  classProvider.list.forEach((element) {
//                    classification.add(element['${ClassificationEntry.columnName}']);
//                  });
//                  location = [];
//                  locationProvider.list.forEach((element) {
//                    location .add(element['${LocationEntry.columnName}']);
//                  });
//                  return _buildDrawer();
//                }else if(classProvider.pageStatus == PageStatus.error || locationProvider.pageStatus == PageStatus.error){
//                  return CustomErrorWidget();
//                }else{
//                  return LoadingWidget();
//                }
//              }else
//                return LoadingWidget();
//            },
//          );
//        }
//      },
//    );
    return _buildDrawer();
  }

  Future initList(ClassListProvider classListProvider, LocationProvider locationProvider) async {
    await classListProvider.getAllClass();
    await locationProvider.getAllLocation();
  }

  _buildDrawer() {
    return SingleChildScrollView(
      child: Container(
        height: sc.screenHeight(),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: editWidget1)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildDate(),
//            _buildClassification(),
//            _buildLocation(),
            _buildButton()
          ],
        ),
      ),
    );
  }

  _buildDate() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 30),
          width: sc.screenWidth(),
          height: 100,
          decoration: BoxDecoration(
              color: yellow_ffe78f,
              boxShadow: [
                BoxShadow(
                  color: yellow_ffe78f,
                  offset: Offset(2.0, 2.0),
                  blurRadius: 10.0,
                )
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              )),
        ),
        Container(
          padding: EdgeInsets.only(
            top: 20,
            bottom: 20,
          ),
          margin: EdgeInsets.only(left: 40),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: pink_fbecec,
              offset: Offset(2.0, 2.0),
              blurRadius: 10.0,
            )
          ], color: pink_fbecec, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 5),
                child: Image(
                  width: 20,
                  height: 20,
                  image: AssetImage(AssertUtils.getAssertImagePath('calendar')),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 5),
                child: Text('状态'),
              ),
              Expanded(
                child: Wrap(
                  runSpacing: 0.0,
                  spacing: 8.0,
                  children: status.map((e) {
                    var value = statusMap[e] ?? CheckItem('status', e, selectAllStatusFunc);
                    if (statusMap[e] == null) statusMap[e] = value;
                    return value;
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

//  _buildClassification() {
//    return Row(
//      children: <Widget>[
//        Padding(
//          padding: const EdgeInsets.all(5.0),
//          child: Image(
//            width: 20,
//            height: 20,
//            image: AssetImage(AssertUtils.getAssertImagePath('classification')),
//          ),
//        ),
//        Container(
//          margin: EdgeInsets.only(right: 10),
//          child: Text('分类'),
//        ),
//        Expanded(
//          child: Wrap(
//            runSpacing: 0.0,
//            spacing: 8.0,
//            children: classification.map((e) {
//              var value = classMap[e] ?? CheckItem(GoodEntry.columnClassification,e, selectAllClassFunc);
//              if (classMap[e] == null) classMap[e] = value;
//              return value;
//            }).toList(),
//          ),
//        ),
//      ],
//    );
//  }
//
//  _buildLocation() {
//    LogUtils.d('left drawer ', 'build location');
//    return Row(
//      children: <Widget>[
//        Padding(
//          padding: const EdgeInsets.all(5.0),
//          child: Image(
//            width: 20,
//            height: 20,
//            image: AssetImage(AssertUtils.getAssertImagePath('location')),
//          ),
//        ),
//        Container(
//          margin: EdgeInsets.only(right: 10),
//          child: Text('位置'),
//        ),
//        Expanded(
//          child: Wrap(
//            runSpacing: 0.0,
//            spacing: 8.0,
//            children: location.map((e) {
//              var value = locationMap[e] ?? CheckItem(GoodEntry.columnLocation,e, selectAllLocationFunc);
//              if (locationMap[e] == null) {
//                locationMap[e] = value;
//              }
//              return value;
//            }).toList(),
//          ),
//        ),
//      ],
//    );
//  }

  _buildButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkBtn(
            onTap: () {
              selectAllStatusFunc(true, true);
//              selectAllClassFunc(false, true);
//              selectAllLocationFunc(false, true);
            },
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [blue_f1f3f8, blue_d6e0f0]),
            borderRadius: BorderRadius.circular(50),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: Text('重置'),
            ),
          ),
          InkBtn(
            onTap: () {
              widget._innerDrawerKey?.currentState.close();
            },
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [blue_f1f3f8, blue_d6e0f0]),
            borderRadius: BorderRadius.circular(50),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: Text('确定'),
            ),
          )
        ],
      ),
    );
  }
}
