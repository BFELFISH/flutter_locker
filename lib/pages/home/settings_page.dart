import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locker/providers/good_list_provider.dart';
import 'package:locker/routes/navigator_utils.dart';
import 'package:locker/utils/assert_utils.dart';
import 'package:locker/utils/log_utils.dart';
import 'package:locker/utils/sc_utils.dart';
import 'package:locker/utils/sp_utils.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/values/key.dart';
import 'package:locker/views/custom_dialog.dart';
import 'package:locker/views/ink_btn.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    LogUtils.d('SettingsPage', "key = ${widget.key}");

    GoodListProvider goodListProvider = Provider.of<GoodListProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: pageBg),
      ),
      padding: EdgeInsets.only(top: sc.statusHeight()),
      child: Column(
        children: <Widget>[
          FutureBuilder(
            future: goodListProvider.getAllGoodList(),
            builder: (context, snapShop) {
              if (snapShop.connectionState == ConnectionState.done) {
                return _buildItem('goods', '所有商品数: ${goodListProvider.goodList.length}', callBack: () {
                  ToastUtils.show('共有商品数: ${goodListProvider.goodList.length}个');
                });
              } else {
                return _buildItem(
                  'goods',
                  '所有商品数: ',
                );
              }
            },
          ),
          _buildItem('warn', '设置默认提前提醒天数', callBack: _showWarnDaysSetting),
          _buildPassWord('safe', '设置访问密码', callBack: _showSettingPas),
          Container(
            height: 50,
          ),
          _buildItem('classification_setting', '分类管理', callBack: _showClassification),
          _buildItem('location_setting', '位置管理', callBack: _showLocation),
        ],
      ),
    );
  }

  _showClassification() {
    NavigatorUtils.toManageClass(context);
  }

  _showLocation() {
    NavigatorUtils.toManageLocation(context);
  }

  _showWarnDaysSetting() async {
    TextEditingController textEditingController = TextEditingController();
    int warnDays = await SpUtils.getInt(WARN_DAY_KEY) ?? 15;
    textEditingController.text = warnDays.toString();
    showCustomDialog(
        context,
        '设置默认提前提醒时间',
        TextField(
          maxLines: 1,
          inputFormatters: [LengthLimitingTextInputFormatter(7)],
          keyboardType: TextInputType.number,
          autofocus: true,
          controller: textEditingController,
          decoration: InputDecoration(
            hintText: '请输入提前提醒时间',
            contentPadding: EdgeInsets.all(0.0),
          ),
          style: TextStyle(fontSize: 18),
        ), () async {
      if (textEditingController.text.trim().isEmpty) {
        ToastUtils.show('请输入提前提醒天数');
      } else {
        int warnDays;
        try {
          warnDays = int.parse(textEditingController.text);
          await SpUtils.setInt(WARN_DAY_KEY, warnDays);
          ToastUtils.show(textEditingController.text);
          Navigator.of(context).pop();
        } catch (error) {
          ToastUtils.show('请输入正确的天数');
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getSwitchValue();
  }

  bool switchValue = false;

  _buildPassWord(String imageName, String tag, {Function callBack}) {
    return Container(
      width: sc.screenWidth(),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: gray_f3f3f3, width: 1))),
      alignment: Alignment.center,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage(AssertUtils.getAssertImagePath('$imageName')),
                  width: 20,
                  height: 20,
                ),
              ),
              Text('$tag'),
            ],
          ),
          Align(
              alignment: Alignment.centerRight,
              child: CupertinoSwitch(
                activeColor: main_color,
                value: switchValue,
                onChanged: (value) {
                  switchValue = value;
                  _showSettingPas();
                },
              ))
        ],
      ),
    );
  }

  getSwitchValue() async {
    switchValue = await SpUtils.getBool(LOCKED_KEY) ?? false;
    print('test build swiva $switchValue');
    setState(() {});
  }

  _showSettingPas() async {
    TextEditingController textEditingController = TextEditingController();
    //如果是从false -> true
    if (switchValue) {
      switchValue = false;
      showCustomDialog(
          context,
          '请设置访问密码',
          TextField(
            maxLines: 1,
            inputFormatters: [LengthLimitingTextInputFormatter(7)],
            keyboardType: TextInputType.text,
            autofocus: true,
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: '请输入访问密码',
              contentPadding: EdgeInsets.all(0.0),
            ),
            style: TextStyle(fontSize: 18),
          ), () async {
        if (textEditingController.text.trim().isEmpty) {
          ToastUtils.show('请输入访问密码');
          switchValue = false;
        } else {
          await SpUtils.setString(PASSWORD_KEY, textEditingController.text);
          await SpUtils.setBool(LOCKED_KEY, true);
          setState(() {
            switchValue = true;
          });
          ToastUtils.show('设置成功');
          Navigator.of(context).pop();
        }
      });
    } else {
      switchValue = true;
      String pas = await SpUtils.getString(PASSWORD_KEY);
      showCustomDialog(
          context,
          '请输入访问密码',
          TextField(
            maxLines: 1,
            inputFormatters: [LengthLimitingTextInputFormatter(7)],
            keyboardType: TextInputType.text,
            autofocus: true,
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: '请输入访问密码',
              contentPadding: EdgeInsets.all(0.0),
            ),
            style: TextStyle(fontSize: 18),
            onChanged: (value) async {
              if (textEditingController.text == pas) {
                setState(() {
                  switchValue = false;
                });
                await SpUtils.setBool(LOCKED_KEY, false);
                Navigator.of(context).pop();
              }
            },
          ), () async {
        if (textEditingController.text == pas) {
          setState(() {
            switchValue = false;
          });
          await SpUtils.setBool(LOCKED_KEY, false);
          Navigator.of(context).pop();
        } else {
          ToastUtils.show('密码错误');
        }
      });
    }
  }

  _buildItem(String imageName, String tag, {Function callBack}) {
    return InkBtn(
      onTap: () {
        if (callBack != null) {
          callBack();
        }
      },
      child: Container(
        width: sc.screenWidth(),
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: gray_f3f3f3, width: 1))),
        alignment: Alignment.center,
        height: 50,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage(AssertUtils.getAssertImagePath('$imageName')),
                    width: 20,
                    height: 20,
                  ),
                ),
                Text('$tag'),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Image(
                image: AssetImage(AssertUtils.getAssertImagePath('goto')),
                width: 20,
                height: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
