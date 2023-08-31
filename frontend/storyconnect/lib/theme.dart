import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color charcoalBlue = Color(0xFF28536B);
const Color rosyBrown = Color(0xFFC2948A);
const Color isabelline = Color(0xFFF6F0ED);
const Color airSuperiorityBlue = Color(0xFF7EA8BE);

const ColorScheme myColorScheme = ColorScheme(
  primary: charcoalBlue,
  secondary: rosyBrown,
  surface: isabelline,
  background: isabelline,
  error: Colors.red,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: charcoalBlue,
  onBackground: charcoalBlue,
  onError: Colors.white,
  brightness: Brightness.light,
);

ThemeData myTheme = ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: charcoalBlue),
        textTheme: GoogleFonts.ramabhadraTextTheme(),
        useMaterial3: true)
    .copyWith(dividerTheme: DividerThemeData(color: Colors.black));
