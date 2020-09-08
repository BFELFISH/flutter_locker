import 'package:flutter/cupertino.dart';
import 'package:locker/beans/location.dart';
import 'package:locker/providers/location_provider.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:locker/widgets/add_class_or_location_widget.dart';
import 'package:provider/provider.dart';

class AddLocationPage extends StatefulWidget {
  final Location location;

  AddLocationPage({this.location});

  @override
  _AddLocationPageState createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  String selectedImage;

  TextEditingController _textEditingController;

  int selectedIndex = 0;

  List<String> iconName = [
    'cupboard',
    'bed',
    'bedside_table',
    'bedside_table2',
    'vanity_mirror',
    'fridge',
    'tv_table',
    'shelf',
    'shelf2',
    'dawer',
    'wine_cabinet',
    'coach',
    'box',
    'book_shelf',
    'study_table',
    'study_table2',
    'washbasin',
    'shoes_shelf',
    'wardrobe',
    'wardrobe2',
    'table',
  ];

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    if (widget.location != null) {
      selectedImage = widget.location.pic;
      selectedIndex = iconName.indexOf(widget.location.pic);
      _textEditingController.text = widget.location.locationName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AddClassOrLocationWidget(
      '位置',
      iconName,
      onTapCallBack,
      _textEditingController,
      selectedIndex: selectedIndex,
      selectedImage: selectedImage,
    );
  }

  onTapCallBack(selectedIndex) async {
    LocationProvider provider = Provider.of<LocationProvider>(context, listen: false);
    if (_textEditingController.text == null || _textEditingController.text.replaceAll(' ', '').length <= 0) {
      ToastUtils.show('请输入位置名称！');
    } else {
      var result;
      if (widget.location != null) {
        widget.location.pic = iconName[selectedIndex];
        widget.location.locationName = _textEditingController.text;
        result = await provider.updateLocation(widget.location);
      } else {
        result = await provider.addLocation(Location(locationName: _textEditingController.text, pic: iconName[selectedIndex]));
      }
      if (result != null || result > 0) {
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
