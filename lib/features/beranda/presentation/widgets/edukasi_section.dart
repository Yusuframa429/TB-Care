import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [EdukasiSection] - Section edukasi dan artikel di halaman Beranda.
///
/// Menampilkan dua kartu artikel tentang TBC secara horizontal.
class EdukasiSection extends StatelessWidget {
  final VoidCallback? onSemuaArtikel;

  const EdukasiSection({super.key, this.onSemuaArtikel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'Edukasi & Update',
          emoji: '🔥',
          actionText: 'Semua Artikel',
          onActionTap: onSemuaArtikel,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: _ArtikelCard(
                  emoji: '🫁',
                  category: 'Edukasi',
                  categoryColor: AppColors.badgeEdukasi,
                  categoryBgColor: AppColors.badgeEdukasiLight,
                  title: 'Mengenal TBC: Gejala & Cara Pencegahan',
                  readTime: '3 menit',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ArtikelCard(
                  emoji: '🥗',
                  category: 'Nutrisi',
                  categoryColor: AppColors.badgeNutrisi,
                  categoryBgColor: AppColors.badgeNutrisiLight,
                  title: 'Pola Makan Sehat Pengobatan TBC',
                  readTime: '5 menit',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// [_ArtikelCard] - Kartu artikel edukasi individual.
class _ArtikelCard extends StatelessWidget {
  final String emoji;
  final String category;
  final Color categoryColor;
  final Color categoryBgColor;
  final String title;
  final String readTime;

  const _ArtikelCard({
    required this.emoji,
    required this.category,
    required this.categoryColor,
    required this.categoryBgColor,
    required this.title,
    required this.readTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Emoji representatif artikel.
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 10),

          /// Badge kategori (Edukasi / Nutrisi).
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: categoryBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              category,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: categoryColor),
            ),
          ),
          const SizedBox(height: 8),

          /// Judul artikel.
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.3),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          /// Durasi baca.
          Row(
            children: [
              const Icon(Icons.schedule, size: 12, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(readTime, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}
