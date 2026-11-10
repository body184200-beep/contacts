import 'package:flutter/material.dart';

class Appcolors {
  // Legacy support
  static const Color blue = Color(0xFF2563EB);
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray = Color(0xFF64748B);
  static const Color red = Color(0xFFEF4444);

  // Modern Color Palette
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primarySoft = Color(0xFFEEF2FF);

  static const Color secondary = Color(0xFF0EA5E9);
  static const Color accent = Color(0xFF6366F1);

  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  static const Color success = Color(0xFF10B981);
  static const Color successSoft = Color(0xFFECFDF5);
  static const Color error = Color(0xFFEF4444);
  static const Color errorSoft = Color(0xFFFEF2F2);
  static const Color favorite = Color(0xFFF43F5E);
  static const Color warning = Color(0xFFF59E0B);

  // Avatar Gradients based on initial/hash
  static const List<List<Color>> avatarGradients = [
    [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
    [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
    [Color(0xFFEC4899), Color(0xFFBE185D)],
    [Color(0xFF10B981), Color(0xFF047857)],
    [Color(0xFFF59E0B), Color(0xFFD97706)],
    [Color(0xFF06B6D4), Color(0xFF0E7490)],
  ];

  static List<Color> getGradientForName(String name) {
    if (name.isEmpty) return avatarGradients[0];
    final index = name.codeUnitAt(0) % avatarGradients.length;
    return avatarGradients[index];
  }
}
