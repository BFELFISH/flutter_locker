import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locker/routes/navigator_utils.dart';
import 'package:locker/utils/sc_utils.dart';
import 'package:locker/utils/sp_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/values/key.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  Widget build(BuildContext context) {
    ScUtils.init(
      context,
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient:
              LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: pageBg),
        ),
      ),
    );
  }

  _navigateTo() async {
    bool isLocked = await SpUtils.getBool(LOCKED_KEY) ?? false;
    if (!isLocked) {
      NavigatorUtils.toHome(context);
    } else {
      NavigatorUtils.toPasswordPage(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    _animation.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _navigateTo();
      }
    });
    _controller.forward();
  }
}
