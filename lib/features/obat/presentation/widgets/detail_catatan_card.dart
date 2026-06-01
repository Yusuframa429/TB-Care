import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [DetailCatatanCard] - Kartu catatan pribadi obat.
///
/// Menampilkan catatan pengguna dalam format yang rapi.
/// Hanya ditampilkan jika catatan tidak kosong.
class DetailCatatanCard extends StatelessWidget {
  final String catatan;

  const DetailCatatanCard({super.key, required this.catatan});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.notes_rounded,
            size: 20,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              catatan,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
