import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LightModeColors {
  // Warm, energetic coral and orange palette
  static const lightPrimary = Color(0xFFFF6B6B); // Coral red
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFFFFE5E5); // Soft coral background
  static const lightOnPrimaryContainer = Color(0xFF8B0000); // Dark red text
  static const lightSecondary = Color(0xFFFF8C42); // Vibrant orange
  static const lightOnSecondary = Color(0xFFFFFFFF);
  static const lightTertiary = Color(0xFFFFD93D); // Golden amber
  static const lightOnTertiary = Color(0xFF2D2D2D);
  static const lightError = Color(0xFFE74C3C); // Bright red
  static const lightOnError = Color(0xFFFFFFFF);
  static const lightErrorContainer = Color(0xFFFFE5E5);
  static const lightOnErrorContainer = Color(0xFF8B0000);
  static const lightInversePrimary = Color(0xFFFF8C42);
  static const lightShadow = Color(0x1A000000);
  static const lightSurface = Color(0xFFFFFBFE);
  static const lightOnSurface = Color(0xFF2D2D2D);
  static const lightAppBarBackground = Color(0xFFFFFBFE);
  static const accent = Color(0xFFFFD93D); // Golden accent
  static const lightSurfaceVariant = Color(0xFFFFF5F5); // Very light coral
  static const lightOutline = Color(0xFFFFB4C8); // Soft coral outline
}

class DarkModeColors {
  // Warm dark mode with coral and orange accents
  static const darkPrimary = Color(0xFFFF6B6B); // Same coral for consistency
  static const darkOnPrimary = Color(0xFF000000);
  static const darkPrimaryContainer = Color(0xFF8B0000); // Dark red container
  static const darkOnPrimaryContainer = Color(0xFFFFE5E5);
  static const darkSecondary = Color(0xFFFF8C42); // Vibrant orange
  static const darkOnSecondary = Color(0xFF000000);
  static const darkTertiary = Color(0xFFFFD93D); // Golden amber
  static const darkOnTertiary = Color(0xFF000000);
  static const darkError = Color(0xFFFF6B6B);
  static const darkOnError = Color(0xFF000000);
  static const darkErrorContainer = Color(0xFF8B0000);
  static const darkOnErrorContainer = Color(0xFFFFE5E5);
  static const darkInversePrimary = Color(0xFFFF8C42);
  static const darkShadow = Color(0x33000000);
  static const darkSurface = Color(0xFF1A1A1A);
  static const darkOnSurface = Color(0xFFE8E8E8);
  static const darkAppBarBackground = Color(0xFF1A1A1A);
  static const accent = Color(0xFFFFD93D); // Golden accent
  static const darkSurfaceVariant = Color(0xFF2A1A1A); // Dark coral background
  static const darkOutline = Color(0xFFFF6B6B); // Coral outline
}

