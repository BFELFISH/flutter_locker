import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locker/database/good_entry.dart';
import 'package:locker/utils/assert_utils.dart';
import 'package:locker/utils/sc_utils.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:locker/values/colors.dart';

import 'good_list_widget.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _textEditingController;
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: sc.screenWidth(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: gray_f3f3f3,
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Image(
              image: AssetImage(AssertUtils.getAssertImagePath('search')),
              width: 20,
              height: 20,
            ),
          ),
          Expanded(
            child: TextField(
              maxLines: 1,
              inputFormatters:[LengthLimitingTextInputFormatter(20)],
              keyboardType: TextInputType.text,
              autofocus: false,
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: '请输入物品名称',
                contentPadding: EdgeInsets.all(0.0),
                enabledBorder: _inputBorder,
                focusedBorder: _inputBorder,
              ),
              style: TextStyle(fontSize: 18),
              onEditingComplete: (){
               if(_textEditingController.text == null||_textEditingController.text.isEmpty){
                 ToastUtils.show('请输入物品名称');
               }else{
                 Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (context) => GoodListWidget(
                           false,
                           columns: [GoodEntry.columnName],
                           values: ["${_textEditingController.text}"],
                         )));
               }
              },
            ),
          )
        ],
      ),
    );
  }

  InputBorder _inputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
      width: 1,
    ),
  );
}
