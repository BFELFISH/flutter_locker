import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locker/routes/navigator_utils.dart';
import 'package:locker/utils/sc_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/views/ink_btn.dart';

class AddPhotoDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: sc.screenWidth(),
      decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: pageBg),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[_takePhoto(context), _selectPhoto(context), _cancel(context)],
      ),
    );
  }

  TextStyle buttonStyle = TextStyle(color: black_2d4059, fontSize: 16);
  double buttonHeight = 60;
  final picker = ImagePicker();

  _takePhoto(context) {
    return InkBtn(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      onTap: () async {
        final file = await picker.getImage(source: ImageSource.camera);
        File result = File(file.path);
        Navigator.of(context).pop(result);
      },
      child: Container(
        height: buttonHeight,
        child: Center(
            child: Text(
          '拍照',
          style: buttonStyle,
        )),
      ),
    );
  }

  _selectPhoto(context) {
    return InkBtn(
      onTap: () async {
        final filePath = await picker.getImage(source: ImageSource.gallery);
        if (filePath != null) {
          File result = File(filePath.path);
          Navigator.of(context).pop(result);
        }
      },
      child: Container(
        height: buttonHeight,
        decoration: BoxDecoration(border: Border.all(color: gray_dddddd)),
        child: Center(
            child: Text(
          '从图库中选择',
          style: buttonStyle,
        )),
      ),
    );
  }

  _cancel(context) {
    return InkBtn(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        height: buttonHeight,
        child: Center(
            child: Text(
          '取消',
          style: buttonStyle,
        )),
      ),
    );
  }
}
