import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [HasilGejalaSection] - Section daftar gejala terdeteksi.
///
/// Menampilkan checklist gejala dengan status terdeteksi (hijau)
/// atau tidak terdeteksi (abu-abu).
///
/// Parameter:
/// - [detected]: Daftar gejala yang terdeteksi.
/// - [notDetected]: Daftar gejala yang tidak terdeteksi.
class HasilGejalaSection extends StatelessWidget {
  final List<String> detected;
  final List<String> notDetected;

  const HasilGejalaSection({
    super.key,
    required this.detected,
    required this.notDetected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header section.
            const Row(
              children: [
                Text('📋', style: TextStyle(fontSize: 16)),
                SizedBox(width: 8),
                Text(
                  'Gejala Terdeteksi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            /// Gejala yang terdeteksi (hijau).
            ...detected.map((g) => _buildGejalaItem(g, true)),

            /// Gejala yang tidak terdeteksi (abu-abu).
            ...notDetected.map((g) => _buildGejalaItem(g, false)),
          ],
        ),
      ),
    );
  }

  /// Membangun satu baris gejala dengan checkbox.
  Widget _buildGejalaItem(String label, bool isDetected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          /// Checkbox icon.
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isDetected
                  ? AppColors.primary
                  : AppColors.background,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: isDetected
                    ? AppColors.primary
                    : AppColors.border,
                width: 1.5,
              ),
            ),
            child: isDetected
                ? const Icon(
                    Icons.check_rounded,
                    color: AppColors.white,
                    size: 16,
                  )
                : null,
          ),
          const SizedBox(width: 12),

          /// Label gejala.
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDetected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary.withValues(alpha: 0.6),
              fontWeight:
                  isDetected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
