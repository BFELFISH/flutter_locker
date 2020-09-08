import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locker/routes/navigator_utils.dart';
import 'package:locker/utils/log_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/values/icon.dart';

import 'file:///E:/flutterCodes/locker/locker/lib/pages/home/good_list_page.dart';
import 'file:///E:/flutterCodes/locker/locker/lib/pages/home/location_page.dart';
import 'file:///E:/flutterCodes/locker/locker/lib/pages/home/settings_page.dart';

import 'classification_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  final String TAG = 'Home_Page';

  ///具体数值看icons/bottomnavigator.html
  Map iconMap = {
    '主页': Icon(BottomNavigatorIcons.home),
    '位置': Icon(BottomNavigatorIcons.location),
    '分类': Icon(BottomNavigatorIcons.classification),
    '设置': Icon(BottomNavigatorIcons.setting),
  };

  ///页面列表
  List<Widget> _pages = [
    GoodListPage(),
    LocationPage(),
    ClassificationPage(),
    SettingsPage(),
  ];

  int _position = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    LogUtils.d(TAG, "key = ${widget.key}");
    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            NavigatorUtils.toAddGood(context);
          },
          backgroundColor: main_color,
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: pink_ffe4e4,
          iconSize: 20,
          type: BottomNavigationBarType.fixed,
          currentIndex: _position,
          selectedItemColor: main_color,
          unselectedItemColor: gray_838383,
          selectedLabelStyle: TextStyle(color: black_2d4059, fontSize: 12),
          unselectedLabelStyle: TextStyle(color: gray_dddddd, fontSize: 12),
          unselectedFontSize: 14,
          selectedFontSize: 14,
          items: iconMap.keys
              .map((key) => BottomNavigationBarItem(
                  title: Text(
                    key,
                  ),
                  icon: iconMap[key]))
              .toList(),
          showUnselectedLabels: true,
          onTap: (position) {
            setState(() {
              _position = position;
              _pageController.jumpToPage(position);
            });
          },
        ),
        body: _buildBody());
  }

  _buildBody() {
    return PageView.builder(
        itemCount: _pages.length,
        controller: _pageController,
        onPageChanged: (position) {
          setState(() {
            _position = position;
          });
        },
        itemBuilder: (context, position) => _pages[position]);
  }

  @override
  bool get wantKeepAlive => true;
}
