import 'package:flutter/material.dart';

showCustomWarningDialog(BuildContext context,String content,Function sure){
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
            FlatButton(
              onPressed: () async {
                sure();
                Navigator.of(context).pop();
              },
              child: Text('确定'),
            ),
          ],
        );
      });
}

showCustomDialog(BuildContext context,String title,Widget widget,Function sure){
  showDialog(context: context,
  barrierDismissible: false,
  builder: (context){
    return AlertDialog(
      title: Text(title),
      content: widget,
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: Text('取消'),
        ),
        FlatButton(
          onPressed: () async {
            sure();
          },
          child: Text('确定'),
        ),
      ],
    );
  });
}