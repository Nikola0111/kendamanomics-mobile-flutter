import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/models/bottom_navigation_data.dart';

class BottomNavigation extends StatelessWidget {
  static const double _sidePadding = 20.0;
  static const double iconSize = 80.0;

  final List<BottomNavigationData> items;
  final int pageIndex;
  final void Function(int index) onPageUpdated;
  const BottomNavigation({super.key, required this.items, required this.pageIndex, required this.onPageUpdated});

  @override
  Widget build(BuildContext context) {
    // icon size proportion is 392.72 / 70
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedPadding(
          duration: const Duration(milliseconds: 300),
          curve: Curves.linearToEaseOut,
          padding: EdgeInsets.only(left: _calculateIndicatorOffset(context)),
          child: Container(
            width: iconSize,
            height: 1,
            color: CustomColors.of(context).primary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              if (i == 0) const SizedBox(width: _sidePadding),
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    onPageUpdated(i);
                    context.goNamed(items[i].pageName);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    width: iconSize,
                    height: iconSize,
                    child: _getItem(data: items[i]),
                  ),
                ),
              ),
              if (i != items.length - 1) const Spacer(),
              if (i == items.length - 1) const SizedBox(width: _sidePadding),
            ]
          ],
        ),
      ],
    );
  }

  Widget _getItem({required BottomNavigationData data}) {
    if (data.isLocal) {
      return Image.asset(data.pathOrUrl, fit: BoxFit.fitHeight);
    } else {
      return Image.network(data.pathOrUrl, fit: BoxFit.cover);
    }
  }

  double _calculateIndicatorOffset(BuildContext context) {
    final spacerWidth = (MediaQuery.of(context).size.width - 2 * _sidePadding - 3 * iconSize) / 2;
    final offset = pageIndex * spacerWidth + iconSize * pageIndex + _sidePadding;
    return offset;
  }
}
