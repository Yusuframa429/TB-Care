import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [ObatProgressCard] - Kartu progress pengobatan TB di halaman Obat.
///
/// Menampilkan:
/// - Hari pengobatan saat ini dari total hari (misal: "Hari ke 14 dari 180")
/// - Persentase kepatuhan minum obat
/// - Progress bar visual
/// - Sisa hari menuju kesembuhan
///
/// Saat ini menggunakan data dummy.
class ObatProgressCard extends StatelessWidget {
  /// Hari pengobatan saat ini.
  final int hariKe;

  /// Total hari pengobatan (standar TBC = 180 hari).
  final int totalHari;

  /// Persentase kepatuhan (0-100).
  final int kepatuhanPersen;

  /// Label kualitas kepatuhan (misal: "Excellent").
  final String kualitasLabel;

  const ObatProgressCard({
    super.key,
    required this.hariKe,
    required this.totalHari,
    required this.kepatuhanPersen,
    required this.kualitasLabel,
  });

  @override
  Widget build(BuildContext context) {
    final progress = hariKe / totalHari;
    final sisaHari = totalHari - hariKe;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Baris atas: Hari ke & Kepatuhan.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Kiri: Hari pengobatan.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hari ke',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$hariKe',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                        height: 1,
                      ),
                    ),
                    Text(
                      'dari $totalHari',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),

              /// Kanan: Kepatuhan.
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Kepatuhan',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$kepatuhanPersen%',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                      height: 1,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        kualitasLabel,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text('⭐', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// Progress bar.
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.white.withValues(alpha: 0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),

          /// Label sisa hari.
          Text(
            '$sisaHari hari lagi menuju kesembuhan!',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
