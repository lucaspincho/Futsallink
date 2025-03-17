import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';

ThemeData futsallinkDarkTheme() {
  // Define o texto base com a fonte Unbounded
  const defaultTextStyle = TextStyle(fontFamily: 'Unbounded');
  
  return ThemeData.dark().copyWith(
    scaffoldBackgroundColor: FutsallinkColors.darkBackground,
    primaryColor: FutsallinkColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: FutsallinkColors.primary,
      secondary: FutsallinkColors.primary,
      background: FutsallinkColors.darkBackground,
      surface: FutsallinkColors.cardBackground,
    ),
    // Configura a fonte padrão
    textTheme: TextTheme(
      displayLarge: FutsallinkTypography.headline1,
      displayMedium: FutsallinkTypography.headline2,
      displaySmall: FutsallinkTypography.headline3,
      headlineMedium: FutsallinkTypography.subtitle1,
      headlineSmall: FutsallinkTypography.subtitle2,
      bodyLarge: FutsallinkTypography.body1,
      bodyMedium: FutsallinkTypography.body2,
      labelLarge: FutsallinkTypography.button,
      bodySmall: FutsallinkTypography.caption,
    ).apply(
      fontFamily: 'Unbounded',
      bodyColor: FutsallinkColors.textPrimary,
      displayColor: FutsallinkColors.textPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: UnboundedFont.bold(
        size: 20,
        color: Colors.white,
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
        textStyle: UnboundedFont.medium(
          size: 16,
          color: Colors.white,
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: FutsallinkColors.primary,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: UnboundedFont.medium(size: 12),
      unselectedLabelStyle: UnboundedFont.regular(size: 12),
    ),
  );
}