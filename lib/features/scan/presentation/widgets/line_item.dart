import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class LineItem extends StatelessWidget {
  final String line;

  const LineItem({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      data: line,
      dragAnchorStrategy: childDragAnchorStrategy,

      feedback: Container(
        key: GlobalKey(),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Appcolors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          line,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color:Appcolors.white),
        ),
      ),

      child: Chip(label: Text(line)),
    );
  }
}
