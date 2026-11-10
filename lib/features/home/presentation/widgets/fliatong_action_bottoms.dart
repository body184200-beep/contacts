import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class FloatingActionBottoms extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final ShapeBorder? shape;

  const FloatingActionBottoms({
    super.key,
    required this.onPressed,
    required this.child,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Appcolors.primaryLight, Appcolors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Appcolors.primary.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        elevation: 0,
        highlightElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Appcolors.white,
        shape: shape ?? const CircleBorder(),
        child: child,
      ),
    );
  }
}
