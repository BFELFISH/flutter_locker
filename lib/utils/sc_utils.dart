import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/screenutil.dart';

ScUtils sc = ScUtils();
class ScUtils{
  static double sysBottom;

  ///启动时调用
  static init(context) {
    ///屏幕适配插件初始化
    ///[width] UI标注宽度
    ///[height] UI标注高度
    ScreenUtil.init(context,width: 360, height: 640);

    sysBottom = MediaQuery.of(context).padding.bottom;
  }

  ///计算宽度
  ///[width] UI标注宽度
  double w(num width) {
    // return ScreenUtil().setWidth(width);
    return width.toDouble();
  }

  ///计算高度
  ///[] UI标注高度
  double h(num height) {
    //return ScreenUtil().setHeight(height);
    return height.toDouble();
  }

  ///获取水平间距
  ///[marginWidth] UI标注,水平方向间距
  double marginW(num marginWidth) {
    //return ScreenUtil().setWidth(marginWidth);
    return marginWidth.toDouble();
  }

  ///获取垂直间距
  ///[marginHeight] UI标注:垂直方向间距
  double marginH(num marginHeight) {
    //return ScreenUtil().setHeight(marginHeight);
    return marginHeight.toDouble();
  }

  ///状态栏的高度:dp
  double statusHeight() {
    return ScreenUtil.statusBarHeight;
  }

  ///屏幕宽度:dp
  double screenWidth() {
    return ScreenUtil.screenWidth;
  }

  ///屏幕高度:dp
  double screenHeight() {
    return ScreenUtil.screenHeight;
  }

  double screenPaddingBottom(){
    return sysBottom;
  }
}