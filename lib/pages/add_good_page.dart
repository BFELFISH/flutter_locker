import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locker/beans/goods.dart';
import 'package:locker/database/good_entry.dart';
import 'package:locker/providers/add_good_provider.dart';
import 'package:locker/utils/assert_utils.dart';
import 'package:locker/utils/sc_utils.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/views/ink_btn.dart';
import 'package:locker/widgets/add_good/add_photo_dialog_widget.dart';
import 'package:locker/widgets/add_good/edit_widget.dart';
import 'package:locker/widgets/add_good/select_widget.dart';
import 'package:provider/provider.dart';

class AddGoodPage extends StatefulWidget {
  Good good;

  AddGoodPage({this.good});

  @override
  _AddGoodPageState createState() => _AddGoodPageState();
}

class _AddGoodPageState extends State<AddGoodPage> {
  ScrollController _controller;
  final Map<String, InputType> inputContent = {
    Good.columnToLabel[GoodEntry.columnName]: InputType.text,
    Good.columnToLabel[GoodEntry.columnLocation]: InputType.select,
    Good.columnToLabel[GoodEntry.columnClassification]: InputType.select,
    Good.columnToLabel[GoodEntry.columnBuyDate]: InputType.date,
    Good.columnToLabel[GoodEntry.columnPrdDate]: InputType.date,
    Good.columnToLabel[GoodEntry.columnExpDate]: InputType.date,
    '有效天数': InputType.int,
    Good.columnToLabel[GoodEntry.columnPrice]: InputType.double,
    Good.columnToLabel[GoodEntry.columnNum]: InputType.int,
    Good.columnToLabel[GoodEntry.columnRemarks]: InputType.text,
    Good.columnToLabel[GoodEntry.columnWarnDays]: InputType.int,
  };
  AddGoodProvider provider;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    provider = Provider.of<AddGoodProvider>(context, listen: false);
    if (widget.good != null) {
      provider.goodId = widget.good.id;
      provider.editValue[Good.columnToLabel[GoodEntry.columnId]] = widget.good.id.toString();
      provider.editValue[Good.columnToLabel[GoodEntry.columnName]] = widget.good.name.toString();
      provider.editValue[Good.columnToLabel[GoodEntry.columnBuyDate]] = widget.good.buyDate;
      provider.editValue[Good.columnToLabel[GoodEntry.columnExpDate]] = widget.good.expDate;
      provider.editValue[Good.columnToLabel[GoodEntry.columnPrdDate]] = widget.good.prdDate;
      provider.editValue[Good.columnToLabel[GoodEntry.columnPrice]] = widget.good.price?.toString();
      provider.editValue[Good.columnToLabel[GoodEntry.columnNum]] = widget.good.numOfGood?.toString();
      provider.goodPicByte = widget.good?.pic;
      if (widget.good.pic != null) {
        goodPhotoImage = Image.memory(widget.good?.pic);
      }
      if (widget.good.locationDetail != null) {
        provider.editValue[Good.columnToLabel[GoodEntry.columnLocation] + 'id'] = widget.good.locationDetail.id;
        provider.editValue[Good.columnToLabel[GoodEntry.columnLocation]] =
            widget.good.locationDetail.location.locationName + widget.good?.locationDetail.locationDetail;
      }
      provider.editValue[Good.columnToLabel[GoodEntry.columnRemarks]] = widget.good.remarks;
      provider.editValue[Good.columnToLabel[GoodEntry.columnWarnDays]] = widget.good.warnDays?.toString();
      provider.editValue[Good.columnToLabel[GoodEntry.columnClassification] + 'id'] = widget.good.classification?.id;
      provider.editValue[Good.columnToLabel[GoodEntry.columnClassification]] = widget.good.classification?.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          controller: _controller,
          child: Container(
            decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: pageBg)),
            padding: EdgeInsets.only(top: sc.statusHeight() + 10, left: 10, right: 10),
            child: Column(
              children: <Widget>[
                _buildPhoto(),
                _buildEditMessage(),
                _buildSummitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  File goodPhoto;
  Image goodPhotoImage;

  ///添加图片
  _buildPhoto() {
    return GestureDetector(
        onTap: () async {
          var result = await showModalBottomSheet(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
              context: context,
              isDismissible: false,
              builder: (context) {
                return AddPhotoDialog();
              });
          setState(() {
            goodPhoto = result ?? goodPhoto;
            goodPhotoImage = result == null ? Image.file(goodPhoto) : null;
            provider.goodPic = goodPhoto;
          });
        },
        child: Container(
          alignment: Alignment.center,
          child: goodPhotoImage == null
              ? Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: pink2blue), shape: BoxShape.circle),
                  child: Image(
                    width: 40,
                    color: Colors.white,
                    image: AssetImage(AssertUtils.getAssertImagePath('add')),
                  ),
                )
              : goodPhotoImage,
          width: sc.screenWidth(),
          height: 200,
        ));
  }

  ///编辑信息区域
  _buildEditMessage() {
    return Container(
        margin: EdgeInsets.only(top: 10, bottom: 20),
        decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(15)),
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: inputContent.length,
          itemBuilder: (context, index) {
            Widget child = _buildInputItem(index);
            return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(colors: index % 2 == 0 ? editWidget1 : editWidget2),
                ),
                child: child);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Divider(
                height: sc.marginH(8),
                color: Colors.transparent,
              ),
            );
          },
        ));
  }

  Widget _buildInputItem(int index) {
    Widget child;
    InputType currentType = inputContent.values.toList()[index];
    String tag = inputContent.keys.toList()[index];
    if (currentType == InputType.text || InputType.double == currentType || InputType.int == currentType) {
      if (tag == '有效天数') {
        child = EditWidget(
          tag,
          currentType,
          onValidDayInputComplete: _onValidDayInputComplete,
          textMaxLength: 4,
        );
      } else {
        child = EditWidget(
          tag,
          currentType,
          textMaxLength: tag == Good.columnToLabel[GoodEntry.columnRemarks] ? 20 : 7,
        );
      }
    } else if (tag == Good.columnToLabel['${GoodEntry.columnExpDate}']) {
      child = SelectWidget(
        tag,
        key: expDateKey,
      );
    } else if (tag == Good.columnToLabel['${GoodEntry.columnPrdDate}']) {
      child = SelectWidget(
        tag,
        key: prdDateKey,
      );
    } else {
      child = SelectWidget(tag);
    }

    return child;
  }

  _buildSummitButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: InkBtn(
        onTap: () {
          addGood();
        },
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: details1),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50),
          child: Text('保存'),
        ),
      ),
    );
  }

  _onValidDayInputComplete(String input) {
    int validDays;
    try {
      validDays = int.parse(input);
    } catch (error) {
      ToastUtils.show('请输入正确的有效天数');
    }

    String validDate = DateTime.parse(prdDateKey.currentState.selected + '00:00:00').add(Duration(days: validDays)).toString().substring(0, 11);

    expDateKey.currentState.setInput(validDate);
  }

  ///添加物品
  addGood() {
    provider.addGood(context, (succeed, mes) {
      ToastUtils.show(mes);
      if (succeed) {
        goodPhoto = null;
        Future.delayed(Duration(seconds: 1)).then((value) {
          if (widget.good?.id != null) {
            Navigator.of(context).pop();
          }
          Navigator.of(context).pop();
        });
      }
    });
  }

  GlobalKey<SelectWidgetState> expDateKey = GlobalKey<SelectWidgetState>();
  GlobalKey<SelectWidgetState> prdDateKey = GlobalKey<SelectWidgetState>();

  @override
  void dispose() {
    provider.editValue = {};
    super.dispose();
  }
}

enum InputType {
  text,
  double,
  int,
  date,
  select,
}