class FontSizes {
  static const double displayLarge = 57.0;
  static const double displayMedium = 45.0;
  static const double displaySmall = 36.0;
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 24.0;
  static const double headlineSmall = 22.0;
  static const double titleLarge = 22.0;
  static const double titleMedium = 18.0;
  static const double titleSmall = 16.0;
  static const double labelLarge = 16.0;
  static const double labelMedium = 14.0;
  static const double labelSmall = 12.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
}

ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: LightModeColors.lightPrimary,
    onPrimary: LightModeColors.lightOnPrimary,
    primaryContainer: LightModeColors.lightPrimaryContainer,
    onPrimaryContainer: LightModeColors.lightOnPrimaryContainer,
    secondary: LightModeColors.lightSecondary,
    onSecondary: LightModeColors.lightOnSecondary,
    tertiary: LightModeColors.lightTertiary,
    onTertiary: LightModeColors.lightOnTertiary,
    error: LightModeColors.lightError,
    onError: LightModeColors.lightOnError,
    errorContainer: LightModeColors.lightErrorContainer,
    onErrorContainer: LightModeColors.lightOnErrorContainer,
    inversePrimary: LightModeColors.lightInversePrimary,
    shadow: LightModeColors.lightShadow,
    surface: LightModeColors.lightSurface,
    onSurface: LightModeColors.lightOnSurface,
    surfaceContainerHighest: LightModeColors.lightSurfaceVariant,
    outline: LightModeColors.lightOutline,
  ),
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: LightModeColors.lightAppBarBackground,
    foregroundColor: LightModeColors.lightOnPrimaryContainer,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 8,
    shadowColor: LightModeColors.lightPrimary.withOpacity(0.2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 8,
      shadowColor: LightModeColors.lightPrimary.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      elevation: 8,
      shadowColor: LightModeColors.lightPrimary.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: LightModeColors.lightOutline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: LightModeColors.lightOutline.withOpacity(0.5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: LightModeColors.lightPrimary, width: 2),
    ),
    filled: true,
    fillColor: LightModeColors.lightSurfaceVariant,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: FontSizes.displayLarge,
      fontWeight: FontWeight.normal,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: FontSizes.displayMedium,
      fontWeight: FontWeight.normal,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: FontSizes.displaySmall,
      fontWeight: FontWeight.w600,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: FontSizes.headlineLarge,
      fontWeight: FontWeight.normal,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: FontSizes.headlineMedium,
      fontWeight: FontWeight.w500,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: FontSizes.headlineSmall,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: FontSizes.titleLarge,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: FontSizes.titleMedium,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: FontSizes.titleSmall,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: FontSizes.labelLarge,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: FontSizes.labelMedium,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: FontSizes.labelSmall,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: FontSizes.bodyLarge,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: FontSizes.bodyMedium,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: FontSizes.bodySmall,
      fontWeight: FontWeight.normal,
    ),
  ),
);

ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: DarkModeColors.darkPrimary,
    onPrimary: DarkModeColors.darkOnPrimary,
    primaryContainer: DarkModeColors.darkPrimaryContainer,
    onPrimaryContainer: DarkModeColors.darkOnPrimaryContainer,
    secondary: DarkModeColors.darkSecondary,
    onSecondary: DarkModeColors.darkOnSecondary,
    tertiary: DarkModeColors.darkTertiary,
    onTertiary: DarkModeColors.darkOnTertiary,
    error: DarkModeColors.darkError,
    onError: DarkModeColors.darkOnError,
    errorContainer: DarkModeColors.darkErrorContainer,
    onErrorContainer: DarkModeColors.darkOnErrorContainer,
    inversePrimary: DarkModeColors.darkInversePrimary,
    shadow: DarkModeColors.darkShadow,
    surface: DarkModeColors.darkSurface,
    onSurface: DarkModeColors.darkOnSurface,
    surfaceContainerHighest: DarkModeColors.darkSurfaceVariant,
    outline: DarkModeColors.darkOutline,
  ),
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    backgroundColor: DarkModeColors.darkAppBarBackground,
    foregroundColor: DarkModeColors.darkOnPrimaryContainer,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 8,
    shadowColor: DarkModeColors.darkPrimary.withOpacity(0.3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 8,
      shadowColor: DarkModeColors.darkPrimary.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      elevation: 8,
      shadowColor: DarkModeColors.darkPrimary.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: DarkModeColors.darkOutline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: DarkModeColors.darkOutline.withOpacity(0.5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: DarkModeColors.darkPrimary, width: 2),
    ),
    filled: true,
    fillColor: DarkModeColors.darkSurfaceVariant,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: FontSizes.displayLarge,
      fontWeight: FontWeight.normal,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: FontSizes.displayMedium,
      fontWeight: FontWeight.normal,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: FontSizes.displaySmall,
      fontWeight: FontWeight.w600,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: FontSizes.headlineLarge,
      fontWeight: FontWeight.normal,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: FontSizes.headlineMedium,
      fontWeight: FontWeight.w500,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: FontSizes.headlineSmall,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: FontSizes.titleLarge,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: FontSizes.titleMedium,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: FontSizes.titleSmall,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: FontSizes.labelLarge,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: FontSizes.labelMedium,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: FontSizes.labelSmall,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: FontSizes.bodyLarge,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: FontSizes.bodyMedium,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: FontSizes.bodySmall,
      fontWeight: FontWeight.normal,
    ),
  ),
);
