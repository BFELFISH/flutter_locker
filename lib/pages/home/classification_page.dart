import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locker/beans/classification.dart';
import 'package:locker/database/good_entry.dart';
import 'package:locker/utils/log_utils.dart';
import 'package:locker/utils/sc_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/views/ink_btn.dart';
import 'package:locker/widgets/good/good_list_widget.dart';

import 'file:///E:/flutterCodes/locker/locker/lib/widgets/classification/classification_list_widget.dart';

class ClassificationPage extends StatefulWidget {
  @override
  _ClassificationPageState createState() => _ClassificationPageState();
}

class _ClassificationPageState extends State<ClassificationPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: pageBg),
      ),
      child: Column(
        children: <Widget>[
          _dataStatistics(),
          _classificationList(),
        ],
      ),
    );
  }

  TextStyle dataStatisticsText = TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);

  _dataStatistics() {
    return Container(
      height: 80,
      margin: EdgeInsets.only(top: sc.statusHeight() + 10, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkBtn(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GoodListWidget(
                            false,
                            columns: ['已过期'],
                          )));
            },
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: editWidget2),
            child: Container(
              width: 150,
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
              child: Center(
                  child: Text(
                '已过期',
                style: dataStatisticsText,
              )),
            ),
          ),
          InkBtn(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GoodListWidget(
                            false,
                            columns: ['即将过期'],
                          )));
            },
            borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: pink2blue),
            child: Container(
                width: 150,
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                child: Center(
                    child: Text(
                  '即将过期',
                  style: dataStatisticsText,
                ))),
          )
        ],
      ),
    );
  }

  _classificationList() {
    return Expanded(
      child: ClassificationListWidget(_toGoodListOfClass),
    );
  }

  _toGoodListOfClass(BuildContext context, Classification classification) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GoodListWidget(
                  false,
                  columns: [GoodEntry.columnClassification],
                  values: [classification?.id.toString()],
                )));
  }
}
