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

const offWhite = Color.fromARGB(255, 250, 249, 249);

final _lightColorScheme =
    ColorScheme.fromSeed(seedColor: charcoalBlue, brightness: Brightness.light)
        .copyWith(
  background: offWhite,
);

ThemeData lightTheme = ThemeData(
        fontFamily: GoogleFonts.ramabhadra().fontFamily,
        colorScheme: _lightColorScheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: offWhite,
          surfaceTintColor: Colors.transparent,
        ),
        dialogTheme: const DialogTheme(surfaceTintColor: offWhite),
        textTheme: GoogleFonts.ramabhadraTextTheme(),
        cardTheme: CardTheme(
            surfaceTintColor: _lightColorScheme.primaryContainer, elevation: 2),
        useMaterial3: true)
    .copyWith(dividerTheme: const DividerThemeData(color: Colors.black));

final _darkColorScheme =
    ColorScheme.fromSeed(seedColor: charcoalBlue, brightness: Brightness.dark);

ThemeData darkTheme = ThemeData(
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.transparent,
        ),
        fontFamily: GoogleFonts.ramabhadra().fontFamily,
        dividerColor: Colors.white,
        colorScheme: _darkColorScheme,
        useMaterial3: true)
    .copyWith(
  dividerTheme: const DividerThemeData(color: Colors.black),
);
