import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// [KepatuhanObatCard] - Kartu kepatuhan minum obat di halaman Beranda.
///
/// Menampilkan progress bar persentase kepatuhan minum obat
/// dan informasi streak berturut-turut.
///
/// Parameter:
/// - [percentage]: Persentase kepatuhan (0-100).
/// - [streakDays]: Jumlah hari berturut-turut minum obat.
/// - [onTap]: Callback saat kartu ditekan untuk lihat detail kepatuhan.
class KepatuhanObatCard extends StatelessWidget {
  final double percentage;
  final int streakDays;
  final VoidCallback? onTap;

  const KepatuhanObatCard({
    super.key,
    required this.percentage,
    required this.streakDays,
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  FaIcon(FontAwesomeIcons.capsules, size: 16, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text('Kepatuhan Obat', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                ],
              ),
              Text('${percentage.toInt()}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              backgroundColor: AppColors.primaryLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text('Streak $streakDays hari — Luar biasa!', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
