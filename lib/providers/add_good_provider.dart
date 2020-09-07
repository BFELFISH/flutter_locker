import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:locker/beans/classification.dart';
import 'package:locker/beans/goods.dart';
import 'package:locker/beans/location_detial.dart';
import 'package:locker/database/good_entry.dart';
import 'package:locker/database/good_table.dart';
import 'package:locker/providers/good_list_provider.dart';
import 'package:locker/utils/log_utils.dart';
import 'package:locker/utils/sp_utils.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:locker/values/key.dart';
import 'package:provider/provider.dart';

class AddGoodProvider extends ChangeNotifier {
  final String TAG = 'AddGoodProvider';

  ///编辑中的label对应的value
  Map<String, dynamic> editValue = {};

  File goodPic;
  Uint8List goodPicByte;
  GoodTable _goodTable = GoodTable.getInstance();
  int goodId;

  Future addGood(BuildContext context, Function(bool succeed, String mes) callback) async {
    if (!checkData(callback)) {
      return;
    }
    _goodTable.openDb();
    Good good = Good();
    await buildGood(good);
    var result;
    if (goodId != null) {
      result = await _goodTable.update(good);
    } else {
      result = await _goodTable.insert(good);
    }
    if (result > 0) {
      await Provider.of<GoodListProvider>(context, listen: false).getAllGoodList();
      Provider.of<GoodListProvider>(context, listen: false).refresh();
      goodPic = null;
      editValue = {};
      if (goodId != null) {
        goodId = null;
      }

      callback(true, '添加成功');
    } else {
      print('test build $result $goodId');
      callback(false, '添加失败了');
    }
  }

  ///根据数据生成相应实体
  buildGood(Good good) async {
    if (goodId != null) {
      good.id = goodId;
    }
    good.name = editValue[Good.columnToLabel[GoodEntry.columnName]];
    good.buyDate = editValue[Good.columnToLabel[GoodEntry.columnBuyDate]];
    good.expDate = editValue[Good.columnToLabel[GoodEntry.columnExpDate]];
    good.prdDate = editValue[Good.columnToLabel[GoodEntry.columnPrdDate]];
    if (goodPic != null) {
      good.pic = await goodPic.readAsBytes();
    } else if (goodPicByte != null) {
      good.pic = goodPicByte;
    }
    if (editValue[Good.columnToLabel[GoodEntry.columnPrice]].toString().isNotEmpty) {
      good.price = double.parse(editValue[Good.columnToLabel[GoodEntry.columnPrice]].toString());
    }
    if (editValue[Good.columnToLabel[GoodEntry.columnNum]].toString().isNotEmpty) {
      good.numOfGood = int.parse(editValue[Good.columnToLabel[GoodEntry.columnNum]].toString());
    }
    if (editValue[Good.columnToLabel[GoodEntry.columnLocation]] != null &&
        editValue[Good.columnToLabel[GoodEntry.columnLocation]].toString().isNotEmpty) {
      good.locationId = int.parse(editValue[Good.columnToLabel[GoodEntry.columnLocation]].toString());
      good.locationDetail = LocationDetail(id: good.locationId);
    }
    if (editValue[Good.columnToLabel[GoodEntry.columnClassification]] != null &&
        editValue[Good.columnToLabel[GoodEntry.columnClassification]].toString().isNotEmpty) {
      good.classification = Classification(id: int.parse(editValue[Good.columnToLabel[GoodEntry.columnClassification]].toString()));
    }
    good.remarks = editValue[Good.columnToLabel[GoodEntry.columnRemarks]];
    good.warnDays = int.parse(editValue[Good.columnToLabel[GoodEntry.columnWarnDays]].toString()) ?? await SpUtils.getInt(WARN_DAY_KEY) ?? 15;
  }

  ///检查数据
  checkData(Function(bool succeed, String mes) callback) {
    ///生产日期不得晚于过期日期
    DateTime prdDate = DateTime.parse(editValue[Good.columnToLabel[GoodEntry.columnPrdDate]] + '00:00:00');
    DateTime expDate = DateTime.parse(editValue[Good.columnToLabel[GoodEntry.columnExpDate]] + '00:00:00');
    if (prdDate.isAfter(expDate)) {
      callback(false, '生产日期不得晚于有效期');
      return false;
    }

    ///数量只能为整型
    try {
      if (editValue[Good.columnToLabel[GoodEntry.columnNum]].toString().isNotEmpty) {
        editValue[Good.columnToLabel[GoodEntry.columnNum]] = int.parse(editValue[Good.columnToLabel[GoodEntry.columnNum]].toString());
      }
    } catch (error) {
      callback(false, '请输入正确的数量');
      return false;
    }

    ///价格只能为数字
    try {
      if (editValue[Good.columnToLabel[GoodEntry.columnPrice]].toString().isNotEmpty) {
        editValue[Good.columnToLabel[GoodEntry.columnPrice]] = double.parse(editValue[Good.columnToLabel[GoodEntry.columnPrice]].toString());
      }
    } catch (error) {
      callback(false, '请输入正确的价格');
      return false;
    }

    ///提醒天数为数字
    try {
      if (editValue[Good.columnToLabel[GoodEntry.columnWarnDays]].toString().isNotEmpty) {
        editValue[Good.columnToLabel[GoodEntry.columnWarnDays]] = int.parse(editValue[Good.columnToLabel[GoodEntry.columnWarnDays]].toString());
      }
    } catch (error) {
      callback(false, '请输入正确的提前提醒天数');
      return false;
    }

    ///物品名称不能为空
    if (editValue[Good.columnToLabel[GoodEntry.columnName]] != null && editValue[Good.columnToLabel[GoodEntry.columnName]].toString().isEmpty) {
      callback(false, '请输入物品名称');
      return false;
    }
    return true;
  }
}
