import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'app_colors.dart';

part 'app_theme.g.dart';

@riverpod
class AppTheme extends _$AppTheme {
  @override
  ThemeData build() {
    return _lightTheme;
  }

  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.forestGreen,
      primary: AppColors.forestGreen,
      secondary: AppColors.leafGreen,
      surface: AppColors.offWhite,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.offWhite,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.forestGreen,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.earthBrown,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(color: AppColors.earthBrown),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.forestGreen,
        foregroundColor: Colors.white,
      ),
    ),
  );
}
