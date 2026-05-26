import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

import '../../domain/entities/screening_result.dart';
import '../widgets/hasil_risk_card.dart';
import '../widgets/hasil_gejala_section.dart';
import '../widgets/hasil_rekomendasi_card.dart';
import '../widgets/hasil_konsultasi_card.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../chat/presentation/pages/chat_page.dart';

/// [HasilPemeriksaanPage] - Halaman hasil pemeriksaan Cek AI.
class HasilPemeriksaanPage extends StatelessWidget {
  final ScreeningResult result;

  const HasilPemeriksaanPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    // Tentukan label dan deskripsi berdasarkan risk level
    String riskLevelLabel;
    String riskDescription;
    String recommendationText;

    switch (result.riskLevel) {
      case RiskLevel.low:
        riskLevelLabel = 'RISIKO RENDAH';
        riskDescription = 'Kemungkinan TBC paru aktif rendah';
        recommendationText =
            'Pantau gejala 1-2 minggu. Jika memburuk, periksa ke fasyankes. Tetap jaga pola hidup sehat.';
        break;
      case RiskLevel.medium:
        riskLevelLabel = 'RISIKO SEDANG';
        riskDescription = 'Kemungkinan TBC paru aktif moderat';
        recommendationText =
            'Segera periksa ke Puskesmas/Klinik untuk pemeriksaan rontgen dada, tes dahak, dan konsultasi dokter.';
        break;
      case RiskLevel.high:
        riskLevelLabel = 'RISIKO TINGGI';
        riskDescription = 'Kemungkinan TBC paru aktif tinggi';
        recommendationText =
            'SEGERA ke Fasyankes / DOTS Center untuk pemeriksaan rontgen, tes sputum, dan tes TCM. Isolasi sementara jika batuk parah. Jangan menunda!';
        break;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Hasil Pemeriksaan',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Kartu risiko TBC.
            HasilRiskCard(
              riskLevel: riskLevelLabel,
              description: riskDescription,
              detectedCount: result.detectedSymptoms.length,
              totalCount: 6, // Total 6 gejala utama + sekunder
            ),
            const SizedBox(height: 20),

            /// Section gejala terdeteksi.
            HasilGejalaSection(
              detected: result.detectedSymptoms,
              notDetected: result.notDetectedSymptoms,
            ),
            const SizedBox(height: 20),

            /// Kartu rekomendasi.
            HasilRekomendasiCard(
              message: recommendationText,
              onCariTap: () async {
                final uri = Uri.parse(
                    'https://www.google.com/maps/search/?api=1&query=puskesmas');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Tidak dapat membuka Google Maps')),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 24),

            /// Section konsultasi dokter.
            HasilKonsultasiCard(
              onChatTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatPage()),
                );
              },
            ),
            const SizedBox(height: 24),

            /// Disclaimer Penting.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Aplikasi ini hanya alat skrining awal berbasis gejala. Ini BUKAN diagnosis medis definitif. Hasil skrining tidak menggantikan pemeriksaan dokter.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary.withValues(alpha: 0.8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// Badge AI Certified.
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'AI Certified — Verified by Kemenkes RI',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
