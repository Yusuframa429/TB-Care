import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [DetailStatistikCard] - Kartu kepatuhan 30 hari terakhir.
///
/// Menampilkan circular progress, persentase, label kualitas,
/// dan jumlah dosis yang diminum dari total dosis.
class DetailStatistikCard extends StatelessWidget {
  final int persen;
  final int diminum;
  final int total;

  const DetailStatistikCard({
    super.key,
    required this.persen,
    required this.diminum,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final label = persen >= 90
        ? 'Baik Sekali'
        : persen >= 75
        ? 'Baik'
        : persen >= 50
        ? 'Cukup'
        : 'Perlu Ditingkatkan';
    final warna = persen >= 90
        ? AppColors.primary
        : persen >= 75
        ? AppColors.info
        : persen >= 50
        ? AppColors.warning
        : AppColors.danger;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: persen / 100,
                    strokeWidth: 5,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(warna),
                  ),
                ),
                Text(
                  '$persen%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: warna,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: warna,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$diminum dari $total dosis diminum',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
