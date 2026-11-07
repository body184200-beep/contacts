import 'package:flutter/material.dart';

class FloatingActionBottoms extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final ShapeBorder shape;

  const FloatingActionBottoms({
    super.key,
    required this.onPressed,
    required this.child,
    required this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: shape,
      child: child,
    );
  }
}
