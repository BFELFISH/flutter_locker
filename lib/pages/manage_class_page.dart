import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:locker/beans/classification.dart';
import 'package:locker/config/page_status.dart';
import 'package:locker/database/classification_entry.dart';
import 'package:locker/providers/add_good_provider.dart';
import 'package:locker/providers/classification_list_provider.dart';
import 'package:locker/providers/good_list_provider.dart';
import 'package:locker/utils/assert_utils.dart';
import 'package:locker/utils/toast_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/widgets/empty_widget.dart';
import 'package:locker/widgets/error_widget.dart';
import 'package:locker/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class ManageClassPage extends StatefulWidget {
  @override
  _ManageClassPageState createState() => _ManageClassPageState();
}

class _ManageClassPageState extends State<ManageClassPage> {
  List<Map> classificationList;

  @override
  Widget build(BuildContext context) {
    ClassListProvider provider = Provider.of(context, listen: false);
    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: pageBg)),
      child: FutureBuilder(
        future: provider.getAllClass(),
        builder: (context, snapShop) {
          if (snapShop.connectionState == ConnectionState.done) {
            if (provider.pageStatus == PageStatus.success) {
              classificationList = provider.list;
              return _buildList();
            } else if (provider.pageStatus == PageStatus.empty) {
              return EmptyWidget();
            } else if (provider.pageStatus == PageStatus.error) {
              return CustomErrorWidget();
            } else {
              return LoadingWidget();
            }
          } else {
            return LoadingWidget();
          }
        },
      ),
    );
  }

  _buildList() {
    return Container(
      child: ListView.builder(
          itemCount: classificationList.length,
          itemBuilder: (context, index) {
            return _buildItem(Classification(
                id: classificationList[index][ClassificationEntry.columnId],
                name: classificationList[index][ClassificationEntry.columnName],
                pic: classificationList[index][ClassificationEntry.columnPic]));
          }),
    );
  }

  _buildItem(Classification classification) {
    return Slidable(
      controller: SlidableController(),
      actionPane: SlidableDrawerActionPane(),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: gray_e5e5e5)),
        padding: EdgeInsets.only(left: 15, top: 15, bottom: 10),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 20),
              child: Image(
                image: AssetImage(AssertUtils.getAssertImagePath(classification.pic)),
                width: 30,
              ),
            ),
            Text(
              classification.name,
              style: TextStyle(color: black_2d4059, fontSize: 14, decoration: TextDecoration.none),
            )
          ],
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: '编辑',
          icon: Icons.edit,
          color: main_color,
          onTap: () {

          },
        ),
        IconSlideAction(
          caption: '删除',
          icon: Icons.delete,
          color: main_color,
          onTap: () async {
            ToastUtils.show('删除');
            await Provider.of<ClassListProvider>(context, listen: false)
                .deleteClassById(classification.id, Provider.of<GoodListProvider>(context, listen: false));
            setState(() {});
          },
        )
      ],
    );
  }
}
