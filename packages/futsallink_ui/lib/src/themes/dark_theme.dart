import 'package:flutter/material.dart';
import '../tokens/colors.dart';

ThemeData futsallinkDarkTheme() {
  return ThemeData.dark().copyWith(
    scaffoldBackgroundColor: FutsallinkColors.darkBackground,
    primaryColor: FutsallinkColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: FutsallinkColors.primary,
      secondary: FutsallinkColors.primary,
      background: FutsallinkColors.darkBackground,
      surface: FutsallinkColors.cardBackground,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: FutsallinkColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: FutsallinkColors.primary,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    ),
  );
}