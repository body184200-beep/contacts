import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class ContactAvatar extends StatelessWidget {
  final String name;
  final String imagePath;
  final double radius;
  final double? fontSize;

  const ContactAvatar({
    super.key,
    required this.name,
    this.imagePath = '',
    this.radius = 24,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasValidImage = imagePath.isNotEmpty && File(imagePath).existsSync();

    if (hasValidImage) {
      return Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Appcolors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _buildGradientInitial(),
          ),
        ),
      );
    }

    return _buildGradientInitial();
  }

  Widget _buildGradientInitial() {
    final gradientColors = Appcolors.getGradientForName(name);
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: Appcolors.white,
          fontSize: fontSize ?? (radius * 0.9),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
