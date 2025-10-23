/*
 * Fitto - Your Personal Fitness Companion
 * Copyright (C) 2025 Deepen Black
 * All rights reserved.
 */

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// Fitto Color Scheme - Warm, energetic colors for motivation
// Primary: Warm Orange - Energy and vitality
// Secondary: Coral Red - Passion and determination
// Tertiary: Golden Yellow - Success and achievement

const Color wgerPrimaryColor = Color(0xffF57C00); // Warm Orange
const Color wgerPrimaryButtonColor = Color(0xffFF6F00); // Vibrant Orange
const Color wgerPrimaryColorLight = Color(0xffFFB74D); // Light Orange
const Color wgerSecondaryColor = Color(0xffFF5722); // Coral Red
const Color wgerSecondaryColorLight = Color(0xffFF8A65); // Light Coral
const Color wgerTertiaryColor = Color(0xffFFC107); // Golden Yellow

const FlexSubThemesData wgerSubThemeData = FlexSubThemesData(
  fabSchemeColor: SchemeColor.secondary,
  inputDecoratorBorderType: FlexInputBorderType.underline,
  inputDecoratorIsFilled: false,
  useMaterial3Typography: true,
  appBarScrolledUnderElevation: 4,
  navigationBarIndicatorOpacity: 0.24,
  navigationBarHeight: 56,
  // Rounded corners for modern, friendly UI
  defaultRadius: 16.0,
  cardRadius: 20.0,
  dialogRadius: 24.0,
  fabRadius: 28.0,
  chipRadius: 16.0,
  buttonRadius: 16.0,
);

const String wgerDisplayFont = 'RobotoCondensed';
const List<FontVariation> displayFontBoldWeight = [FontVariation('wght', 600)];
const List<FontVariation> displayFontHeavyWeight = [FontVariation('wght', 800)];

// Make a light ColorScheme from the seeds.
final ColorScheme schemeLight = SeedColorScheme.fromSeeds(
  primary: wgerPrimaryColor,
  primaryKey: wgerPrimaryColor,
  secondaryKey: wgerSecondaryColor,
  secondary: wgerSecondaryColor,
  tertiaryKey: wgerTertiaryColor,
  brightness: Brightness.light,
  tones: FlexTones.vivid(Brightness.light),
);

// Make a dark ColorScheme from the seeds.
final ColorScheme schemeDark = SeedColorScheme.fromSeeds(
  // primary: wgerPrimaryColor,
  primaryKey: wgerPrimaryColor,
  secondaryKey: wgerSecondaryColor,
  secondary: wgerSecondaryColor,
  brightness: Brightness.dark,
  tones: FlexTones.vivid(Brightness.dark),
);

// Make a high contrast light ColorScheme from the seeds
final ColorScheme schemeLightHc = SeedColorScheme.fromSeeds(
  primaryKey: wgerPrimaryColor,
  secondaryKey: wgerSecondaryColor,
  brightness: Brightness.light,
  tones: FlexTones.ultraContrast(Brightness.light),
);

// Make a ultra contrast dark ColorScheme from the seeds.
final ColorScheme schemeDarkHc = SeedColorScheme.fromSeeds(
  primaryKey: wgerPrimaryColor,
  secondaryKey: wgerSecondaryColor,
  brightness: Brightness.dark,
  tones: FlexTones.ultraContrast(Brightness.dark),
);

const wgerTextTheme = TextTheme(
  displayLarge: TextStyle(
    fontFamily: wgerDisplayFont,
    fontVariations: displayFontHeavyWeight,
  ),
  displayMedium: TextStyle(
    fontFamily: wgerDisplayFont,
    fontVariations: displayFontHeavyWeight,
  ),
  displaySmall: TextStyle(
    fontFamily: wgerDisplayFont,
    fontVariations: displayFontHeavyWeight,
  ),
  headlineLarge: TextStyle(
    fontFamily: wgerDisplayFont,
    fontVariations: displayFontBoldWeight,
  ),
  headlineMedium: TextStyle(
    fontFamily: wgerDisplayFont,
    fontVariations: displayFontBoldWeight,
  ),
  headlineSmall: TextStyle(
    fontFamily: wgerDisplayFont,
    fontVariations: displayFontBoldWeight,
  ),
  titleLarge: TextStyle(
    fontFamily: wgerDisplayFont,
    fontVariations: displayFontBoldWeight,
  ),
  titleMedium: TextStyle(
    fontFamily: wgerDisplayFont,
    fontVariations: displayFontBoldWeight,
  ),
  titleSmall: TextStyle(
    fontFamily: wgerDisplayFont,
    fontVariations: displayFontBoldWeight,
  ),
);

final wgerLightTheme = FlexThemeData.light(
  colorScheme: schemeLight,
  useMaterial3: true,
  appBarStyle: FlexAppBarStyle.primary,
  subThemesData: wgerSubThemeData,
  textTheme: wgerTextTheme,
);

final wgerDarkTheme = FlexThemeData.dark(
  colorScheme: schemeDark,
  useMaterial3: true,
  subThemesData: wgerSubThemeData,
  textTheme: wgerTextTheme,
);

final wgerLightThemeHc = FlexThemeData.light(
  colorScheme: schemeLightHc,
  useMaterial3: true,
  appBarStyle: FlexAppBarStyle.primary,
  subThemesData: wgerSubThemeData,
  textTheme: wgerTextTheme,
);

final wgerDarkThemeHc = FlexThemeData.dark(
  colorScheme: schemeDarkHc,
  useMaterial3: true,
  subThemesData: wgerSubThemeData,
  textTheme: wgerTextTheme,
);

CalendarStyle getWgerCalendarStyle(ThemeData theme) {
  return CalendarStyle(
    outsideDaysVisible: false,
    todayDecoration: const BoxDecoration(
      color: Colors.amber,
      shape: BoxShape.circle,
    ),
    markerDecoration: BoxDecoration(
      color: theme.textTheme.headlineLarge?.color,
      shape: BoxShape.circle,
    ),
    selectedDecoration: const BoxDecoration(
      color: wgerSecondaryColor,
      shape: BoxShape.circle,
    ),
    rangeStartDecoration: const BoxDecoration(
      color: wgerSecondaryColor,
      shape: BoxShape.circle,
    ),
    rangeEndDecoration: const BoxDecoration(
      color: wgerSecondaryColor,
      shape: BoxShape.circle,
    ),
    rangeHighlightColor: wgerSecondaryColorLight,
    weekendTextStyle: const TextStyle(color: wgerSecondaryColor),
  );
}
