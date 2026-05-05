import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// [CekAiCard] - Kartu promosi fitur Cek AI di halaman Beranda.
///
/// Menampilkan informasi tentang fitur skrining gejala TBC menggunakan AI,
/// beserta badge "AI Aktif", ikon paru-paru, dan tombol CTA "Mulai Pemeriksaan".
///
/// Parameter:
/// - [onStartTap]: Callback saat tombol "Mulai Pemeriksaan" ditekan.
class CekAiCard extends StatelessWidget {
  /// Callback yang dipanggil saat user menekan tombol "Mulai Pemeriksaan".
  final VoidCallback? onStartTap;

  const CekAiCard({super.key, this.onStartTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Baris atas: Label "TBC CHECK AI" dan badge "AI Aktif".
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Label dengan ikon stetoskop.
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.stethoscope,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'TBC CHECK AI',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),

              /// Badge "AI Aktif" berwarna hijau.
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 6, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'AI Aktif',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// Baris tengah: Judul & deskripsi (kiri) + Ikon paru-paru (kanan).
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Kolom kiri: Judul dan deskripsi.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cek Gejala dengan\nAsisten Pintar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Analisis gejala TBC secara akurat menggunakan AI dalam hitungan menit',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              /// Ikon paru-paru representatif.
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0ED),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.lungs,
                  size: 36,
                  color: Color(0xFFE88B76),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// Tombol CTA "Mulai Pemeriksaan".
          GestureDetector(
            onTap: onStartTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Mulai Pemeriksaan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward, size: 16, color: AppColors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
