import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:locker/utils/log_utils.dart';

class ToastUtils {
  static bool _isFirst = true;

  static void show(String text, {bool isShowLong = false}) {
    if (text != null && text.length > 0) {
      if (_isFirst) {
        _isFirst = false;
      } else {
        Fluttertoast.cancel();
      }

      Fluttertoast.showToast(
        msg: text,
        toastLength: isShowLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16,
      );
    } else {
      LogUtils.w('ToastUtils', "toast content is empty");
    }
  }

}