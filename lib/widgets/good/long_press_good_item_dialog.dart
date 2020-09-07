import 'package:flutter/cupertino.dart';
import 'package:locker/utils/sc_utils.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/views/ink_btn.dart';

class LongPressGoodItemDialog extends StatelessWidget {
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: pageBg),
      ),
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[_buildEdit(), _buildDelete(), _buildCancel()],
      ),
    );
  }

  TextStyle style = TextStyle(color: black_2d4059, fontSize: 16);

  _buildEdit() {
    return InkBtn(
      onTap: () {
        Navigator.of(context).pop('edit');
      },
      child: Container(
        height: buttonHeight,
        child: Center(
            child: Text(
          '编辑',
          style: style,
        )),
      ),
    );
  }

  double buttonHeight = 60;

  _buildDelete() {
    return InkBtn(
      onTap: () {
        ToastUtils.show('删除');
        Navigator.of(context).pop('delete');
      },
      child: Container(
        height: buttonHeight,
        width: sc.screenWidth(),
        decoration: BoxDecoration(border: Border.all(color: gray_dddddd)),
        child: Center(
            child: Text(
          '删除',
          style: style,
        )),
      ),
    );
  }

  _buildCancel() {
    return InkBtn(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        height: buttonHeight,
        child: Center(
            child: Text(
          '取消',
          style: style,
        )),
      ),
    );
  }
}
