import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locker/beans/classification.dart';
import 'package:locker/beans/goods.dart';
import 'package:locker/beans/location.dart';
import 'package:locker/beans/location_detial.dart';
import 'package:locker/pages/good_detail_page.dart';
import 'package:locker/providers/classification_list_provider.dart';
import 'package:locker/providers/good_list_provider.dart';
import 'package:locker/providers/location_detail_provider.dart';
import 'package:locker/providers/location_provider.dart';
import 'package:locker/utils/log_utils.dart';
import 'package:locker/utils/sc_utils.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/values/text_style.dart';
import 'package:locker/views/ink_btn.dart';
import 'file:///E:/flutterCodes/locker/locker/lib/widgets/good/long_press_good_item_dialog.dart';
import 'package:provider/provider.dart';

class GoodListItem extends StatelessWidget {
  ///物品实例
  final Good good;

  GoodListItem(this.good);

  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return InkBtn(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => GoodDetailPage(good)));
      },
      borderRadius: BorderRadius.circular(50),
      onLongPress: () async {
        var result = await showModalBottomSheet(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
            context: context,
            builder: (context) {
              return LongPressGoodItemDialog();
            });
        if (result != null) {
          if (result.toString() == 'delete') {
            await Provider.of<GoodListProvider>(context, listen: false).deleteGoodById(good.id);
          } else {
            ToastUtils.show('编辑');
          }
        }
      },
      child: Container(width: sc.screenWidth(), height: 180, child: good.pic != null ? _buildDetailsWithPhoto() : _buildDetailsNoPhoto()),
    );
  }

  _buildDetailsWithPhoto() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            width: sc.screenWidth() - sc.w(100),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: pink_ffe4e4,
                    offset: Offset(2.0, 2.0),
                    blurRadius: 10.0,
                  )
                ],
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: details1)),
            child: _buildDetails(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _buildPhoto(),
          )
        ],
      ),
    );
  }

  _buildDetailsNoPhoto() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: pink2blue)),
      child: Row(
        children: <Widget>[_buildDetails(), _buildDetails2()],
      ),
    );
  }

  ///如果有图片则显示图片
  _buildPhoto() {
    return Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: yellow_f6f4e6,
            offset: Offset(2.0, 2.0),
            blurRadius: 10.0,
          )
        ], borderRadius: BorderRadius.circular(15), gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: photo)),
        margin: EdgeInsets.only(left: 10, right: 10),
        padding: EdgeInsets.all(10),
        width: sc.w(120),
        height: sc.h(120),
        child: Image.memory(good.pic));
  }

  final TextStyle messageStyle = black_2d4059_14;

  ///详细内容
  _buildDetails() {
    return Container(
      margin: EdgeInsets.only(right: 20, top: 5, bottom: 5, left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildText('物品名称：' + good.name),
          _buildText('有效期：' + good.expDate),
          _buildLocation(),
          _buildClassification(),
          _buildValidDays(),
        ],
      ),
    );
  }

  ///没有图片时候的详细内容
  _buildDetails2() {
    return Container(
      margin: EdgeInsets.only(
        top: 5,
        bottom: 5,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          good.remarks == null || good.remarks.isEmpty ? Container() : _buildText('备注：' + good.remarks),
          good.numOfGood == null ? Container() : _buildText('数量：' + good.numOfGood.toString()),
          good.price == null ? Container() : _buildText('价格：' + good.price.toString()),
          good.buyDate == null ? Container() : _buildText('购买日期：' + good.buyDate),
          good.prdDate == null ? Container() : _buildText('生产日期：' + good.prdDate),
        ],
      ),
    );
  }

  _buildLocation() {
    if (good.locationId == null) {
      return Container();
    } else {
      return FutureBuilder(
        future: getGoodLocation(),
        builder: (context, snapShop) {
          if (snapShop.connectionState == ConnectionState.done) {
            return _buildText('位置：' + good.locationDetail.location.locationName + good.locationDetail.locationDetail);
          } else {
            return Container();
          }
        },
      );
    }
  }

  getGoodLocation() async {
    ///根据locationdetail先拿到location的id，再拿location
    if (good.locationDetail == null) {
      var result = await Provider.of<LocationDetailProvider>(context, listen: false).getLocationDetailById(good.locationId);
      List<Map> temp = result as List<Map>;
      good.locationDetail = LocationDetail.fromJson(temp[0]);
      result = await Provider.of<LocationProvider>(context, listen: false).getLocationById(good.locationDetail.locationId);
      temp = result as List<Map>;
      good.locationDetail.location = Location.fromJsonMap(temp[0]);
    }
  }

//
  _buildClassification() {
    if (good.classificationId == null) {
      return Container();
    } else {
      return FutureBuilder(
        future: getGoodClassification(),
        builder: (context, snapShop) {
          if (snapShop.connectionState == ConnectionState.done) {
            return _buildText('分类：' + good.classification.name);
          } else {
            return Container();
          }
        },
      );
    }
  }

  getGoodClassification() async {
    if (good.classification == null) {
      var result = await Provider.of<ClassListProvider>(context, listen: false).getClassById(good.classificationId);
      List<Map> temp = result as List<Map>;
      good.classification = Classification.fromJsonMap(temp[0]);
    }
  }

  ///计算剩余有效时间
  _buildValidDays() {
    int remainDays = DateTime.parse(good.expDate + '00:00:00').difference(DateTime.now()).inDays;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: <Widget>[
          Text(
            remainDays < 0 ? '已过期：' : '剩余有效时间：',
            style: remainDays >= 0 ? messageStyle : TextStyle(color: Colors.red),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${remainDays.abs()} 天',
            style: messageStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  _buildText(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        '$message',
        style: messageStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
