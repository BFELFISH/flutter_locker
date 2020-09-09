import 'package:flutter/cupertino.dart';
import 'package:locker/beans/goods.dart';
import 'package:locker/config/page_status.dart';
import 'package:locker/database/good_entry.dart';
import 'package:locker/database/good_table.dart';

class GoodListProvider extends ChangeNotifier {
  final String TAG = 'GoodListProvider';
  PageStatus _pageStatus = PageStatus.loading;

  GoodTable _goodTable = GoodTable.getInstance();
  List<Map> _goodList = [];
  Map<String, List> requestMap = {};

  ///排序指标
  SortType _sortType = SortType.remainDays;

  ///0 递增，1递减
  int _sort = 0;

  set sortType(SortType value) {
    _sortType = value;
    notifyListeners();
  }

  set sort(int value) {
    _sort = value;
    notifyListeners();
  }

  SortType get sortType => _sortType;

  List<Map> get goodList {
    if (_sortType != null) {
      switch (_sortType) {
        case SortType.remainDays:
          _goodList = Good.sortByDate(GoodEntry.columnExpDate, _sort, _goodList);
          break;
        case SortType.buyDate:
          _goodList = Good.sortByDate(GoodEntry.columnBuyDate, _sort, _goodList);
          break;
        case SortType.num:
          _goodList = Good.sortByNumOrPrice(GoodEntry.columnNum, _sort, _goodList);
          break;
        case SortType.price:
          _goodList = Good.sortByNumOrPrice(GoodEntry.columnPrice, _sort, _goodList);
          break;
      }
    }
    return _goodList;
  }

  Future getGoodList() async {
    if (requestMap.length == 0) {
      await getAllGoodList();
    } else {
      List<String> columns = [];
      List<String> values = [];
      requestMap.keys.forEach((keys) {
        requestMap[keys].forEach((element) {
          values.add(element);
          columns.add(keys);
        });
      });
      await getGoodByParams(columns, values);
    }
  }

  ///获取所有物品
  Future getAllGoodList() async {
    await _goodTable.openDb();
    _pageStatus = PageStatus.loading;
    List<Map> result = await _goodTable.getAllGood();
    _pageStatus = getResultStatus(result);
    _goodList = result;
  }

  ///根据参数获取物品列表
  Future getGoodByParams(List<String> columns, List<String> keys) async {
    await _goodTable.openDb();
    _pageStatus = PageStatus.loading;

    List<Map> result;
    if (columns.length == 1 && columns.contains(GoodEntry.columnName)) {
      result = await _goodTable.getGoodByName(keys[0]);
    } else if (columns.length == 1 && columns.contains('即将过期')) {
      result = await getAlmostExpGood();
    } else if (columns.length == 1 && columns.contains('已过期')) {
      result = await getExpGood();
    } else {
      result = await _goodTable.getGoodByColumns(columns, keys);
    }
    _pageStatus = getResultStatus(result);
    _goodList = result;
  }

  ///根据单个参数获取
  Future getGoodByParam(String columnName, String value) async {
    await _goodTable.openDb();
    _pageStatus = PageStatus.loading;
    List<Map> result = await _goodTable.getGoodByOneColumn(columnName, value);
    _pageStatus = getResultStatus(result);
    _goodList = result;
  }

  Future deleteGoodById(int id) async {
    await _goodTable.openDb();
    var result = await _goodTable.delete(id);
    await getAllGoodList();
    refresh();
    return result;
  }

  ///获取即将过期物品
  Future getAlmostExpGood() async {
    await _goodTable.openDb();
    List<Map> result = await _goodTable.getAllGood();
    List<Map> goods = [];

    ///将map转成goodlist
    result.forEach((element) {
      if (Good.isAlmostExp(element[GoodEntry.columnExpDate], element[GoodEntry.columnWarnDays])) {
        goods.add(element);
      }
    });
    return goods;
  }

  ///获取已过期物品
  Future getExpGood() async {
    await _goodTable.openDb();
    List<Map> result = await _goodTable.getAllGood();
    List<Map> goods = [];

    ///将map转成goodlist
    result.forEach((element) {
      if (Good.isExp(element[GoodEntry.columnExpDate])) {
        goods.add(element);
      }
    });
    return goods;
  }

  refresh() {
    notifyListeners();
  }

  PageStatus get pageStatus => _pageStatus;

  int get sort => _sort;
}

enum SortType {
  remainDays,
  num,
  price,
  buyDate,
}
