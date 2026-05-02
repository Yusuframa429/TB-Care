import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [TahukahAndaCard] - Kartu fakta menarik tentang TBC di halaman Beranda.
///
/// Menampilkan informasi edukatif singkat dengan desain yang menarik
/// menggunakan warna biru-teal (info).
class TahukahAndaCard extends StatelessWidget {
  final String fact;

  const TahukahAndaCard({super.key, required this.fact});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Ikon lampu/ide.
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('💡', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tahukah Anda?',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.info),
                ),
                const SizedBox(height: 6),
                Text(
                  fact,
                  style: TextStyle(fontSize: 13, color: AppColors.textPrimary.withValues(alpha: 0.8), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
