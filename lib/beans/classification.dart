
import 'package:locker/database/classification_entry.dart';

class Classification{
  int id;
  ///分类名称
  String name;
  ///分类图标
  String pic;

  Classification({this.id,this.name,this.pic});

  Classification.fromJsonMap(Map<String, dynamic> map)
      : id = map['${ClassificationEntry.columnId}'],
       name = map['${ClassificationEntry.columnName}'],
       pic = map['${ClassificationEntry.columnPic}'];

}