import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:locker/beans/goods.dart';
import 'package:locker/config/page_status.dart';
import 'package:locker/providers/good_list_provider.dart';
import 'package:locker/utils/sc_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/widgets/empty_widget.dart';
import 'package:locker/widgets/error_widget.dart';
import 'package:locker/widgets/good/good_list_sort.dart';
import 'package:locker/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'file:///E:/flutterCodes/locker/locker/lib/widgets/good/good_list_item_widget.dart';

class GoodListWidget extends StatefulWidget {
  bool isAll;
  List<String> columns;
  List<String> values;

  GoodListWidget(this.isAll, {this.columns, this.values});

  @override
  _GoodListWidgetState createState() => _GoodListWidgetState();
}

class _GoodListWidgetState extends State<GoodListWidget> {
  RefreshController refreshController = RefreshController();

  BuildContext context;
  List<Map> goodList;

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
      padding: EdgeInsets.only(top: sc.statusHeight()),
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: pageBg)),
      child: Consumer<GoodListProvider>(builder: (context, provider, child) {
        return FutureBuilder(
            future: widget.isAll ? provider.getAllGoodList() : provider.getGoodByParams(widget.columns, widget.values),
            builder: (context, snapShop) {
              if (snapShop.connectionState == ConnectionState.done) {
                if (provider.pageStatus == PageStatus.success) {
                  goodList = provider.goodList;
                  return _buildGoodList();
                } else if (provider.pageStatus == PageStatus.empty) {
                  return EmptyWidget();
                } else if (PageStatus.error == provider.pageStatus) {
                  return CustomErrorWidget();
                } else {
                  return LoadingWidget();
                }
              } else {
                return LoadingWidget();
              }
            });
      }),
    );
  }

  _buildGoodList() {
    return Column(
      children: <Widget>[
        GoodListSort(),
        Expanded(
          child: Container(
              padding: EdgeInsets.all(15),
              child: AnimationLimiter(
                  child: SmartRefresher(
                enablePullDown: true,
                header: BezierCircleHeader(),
                controller: refreshController,
                onRefresh: onRefresh,
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.transparent,
                      height: 10,
                    );
                  },
                  itemCount: goodList.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 250),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(child: GoodListItem(Good.fromJsonMap(goodList[index]))),
                      ),
                    );
                  },
                ),
              ))),
        ),
      ],
    );
  }

  onRefresh() async {
//    if (widget.isAll) {
//      GoodListProvider provider = Provider.of<GoodListProvider>(context, listen: false);
//      await provider.getAllGoodList();
//      goodList = provider.goodList;
//    }
    setState(() {
      refreshController.refreshCompleted();
    });
  }
}
