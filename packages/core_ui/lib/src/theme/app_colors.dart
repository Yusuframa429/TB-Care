import 'package:flutter/material.dart';

/// [AppColors] - Kelas yang menyimpan seluruh konstanta warna aplikasi TB Care.
///
/// Gunakan kelas ini sebagai single source of truth untuk warna
/// agar konsistensi desain terjaga di seluruh tim.
///
/// Contoh penggunaan:
/// ```dart
/// Container(color: AppColors.primary)
/// ```
class AppColors {
  AppColors._(); // Private constructor, kelas ini tidak boleh di-instansiasi.

  /// Warna utama aplikasi (hijau TB Care).
  static const Color primary = Color(0xFF2E7D5B);

  /// Warna utama versi terang, digunakan untuk background aktif pada navbar.
  static const Color primaryLight = Color(0xFFE8F5EE);

  /// Warna teks/ikon yang sedang aktif pada navbar.
  static const Color navbarActive = Color(0xFF2E7D5B);

  /// Warna teks/ikon yang tidak aktif pada navbar.
  static const Color navbarInactive = Color(0xFF9E9E9E);

  /// Warna background utama aplikasi.
  static const Color background = Color(0xFFF9FAFB);

  /// Warna putih standar.
  static const Color white = Color(0xFFFFFFFF);

  /// Warna teks utama (gelap).
  static const Color textPrimary = Color(0xFF1A1A2E);

  /// Warna teks sekunder (abu-abu).
  static const Color textSecondary = Color(0xFF6B7280);

  /// Warna border/divider umum.
  static const Color border = Color(0xFFE5E7EB);
}
