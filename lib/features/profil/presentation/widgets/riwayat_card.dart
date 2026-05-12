import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [RiwayatCard] - Kartu riwayat pemeriksaan individual.
///
/// Menampilkan informasi satu pemeriksaan (AI Check atau Konsultasi)
/// dengan ikon tipe, tanggal, deskripsi, status badge, dan tombol aksi.
///
/// Parameter:
/// - [type]: Jenis pemeriksaan ('AI Check' atau 'Konsultasi').
/// - [date]: Tanggal pemeriksaan.
/// - [status]: Status hasil ('SEDANG', 'RENDAH', 'Selesai').
/// - [description]: Deskripsi singkat (misal: '3/6 gejala terdeteksi').
/// - [actionLabel]: Label tombol aksi ('Lihat Detail' / 'Lihat Rekaman').
/// - [onActionTap]: Callback saat tombol aksi ditekan.
class RiwayatCard extends StatelessWidget {
  final String type;
  final String date;
  final String status;
  final String description;
  final String actionLabel;
  final VoidCallback? onActionTap;

  const RiwayatCard({
    super.key,
    required this.type,
    required this.date,
    required this.status,
    required this.description,
    required this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Baris atas: Ikon + Judul + Status Badge.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Ikon tipe pemeriksaan.
              _buildTypeIcon(),
              const SizedBox(width: 12),

              /// Judul dan tanggal.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              /// Status badge.
              _buildStatusBadge(),
            ],
          ),
          const SizedBox(height: 10),

          /// Deskripsi (misal: '3/6 gejala terdeteksi' atau nama dokter).
          Padding(
            padding: const EdgeInsets.only(left: 52),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 8),

          /// Tombol aksi ("Lihat Detail →" / "Lihat Rekaman →").
          Padding(
            padding: const EdgeInsets.only(left: 52),
            child: GestureDetector(
              onTap: onActionTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun ikon tipe pemeriksaan.
  ///
  /// AI Check → ikon brain/medical, Konsultasi → ikon chat/comment.
  Widget _buildTypeIcon() {
    final bool isAiCheck = type == 'AI Check';
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isAiCheck ? AppColors.primaryLight : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isAiCheck ? Icons.psychology_outlined : Icons.chat_bubble_outline,
        size: 20,
        color: isAiCheck ? AppColors.primary : AppColors.textSecondary,
      ),
    );
  }

  /// Membangun badge status pemeriksaan.
  ///
  /// Warna disesuaikan berdasarkan status:
  /// - 'SEDANG' → oranye (warning).
  /// - 'RENDAH' → hijau (primary).
  /// - 'Selesai' → hijau (primary).
  Widget _buildStatusBadge() {
    Color textColor;
    Color bgColor;

    switch (status.toUpperCase()) {
      case 'SEDANG':
        textColor = AppColors.warning;
        bgColor = AppColors.warningLight;
        break;
      case 'TINGGI':
        textColor = AppColors.danger;
        bgColor = AppColors.dangerLight;
        break;
      case 'RENDAH':
        textColor = AppColors.primary;
        bgColor = AppColors.primaryLight;
        break;
      case 'SELESAI':
        textColor = AppColors.primary;
        bgColor = AppColors.primaryLight;
        break;
      default:
        textColor = AppColors.textSecondary;
        bgColor = const Color(0xFFF3F4F6);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
