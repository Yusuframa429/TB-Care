import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [HasilKonsultasiCard] - Section ajakan konsultasi dokter.
///
/// Menampilkan ajakan untuk chat dengan dokter spesialis paru
/// beserta tombol CTA hijau.
///
/// Parameter:
/// - [onChatTap]: Callback saat tombol "Chat dengan Dokter" ditekan.
class HasilKonsultasiCard extends StatelessWidget {
  final VoidCallback? onChatTap;

  const HasilKonsultasiCard({super.key, this.onChatTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Judul section.
          const Row(
            children: [
              Text('🩺', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Ingin konsultasi lebih lanjut?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          /// Subtitle.
          Text(
            'Chat dengan dokter spesialis paru kami 24/7',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 14),

          /// Tombol CTA: Chat dengan Dokter.
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onChatTap,
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
              label: const Text(
                'Chat dengan Dokter',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
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
    );
  }
}
