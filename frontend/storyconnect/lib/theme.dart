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

final offWhite = Color.fromARGB(255, 250, 249, 249);

ThemeData lightTheme = ThemeData(
        fontFamily: GoogleFonts.ramabhadra().fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: charcoalBlue)
            .copyWith(background: offWhite),
        appBarTheme: AppBarTheme(
          backgroundColor: offWhite,
          surfaceTintColor: Colors.transparent,
        ),
        textTheme: GoogleFonts.ramabhadraTextTheme(),
        cardTheme: CardTheme(
            surfaceTintColor: Color.fromARGB(255, 198, 198, 198), elevation: 2),
        useMaterial3: true)
    .copyWith(dividerTheme: DividerThemeData(color: Colors.black));

ThemeData darkTheme = ThemeData(
        fontFamily: GoogleFonts.ramabhadra().fontFamily,
        dividerColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
            seedColor: charcoalBlue, brightness: Brightness.dark),
        useMaterial3: true)
    .copyWith(dividerTheme: DividerThemeData(color: Colors.black));
