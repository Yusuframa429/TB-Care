import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// [HasilRiskCard] - Kartu risiko TBC di halaman Hasil Pemeriksaan.
///
/// Menampilkan ikon paru-paru, level risiko (badge), deskripsi,
/// jumlah gejala terdeteksi, dan dot indicator visualisasi risiko.
///
/// Parameter:
/// - [riskLevel]: Label level risiko (misal: "RISIKO SEDANG").
/// - [description]: Deskripsi singkat hasil (misal: "Perlu pemeriksaan lanjutan").
/// - [detectedCount]: Jumlah gejala yang terdeteksi.
/// - [totalCount]: Jumlah total gejala yang diperiksa.
class HasilRiskCard extends StatelessWidget {
  final String riskLevel;
  final String description;
  final int detectedCount;
  final int totalCount;

  const HasilRiskCard({
    super.key,
    required this.riskLevel,
    required this.description,
    required this.detectedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFFDE68A).withValues(alpha: 0.6),
          ),
        ),
        child: Column(
          children: [
            /// Ikon paru-paru.
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFFED7AA).withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.lungs,
                  color: Color(0xFFEA580C),
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// Badge level risiko.
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                riskLevel,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// Deskripsi hasil.
            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),

            /// Jumlah gejala terdeteksi.
            Text(
              '$detectedCount/$totalCount gejala TBC terdeteksi',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 14),

            /// Dot indicator visualisasi risiko.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalCount, (index) {
                final bool isFilled = index < detectedCount;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isFilled
                          ? const Color(0xFFF59E0B)
                          : AppColors.border,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
