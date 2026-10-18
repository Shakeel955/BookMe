import 'package:flutter/material.dart';

// Eye-catching Baby Blue primary with vibrant Coral Orange contrast
const kTeal = Color(0xFF0284C7); // Vibrant Sky / Baby Blue primary
const kAmber = Color(0xFFF97316); // High-contrast Coral Orange (offers, stars, badges)
const kRed = Color(0xFFEF4444); // Modern Bright Red
const kGreen = Color(0xFF10B981); // Emerald Green for confirmed status
const kTints = [Color(0xFFBAE6FD), Color(0xFFFED7AA), Color(0xFFC7D2FE), Color(0xFFFBCFE8)];

class Pal {
  final Color bg, surface, text, grey, border, tint, tealText;
  const Pal(this.bg, this.surface, this.text, this.grey, this.border, this.tint, this.tealText);
}

const _light = Pal(
  Color(0xFFF8FAFC), // Light Background
  Colors.white,      // Light Surface
  Color(0xFF0F172A), // Dark Text
  Color(0xFF64748B), // Slate Grey
  Color(0xFFE2E8F0), // Border
  Color(0xFFE0F2FE), // Soft Baby Blue Tint
  Color(0xFF0284C7), // Sky/Baby Blue Accent Text
);

const _dark = Pal(
  Color(0xFF0B1220), // Dark Background
  Color(0xFF111827), // Dark Surface
  Color(0xFFF1F5F9), // Light Text
  Color(0xFF94A3B8), // Muted Grey
  Color(0xFF1F2937), // Dark Border
  Color(0xFF0C4A6E), // Dark Baby Blue Tint
  Color(0xFF38BDF8), // Glowing Cyan-Baby Blue Text in Dark Mode
);

extension PalX on BuildContext {
  Pal get p => Theme.of(this).brightness == Brightness.dark ? _dark : _light;
}

ThemeData buildTheme(Brightness b) {
  final pal = b == Brightness.dark ? _dark : _light;
  return ThemeData(
    useMaterial3: true,
    brightness: b,
    colorScheme: ColorScheme.fromSeed(seedColor: kTeal, brightness: b, primary: kTeal),
    scaffoldBackgroundColor: pal.bg,
    canvasColor: pal.surface,
  );
}
