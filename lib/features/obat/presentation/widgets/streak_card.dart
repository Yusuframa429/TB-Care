import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

/// [StreakCard] - Kartu motivasi yang menampilkan streak minum obat.
///
/// Menampilkan jumlah hari berturut-turut minum obat dengan
/// pesan motivasi dan ikon api.
///
/// Saat ini menggunakan data dummy.
class StreakCard extends StatelessWidget {
  /// Jumlah hari streak berturut-turut.
  final int streakHari;

  /// Pesan motivasi yang ditampilkan.
  final String pesan;

  const StreakCard({
    super.key,
    required this.streakHari,
    required this.pesan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFFED7AA),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          /// Ikon api.
          const Text('🔥', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),

          /// Teks streak dan pesan.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Streak $streakHari Hari!',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFB45309),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  pesan,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF92400E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
