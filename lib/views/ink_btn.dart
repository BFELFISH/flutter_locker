import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/***
 *  Create by Panjiaru on 2020/7/29
 *  Description: 可以自定义边框的水波纹按钮,注意child中的Container不能设置背景颜色，否则水波纹无效
 */
class InkBtn extends StatelessWidget {
  ///背景颜色
  Color color;

  BorderRadiusGeometry borderRadius;

  ///高亮颜色
  Color highlightColor;

  ///溅射颜色
  Color splashColor;

  ///按钮内内容
  Widget child;

  Function onTap;
  Function onLongPress;

  ///渐变背景
  Gradient gradient;

  InkBtn({this.color = Colors.transparent, this.borderRadius,this.onLongPress, this.onTap, this.gradient, this.child, this.highlightColor, this.splashColor})
      : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: borderRadius,
      color: color,
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: borderRadius,
        ),
        child: InkWell(
          highlightColor: highlightColor,
          splashColor: splashColor,
          onTap: () {
            if (this.onTap != null) {
              onTap();
            }
          },
          onLongPress: (){
            if (this.onLongPress != null) {
              onLongPress();
            }
          },
          borderRadius: borderRadius,
          child: child,
        ),
      ),
    );
  }
}
