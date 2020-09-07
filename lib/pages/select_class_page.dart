import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locker/beans/classification.dart';

import 'file:///E:/flutterCodes/locker/locker/lib/widgets/classification/classification_list_widget.dart';

class SelectClassPage extends StatelessWidget {
  SelectClassPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ClassificationListWidget(_returnResult),
    );
  }

  _returnResult(BuildContext context, Classification classification) {
    Navigator.of(context).pop(classification);
  }
}
