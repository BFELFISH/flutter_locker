import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locker/beans/location.dart';
import 'package:locker/beans/location_detial.dart';
import 'package:locker/providers/location_detail_provider.dart';
import 'package:locker/routes/navigator_utils.dart';
import 'package:locker/utils/assert_utils.dart';
import 'package:locker/utils/sc_utils.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/views/ink_btn.dart';
import 'package:provider/provider.dart';

class AddLocationDetailPage extends StatefulWidget {
  final Location location;

  AddLocationDetailPage(this.location);

  @override
  _AddLocationDetailPageState createState() => _AddLocationDetailPageState();
}

class _AddLocationDetailPageState extends State<AddLocationDetailPage> {
  TextEditingController _textEditingController = TextEditingController();

  TextStyle style = TextStyle(color: black_2d4059, fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          width: sc.screenWidth(),
          decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: pageBg)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      minRadius: 30,
                      maxRadius: 30,
                      backgroundColor: Colors.white,
                    ),
                    Image(
                      width: 80,
                      height: 80,
                      image: AssetImage(AssertUtils.getAssertImagePath(widget.location.pic)),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(left: 80, top: 20, bottom: 20),
                  child: Text(
                    '位置：${widget.location.locationName}',
                    style: style,
                  )),
              Container(
                padding: EdgeInsets.only(left: 80, top: 20, bottom: 70),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '位置详情：',
                      style: style,
                    ),
                    Container(
                      width: 150,
                      child: TextField(
                        maxLines: 1,
                        inputFormatters: [LengthLimitingTextInputFormatter(7)],
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: '请输入详细位置',
                          contentPadding: EdgeInsets.all(0.0),
                          enabledBorder: _inputBorder,
                          focusedBorder: _inputBorder,
                        ),
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
              Center(
                child: InkBtn(
                  onTap: () {
                    addLocationDetail();
                  },
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: details1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50),
                    child: Text(
                      '添加',
                      style: style,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  addLocationDetail() async {
    if (_textEditingController.text == null || _textEditingController.text.isEmpty) {
      ToastUtils.show('请输入位置详细信息');
    } else {
      LocationDetailProvider provider = Provider.of<LocationDetailProvider>(context, listen: false);
      var result = await provider.addLocationDetail(LocationDetail(locationDetail: _textEditingController.text, location: widget.location));
      if (result == null || result < 0) {
        ToastUtils.show('添加失败');
      } else {
        Future.delayed(Duration(milliseconds: 500)).whenComplete(() async {
          ToastUtils.show('添加成功');
          Navigator.of(context).pop();
        });
      }
    }
  }

  InputBorder _inputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
      width: 1,
    ),
  );
}
