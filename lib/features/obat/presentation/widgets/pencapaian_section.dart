import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [PencapaianSection] - Section badge pencapaian pengobatan.
///
/// Menampilkan grid 3 kolom berisi badge pencapaian yang sudah
/// terbuka (unlocked) dan yang masih terkunci (locked).
///
/// Saat ini menggunakan data dummy.
class PencapaianSection extends StatelessWidget {
  const PencapaianSection({super.key});

  /// Data dummy pencapaian.
  static const List<Map<String, dynamic>> _pencapaian = [
    {
      'emoji': '🔥',
      'label': 'Streak 14 Hari',
      'unlocked': true,
      'bgColor': 0xFFFFF8E1,
    },
    {
      'emoji': '⭐',
      'label': 'Kepatuhan 90%+',
      'unlocked': true,
      'bgColor': 0xFFFFF8E1,
    },
    {
      'emoji': '🏆',
      'label': 'Seminggu Penuh',
      'unlocked': true,
      'bgColor': 0xFFFFF8E1,
    },
    {
      'emoji': '💎',
      'label': '1 Bulan Sempurna',
      'unlocked': false,
      'bgColor': 0xFFF3F4F6,
    },
    {
      'emoji': '😔',
      'label': '3 Bulan Konsisten',
      'unlocked': false,
      'bgColor': 0xFFF3F4F6,
    },
    {
      'emoji': '🎯',
      'label': 'Pengobatan Selesai',
      'unlocked': false,
      'bgColor': 0xFFF3F4F6,
    },
  ];

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header dengan tombol "Lihat Semua".
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text('🏅', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Text(
                    'Pencapaian',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Navigasi ke halaman semua pencapaian.
                },
                child: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          /// Grid pencapaian (2 baris x 3 kolom).
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: _pencapaian.length,
            itemBuilder: (context, index) {
              final item = _pencapaian[index];
              return _BadgeItem(
                emoji: item['emoji'] as String,
                label: item['label'] as String,
                isUnlocked: item['unlocked'] as bool,
                bgColor: Color(item['bgColor'] as int),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// [_BadgeItem] - Satu badge pencapaian dalam grid.
class _BadgeItem extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isUnlocked;
  final Color bgColor;

  const _BadgeItem({
    required this.emoji,
    required this.label,
    required this.isUnlocked,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.4,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnlocked
                ? const Color(0xFFFCD34D)
                : AppColors.border,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isUnlocked
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
