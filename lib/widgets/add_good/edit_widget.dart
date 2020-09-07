import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locker/pages/add_good_page.dart';
import 'package:locker/providers/add_good_provider.dart';
import 'package:locker/utils/sc_utils.dart';
import 'package:locker/utils/sp_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/values/key.dart';
import 'package:provider/provider.dart';

class EditWidget extends StatefulWidget {
  final String editLable;
  final InputType inputType;
  Function(String input) onValidDayInputComplete;

  EditWidget(this.editLable, this.inputType, {this.onValidDayInputComplete});

  @override
  EditWidgetState createState() => EditWidgetState();
}

class EditWidgetState extends State<EditWidget> {
  final TextEditingController textEditingController = TextEditingController();
  AddGoodProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<AddGoodProvider>(context, listen: false);
    if (widget.editLable == '提前提醒天数') {
      initWarnDays();
    }
    if (provider.editValue[widget.editLable] != null) {
      textEditingController.text = provider.editValue[widget.editLable];
    }
  }

  initWarnDays() async {
    if (provider.editValue[widget.editLable] == null) {
      var result = await SpUtils.getInt(WARN_DAY_KEY);
      int warnDays = result ?? 15;
      textEditingController.text = warnDays.toString();
      provider.editValue[widget.editLable] = warnDays.toString();
    }
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    provider.editValue[widget.editLable] = textEditingController.text;
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: sc.screenWidth(),
      child: Row(
        children: <Widget>[
          Text(
            '${widget.editLable}：',
            style: TextStyle(color: black_2d4059, fontSize: 16),
          ),
          Expanded(
            child: TextField(
              maxLines: 1,
              inputFormatters: [LengthLimitingTextInputFormatter(20)],
              keyboardType: widget.inputType == InputType.text ? TextInputType.text : TextInputType.number,
              autofocus: false,
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: '请输入${widget.editLable}',
                contentPadding: EdgeInsets.all(0.0),
                enabledBorder: _inputBorder,
                focusedBorder: _inputBorder,
              ),
              onEditingComplete: () {
                if (widget.editLable == '有效天数') {
                  widget.onValidDayInputComplete(textEditingController.text);
                }
                provider.editValue[widget.editLable] = textEditingController.text;
              },
              focusNode: focusNode,
              onChanged: (value) {
                if (widget.editLable == '有效天数') {
                  widget.onValidDayInputComplete(textEditingController.text);
                }
                provider.editValue[widget.editLable] = textEditingController.text;
              },
            ),
          )
        ],
      ),
    );
  }

  final InputBorder _inputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
      width: 1,
    ),
  );
}
