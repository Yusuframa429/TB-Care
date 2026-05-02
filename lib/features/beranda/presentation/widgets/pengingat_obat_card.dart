import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [PengingatObatCard] - Kartu pengingat minum obat di halaman Beranda.
///
/// Menampilkan informasi pengingat obat berupa judul pengingat,
/// waktu minum obat, dan status apakah sudah diminum atau belum.
///
/// Parameter:
/// - [title]: Judul pengingat (misal: "Pengingat Obat Malam").
/// - [time]: Waktu minum obat (misal: "20:00").
/// - [isTaken]: Status apakah obat sudah diminum atau belum.
/// - [onTap]: Callback saat kartu ditekan untuk melihat detail.
class PengingatObatCard extends StatelessWidget {
  /// Judul pengingat obat.
  final String title;

  /// Waktu yang dijadwalkan untuk minum obat (format: "HH:mm").
  final String time;

  /// Status apakah obat sudah diminum.
  /// `true` = sudah diminum, `false` = belum diminum.
  final bool isTaken;

  /// Callback saat kartu ditekan.
  final VoidCallback? onTap;

  const PengingatObatCard({
    super.key,
    required this.title,
    required this.time,
    this.isTaken = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            /// Ikon jam/alarm dalam lingkaran berwarna oranye.
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.access_time_filled,
                size: 22,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 14),

            /// Kolom tengah: Judul dan status waktu.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),

                  /// Baris status: waktu + status diminum/belum.
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '$time — ${isTaken ? 'Sudah diminum' : 'Belum diminum'}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isTaken ? AppColors.primary : AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Ikon panah kanan (chevron) untuk navigasi.
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
