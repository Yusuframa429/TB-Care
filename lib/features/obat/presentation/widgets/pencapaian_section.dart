import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [PencapaianSection] - Section grid badge pencapaian pengobatan.
///
/// Menerima [pencapaianList] berisi data badge dari [ObatRepository],
/// sehingga status unlocked berdasarkan data nyata (streak, kepatuhan, dll.).
///
/// Format setiap item dalam [pencapaianList]:
/// ```dart
/// {
///   'emoji': '🔥',
///   'label': 'Streak 14 Hari',
///   'unlocked': true,
///   'bgColor': 0xFFFFF8E1,
/// }
/// ```
class PencapaianSection extends StatelessWidget {
  /// Daftar pencapaian dari [ObatRepository.getPencapaian()].
  final List<Map<String, dynamic>> pencapaianList;

  const PencapaianSection({super.key, required this.pencapaianList});

  @override
  Widget build(BuildContext context) {
    // Gunakan data dummy jika pencapaianList kosong.
    final data = pencapaianList.isNotEmpty ? pencapaianList : _dummy;

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
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return _BadgeItem(
            emoji: item['emoji'] as String,
            label: item['label'] as String,
            isUnlocked: item['unlocked'] as bool,
            bgColor: Color(item['bgColor'] as int),
          );
        },
      ),
    );
  }

  /// Data dummy (dipakai jika pencapaianList kosong).
  static const List<Map<String, dynamic>> _dummy = [
    {
      'emoji': '🔥',
      'label': 'Streak 14 Hari',
      'unlocked': false,
      'bgColor': 0xFFF3F4F6,
    },
    {
      'emoji': '⭐',
      'label': 'Kepatuhan 90%+',
      'unlocked': false,
      'bgColor': 0xFFF3F4F6,
    },
    {
      'emoji': '🏆',
      'label': 'Seminggu Penuh',
      'unlocked': false,
      'bgColor': 0xFFF3F4F6,
    },
    {
      'emoji': '💎',
      'label': '1 Bulan Sempurna',
      'unlocked': false,
      'bgColor': 0xFFF3F4F6,
    },
    {
      'emoji': '🎯',
      'label': '3 Bulan Konsisten',
      'unlocked': false,
      'bgColor': 0xFFF3F4F6,
    },
    {
      'emoji': '🎓',
      'label': 'Pengobatan Selesai',
      'unlocked': false,
      'bgColor': 0xFFF3F4F6,
    },
  ];
}

/// [_BadgeItem] - Satu badge dalam grid pencapaian.
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
            color: isUnlocked ? const Color(0xFFFCD34D) : AppColors.border,
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
