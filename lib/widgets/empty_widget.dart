import 'package:flutter/cupertino.dart';
import 'package:locker/utils/assert_utils.dart';
import 'package:locker/values/colors.dart';

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                width: 30,
                image: AssetImage(AssertUtils.getAssertImagePath('empty')),
              ),
            ),
            Text(
              '暂时无内容',
              style: TextStyle(color: black_2d4059, fontSize: 16, decoration: TextDecoration.none),
            ),
          ],
        ),
      ),
    );
  }
}
