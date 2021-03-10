import 'package:flutter/material.dart';
import 'package:qbscap/colors.dart';

class QBListItem extends StatelessWidget {
  final Color backgroundColor;

  const QBListItem({
    Key key,
    this.backgroundColor = COLOR_GRAY,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Material(
        color: this.backgroundColor,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: () {},
          child: Container(
            width: 118,
          ),
        ),
      ),
    );
  }
}
