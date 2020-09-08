import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:locker/utils/assert_utils.dart';
import 'package:locker/utils/log_utils.dart';
import 'package:locker/utils/sc_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/views/ink_btn.dart';
import 'package:locker/widgets/drawer_left_widget.dart';

import 'file:///E:/flutterCodes/locker/locker/lib/widgets/good/good_list_widget.dart';
import 'file:///E:/flutterCodes/locker/locker/lib/widgets/good/search_widget.dart';

class GoodListPage extends StatefulWidget {
  @override
  _GoodListPageState createState() => _GoodListPageState();
}

class _GoodListPageState extends State<GoodListPage> {
  final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();
  List<Map> goodList;

  @override
  Widget build(BuildContext context) {
    LogUtils.d('GoodListPage', "key = ${widget.key}");

    return InnerDrawer(
      key: _innerDrawerKey,
      swipe: false,
      rightChild: DrawerLeftWidget(_innerDrawerKey),
      scaffold: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: pageBg),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: sc.statusHeight() + 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(child: Container(child: Search())),
                      InkBtn(
                        onTap: () {
                          _innerDrawerKey.currentState.open();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(right: 20, left: 10),
                          child: Image(
                            width: 25,
                            color: main_color,
                            image: AssetImage(AssertUtils.getAssertImagePath('menu')),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: GoodListWidget(true))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
