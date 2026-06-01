import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [StatistikKepatuhanCard] - Kartu statistik kepatuhan minum obat.
///
/// Menampilkan 3 statistik dalam satu baris:
/// - Kepatuhan hari ini (misal: "1/2")
/// - Kepatuhan minggu ini (misal: "13/14")
/// - Kepatuhan bulan ini (misal: "96%")
///
/// Saat ini menggunakan data dummy.
class StatistikKepatuhanCard extends StatelessWidget {
  /// Kepatuhan hari ini (format "X/Y").
  final String hariIni;

  /// Kepatuhan minggu ini (format "X/Y").
  final String mingguIni;

  /// Kepatuhan bulan ini (format "X%").
  final String bulanIni;

  const StatistikKepatuhanCard({
    super.key,
    required this.hariIni,
    required this.mingguIni,
    required this.bulanIni,
  });

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: _StatItem(
              value: hariIni,
              label: 'Hari Ini',
              showDivider: true,
            ),
          ),
          Expanded(
            child: _StatItem(
              value: mingguIni,
              label: 'Minggu Ini',
              showDivider: true,
            ),
          ),
          Expanded(
            child: _StatItem(
              value: bulanIni,
              label: 'Bulan Ini',
              showDivider: false,
            ),
          ),
        ],
      ),
    );
  }
}

/// [_StatItem] - Satu kolom statistik dengan nilai dan label.
class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final bool showDivider;

  const _StatItem({
    required this.value,
    required this.label,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        if (showDivider)
          Container(width: 1, height: 40, color: AppColors.border),
      ],
    );
  }
}
