import 'package:flutter/material.dart';

enum AppLang { de, en }

/// Renkler.
class AppColors {
  static const Color background = Color(0xFFF9F7F3);
  static const Color panel = Colors.white;
  static const Color subtleBorder = Color(0xFFE8E2DA);
  static const Color textPrimary = Color(0xFF1F2933);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color badge = Color(0xFFE8EFF7);
  static const Color primary = Color(0xFFCE000C);
  static const Color mustard = Color(0xFFD2A13A);
  static const Color teal = Color(0xFF248C81);
  static const Color salmon = Color(0xFFE07452);
  static const Color steel = Color(0xFF4F7A99);
  static const Color crimson = Color(0xFFD6424B);
  static const Color indigo = Color(0xFF6366F1);
  static const Color sand = Color(0xFFD9AF54);
}

class AppShadows {
  static final List<BoxShadow> soft = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 14,
      offset: const Offset(0, 8),
    ),
  ];
}
