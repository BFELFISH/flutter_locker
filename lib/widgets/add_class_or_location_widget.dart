import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:locker/utils/assert_utils.dart';
import 'package:locker/utils/sc_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/views/ink_btn.dart';

class AddClassOrLocationWidget extends StatefulWidget {
  final List iconName;
  final Function onTapCallBack;
  final TextEditingController _textEditingController;
  final String tag;
  String selectedImage;

  int selectedIndex = 0;

  AddClassOrLocationWidget(this.tag, this.iconName, this.onTapCallBack, this._textEditingController, {this.selectedImage, this.selectedIndex});

  @override
  _AddClassOrLocationWidgetState createState() => _AddClassOrLocationWidgetState();
}

class _AddClassOrLocationWidgetState extends State<AddClassOrLocationWidget> {
  @override
  void initState() {
    super.initState();
    widget.selectedImage = widget.iconName[widget.selectedIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.only(top: sc.statusHeight() + 20),
            width: sc.screenWidth(),
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: pageBg),
            ),
            child: Column(children: <Widget>[
              _buildSelectedIcon(),
              _buildIconName(),
              _buildIconList(),
              _buildSummitButton(),
            ]),
          ))),
    );
  }

  _buildSelectedIcon() {
    return CircleAvatar(
        backgroundColor: Colors.white,
        minRadius: 50,
        child: widget.selectedImage == null
            ? Container()
            : Image(
                image: AssetImage(AssertUtils.getAssertImagePath(widget.selectedImage)),
              ));
  }

  _buildIconName() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      width: sc.screenWidth(),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '${widget.tag}名称：',
            style: TextStyle(color: black_2d4059, fontSize: 18, decoration: TextDecoration.none),
          ),
          Container(
            width: 150,
            child: TextField(
              maxLines: 1,
              inputFormatters: [LengthLimitingTextInputFormatter(7)],
              keyboardType: TextInputType.text,
              autofocus: false,
              controller: widget._textEditingController,
              decoration: InputDecoration(
                hintText: '请输入${widget.tag}名称',
                contentPadding: EdgeInsets.all(0.0),
                enabledBorder: _inputBorder,
                focusedBorder: _inputBorder,
              ),
              style: TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
    );
  }

  _buildIconList() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: AnimationLimiter(
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.iconName.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 20.0,
            crossAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: widget.iconName.length,
              duration: const Duration(milliseconds: 250),
              child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                      child: GestureDetector(
                    onTap: () {
                      widget.selectedIndex = index;
                      widget.selectedImage = widget.iconName[index];
                      setState(() {});
                    },
                    child: CircleAvatar(
                      backgroundColor: widget.selectedIndex == index ? main_color : Colors.white,
                      minRadius: 30,
                      maxRadius: 30,
                      child: Image(
                        width: 30,
                        height: 30,
                        image: AssetImage(AssertUtils.getAssertImagePath(widget.iconName[index])),
                      ),
                    ),
                  ))),
            );
          },
        ),
      ),
    );
  }

  _buildSummitButton() {
    return Container(
      margin: EdgeInsets.only(top: 50, bottom: 50),
      child: InkBtn(
        onTap: () async {
          widget.onTapCallBack(widget.selectedIndex);
        },
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: details1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50),
          child: Text(
            '添加',
            style: TextStyle(color: black_2d4059, fontSize: 14),
          ),
        ),
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
