import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// [SectionHeader] - Widget reusable untuk menampilkan header section
/// dengan judul di kiri dan tombol aksi (opsional) di kanan.
///
/// Digunakan di berbagai halaman seperti Beranda untuk bagian
/// "Riwayat Kesehatan", "Edukasi & Update", dll.
///
/// Parameter:
/// - [title]: Teks judul section (wajib).
/// - [emoji]: Emoji yang ditampilkan sebelum judul (opsional).
/// - [actionText]: Teks tombol aksi di kanan, misal "Lihat Semua" (opsional).
/// - [onActionTap]: Callback saat tombol aksi ditekan (opsional).
///
/// Contoh penggunaan:
/// ```dart
/// SectionHeader(
///   title: 'Riwayat Kesehatan',
///   emoji: '📊',
///   actionText: 'Lihat Semua',
///   onActionTap: () => print('Lihat semua'),
/// )
/// ```
class SectionHeader extends StatelessWidget {
  /// Teks judul utama section.
  final String title;

  /// Emoji yang ditampilkan sebelum judul (opsional).
  final String? emoji;

  /// Teks aksi di sisi kanan, misal "Lihat Semua" atau "Semua Artikel".
  final String? actionText;

  /// Callback yang dipanggil saat teks aksi ditekan.
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.emoji,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Baris kiri: Emoji (jika ada) + Judul.
          Row(
            children: [
              if (emoji != null) ...[
                Text(emoji!, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          /// Baris kanan: Tombol aksi (jika ada).
          if (actionText != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionText!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
