import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locker/beans/goods.dart';
import 'package:locker/providers/good_list_provider.dart';
import 'package:locker/utils/assert_utils.dart';
import 'package:locker/utils/sc_utils.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/views/custom_dialog.dart';
import 'package:locker/views/ink_btn.dart';
import 'package:provider/provider.dart';

class GoodDetailPage extends StatelessWidget {
  final Good good;
  BuildContext context;

  GoodDetailPage(this.good);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
      padding: EdgeInsets.only(top: sc.statusHeight()),
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: pageBg)),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: ScrollController(),
        child: Container(
          margin: EdgeInsets.only(bottom: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildPhoto(),
              _buildDetails1('物品名称', good.name),
              _buildDetails1('购买日期', good.buyDate),
              _buildDetails1('有效期', good.expDate),
              _buildDetails1('生产日期', good.prdDate),
              _buildClassification(),
              _buildLocation(),
              _buildDetails1('单价', good.price),
              _buildDetails1('数量', good.numOfGood),
              _buildDetails1('备注', good.remarks),
              _buildDetails1('提前提醒天数', good.warnDays),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  bool isPink = false;

  _buildClassification() {
    if (good.classification == null) {
      return Container();
    } else {
      return _buildDetails1('分类', good.classification.name);
    }
  }

  _buildLocation() {
    if (good.locationDetail == null) {
      return Container();
    } else {
      return _buildDetails1('位置', good.locationDetail.location?.locationName + good.locationDetail.locationDetail);
    }
  }

  _buildPhoto() {
    return Visibility(
      visible: good.pic != null,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: photo)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: sc.screenWidth(),
        height: 200,
        child: good.pic != null ? Image.memory(good.pic) : Container(),
      ),
    );
  }

  TextStyle detailsStyle = TextStyle(color: gray_838383, fontSize: 14, decoration: TextDecoration.none);

  _buildDetails1(String tag, dynamic value) {
    isPink = !isPink;
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      padding: EdgeInsets.only(top: 20, bottom: 20, right: 5, left: 10),
      width: isPink ? sc.screenWidth() * 5 / 6 : sc.screenWidth() * 3 / 4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: isPink ? good_details1 : good_details2)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            tag + '：',
            style: detailsStyle,
          ),
          Text(value == null || (value is String && value.isEmpty) ? '未填写' : value.toString(), style: detailsStyle)
        ],
      ),
    );
  }

  double imageSize = 30;

  _buildButtons() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkBtn(
            onTap: () {
              //Navigator.push(context,MaterialPageRoute(builder: (context)=>AddGoodPage(good: good,)));
            },
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: details1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
                    child: Image(
                      width: imageSize,
                      image: AssetImage(AssertUtils.getAssertImagePath('edit')),
                    ),
                  ),
                  Text(
                    '编辑',
                    style: detailsStyle,
                  ),
                ],
              ),
            ),
          ),
          InkBtn(
            onTap: () async {
              showCustomWarningDialog(context, '是否删除此物品?', () async {
                var result = await Provider.of<GoodListProvider>(context, listen: false).deleteGoodById(good.id);
                Future.delayed(Duration(milliseconds: 500)).whenComplete(() {
                  ToastUtils.show('删除成功');
                  Navigator.of(context).pop();
                });
              });
            },
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: details1),
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
                    child: Image(
                      width: imageSize,
                      image: AssetImage(AssertUtils.getAssertImagePath('delete')),
                    ),
                  ),
                  Text(
                    '删除',
                    style: detailsStyle,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
