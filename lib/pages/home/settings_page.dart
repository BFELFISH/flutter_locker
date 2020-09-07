import 'package:flutter/cupertino.dart';
import 'package:locker/providers/good_list_provider.dart';
import 'package:locker/routes/navigator_utils.dart';
import 'package:locker/utils/assert_utils.dart';
import 'package:locker/utils/sc_utils.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/views/ink_btn.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
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
    ToastUtils.show('on tap location');
  }

  _showWarnDaysSetting() {
    ToastUtils.show('on tap warn');
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
