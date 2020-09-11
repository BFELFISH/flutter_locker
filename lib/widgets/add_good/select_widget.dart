import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locker/beans/classification.dart';
import 'package:locker/beans/location_detial.dart';
import 'package:locker/providers/add_good_provider.dart';
import 'package:locker/routes/navigator_utils.dart';
import 'package:locker/utils/assert_utils.dart';
import 'package:locker/utils/sc_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/views/ink_btn.dart';
import 'package:provider/provider.dart';

class SelectWidget extends StatefulWidget {
  final String tag;
  Key key;

  SelectWidget(this.tag, {this.key});

  @override
  SelectWidgetState createState() => SelectWidgetState();
}

class SelectWidgetState extends State<SelectWidget> {
  String selected;
  AddGoodProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<AddGoodProvider>(context, listen: false);
    if (widget.tag != '分类' && widget.tag != '位置') {
      if (provider.editValue[widget.tag] == null) {
        selected = DateTime.now().toString().substring(0, 11);
        provider.editValue[widget.tag] = selected;
      }
    }
    if (provider.editValue[widget.tag] != null) {
      selected = provider.editValue[widget.tag];
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkBtn(
      onTap: () async {
        var result;
        if (widget.tag == '分类') {
          result = await NavigatorUtils.toSelectClass(context);
          if (result is Classification) {
            provider.editValue[widget.tag + 'id'] = result.id;
            selected = result.name;
          }
        } else if (widget.tag == '位置') {
          result = await NavigatorUtils.toSelectLocation(context);
          if (result is LocationDetail) {
            provider.editValue[widget.tag + 'id'] = result.id;
            selected = result.location?.locationName;
            selected += result.locationDetail;
          }
        } else {
          result = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(DateTime.now().year - 30),
              lastDate: DateTime(DateTime.now().year + 500));
          if (result != null) {
            result = result.toString().substring(0, 11);
            selected = result;
            provider.editValue[widget.tag] = selected;
          }
        }
        if (result != null) {
          setState(() {});
        }
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: sc.screenWidth(),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  '${widget.tag}：',
                  style: TextStyle(color: black_2d4059, fontSize: 16),
                ),
                Expanded(child: Text(selected ?? '', style: TextStyle(color: black_2d4059, fontSize: 16)))
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Image(
                image: AssetImage(AssertUtils.getAssertImagePath('goto')),
                width: 20,
                height: 20,
              ),
            )
          ],
        ),
      ),
    );
  }

  setInput(String input) {
    setState(() {
      selected = input;
      provider.editValue[widget.tag] = selected;
    });
  }
}
