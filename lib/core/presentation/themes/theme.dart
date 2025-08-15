import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF140A06),
    onSurface: Color(0xFFFBE4C8),

    primary: Color(0xFFFF9966),
    onPrimary: Color(0xFF3A241C),

    secondary: Color(0xFFD4B392),
    onSecondary: Color(0xFF1E120D),

    tertiary: Color(0xFFE36B2D),
    onTertiary: Color(0xFFFFF3E4),

    surfaceContainerLowest: Color(0xFF1C110B),
    surfaceContainerLow: Color(0xFF27160F),
    surfaceContainer: Color(0xFF2F1C14),
    surfaceContainerHigh: Color(0xFF372118),
    surfaceContainerHighest: Color(0xFF3F271C),

    primaryContainer: Color(0xFF4E2F24),
    onPrimaryContainer: Color(0xFFFFE0CC),

    secondaryContainer: Color(0xFF3E2A21),
    onSecondaryContainer: Color(0xFFF3DDC9),

    tertiaryContainer: Color(0xFF4F3A1F),
    onTertiaryContainer: Color(0xFFFFF1D6),

    outlineVariant: Color(0xFF9B735B),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      textStyle: WidgetStateProperty.resolveWith<TextStyle>((states) => const TextStyle(fontWeight: FontWeight.w700)),
    ),
  ),
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: true,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  ),
);

final lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFFFEED6),
    onSurface: Color(0xFF443026),
    primary: Color(0xFFD95D19),
    onPrimary: Color(0xFFFFEED6),
    secondary: Color(0xFF443026),
    onSecondary: Color(0xFFF6F2CC),
    onTertiary: Color(0xFF443026),
    surfaceContainerHighest: Color(0xFFFDE2C2),
    primaryContainer: Color(0xFFFFDBC8),
    onPrimaryContainer: Color(0xFF443026),
    secondaryContainer: Color(0xFFE6D1BF),
    onSecondaryContainer: Color(0xFF443026),
    tertiaryContainer: Color(0xFFF6F2CC),
    onTertiaryContainer: Color(0xFF443026),
    tertiary: Color(0xFFD95D19),
    outlineVariant: Color(0xFFDCC5AC),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      textStyle: WidgetStateProperty.resolveWith<TextStyle>((states) => const TextStyle(fontWeight: FontWeight.w700)),
    ),
  ),
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: true,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  ),
);
