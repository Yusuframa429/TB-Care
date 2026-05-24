import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/dokter_data.dart';

/// [DokterCard] - Kartu informasi dokter untuk mode Chat Dokter.
///
/// Menampilkan avatar inisial (lingkaran hijau), nama dokter,
/// spesialisasi, rating bintang, status ketersediaan, dan
/// tombol WhatsApp untuk memulai konsultasi.
///
/// Parameter:
/// - [dokter]: Objek [Dokter] yang berisi data dokter.
class DokterCard extends StatelessWidget {
  /// Data dokter yang akan ditampilkan.
  final Dokter dokter;

  const DokterCard({super.key, required this.dokter});

  /// Buka WhatsApp ke nomor dokter menggunakan url_launcher.
  Future<void> _openWhatsApp(BuildContext context) async {
    final url = Uri.parse(
      'https://wa.me/${dokter.nomorWhatsApp}?text=Halo Dokter, saya ingin berkonsultasi mengenai TBC.',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Tidak dapat membuka WhatsApp'),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

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
      child: Row(
        children: [
          /// Avatar inisial (lingkaran hijau).
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                dokter.inisial,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          /// Info dokter (nama, spesialisasi, rating + ketersediaan).
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Nama dokter.
                Text(
                  dokter.nama,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),

                /// Spesialisasi.
                Text(
                  dokter.spesialisasi,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4),

                /// Rating + ketersediaan.
                Row(
                  children: [
                    /// Bintang rating.
                    const Icon(
                      Icons.star_rounded,
                      size: 15,
                      color: Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      dokter.rating.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),

                    /// Dot hijau + teks ketersediaan.
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: dokter.isOnline
                            ? const Color(0xFF4ADE80)
                            : AppColors.textSecondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        dokter.ketersediaan,
                        style: TextStyle(
                          fontSize: 12,
                          color: dokter.isOnline
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          /// Tombol WhatsApp.
          GestureDetector(
            onTap: () => _openWhatsApp(context),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF25D366).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_rounded,
                color: Color(0xFF25D366),
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
