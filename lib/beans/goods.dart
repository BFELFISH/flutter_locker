import 'dart:typed_data';

import 'package:locker/database/good_entry.dart';

import 'classification.dart';
import 'location_detial.dart';

class Good {
  int id;

  ///物品名称
  String name;

  ///购买日期
  String buyDate;

  ///过期日期
  String expDate;

  ///生产日期
  String prdDate;

  ///单价
  num price;

  ///数量
  int numOfGood;

  ///物品图片
  Uint8List pic;

  int locationId;

  ///物品位置(在数据库中记录的是id
  LocationDetail locationDetail;

  ///物品备注
  String remarks;

  ///提前提醒天数
  int warnDays;

  int classificationId;

  ///物品分类（在数据库中记录的是id
  Classification classification;

  static Map<String, String> columnToLabel = {
    GoodEntry.columnName: '物品名称',
    GoodEntry.columnLocation: '位置',
    GoodEntry.columnClassification: '分类',
    GoodEntry.columnBuyDate: '购买日期',
    GoodEntry.columnPrdDate: '生产日期',
    GoodEntry.columnExpDate: '有效期',
    GoodEntry.columnPrice: '单价',
    GoodEntry.columnNum: '数量',
    GoodEntry.columnRemarks: '备注',
    GoodEntry.columnWarnDays: '提前提醒天数',
  };

  Good(
      {this.id,
      this.name,
      this.buyDate,
      this.expDate,
      this.prdDate,
      this.price,
      this.numOfGood,
      this.pic,
      this.locationId,
      this.locationDetail,
      this.remarks,
      this.warnDays,
      this.classificationId,
      this.classification});

  Good.fromJsonMap(Map<String, dynamic> map)
      : id = map['${GoodEntry.columnId}'],
        name = map['${GoodEntry.columnName}'],
        buyDate = map['${GoodEntry.columnBuyDate}'],
        expDate = map['${GoodEntry.columnExpDate}'],
        prdDate = map['${GoodEntry.columnPrdDate}'],
        price = map['${GoodEntry.columnPrice}'],
        numOfGood = map['${GoodEntry.columnNum}'],
        pic = map['${GoodEntry.columnPic}'],
        locationId = map['${GoodEntry.columnLocation}'],
        remarks = map['${GoodEntry.columnRemarks}'],
        warnDays = map['${GoodEntry.columnWarnDays}'],
        classificationId = map['${GoodEntry.columnClassification}'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) {
      data['${GoodEntry.columnId}'] = id;
    }
    data['${GoodEntry.columnName}'] = name;
    data['${GoodEntry.columnBuyDate}'] = buyDate;
    if (expDate != null) {
      data['${GoodEntry.columnExpDate}'] = expDate;
    }
    data['${GoodEntry.columnPrdDate}'] = prdDate;
    data['${GoodEntry.columnPrice}'] = price;
    data['${GoodEntry.columnNum}'] = numOfGood;
    if (locationDetail != null) {
      data['${GoodEntry.columnLocation}'] = locationId;
    }
    data['${GoodEntry.columnRemarks}'] = remarks;
    data['${GoodEntry.columnWarnDays}'] = warnDays;
    if (classification != null) {
      data['${GoodEntry.columnClassification}'] = classification.id;
    }
    return data;
  }

  static bool isExp(String expDate) {
    if (expDate != null && expDate.isNotEmpty) {
      if (DateTime.parse(expDate + '00:00:00').difference(DateTime.now()).inDays < 0) {
        return true;
      }
    }
    return false;
  }

  static bool isAlmostExp(String expDate, int warnDays) {
    if (expDate != null && expDate.isNotEmpty) {
      ///已经过期的直接忽略,这时候exp - now < 0
      if (isExp(expDate)) {
        return false;
      } else {
        if (DateTime.parse(expDate + '00:00:00').difference(DateTime.now()).inDays > warnDays) {
          return false;
        }
      }
    }
    return true;
  }
}
