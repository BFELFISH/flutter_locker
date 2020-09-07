import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:locker/beans/classification.dart';
import 'package:locker/config/page_status.dart';
import 'package:locker/providers/classification_list_provider.dart';
import 'package:locker/routes/navigator_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:locker/views/ink_btn.dart';
import 'package:provider/provider.dart';

import '../empty_widget.dart';
import '../error_widget.dart';
import '../loading_widget.dart';
import 'classification_list_item_widget.dart';

class ClassificationListWidget extends StatelessWidget {
  List<Map> classifications;
  Function(BuildContext context, Classification classification) tapItemCallBack;

  ClassificationListWidget(this.tapItemCallBack);

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassListProvider>(
      builder: (context, provider, child) {
        if (provider.pageStatus == PageStatus.success && classifications != null) {
          classifications = provider.list;
          return _buildClassList();
        } else {
          return FutureBuilder(
            future: provider.getAllClass(),
            builder: (context, snapshop) {
              if (snapshop.connectionState == ConnectionState.done) {
                if (provider.pageStatus == PageStatus.success) {
                  classifications = provider.list;
                  return _buildClassList();
                } else if (PageStatus.empty == provider.pageStatus) {
                  return EmptyWidget();
                } else {
                  return CustomErrorWidget();
                }
              } else {
                return LoadingWidget();
              }
            },
          );
        }
      },
    );
  }

  _buildClassList() {
    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: pageBg)),
      padding: const EdgeInsets.all(8.0),
      child: AnimationLimiter(
        child: GridView.builder(
          itemCount: classifications.length + 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: classifications.length + 1,
              duration: const Duration(milliseconds: 250),
              child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: index == classifications.length
                        ? _addClassificationWidget(context)
                        : ClassListItemWidget(
                            classification: Classification.fromJsonMap(classifications[index]),
                            tapItemCallBack: tapItemCallBack,
                          ),
                  )),
            );
          },
        ),
      ),
    );
  }

  ///添加新的分类
  _addClassificationWidget(context) {
    return InkBtn(
      onTap: () {
        NavigatorUtils.toAddClass(context);
      },
      borderRadius: BorderRadius.circular(15),
      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: photo),
      child: Container(
        decoration: BoxDecoration(boxShadow: [BoxShadow(color: yellow_f9f7d9, offset: Offset(2.0, 2.0), blurRadius: 10.0)]),
        width: 50,
        height: 50,
        child: Icon(
          Icons.add,
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }
}
