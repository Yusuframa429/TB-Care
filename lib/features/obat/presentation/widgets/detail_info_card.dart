import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';
import 'info_row.dart';

/// [DetailInfoCard] - Kartu informasi umum obat.
///
/// Menampilkan frekuensi minum dan kondisi makan.
class DetailInfoCard extends StatelessWidget {
  final String frekuensi;
  final String kondisiMakan;

  const DetailInfoCard({
    super.key,
    required this.frekuensi,
    required this.kondisiMakan,
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
      child: Column(
        children: [
          InfoRow(
            icon: Icons.repeat_rounded,
            iconColor: AppColors.primary,
            label: 'Frekuensi',
            value: frekuensi,
          ),
          const Divider(height: 20, color: AppColors.border),
          InfoRow(
            icon: Icons.restaurant_rounded,
            iconColor: AppColors.warning,
            label: 'Kondisi Makan',
            value: kondisiMakan,
          ),
        ],
      ),
    );
  }
}
