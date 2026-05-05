import 'package:flutter/material.dart';
import 'app_colors.dart';

/// [AppTheme] - Kelas yang menyediakan konfigurasi tema global aplikasi.
///
/// Digunakan di `MaterialApp` sebagai parameter `theme` agar seluruh
/// widget di aplikasi otomatis mengikuti desain yang konsisten.
///
/// Contoh penggunaan:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.lightTheme,
/// )
/// ```
class AppTheme {
  AppTheme._(); // Private constructor, kelas ini tidak boleh di-instansiasi.

  /// Tema terang (light mode) untuk aplikasi TB Care.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.navbarActive,
        unselectedItemColor: AppColors.navbarInactive,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
