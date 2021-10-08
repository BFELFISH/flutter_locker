import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:locker/values/colors.dart';

class LoadingWidget extends StatefulWidget {
  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitCircle(
              color: main_color,
              size: 50.0,
              controller: _controller,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                '加载中',
                style: TextStyle(fontSize: 14, decoration: TextDecoration.none),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
