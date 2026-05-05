import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [EmergencySosCard] - Kartu darurat/emergency SOS di halaman Profil.
///
/// Menampilkan kartu berwarna salmon/coral yang bisa ditekan
/// untuk menghubungi bantuan darurat.
///
/// Parameter:
/// - [onTap]: Callback saat kartu ditekan.
class EmergencySosCard extends StatelessWidget {
  final VoidCallback? onTap;

  const EmergencySosCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFEEAEA),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFDD5D5)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF87171).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFEF4444),
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🚨 Darurat / Emergency SOS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Butuh bantuan segera? Tap untuk menghubungi',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
