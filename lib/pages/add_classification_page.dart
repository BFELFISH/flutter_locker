import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locker/beans/classification.dart';
import 'package:locker/providers/classification_list_provider.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:locker/widgets/add_class_or_location_widget.dart';
import 'package:provider/provider.dart';

class AddClassPage extends StatefulWidget {
  final Classification classification;

  AddClassPage({this.classification});

  @override
  _AddClassPageState createState() => _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {
  String selectedImage;
  TextEditingController _textEditingController;

  int selectedIndex = 0;

  List<String> iconName = [
    'bottle',
    'clothes',
    'coffee',
    'flower',
    'game',
    'jewelry',
    'juice',
    'key',
    'letter',
    'lipstick',
    'make_up',
    'mask',
    'medicine',
    'pen',
    'photo_shop',
    'science',
    'shoes',
    'sport',
    'watch',
    'skirt',
    'snack',
    'sunglasses',
    'diploma',
    'coupon',
    'book',
  ];

  @override
  void initState() {
    _textEditingController = TextEditingController();
    if (widget.classification != null) {
      selectedImage = widget.classification.pic;
      selectedIndex = iconName.indexOf(widget.classification.pic);
      _textEditingController.text = widget.classification.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('test build selectimage ${selectedIndex}');

    return AddClassOrLocationWidget(
      '分类',
      iconName,
      onTapCallBack,
      _textEditingController,
      selectedImage: selectedImage,
      selectedIndex: selectedIndex,
    );
  }

  onTapCallBack(selectedIndex) async {
    ClassListProvider provider = Provider.of<ClassListProvider>(context, listen: false);
    if (_textEditingController.text == null || _textEditingController.text.replaceAll(' ', '').length <= 0) {
      ToastUtils.show('请输入分类名称！');
    } else {
      var result;
      if (widget.classification == null) {
        result = await provider.addClass(Classification(name: _textEditingController.text, pic: iconName[selectedIndex]));
      } else {
        widget.classification.name = _textEditingController.text;
        widget.classification.pic = iconName[selectedIndex];
        result = await provider.updateClass(widget.classification);
      }
      if (result > 0) {
        Future.delayed(Duration(milliseconds: 500)).whenComplete(() async {
          ToastUtils.show('添加成功');
          Navigator.of(context).pop();
        });
      } else {
        ToastUtils.show('添加失败');
      }
    }
  }
}
