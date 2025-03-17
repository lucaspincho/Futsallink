import 'package:flutter/material.dart';
import 'colors.dart';

/// Classe que gerencia a fonte Unbounded para uso em todo o aplicativo
class UnboundedFont {
  /// Retorna a fonte Unbounded com as configurações especificadas
  static TextStyle get({
    double size = 16,
    FontWeight weight = FontWeight.normal,
    Color color = FutsallinkColors.textPrimary,
    double? height,
    TextDecoration? decoration,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'Unbounded',
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      decoration: decoration,
      letterSpacing: letterSpacing,
    );
  }

  /// Retorna a fonte Unbounded em peso light
  static TextStyle light({
    double size = 16,
    Color color = FutsallinkColors.textPrimary,
    double? height,
    TextDecoration? decoration,
    double? letterSpacing,
  }) {
    return get(
      size: size,
      weight: FontWeight.w300,
      color: color,
      height: height,
      decoration: decoration,
      letterSpacing: letterSpacing,
    );
  }

  /// Retorna a fonte Unbounded em peso regular
  static TextStyle regular({
    double size = 16,
    Color color = FutsallinkColors.textPrimary,
    double? height,
    TextDecoration? decoration,
    double? letterSpacing,
  }) {
    return get(
      size: size,
      weight: FontWeight.w400,
      color: color,
      height: height,
      decoration: decoration,
      letterSpacing: letterSpacing,
    );
  }

  /// Retorna a fonte Unbounded em peso medium
  static TextStyle medium({
    double size = 16,
    Color color = FutsallinkColors.textPrimary,
    double? height,
    TextDecoration? decoration,
    double? letterSpacing,
  }) {
    return get(
      size: size,
      weight: FontWeight.w500,
      color: color,
      height: height,
      decoration: decoration,
      letterSpacing: letterSpacing,
    );
  }

  /// Retorna a fonte Unbounded em peso semibold
  static TextStyle semiBold({
    double size = 16,
    Color color = FutsallinkColors.textPrimary,
    double? height,
    TextDecoration? decoration,
    double? letterSpacing,
  }) {
    return get(
      size: size,
      weight: FontWeight.w600,
      color: color,
      height: height,
      decoration: decoration,
      letterSpacing: letterSpacing,
    );
  }

  /// Retorna a fonte Unbounded em peso bold
  static TextStyle bold({
    double size = 16,
    Color color = FutsallinkColors.textPrimary,
    double? height,
    TextDecoration? decoration,
    double? letterSpacing,
  }) {
    return get(
      size: size,
      weight: FontWeight.w700,
      color: color,
      height: height,
      decoration: decoration,
      letterSpacing: letterSpacing,
    );
  }

  /// Retorna a fonte Unbounded em peso extraBold
  static TextStyle extraBold({
    double size = 16,
    Color color = FutsallinkColors.textPrimary,
    double? height,
    TextDecoration? decoration,
    double? letterSpacing,
  }) {
    return get(
      size: size,
      weight: FontWeight.w800,
      color: color,
      height: height,
      decoration: decoration,
      letterSpacing: letterSpacing,
    );
  }
}

class FutsallinkTypography {
  // Atualizar as definições existentes para usar a fonte Unbounded
  static final TextStyle headline1 = UnboundedFont.bold(
    size: 28,
    color: FutsallinkColors.textPrimary,
  );
  
  static final TextStyle headline2 = UnboundedFont.bold(
    size: 22,
    color: FutsallinkColors.textPrimary,
  );

  // Adicionar mais estilos de texto pré-definidos
  static final TextStyle headline3 = UnboundedFont.semiBold(
    size: 20,
    color: FutsallinkColors.textPrimary,
  );

  static final TextStyle subtitle1 = UnboundedFont.medium(
    size: 18,
    color: FutsallinkColors.textPrimary,
  );

  static final TextStyle subtitle2 = UnboundedFont.medium(
    size: 16,
    color: FutsallinkColors.textPrimary,
  );

  static final TextStyle body1 = UnboundedFont.regular(
    size: 16,
    color: FutsallinkColors.textPrimary,
  );

  static final TextStyle body2 = UnboundedFont.regular(
    size: 14,
    color: FutsallinkColors.textPrimary,
  );

  static final TextStyle button = UnboundedFont.medium(
    size: 16,
    color: Colors.white,
  );

  static final TextStyle caption = UnboundedFont.regular(
    size: 12,
    color: FutsallinkColors.textSecondary,
  );
}