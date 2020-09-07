
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locker/utils/log_utils.dart';
import 'package:locker/values/colors.dart';

class CheckItem extends StatefulWidget {
  ///所属列
  final String columnName;
  ///关键字
  final String tag;
  Function callback;
  bool _checked = true;


  set checked(bool value) {
    _checked = value;
  }

  CheckItem(this.columnName,this.tag,this.callback);

  refresh(){
   state?.setState(() {});
  }

  CheckItemState state;
  @override
  CheckItemState createState(){
    if(state == null){
      state = CheckItemState();
    }
    return state;
  }
}

class CheckItemState extends State<CheckItem> {



  @override
  Widget build(BuildContext context) {
    return Container(
      child: ChoiceChip(
        backgroundColor: Colors.white,
        selectedColor: blue_f1f3f8,
        shadowColor: gray_dddddd,
        label: Text('${widget.tag}'),
        selected: widget._checked,
        onSelected: (value) {
          setState(() {
            widget._checked = value;
            ///全部才需要更改全选状态，如果不是全部，则只有取消才需要通知
            if(widget.tag == '全部'){
              widget.callback(value,true);
            }else{
              if(!value){
                widget.callback(false,false);
              }
            }
          });
        },
      ),
//      child: Row(
//        mainAxisSize: MainAxisSize.min,
//        children: <Widget>[
//          Padding(
//            padding: const EdgeInsets.all(2.0),
//            child: Checkbox(
//              value: checked,
//              tristate: false,
//              onChanged: (value) {
//                setState(() {
//                  checked = value;
//                });
//              },
//            ),
//          ),
//          Text(widget.tag),
//        ],
//      ),
    );
  }
}
