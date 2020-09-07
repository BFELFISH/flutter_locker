import 'package:flutter/cupertino.dart';
import 'package:locker/beans/classification.dart';
import 'package:locker/utils/assert_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/views/ink_btn.dart';

class ClassListItemWidget extends StatelessWidget  {
  final Classification classification;
  final Function(BuildContext context,Classification classification) tapItemCallBack;


  const ClassListItemWidget({Key key, this.classification,this.tapItemCallBack}) ;
  @override
  Widget build(BuildContext context) {
    return InkBtn(
      onTap: (){
        tapItemCallBack(context,classification);
      },
      borderRadius: BorderRadius.circular(15),
      gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: editWidget1),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: yellow_f9f7d9,
              offset: Offset(2.0,2.0),
              blurRadius: 10.0
            )
          ]
        ),
        width: 50,
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              width: 40,
              height: 40,
              image: AssetImage(AssertUtils.getAssertImagePath('${classification.pic}')),
            ),
            Text('${classification.name}')
          ],
        ),
      ),
    );
  }

}
