import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [CekAiStepIndicator] - Widget indikator langkah proses Cek AI.
///
/// Menampilkan 3 langkah: ① Gejala → ② Detail → ③ Analisis.
/// Langkah aktif ditandai dengan warna hijau, sisanya abu-abu.
///
/// Parameter:
/// - [currentStep]: Langkah yang sedang aktif (1, 2, atau 3).
class CekAiStepIndicator extends StatelessWidget {
  final int currentStep;

  const CekAiStepIndicator({super.key, this.currentStep = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      color: AppColors.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStep(number: 1, label: 'Gejala'),
          _buildChevron(),
          _buildStep(number: 2, label: 'Detail'),
          _buildChevron(),
          _buildStep(number: 3, label: 'Analisis'),
        ],
      ),
    );
  }

  /// Membangun satu item langkah (nomor + label).
  Widget _buildStep({required int number, required String label}) {
    final bool isActive = number <= currentStep;
    final Color color = isActive ? AppColors.primary : AppColors.textSecondary;

    return Row(
      children: [
        /// Lingkaran nomor langkah.
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.border,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isActive ? AppColors.white : AppColors.textSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),

        /// Label langkah.
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Chevron separator (>) antar langkah.
  Widget _buildChevron() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Icon(
        Icons.chevron_right_rounded,
        size: 18,
        color: AppColors.textSecondary.withValues(alpha: 0.4),
      ),
    );
  }
}
