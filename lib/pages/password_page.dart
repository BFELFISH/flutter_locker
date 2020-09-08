import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locker/routes/navigator_utils.dart';
import 'package:locker/utils/sp_utils.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/values/key.dart';

class PasswordPage extends StatelessWidget {
  TextEditingController _textEditingController = TextEditingController();
  String pas;

  PasswordPage() {
    getPas();
  }

  getPas() async {
    pas = await SpUtils.getString(PASSWORD_KEY);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: pageBg)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '请输入访问密码',
                style: TextStyle(color: black_2d4059, fontSize: 18, decoration: TextDecoration.none),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                child: TextField(
                  obscureText:true,
                  maxLines: 1,
                  inputFormatters: [LengthLimitingTextInputFormatter(7)],
                  keyboardType: TextInputType.text,

                  autofocus: false,
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintText: '请输入访问密码',
                    contentPadding: EdgeInsets.all(0.0),
                  ),
                  style: TextStyle(fontSize: 18),
                  onChanged: (value) {
                    if (pas == _textEditingController.text) {
                      NavigatorUtils.toHome(context);
                    }else if(_textEditingController.text.length>pas.length){
                      ToastUtils.show('密码错误');
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
