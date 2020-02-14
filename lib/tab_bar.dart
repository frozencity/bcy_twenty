import 'package:bcy_twenty/data/colors.dart';
import 'package:flutter/material.dart';

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return new Container(
      decoration: BoxDecoration(
          color: isDark ? BCYColors.KindaBlack : Colors.white,
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.transparent : Colors.grey[400],
              blurRadius: 1.5,
            ),
          ]
      ),
      child: _tabBar,

    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}