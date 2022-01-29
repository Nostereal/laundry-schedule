import 'package:flutter/material.dart';
import 'package:washing_schedule/home/home.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    Key? key,
    this.paddingHorizontal = horizontalPadding,
    this.leftItem,
    required this.rightItem,
  }) : super(key: key);

  final double paddingHorizontal;

  final Widget? leftItem;
  final Widget rightItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: paddingHorizontal,
      ),
      child: Row(
        children: [
          if (leftItem != null) ...[leftItem!, const SizedBox(width: 8)],
          rightItem,
        ],
      ),
    );
  }
}
