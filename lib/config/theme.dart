import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Bangla Font
final List<String> _fontFamilyFallback = [
  GoogleFonts.notoSerifBengali().fontFamily!,
];

const Color primaryColorLight = Color(0xFF212121);
const Color accentColorLight = Color(0xFF424242);
const Color lightBackgroundColor = Color(0xFFFFFFFF);
const Color cardLightColor = Color(0xFFF5F5F5);
const Color textLightColor = Color(0xFF212121);
const Color hintLightColor = Color(0xFF757575);

const Color primaryColorDark = Color(0xFFE0E0E0);
const Color accentColorDark = Color(0xFFBDBDBD);
const Color darkBackgroundColor = Color(0xFF000000);
const Color cardDarkColor = Color(0xFF212121);
const Color textDarkColor = Color(0xFFE0E0E0);
const Color hintDarkColor = Color(0xFF9E9E9E);

// Light Theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: primaryColorLight,
    secondary: accentColorLight,
    surface: lightBackgroundColor,
    background: lightBackgroundColor,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: textLightColor,
    onBackground: textLightColor,
    error: Colors.red.shade700,
    onError: Colors.white,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: GoogleFonts.playfairDisplay().fontFamily,
  textTheme: TextTheme(
    displayLarge: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.light().textTheme.displayLarge,
      color: textLightColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    displayMedium: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.light().textTheme.displayMedium,
      color: textLightColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    displaySmall: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.light().textTheme.displaySmall,
      color: textLightColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    headlineLarge: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.light().textTheme.headlineLarge,
      color: textLightColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    headlineMedium: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.light().textTheme.headlineMedium,
      color: textLightColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    headlineSmall: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.light().textTheme.headlineSmall,
      color: textLightColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    titleLarge: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.light().textTheme.titleLarge,
      color: textLightColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    titleMedium: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.light().textTheme.titleMedium,
      color: textLightColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    titleSmall: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.light().textTheme.titleSmall,
      color: textLightColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    bodyLarge: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.light().textTheme.bodyLarge,
      color: textLightColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    bodyMedium: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.light().textTheme.bodyMedium,
      color: textLightColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    bodySmall: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.light().textTheme.bodySmall,
      color: hintLightColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    labelLarge: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.light().textTheme.labelLarge,
      color: textLightColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    labelMedium: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.light().textTheme.labelMedium,
      color: textLightColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    labelSmall: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.light().textTheme.labelSmall,
      color: textLightColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColorLight,
    foregroundColor: Colors.white,
    elevation: 2,
    shadowColor: Colors.black12,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: primaryColorLight,
    foregroundColor: Colors.white,
    elevation: 4,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade100,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: accentColorLight, width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
    ),
    contentPadding: const EdgeInsets.symmetric(
      vertical: 16.0,
      horizontal: 20.0,
    ),
    hintStyle: TextStyle(color: hintLightColor),
  ),
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    buttonColor: primaryColorLight,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColorLight,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      minimumSize: const Size(double.infinity, 56),
      elevation: 3,
      shadowColor: primaryColorLight.withOpacity(0.2),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryColorLight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
    color: cardLightColor,
    shadowColor: Colors.black.withOpacity(0.08),
  ),
  scaffoldBackgroundColor: lightBackgroundColor,
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: primaryColorDark,
    secondary: accentColorDark,
    surface: darkBackgroundColor,
    background: darkBackgroundColor,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: textDarkColor,
    onBackground: textDarkColor,
    error: Colors.red.shade400,
    onError: Colors.black,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: GoogleFonts.playfairDisplay().fontFamily,
  textTheme: TextTheme(
    displayLarge: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.dark().textTheme.displayLarge,
      color: textDarkColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    displayMedium: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.dark().textTheme.displayMedium,
      color: textDarkColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    displaySmall: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.dark().textTheme.displaySmall,
      color: textDarkColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    headlineLarge: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.dark().textTheme.headlineLarge,
      color: textDarkColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    headlineMedium: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.dark().textTheme.headlineMedium,
      color: textDarkColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    headlineSmall: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.dark().textTheme.headlineSmall,
      color: textDarkColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    titleLarge: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.dark().textTheme.titleLarge,
      color: textDarkColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    titleMedium: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.dark().textTheme.titleMedium,
      color: textDarkColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    titleSmall: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.dark().textTheme.titleSmall,
      color: textDarkColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    bodyLarge: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.dark().textTheme.bodyLarge,
      color: textDarkColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    bodyMedium: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.dark().textTheme.bodyMedium,
      color: textDarkColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    bodySmall: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.dark().textTheme.bodySmall,
      color: hintDarkColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    labelLarge: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.dark().textTheme.labelLarge,
      color: textDarkColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    labelMedium: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.dark().textTheme.labelMedium,
      color: textDarkColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
    labelSmall: GoogleFonts.playfairDisplay(
      textStyle: ThemeData.dark().textTheme.labelSmall,
      color: textDarkColor,
      fontWeight: FontWeight.w500,
    ).copyWith(fontFamilyFallback: _fontFamilyFallback),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: darkBackgroundColor,
    foregroundColor: Colors.white,
    elevation: 2,
    shadowColor: Colors.white12,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: primaryColorDark,
    foregroundColor: Colors.black,
    elevation: 4,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade900,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: accentColorDark, width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: Colors.grey.shade700, width: 1.0),
    ),
    contentPadding: const EdgeInsets.symmetric(
      vertical: 16.0,
      horizontal: 20.0,
    ),
    hintStyle: TextStyle(color: hintDarkColor),
  ),
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    buttonColor: primaryColorDark,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColorDark,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      minimumSize: const Size(double.infinity, 56),
      elevation: 3,
      shadowColor: primaryColorDark.withOpacity(0.2),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryColorDark,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
    color: cardDarkColor,
    shadowColor: Colors.white.withOpacity(0.08),
  ),
  scaffoldBackgroundColor: darkBackgroundColor,
);
