import 'package:flutter/cupertino.dart';
import 'package:locker/beans/classification.dart';
import 'package:locker/config/page_status.dart';
import 'package:locker/database/classification_entry.dart';
import 'package:locker/database/classification_table.dart';
import 'package:locker/database/good_entry.dart';
import 'package:locker/providers/good_list_provider.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:sqflite/sqflite.dart';

class ClassListProvider extends ChangeNotifier {
  final String TAG = 'ClassificationProvider';

  PageStatus _pageStatus = PageStatus.loading;
  List<Map> list = [];
  ClassificationTable _classificationTable = ClassificationTable.getInstance();

  PageStatus get pageStatus => _pageStatus;

  Future getAllClass() async {
    await _classificationTable.openDb();
    _pageStatus = PageStatus.loading;
    list = await _classificationTable.getClassification();
    _pageStatus = getResultStatus(list);
  }

  Future getClassById(int id) async {
    await _classificationTable.openDb();
    return await _classificationTable.getClassByOneColumn(ClassificationEntry.columnId, id.toString());
  }

  Future addClass(Classification classification) async {
    var result;
    await _classificationTable.openDb();
    try {
      result = await _classificationTable.insert(classification);
    } on DatabaseException catch (error) {
      ToastUtils.show('添加失败，该分类已存在');
    }
    await getAllClass();
    refresh();
    return result;
  }

  Future deleteClassById(int id, GoodListProvider provider) async {
    await _classificationTable.openDb();
    await _classificationTable.delete(id);

    await provider.getGoodByParam(GoodEntry.columnClassification, id.toString());
    List<Map> result = provider.goodList;
    if (result != null) {
      result.forEach((element) async {
        await provider.deleteGoodById(element[GoodEntry.columnId]);
      });
      await provider.getAllGoodList();
      provider.refresh();
    }
  }

  Future updateClass(Classification classification) async {
    await _classificationTable.openDb();
    var result = await _classificationTable.update(classification);
    await getAllClass();
    refresh();
    return result;
  }

  refresh() {
    notifyListeners();
  }
}
