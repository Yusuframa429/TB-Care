import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [HasilRekomendasiCard] - Kartu rekomendasi tindakan lanjutan.
///
/// Menampilkan pesan rekomendasi dari AI dan tombol CTA
/// untuk mencari fasilitas kesehatan terdekat.
///
/// Parameter:
/// - [message]: Teks rekomendasi.
/// - [onCariTap]: Callback saat tombol "Cari Fasyankes" ditekan.
class HasilRekomendasiCard extends StatelessWidget {
  final String message;
  final VoidCallback? onCariTap;

  const HasilRekomendasiCard({
    super.key,
    required this.message,
    this.onCariTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFFDE68A).withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header: ikon peringatan + judul.
            const Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFF59E0B),
                  size: 20,
                ),
                SizedBox(width: 6),
                Text('🩺', style: TextStyle(fontSize: 15)),
                SizedBox(width: 6),
                Text(
                  'Rekomendasi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Teks rekomendasi.
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            /// Tombol CTA: Cari Fasyankes Terdekat.
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onCariTap,
                icon: const Icon(Icons.location_on_outlined, size: 18),
                label: const Text(
                  'Cari Fasyankes Terdekat',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
