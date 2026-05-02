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

  /// Warna utama versi gelap, digunakan untuk gradient header.
  static const Color primaryDark = Color(0xFF1B5E3E);

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

  /// Warna warning/peringatan (oranye), digunakan untuk pengingat obat.
  static const Color warning = Color(0xFFF59E0B);

  /// Warna warning versi terang, digunakan untuk background ikon peringatan.
  static const Color warningLight = Color(0xFFFFF8E1);

  /// Warna danger/bahaya (merah), digunakan untuk status "belum diminum".
  static const Color danger = Color(0xFFEF4444);

  /// Warna danger versi terang.
  static const Color dangerLight = Color(0xFFFEE2E2);

  /// Warna info (biru-teal), digunakan untuk kartu "Tahukah Anda?".
  static const Color info = Color(0xFF0EA5E9);

  /// Warna info versi terang.
  static const Color infoLight = Color(0xFFE0F2FE);

  /// Warna badge kategori "Edukasi" (merah muda).
  static const Color badgeEdukasi = Color(0xFFE74C3C);

  /// Warna background badge kategori "Edukasi".
  static const Color badgeEdukasiLight = Color(0xFFFDECEC);

  /// Warna badge kategori "Nutrisi" (hijau).
  static const Color badgeNutrisi = Color(0xFF27AE60);

  /// Warna background badge kategori "Nutrisi".
  static const Color badgeNutrisiLight = Color(0xFFE8F8F0);

  /// Warna background kartu (putih dengan sedikit warmth).
  static const Color cardBackground = Color(0xFFFFFFFF);

  /// Warna shadow kartu.
  static const Color cardShadow = Color(0x0A000000);
}
