import 'package:flutter/cupertino.dart';
import 'package:locker/utils/assert_utils.dart';

class CustomErrorWidget extends StatelessWidget {
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
                image: AssetImage(AssertUtils.getAssertImagePath('error')),
              ),
            ),
            Text('出错啦'),
          ],
        ),
      ),
    );
  }
}
