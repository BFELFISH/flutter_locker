import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locker/providers/good_list_provider.dart';
import 'package:locker/utils/assert_utils.dart';
import 'package:locker/utils/sc_utils.dart';
import 'package:locker/values/colors.dart';
import 'package:provider/provider.dart';

class GoodListSort extends StatefulWidget {
  @override
  _GoodListSortState createState() => _GoodListSortState();
}

class _GoodListSortState extends State<GoodListSort> {
  GoodListProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<GoodListProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: tag2SortType.keys.map((e) => _buildItem(e)).toList(),
    );
  }

  Widget _buildItem(String tag) {
    return GestureDetector(
      onTap: () {
        if (tag2SortType[tag] == provider.sortType) {
          if (provider.sort == 0) {
            provider.sort = 1;
          } else {
            provider.sort = 0;
          }
        } else {
          provider.sortType = tag2SortType[tag];
          provider.sort = 0;
        }
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 2.0),
              child: Text(
                tag,
                style: TextStyle(
                    color: tag2SortType[tag] == provider.sortType ? Colors.red : gray_838383, fontSize: 14, decoration: TextDecoration.none),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image(
                  width: 10,
                  image: AssetImage(AssertUtils.getAssertImagePath('up')),
                  color: tag2SortType[tag] == provider.sortType && provider.sort == 1 ? Colors.red : gray_838383,
                ),
                Image(
                    width: 10,
                    image: AssetImage(AssertUtils.getAssertImagePath('down')),
                    color: tag2SortType[tag] == provider.sortType && provider.sort == 0 ? Colors.red : gray_838383),
              ],
            )
          ],
        ),
      ),
    );
  }

  Map<String, SortType> tag2SortType = {'剩余有效时间': SortType.remainDays, '数量': SortType.num, '价格': SortType.price, '购买时间': SortType.buyDate};
}
